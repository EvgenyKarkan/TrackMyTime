//
//  EKCalendarViewController.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 07.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKCalendarViewController.h"
#import "EKAppDelegate.h"
#import "EKAttributedStringUtil.h"
#import "EKCoreDataProvider.h"

static NSString * const kEKFutureDate = @"No stats exists for future date";
static NSString * const kEKButtonTitle = @"Chart";


@interface EKCalendarViewController () <DSLCalendarViewDelegate>

@property (nonatomic, weak) IBOutlet DSLCalendarView *calendar;
@property (nonatomic, strong) EKAppDelegate *appDelegate;
@property (nonatomic, strong) UILabel *rangeLabel;
@property (nonatomic, strong) DSLCalendarRange *rangeForFetch;

@end


@implementation EKCalendarViewController;

#pragma mark - Life cycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	self.view.backgroundColor = [UIColor colorWithRed:0.898039f green:0.898039f blue:0.898039f alpha:1.0f];
    self.title = kEKNavigationBarTitle;
    
    [self setupButtons];
    [self setUpUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

- (void)setUpUI
{
	self.calendar.backgroundColor = self.view.backgroundColor;
	self.calendar.delegate = self;
	self.calendar.showDayCalloutView = NO;
    
	CGFloat endY_PointOfCalendar = self.calendar.frame.origin.y + self.calendar.frame.size.height;
	CGSize labelSize = CGSizeMake(self.view.frame.size.width, 40.0f);
    
    self.rangeLabel = [[UILabel alloc] init];
	self.rangeLabel.frame = CGRectMake(0.0f, endY_PointOfCalendar + labelSize.height/2, labelSize.width, labelSize.height);
    self.rangeLabel.font = [UIFont fontWithName:kEKFont size:20.0f];
    self.rangeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.rangeLabel];
}

#pragma mark - Setup buttons

- (void)setupButtons
{
	MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self
                                                                                     action:@selector(leftDrawerButtonPress:)];
	[leftDrawerButton setTintColor:[UIColor colorWithRed:0.000000f green:0.478431f blue:1.000000f alpha:1.0f]];
	[self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    [negativeSpacer setWidth:-15.0f];

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,[[UIBarButtonItem alloc] initWithCustomView:[self chartButton]],nil];
}

- (void)leftDrawerButtonPress:(id)sender
{
	self.appDelegate = (EKAppDelegate *)[[UIApplication sharedApplication] delegate];
	[self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (UIButton *)chartButton
{
    UIButton *chartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chartButton.frame = CGRectMake(0.0f, 0.0f, 60.0f, 30.0f);
    [chartButton addTarget:self action:@selector(chartPressed) forControlEvents:UIControlEventTouchUpInside];
    [chartButton setTitle:kEKButtonTitle forState:UIControlStateNormal];
    [chartButton setTitleColor:[UIColor colorWithRed:0.000000f green:0.478431f blue:1.000000f alpha:1.0f] forState:UIControlStateNormal];
    chartButton.titleLabel.font = [UIFont fontWithName:kEKFont2 size:14.0f];
    chartButton.titleLabel.textColor = [UIColor colorWithRed:0.000000f green:0.478431f blue:1.000000f alpha:1.0f];
    [chartButton setAttributedTitle:[EKAttributedStringUtil attributeStringWithString:kEKButtonTitle] forState:UIControlStateHighlighted];
    
    return chartButton;
}

#pragma mark - DSLCalendarViewDelegate methods

- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range
{
	NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
    
	if ([range.startDay.date isLaterThanDate:today.date]) {
		return;
	}
    
	if (range != nil) {
        self.rangeForFetch = range;
        self.rangeLabel.text = [NSString stringWithFormat:@"%d.%d.%d - %d.%d.%d", range.startDay.day, range.startDay.month, range.startDay.year,
                                                                                  range.endDay.day, range.endDay.month, range.endDay.year];
	}
}

- (DSLCalendarRange *)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range
{
	NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
	NSDateComponents *startDate = range.startDay;
	NSDateComponents *endDate = range.endDay;
    
	NSDate *start = range.startDay.date;
	NSDate *end = range.endDay.date;
    
	if ([start isLaterThanDate:today.date] && [end isLaterThanDate:today.date]) {
		self.rangeLabel.text = kEKFutureDate;
		return nil;
	}
	else {
		if ([start isLaterThanDate:today.date]) {
			startDate = [today copy];
		}
		if ([end isLaterThanDate:today.date]) {
			endDate = [today copy];
		}
        
		return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
	}
    
	return range;
}

#pragma mark - Button action

- (void)chartPressed
{
	NSLog(@"Dates is %@", [[EKCoreDataProvider sharedInstance] fetchedDatesWithCalendarRange:self.rangeForFetch]);
}

@end
