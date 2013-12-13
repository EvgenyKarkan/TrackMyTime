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
#import "EKRecordModel.h"
#import "EKActivityProvider.h"
#import "EKCoreDataProvider.h"

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
    EKRecordModel *record = [[EKRecordModel alloc] init];
    record.activity = [EKActivityProvider activityWithIndex:[self.timeTrackView.picker selectedRowInComponent:0]].name;
    record.duration = [NSNumber numberWithLongLong:self.timeTrackView.counterLabel.currentValue];
    
    [[EKCoreDataProvider sharedInstance] saveRecord:record withCompletionBlock:^(NSString *status) {
        [self provideHUDWithStatus:status];
    }];
    
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

#pragma mark - Private helper (callback from EKCoreDataProvider)

- (void)provideHUDWithStatus:(NSString *)status
{
	if ([status isEqualToString:kEKSavedWithSuccess]) {
		[[EKSoundsProvider sharedInstance] saveSound];
		[SVProgressHUD showImage:[UIImage imageNamed:kEKSuccessHUDIcon] status:kEKSavedWithSuccess];
        
            //this for fetch test
        for (int i = 0; i < [[[EKCoreDataProvider sharedInstance] allRecordModels] count]; i++) {
            NSLog(@"Name is %@", ((EKRecordModel *)[[EKCoreDataProvider sharedInstance] allRecordModels][i]).activity);
            NSLog(@"Duration is %@", ((EKRecordModel *)[[EKCoreDataProvider sharedInstance] allRecordModels][i]).duration);
            
            NSTimeInterval timeInMiliseconds = [((EKRecordModel *)[[EKCoreDataProvider sharedInstance] allRecordModels][i]).duration unsignedLongLongValue];
            NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInMiliseconds / 1000.0f];
            NSLog(@"Formatted output %@", [self timeFormattedStringForValue:timeInMiliseconds]);
            NSLog(@"Readable duration is %@", date);
        }
	}
	else {
		[SVProgressHUD showImage:[UIImage imageNamed:kEKErrorHUDIcon] status:kEKErrorOnSaving];
	}
}

- (NSString *)timeFormattedStringForValue:(unsigned long long)value
{
	unsigned long long msperhour = 3600000;
	unsigned long long mspermin = 60000;
    
	unsigned long long hrs = value / msperhour;
	unsigned long long mins = (value % msperhour) / mspermin;
	unsigned long long secs = ((value % msperhour) % mspermin) / 1000;
	unsigned long long frac = value % 1000 / 10;
    
	NSString *formattedString = @"";
    
	if (hrs == 0) {
		if (mins == 0) {
			formattedString = [NSString stringWithFormat:@"%02llus.%02llu", secs, frac];
		}
		else {
			formattedString = [NSString stringWithFormat:@"%02llum %02llus.%02llu", mins, secs, frac];
		}
	}
	else {
		formattedString = [NSString stringWithFormat:@"%02lluh %02llum %02llus.%02llu", hrs, mins, secs, frac];
	}
    
	return formattedString;
}

@end
