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

@property (nonatomic, strong) EKAppDelegate   *appDelegate;
@property (nonatomic, strong) EKTimeTrackView *timeTrackView;
@property (nonatomic, strong) NSUserDefaults  *userDefaults;

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
    
    self.timeTrackView.delegate = self;
    self.timeTrackView.picker.delegate = self;
    
    self.title = kEKNavigationBarTitle;
    [self setupLeftMenuButton];
    [self observeAppDelegateNotifications];
    
    self.userDefaults = [NSUserDefaults standardUserDefaults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Side-menu button with handler

- (void)setupLeftMenuButton
{
    MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self
                                                                                     action:@selector(leftDrawerButtonPress:)];
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
    if (![self.userDefaults boolForKey:@"onBackgroundWhileCounting"]) {
        self.timeTrackView.counterLabel.isRunning ? [[EKSoundsProvider sharedInstance] stopSound] : [[EKSoundsProvider sharedInstance] startSound];
    }
    
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
    if (![self.userDefaults boolForKey:@"onBackgroundWhileCounting"]) {
        [[EKSoundsProvider sharedInstance] resetSound];
    }
    
    [self.timeTrackView.counterLabel reset];
    [self.timeTrackView updateUIForState:kTTCounterReset];
}

- (void)saveButtonDidPressed
{
    EKRecordModel *record = [[EKRecordModel alloc] init];
    record.activity = [EKActivityProvider activityWithIndex:[self.timeTrackView.picker selectedRowInComponent:0]].name;
    record.duration = [NSNumber numberWithLongLong:self.timeTrackView.counterLabel.currentValue];
    
    NSParameterAssert(record.activity != nil);
    NSParameterAssert(record.duration != nil);
    
    __weak typeof(self) weakSelf = self;
    
    [[EKCoreDataProvider sharedInstance] saveRecord:record withCompletionBlock: ^(NSString *status) {
        [weakSelf provideHUDWithStatus:status];
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
    return [[EKActivityProvider activities] count];
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
    
    [pickerLabel setText:((EKActivity *)[EKActivityProvider activities][row]).name];
    
    return pickerLabel;
}

#pragma mark - Callback from EKCoreDataProvider

- (void)provideHUDWithStatus:(NSString *)status
{
    NSParameterAssert(status != nil);
    
    if ([status isEqualToString:kEKSavedWithSuccess]) {
        [[EKSoundsProvider sharedInstance] saveSound];
        [SVProgressHUD showImage:[UIImage imageNamed:kEKSuccessHUDIcon] status:kEKSavedWithSuccess];
    }
    else {
        [SVProgressHUD showImage:[UIImage imageNamed:kEKErrorHUDIcon] status:kEKErrorOnSaving];
    }
}

#pragma mark - App delegate notifications listening

- (void)observeAppDelegateNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onEnterBackground)
                                                 name:@"UIApplicationDidEnterBackgroundNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDidBecomeActive)
                                                 name:@"UIApplicationDidBecomeActiveNotification"
                                               object:nil];
}

#pragma mark - App states handling

- (void)onEnterBackground
{
    NSParameterAssert(self.userDefaults != nil);
    
    if (self.timeTrackView.counterLabel.isRunning) {
        [self.userDefaults setObject:[NSDate date] forKey:@"onEnterBackgroundDate"];
        [self.userDefaults setBool:YES forKey:@"onBackgroundWhileCounting"];
        [self.userDefaults setObject:@(self.timeTrackView.counterLabel.currentValue) forKey:@"counterValueOnEnterBackground"];
        [self.userDefaults setObject:@([self.timeTrackView.picker selectedRowInComponent:0]) forKey:@"selectedRow"];
        [self.userDefaults synchronize];
        
        [self resetButtonDidPressed];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    }
}

- (void)onDidBecomeActive
{
    NSParameterAssert(self.userDefaults != nil);
    
    if ([self.userDefaults boolForKey:@"onBackgroundWhileCounting"]) {
        NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:[self.userDefaults objectForKey:@"onEnterBackgroundDate"]];
        self.timeTrackView.counterLabel.startValue = [[self.userDefaults objectForKey:@"counterValueOnEnterBackground"] unsignedLongLongValue] + diff * 1000;
        [self.timeTrackView.picker selectRow:[[self.userDefaults objectForKey:@"selectedRow"] integerValue]  inComponent:0 animated:NO];
        self.timeTrackView.counterLabel.resetValue = 0;
        
        [self startStopButtonDidPressed];
        [self.userDefaults setBool:NO forKey:@"onBackgroundWhileCounting"];
        [self.userDefaults synchronize];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

@end
