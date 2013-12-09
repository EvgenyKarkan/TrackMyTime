//
//  EKCalendarViewController.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 07.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKCalendarViewController.h"
#import "EKAppDelegate.h"

@interface EKCalendarViewController () <DSLCalendarViewDelegate>

@property (weak, nonatomic) IBOutlet DSLCalendarView *calendar;
@property (nonatomic, strong) EKAppDelegate *appDelegate;

@end


@implementation EKCalendarViewController;

#pragma mark - Life cycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.appDelegate = (EKAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.view.backgroundColor = [UIColor colorWithRed:0.898039 green:0.898039 blue:0.898039 alpha:1];

	NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:18.0f], NSFontAttributeName,
                                                                    [UIColor blackColor], NSForegroundColorAttributeName, nil];
	self.navigationController.navigationBar.titleTextAttributes = size;
    self.title = @"TrackMyTime";
    
    self.calendar.backgroundColor = [UIColor colorWithRed:0.898039 green:0.898039 blue:0.898039 alpha:1];
	self.calendar.delegate = self;
	self.calendar.showDayCalloutView = NO;
    
    [self setupLeftMenuButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setupLeftMenuButton
{
	MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
        //[leftDrawerButton setTintColor:[UIColor colorWithRed:0.000000 green:0.478431 blue:1.000000 alpha:1]];
	[self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

#pragma mark - Button Handlers

- (void)leftDrawerButtonPress:(id)sender
{
	[self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - DSLCalendarViewDelegate methods

- (void)calendarView:(DSLCalendarView *)calendarView didSelectRange:(DSLCalendarRange *)range
{
	if (range != nil) {
		NSLog(@"Selected %d/%d - %d/%d", range.startDay.day, range.startDay.month, range.endDay.day, range.endDay.month);
	}
	else {
		NSLog(@"No selection");
	}
}

- (DSLCalendarRange *)calendarView:(DSLCalendarView *)calendarView didDragToDay:(NSDateComponents *)day selectingRange:(DSLCalendarRange *)range
{
	if (NO) { // Only select a single day
		return [[DSLCalendarRange alloc] initWithStartDay:day endDay:day];
	}
	else if (NO) { // Don't allow selections before today
		NSDateComponents *today = [[NSDate date] dslCalendarView_dayWithCalendar:calendarView.visibleMonth.calendar];
        
		NSDateComponents *startDate = range.startDay;
		NSDateComponents *endDate = range.endDay;
        
		if ([self day:startDate isBeforeDay:today] && [self day:endDate isBeforeDay:today]) {
			return nil;
		}
		else {
			if ([self day:startDate isBeforeDay:today]) {
				startDate = [today copy];
			}
			if ([self day:endDate isBeforeDay:today]) {
				endDate = [today copy];
			}
            
			return [[DSLCalendarRange alloc] initWithStartDay:startDate endDay:endDate];
		}
	}
    
	return range;
}

- (void)calendarView:(DSLCalendarView *)calendarView willChangeToVisibleMonth:(NSDateComponents *)month duration:(NSTimeInterval)duration
{
	NSLog(@"Will show %@ in %.3f seconds", month, duration);
}

- (void)calendarView:(DSLCalendarView *)calendarView didChangeToVisibleMonth:(NSDateComponents *)month
{
	NSLog(@"Now showing %@", month);
}

- (BOOL)day:(NSDateComponents *)day1 isBeforeDay:(NSDateComponents *)day2
{
	return ([day1.date compare:day2.date] == NSOrderedAscending);
}

@end
