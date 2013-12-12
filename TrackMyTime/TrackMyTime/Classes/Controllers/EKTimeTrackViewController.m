//
//  EKTimeTrackViewController.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 07.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKTimeTrackViewController.h"
#import "EKAppDelegate.h"
#import "EKTimeTrackView.h"
#import "EKSoundsProvider.h"

static CGFloat const kEKPickerSectionWidth  = 300.f;
static CGFloat const kEKPickerSectionHeight = 50.f;
static CGFloat const kEKPickerLabelFontSize = 35.f;
static CGRect  const kEKPickerLabelFrame    = { 0.0f, 0.0f, 300.0f, 40.0f };

@interface EKTimeTrackViewController () <TTCounterLabelDelegate, EKTimeTrackViewDelegate, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *pickerViewData;
@property (nonatomic, strong) EKAppDelegate *appDelegate;
@property (nonatomic, strong) EKTimeTrackView *timeTrackView;

@end


@implementation EKTimeTrackViewController;

#pragma mark - Life cycle

- (void)loadView
{
	EKTimeTrackView *view = [[EKTimeTrackView alloc] init];
	self.view = view;
	self.timeTrackView = view;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	self.pickerViewData = @[@"Meals",
	                        @"Personal care",
	                        @"Transport",
	                        @"Working",
	                        @"Education",
	                        @"Dating",
	                        @"Self development",
	                        @"Cleaning",
	                        @"Shopping",
	                        @"Sports",
	                        @"Cooking",
	                        @"Walking",
	                        @"TV",
	                        @"Music",
	                        @"Games",
	                        @"Social networks",
                            @"Family",
	                        @"Friends",
	                        @"Party",
	                        @"Hobby",
	                        @"Procrastinating",
	                        @"Sleep"];
    
	self.timeTrackView.delegate = self;
	self.timeTrackView.picker.delegate = self;
    
    self.title = kEKNavigationBarTitle;
    [self setupLeftMenuButton];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - Side-menu button with handler

- (void)setupLeftMenuButton
{
	MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self
                                                                                     action:@selector(leftDrawerButtonPress:)];
	[leftDrawerButton setTintColor:[UIColor colorWithRed:0.000000f green:0.478431f blue:1.000000f alpha:1.0f]];
	[self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

- (void)leftDrawerButtonPress:(id)sender
{
    self.appDelegate = (EKAppDelegate *)[[UIApplication sharedApplication] delegate];
	[self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark - EKTimeTrackViewDelegate

- (void)startStopButtonDidPressed
{
    self.timeTrackView.counterLabel.isRunning ? [[EKSoundsProvider sharedInstance] stopSound] : [[EKSoundsProvider sharedInstance] startSound];
    
	if (self.timeTrackView.counterLabel.isRunning) {
		[self.timeTrackView.counterLabel stop];
		[self.timeTrackView updateUIForState:kTTCounterStopped];
	}
	else {
		[self.timeTrackView.counterLabel start];
		[self.timeTrackView updateUIForState:kTTCounterRunning];
	}
}

- (void)resetButtonDidPressed
{
    [[EKSoundsProvider sharedInstance] resetSound];
	[self.timeTrackView.counterLabel reset];
	[self.timeTrackView updateUIForState:kTTCounterReset];
}

- (void)saveButtonDidPressed
{
        //add completion block on callback saving to CoreData
        //only after saving - this is complinion block
	[SVProgressHUD showImage:[UIImage imageNamed:@"1234"] status:@"Error"];
    [[EKSoundsProvider sharedInstance] saveSound];
    
	NSLog(@"Duration %llu", self.timeTrackView.counterLabel.currentValue);
    
	[self.timeTrackView.counterLabel reset];
	[self.timeTrackView updateUIForState:kTTCounterReset];
}

#pragma mark - TTCounterLabelDelegate

- (void)countdownDidEnd
{
	[self.timeTrackView updateUIForState:kTTCounterEnded];
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [self.pickerViewData count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CGFloat sectionWidth = kEKPickerSectionWidth;
	return sectionWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	CGFloat sectionHeight = kEKPickerSectionHeight;
	return sectionHeight;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UILabel *pickerLabel = (UILabel *)view;
    
	if (pickerLabel == nil) {
		CGRect frame = kEKPickerLabelFrame;
		pickerLabel = [[UILabel alloc] initWithFrame:frame];
		[pickerLabel setTextAlignment:NSTextAlignmentCenter];
		[pickerLabel setFont:[UIFont fontWithName:kEKFont size:kEKPickerLabelFontSize]];
		[pickerLabel setTextColor:[UIColor blackColor]];
	}
    
	[pickerLabel setText:self.pickerViewData[row]];
    
	return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"row is %d", row);
}
@end
