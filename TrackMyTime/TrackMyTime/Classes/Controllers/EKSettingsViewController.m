//
//  EKSettingsViewController.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 24.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKSettingsViewController.h"
#import "EKSettingsView.h"
#import "EKSettingsTableProvider.h"
#import "EKAppDelegate.h"

static NSString * const kEKSettingsVCTitle = @"TrackMyTime";

@interface EKSettingsViewController () <EKSettingsTableViewDelegate>

@property (nonatomic, strong) EKSettingsView *settingsView;
@property (nonatomic, strong) EKSettingsTableProvider *tableProvider;
@property (nonatomic, strong) EKAppDelegate *appDelegate;

@end


@implementation EKSettingsViewController;

#pragma mark - Life cycle

- (void)loadView
{
	EKSettingsView *view = [[EKSettingsView alloc] init];
	self.view = view;
	self.settingsView = view;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	self.tableProvider = [[EKSettingsTableProvider alloc] initWithDelegate:self];
	self.settingsView.tableView.delegate = self.tableProvider;
	self.settingsView.tableView.dataSource = self.tableProvider;
	[self setupUI];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - Setup UI

- (void)setupUI
{
	MMDrawerBarButtonItem *leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self
	                                                                                 action:@selector(leftDrawerButtonPress:)];
	[self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
	self.title = kEKSettingsVCTitle;
}

#pragma mark - Action

- (void)leftDrawerButtonPress:(id)sender
{
	NSParameterAssert(sender != nil);
    
	if (sender != nil) {
		self.appDelegate = (EKAppDelegate *)[[UIApplication sharedApplication] delegate];
		[self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
	}
}

#pragma mark - EKSettingsTableViewDelegate

- (void)cellDidPressWithIndex:(NSUInteger)index
{
	NSLog(@"%d %s", __LINE__, __PRETTY_FUNCTION__);
}

@end
