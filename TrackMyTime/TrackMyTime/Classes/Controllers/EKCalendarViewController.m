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
#import "EKChartViewController.h"

static NSString * const kEKNoDataFound      = @"No data found";
static NSString * const kEKInvalidDateRange = @"Select present date";
static NSString * const kEKChartButtonTitle = @"Chart";
static NSString * const kEKChartVCTitle     = @"TrackMyDay";
static NSString * const kEKTitleToPass      = @"%@";
static NSString * const kEKBackButtonTitle  = @"Back";
static NSString * const kEKStubDate         = @"DD.MM.YYYY - DD.MM.YYYY";
static NSString * const kEKTopLabel         = @"Select date range for stats";

@interface EKCalendarViewController () <DSLCalendarViewDelegate>

@property (nonatomic, weak)   IBOutlet DSLCalendarView *calendar;
@property (nonatomic, strong) EKAppDelegate            *appDelegate;
@property (nonatomic, strong) UILabel                  *rangeLabel;
@property (nonatomic, strong) UILabel                  *topLabel;
@property (nonatomic, strong) DSLCalendarRange         *rangeForFetch;
@property (nonatomic, strong) EKChartViewController    *chartViewController;
@property (nonatomic, assign) CGFloat                   viewHeightFromNIB;

@end


@implementation EKCalendarViewController;

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = APP_BACKGROUND_COLOR;
    self.title = @"Stats";
    
    self.rangeLabel = [[UILabel alloc] init];
    self.rangeLabel.text = kEKTopLabel;
    [self.view addSubview:self.rangeLabel];
    
    self.topLabel = [[UILabel alloc] init];
    self.topLabel.text = kEKStubDate;
    [self.view addSubview:self.topLabel];
    
    [self setupButtons];
    self.calendar.delegate = self;
    
    self.chartViewController = [[EKChartViewController alloc] init];
    self.appDelegate = (EKAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.rangeForFetch = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [TSMessage setDefaultViewController:self.navigationController];
    self.viewHeightFromNIB = self.view.frame.size.height;
    self.calendar.delegate = self;
    [self setUpUI];
    [self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
}

#pragma mark - UI

- (void)setUpUI
{
    self.calendar.backgroundColor = self.view.backgroundColor;
    self.calendar.showDayCalloutView = NO;
    
    CGFloat endY_PointOfCalendar = self.calendar.frame.origin.y + self.calendar.frame.size.height;
    CGFloat distance = self.viewHeightFromNIB - endY_PointOfCalendar;
    CGFloat centerY_DownRect = endY_PointOfCalendar + (distance / 2);
    CGSize labelSize = CGSizeMake(self.view.frame.size.width, 40.0f);
    
    self.rangeLabel.frame = CGRectMake(0.0f, centerY_DownRect - labelSize.height / 2, labelSize.width, labelSize.height);
    self.rangeLabel.font = [UIFont fontWithName:kEKFont size:18.0f];
    self.rangeLabel.textAlignment = NSTextAlignmentCenter;
    
    self.topLabel.frame = CGRectMake(0.0f, 70.0f, self.view.frame.size.width, 30.0f);
    self.topLabel.font = [UIFont fontWithName:kEKFont size:18.0f];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Setup buttons

- (void)setupButtons
{
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self
                                                                                     action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    [negativeSpacer setWidth:-15.0f];
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer, [[UIBarButtonItem alloc] initWithCustomView:[self chartButton]]];
}

- (void)leftDrawerButtonPress:(id)sender
{
    NSParameterAssert(sender != nil);
    
    if (sender != nil) {
        [self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}

- (UIButton *)chartButton
{
    UIButton *chartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chartButton.frame = CGRectMake(0.0f, 0.0f, 60.0f, 30.0f);
    [chartButton addTarget:self action:@selector(chartPressed:) forControlEvents:UIControlEventTouchUpInside];
    [chartButton setTitle:kEKChartButtonTitle forState:UIControlStateNormal];
    [chartButton setTitleColor:iOS7Blue forState:UIControlStateNormal];
    chartButton.titleLabel.font = [UIFont fontWithName:kEKFont2 size:17.0f];
    chartButton.titleLabel.textColor = iOS7Blue;
    [chartButton setAttributedTitle:[EKAttributedStringUtil attributeStringWithString:kEKChartButtonTitle] forState:UIControlStateHighlighted];
    
    return chartButton;
}

#pragma mark - DSLCalendarViewDelegate methods

- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range
{
    NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
    
    if ([range.startDay.date isLaterThanDate:today.date]) {
        self.topLabel.text = kEKStubDate;
        self.rangeForFetch = nil;
        return;
    }
    
    if (range != nil) {
        self.rangeForFetch = range;
        self.topLabel.text = [NSString stringWithFormat:@"%ld.%ld.%ld - %ld.%ld.%ld", (long)range.startDay.day, (long)range.startDay.month, (long)range.startDay.year,
                              (long)range.endDay.day, (long)range.endDay.month, (long)range.endDay.year];
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

- (void)chartPressed:(id)sender
{
    NSParameterAssert(sender != nil);
    
    if (sender != nil) {
        if (self.rangeForFetch != nil) {
            if ([[[EKCoreDataProvider sharedInstance] fetchedDatesWithCalendarRange:self.rangeForFetch] count] > 0) {
                self.chartViewController.title = kEKChartVCTitle;
                self.chartViewController.dateModels = [[EKCoreDataProvider sharedInstance] fetchedDatesWithCalendarRange:self.rangeForFetch];
                
                UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:kEKBackButtonTitle
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:nil
                                                                                 action:nil];
                [[self navigationItem] setBackBarButtonItem:newBackButton];
                [self.navigationController pushViewController:self.chartViewController animated:YES];
            }
            else {
                if ([TSMessage isNotificationActive]) {
                    [TSMessage dismissActiveNotification];
                }
                [TSMessage showNotificationWithTitle:kEKNoDataFound type:TSMessageNotificationTypeMessage];
            }
        }
        else {
            if ([TSMessage isNotificationActive]) {
                [TSMessage dismissActiveNotification];
            }
            [TSMessage showNotificationWithTitle:kEKInvalidDateRange type:TSMessageNotificationTypeMessage];
        }
    }
}

@end
