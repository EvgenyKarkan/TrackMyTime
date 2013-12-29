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
#import "NSDate-Utilities.h"
#import "EKCoreDataProvider.h"
#import "EKFileSystemUtil.h"

static NSString * const kEKSettingsVCTitle = @"TrackMyTime";
static NSString * const kEKSent            = @"Sent";
static NSString * const kEKFailed          = @"Failed";
static NSString * const kEKExportFailed    = @"No data to export";


@interface EKSettingsViewController () <EKSettingsTableViewDelegate, MFMailComposeViewControllerDelegate>

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

- (void)mail
{
	MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    
    NSString *zipFileName = [NSString stringWithFormat:@"%@-%@.%@",@"TMT_db",[[NSDate date] stringFromDate],@"zip"];
    
	[self presentViewController:mc animated:YES completion:NULL];
    [mc addAttachmentData:[EKFileSystemUtil zippedSQLiteDatabase] mimeType:@"application/zip" fileName:zipFileName];
}

#pragma mark - EKSettingsTableViewDelegate

- (void)cellDidPressWithIndex:(NSUInteger)index
{
	if (index == 0) {
		if ([[[EKCoreDataProvider sharedInstance] allDateModels] count] > 0) {
			[self mail];
		}
		else {
			[SVProgressHUD showImage:[UIImage imageNamed:kEKErrorHUDIcon] status:kEKExportFailed];
		}
	}
	else if (index == 1) {
		__weak typeof(self) weakSelf = self;
		[[EKCoreDataProvider sharedInstance] clearAllDataWithCompletionBlock: ^(NSString *status) {
		    [weakSelf showHUDWithStatus:status];
		}];
	}
}

- (void)switchDidPressed:(UISwitch *)sender
{
    NSParameterAssert(sender != nil);
    
    if (sender != nil) {
        [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"enableSounds"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - Mail composer delegate 

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	switch (result) {
		case MFMailComposeResultCancelled:
			break;
			
		case MFMailComposeResultSaved:
			break;
			
		case MFMailComposeResultSent:
			[SVProgressHUD showImage:[UIImage imageNamed:kEKSuccessHUDIcon] status:kEKSent];
			break;
			
		case MFMailComposeResultFailed:
			[SVProgressHUD showImage:[UIImage imageNamed:kEKErrorHUDIcon] status:kEKFailed];
			break;
			
		default:
			break;
	}
	[EKFileSystemUtil removeZippedSQLiteDatabase];
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - EKCoreDataProvider callback

- (void)showHUDWithStatus:(NSString *)status
{
	if ([status isEqualToString:kEKClearedWithSuccess]) {
		[SVProgressHUD showImage:[UIImage imageNamed:kEKSuccessHUDIcon] status:kEKClearedWithSuccess];
	}
	else {
		[SVProgressHUD showImage:[UIImage imageNamed:kEKErrorHUDIcon] status:kEKErrorOnClear];
	}
}

@end
