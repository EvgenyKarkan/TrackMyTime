//
//  EKMenuViewController.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 07.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKMenuViewController.h"
#import "EKAppDelegate.h"
#import "EKCalendarViewController.h"
#import "EKTimeTrackViewController.h"
#import "EKMenuView.h"
#import "EKMenuTableProvider.h"
#import "EKSettingsViewController.h"

#import "SSZipArchive.h"

@interface EKMenuViewController () <EKMenuTableViewDelegate>

@property (nonatomic, strong) EKAppDelegate *appDelegate;
@property (nonatomic, strong) EKCalendarViewController *calendarVC;
@property (nonatomic, strong) EKSettingsViewController *settingsVC;
@property (nonatomic, strong) EKMenuView *menuView;
@property (nonatomic, strong) EKMenuTableProvider *tableProvider;

@end


@implementation EKMenuViewController;

#pragma mark - Life cycle

- (void)loadView
{
    EKMenuView *view = [[EKMenuView alloc] init];
	self.view = view;
	self.menuView = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (EKAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.view.backgroundColor = MENU_BACKGROUND_COLOR;
    self.title = kEKNavigationBarTitle;
    
    self.tableProvider = [[EKMenuTableProvider alloc] initWithDelegate:self];
    self.menuView.tableView.delegate = self.tableProvider;
	self.menuView.tableView.dataSource = self.tableProvider;
    
    self.calendarVC = [[EKCalendarViewController alloc] init];
    self.settingsVC = [[EKSettingsViewController alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Menu actions

- (void)showCalendarViewController
{
	[self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    
	UINavigationController *foo = [[UINavigationController alloc] initWithRootViewController:self.calendarVC];
    
	[self.appDelegate.drawerController setCenterViewController:foo
	                                        withCloseAnimation:YES
	                                                completion:nil];
}

- (void)showTimeTrackViewController
{
	[self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
	if ([((UINavigationController *)self.appDelegate.drawerController.centerViewController).topViewController isKindOfClass :[EKTimeTrackViewController class]]) {
		[self.appDelegate.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
	}
	else {
		[self.appDelegate.drawerController setCenterViewController:self.appDelegate.navigationViewControllerCenter
		                                        withCloseAnimation:YES
		                                                completion:nil];
	}
}

- (void)showSettingsViewController
{
    [self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
	UINavigationController *foo = [[UINavigationController alloc] initWithRootViewController:self.settingsVC];
    
	[self.appDelegate.drawerController setCenterViewController:foo
	                                        withCloseAnimation:YES
	                                                completion:nil];
}

- (void)mail
{
        //just for tests
	NSString *fileName = @"TrackMyTime.sqlite";
	NSString *fileName2 = @"TrackMyTime.sqlite-shm";
	NSString *fileName3 = @"TrackMyTime.sqlite-wal";
    
	NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	NSString *path = [directoryPath stringByAppendingPathComponent:fileName];
	NSString *path2 = [directoryPath stringByAppendingPathComponent:fileName2];
	NSString *path3 = [directoryPath stringByAppendingPathComponent:fileName3];
    
    NSArray *inputPaths = @[path, path2, path3];
    
	NSString *archivePath = [directoryPath stringByAppendingPathComponent:@"CreatedArchive.zip"];
	[SSZipArchive createZipFileAtPath:archivePath withFilesAtPaths:inputPaths];
    
    NSString *fileName4 = @"CreatedArchive.zip";
    NSString *path4 = [directoryPath stringByAppendingPathComponent:fileName4];
    NSData *myData4 = [NSData dataWithContentsOfFile:path4];
    
	MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
	[self presentViewController:mc animated:YES completion:NULL];
    [mc addAttachmentData:myData4 mimeType:@"application/zip" fileName:@"Zip.zip"];
}

#pragma mark - EKMenuTableViewDelegate

- (void)cellDidPressWithIndex:(NSUInteger)index
{
	switch (index) {
		case 0:
			[self showTimeTrackViewController];
			break;
            
		case 1:
			[self showCalendarViewController];
			break;
            
		case 2:
            [self showSettingsViewController];
                //[self mail];
			break;
            
		default:
			break;
	}
}

@end
