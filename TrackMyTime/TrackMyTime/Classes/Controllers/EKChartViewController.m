//
//  EKChartViewController.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 14.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKChartViewController.h"
#import "EKAppDelegate.h"
#import "EKRecordModel.h"
#import "EKChartView.h"
#import "EKDateModel.h"
#import "NSString+TimeFormate.h"
#import "EKActivityProvider.h"
#import "EKSoundsProvider.h"
#import "EKScreenshotUtil.h"
#import "EKBar.h"

@interface EKChartViewController ()<XYPieChartDelegate, XYPieChartDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) EKAppDelegate *appDelegate;
@property (nonatomic, strong) EKChartView *chartView;
@property (nonatomic, assign) BOOL pageControlBeingUsed;

@property (nonatomic, strong) NSArray *proxyData;

@end


@implementation EKChartViewController;

#pragma mark - Life cycle

- (void)loadView
{
    EKChartView *view = [[EKChartView alloc] init];
    self.view = view;
    self.chartView = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.appDelegate = (EKAppDelegate *)[[UIApplication sharedApplication] delegate];
	[self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
	[self.chartView.chart setDelegate:self];
	[self.chartView.chart setDataSource:self];
    self.chartView.scrollView.delegate = self;
    
	[self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	[self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    
	self.proxyData = [self endDataReadyForChart];
	[self showPieChart];
	[self.chartView.chart reloadData];
    [self showBarChart];
}

- (void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    
    for (UIView *view in [self.chartView.barChartView subviews]) {
        [view removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

- (void)setUpUI
{
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                   target:self
                                                                                   action:@selector(sharePressed:)];
    [[self navigationItem] setRightBarButtonItem:newBackButton];
    
    [self.chartView.pageControl addTarget:self
                                   action:@selector(controlTapped:)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [self.chartView.scrollView addSubview:self.chartView.barChartView];
}

- (void)showPieChart
{
    self.chartView.totalTime.text = [self totalTime];
    self.chartView.cirle.color = [EKActivityProvider colorForActivity:[[self endDataReadyForChart][0] allKeys][0]];
    self.chartView.activityName.text = [[self endDataReadyForChart][0] allKeys][0];
    self.chartView.activityTime.text = [NSString timeFormattedStringForValue:[[[self endDataReadyForChart][0] allValues][0] unsignedLongLongValue] withFraction:NO];
}

- (void)showBarChart
{
	self.chartView.barChartView.frame = CGRectMake(self.chartView.frame.size.width, 0.0f, self.chartView.frame.size.width, self.chartView.frame.size.height - 124.0f);
    
	CGFloat start = [[self layoutAttributesForBar:[[self endDataReadyForChart] count]][0] floatValue];
	CGFloat barHeight = [[self layoutAttributesForBar:[[self endDataReadyForChart] count]][1] floatValue];
    
	for (NSUInteger i = 0; i < [[self endDataReadyForChart] count]; i++) {
		CGRect newFrame = CGRectMake(30.0f, start + barHeight * 1.5f * i, 260.0f, barHeight);
		EKBar *progBar = [[EKBar alloc] init];
		progBar.frame = newFrame;
		progBar.bar.backgroundColor = [EKActivityProvider colorForActivity:[[self sortedDataForBarChart][i] allKeys][0]];
		[progBar drawBarWithProgress:[[self grades][i] floatValue] animated:YES];
		[progBar addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
		[self.chartView.barChartView addSubview:progBar];
	}
}

#pragma mark - Prepare data for chart

- (NSSet *)activitiesNoDuplicates
{
    NSMutableSet *noDuplicates = [[NSMutableSet alloc] init];
    NSParameterAssert([self.dateModels count] > 0);
    
	for (EKDateModel *date in self.dateModels) {
        if (date != nil) {
            for (EKRecordModel *record in [date.toRecord allObjects]) {
                if ((record != nil) && (record.activity != nil)) {
                    [noDuplicates addObject:record.activity];
                }
            }
        }
	}
    NSParameterAssert([[noDuplicates allObjects] count] > 0);
    
	return [noDuplicates copy];
}

- (NSArray *)recordsFromGivenDates
{
    NSMutableArray *records = [@[] mutableCopy];
    NSParameterAssert([self.dateModels count] > 0);
    
    for (EKDateModel *date in self.dateModels) {
        if (date != nil) {
            for (EKRecordModel *record in [date.toRecord allObjects]) {
                if (record != nil) {
                    [records addObject:record];
                }
            }
        }
	}
    NSParameterAssert([records count] > 0);
    
	return [records copy];
}

- (NSArray *)filteredRecordsGroupedByName
{
    NSMutableArray *result = [@[] mutableCopy];
    
	for (NSInteger i = 0; i < [[[self activitiesNoDuplicates] allObjects] count]; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"activity == %@", [[self activitiesNoDuplicates] allObjects][i]];
        NSArray *mock = [[self recordsFromGivenDates] filteredArrayUsingPredicate:predicate];
        [result addObject:mock];
	}
    NSParameterAssert([result count] > 0);
    
	return [result copy];
}

- (NSArray *)endDataReadyForChart
{
    unsigned long long sum = 0;
    EKRecordModel *mock = nil;
    NSMutableArray *endData = [@[] mutableCopy];
    
	for (NSArray *arrayObject in [self filteredRecordsGroupedByName]) {
        if (arrayObject != nil) {
            for (EKRecordModel *record in arrayObject) {
                if (record != nil) {
                    mock = record;
                    sum = sum + [record.duration unsignedLongLongValue];
                }
            }
            [endData addObject:@{ mock.activity : @(sum) }];
            sum = 0;
        }
	}
    NSParameterAssert([endData count] > 0);

	return [endData copy];
}

- (NSArray *)sortedDataForBarChart
{
	NSArray *sortedArray = [self.proxyData sortedArrayUsingComparator: ^NSComparisonResult (id a, id b) {
	    id firstValue = [(NSDictionary *)a allValues][0];
	    id secondValue = [(NSDictionary *)b allValues][0];
	    return [secondValue compare:firstValue];
	}];
    
    NSParameterAssert(sortedArray != nil);
    
	return sortedArray;
}

- (NSArray *)grades
{
	NSMutableArray *array = [@[] mutableCopy];
	CGFloat grade = 0;
    
	for (NSInteger i = 0; i < [[self sortedDataForBarChart] count]; i++) {
        if ([self sortedDataForBarChart][i] != nil) {
            grade = [[[self sortedDataForBarChart][i] allValues][0] floatValue] / [[[self sortedDataForBarChart][0] allValues][0] floatValue];
            [array addObject:@(grade)];
        }
	}
    NSParameterAssert([array count] > 0);
    
	return [array copy];
}

- (NSArray *)layoutAttributesForBar:(NSInteger)activitiesCount
{
    CGFloat frameCenterY = self.chartView.barChartView.frame.size.height / 2;
    
	NSInteger n = activitiesCount;
	CGFloat barHeight = self.chartView.barChartView.frame.size.height * 0.66666f / n;
	CGFloat first = barHeight / 2;
    
	CGFloat calc = first + (n - 1) * 0.75f * barHeight; // <-- Arithmetic progression here
    CGFloat start = frameCenterY - (NSInteger)calc;
    
    return @[@(start),@(barHeight)];
}

#pragma mark - Prepare data for "total" label

- (NSString *)totalTime
{
	long long sum = 0;
	NSArray *array = self.proxyData;
    
	for (NSUInteger i = 0; i < [array count]; i++) {
		if (array[i] != nil) {
			sum = sum + [[array[i] allValues][0] longLongValue];
		}
	}
    
	return [NSString timeFormattedStringForValue:sum withFraction:NO];
}

#pragma mark - Actions

- (void)sharePressed:(id)sender
{
	if (sender != nil) {
		__weak typeof(self) weakSelf = self;
        
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[[EKScreenshotUtil convertViewToImage:weakSelf.chartView.window]]
		                                                                             applicationActivities:nil];
		    controller.excludedActivityTypes = @[UIActivityTypePostToVimeo, UIActivityTypeAddToReadingList, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact];
		    [weakSelf presentViewController:controller animated:YES completion:nil];
		});
	}
}

- (void)controlTapped:(FXPageControl *)sender
{
	if (sender != nil) {
		CGPoint offset = CGPointMake(sender.currentPage * self.chartView.scrollView.frame.size.width, -64.0f);
		[self.chartView.scrollView setContentOffset:offset animated:YES];
		self.pageControlBeingUsed = YES;
	}
}

- (void)pop:(id)sender
{
	UIView *view = (UIView *)sender;
	CGFloat duration = 0.4f;
    
	view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
	[UIView animateKeyframesWithDuration:duration / 3 delay:0 options:0 animations: ^{
	    view.transform = CGAffineTransformMakeScale(1.05f, 1.5f);
	} completion: ^(BOOL finished) {
	    [UIView animateKeyframesWithDuration:duration / 3 delay:0 options:0 animations: ^{
	        view.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
		} completion: ^(BOOL finished) {
	        [UIView animateKeyframesWithDuration:duration / 3 delay:0 options:0 animations: ^{
	            view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
			} completion: ^(BOOL finished) {
			}];
		}];
	}];
	[[EKSoundsProvider sharedInstance] sliceSound];
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return [self.proxyData count];
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.proxyData[index] allValues][0] unsignedLongLongValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [EKActivityProvider colorForActivity:[self.proxyData[index] allKeys][0]];
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    return [NSString timeFormattedStringForValue:[[self.proxyData[index] allValues][0] unsignedLongLongValue] withFraction:NO];
}

#pragma mark - XYPieChart Delegate

- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
	[[EKSoundsProvider sharedInstance] sliceSound];
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
	[[EKSoundsProvider sharedInstance] sliceSound];
    
	self.chartView.cirle.color = [EKActivityProvider colorForActivity:[self.proxyData[index] allKeys][0]];
	self.chartView.activityTime.text = [NSString timeFormattedStringForValue:[[self.proxyData[index] allValues][0] unsignedLongLongValue] withFraction:NO];
	self.chartView.activityName.text = [self.proxyData[index] allKeys][0];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (!self.pageControlBeingUsed) {
		NSInteger pageIndex = round(scrollView.contentOffset.x / scrollView.bounds.size.width);
		self.chartView.pageControl.currentPage = pageIndex;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	self.pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	self.pageControlBeingUsed = NO;
}

@end
