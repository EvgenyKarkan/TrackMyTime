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

@interface EKChartViewController ()<XYPieChartDelegate, XYPieChartDataSource>

@property (nonatomic, strong) EKAppDelegate *appDelegate;
@property (nonatomic, strong) EKChartView *chartView;

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
    
	[self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:YES];
	[self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    
	[self endDataReadyForChart];
	[self preloadData];
	[self.chartView.chart reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

- (void)setUpUI
{
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    [[self navigationItem] setRightBarButtonItem:newBackButton];
}

- (void)preloadData
{
    self.chartView.totalTime.text = [self totalTime];
    self.chartView.annotationFromTo.text = self.chartAnnotation;
    self.chartView.cirle.color = [EKActivityProvider colorForActivity:[[self endDataReadyForChart][0] allKeys][0]];
    self.chartView.activityName.text = [[self endDataReadyForChart][0] allKeys][0];
    self.chartView.activityTime.text = [NSString timeFormattedStringForValue:[[[self endDataReadyForChart][0] allValues][0] unsignedLongLongValue]];
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

#pragma mark - Prepare data for "total" label

- (NSString *)totalTime
{
    long long int sum = 0;
    NSArray *array = [self endDataReadyForChart];
    
    for (NSUInteger i = 0; i < [array count]; i++) {
        if (array[i] != nil) {
            sum = sum + [[array[i] allValues][0] longLongValue];
        }
    }
    
    return [NSString timeFormattedStringForValue:sum];
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return [[self endDataReadyForChart] count];
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[[self endDataReadyForChart][index] allValues][0] unsignedLongLongValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [EKActivityProvider colorForActivity:[[self endDataReadyForChart][index] allKeys][0]];
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    return [NSString timeFormattedStringForValue:[[[self endDataReadyForChart][index] allValues][0] unsignedLongLongValue]];
}

#pragma mark - XYPieChart Delegate

- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    [[EKSoundsProvider sharedInstance] sliceSound];
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    [[EKSoundsProvider sharedInstance] sliceSound];
    
    self.chartView.cirle.color = [EKActivityProvider colorForActivity:[[self endDataReadyForChart][index] allKeys][0]];
    self.chartView.activityTime.text = [NSString timeFormattedStringForValue:[[[self endDataReadyForChart][index] allValues][0] unsignedLongLongValue]];
    self.chartView.activityName.text = [[self endDataReadyForChart][index] allKeys][0];
}

@end
