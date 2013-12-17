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

@interface EKMenuViewController () <EKMenuTableViewDelegate>

@property (nonatomic, strong) EKAppDelegate *appDelegate;
@property (nonatomic, strong) EKCalendarViewController *calendarVC;
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
    
    self.view.backgroundColor = menuBackground;
    self.title = kEKNavigationBarTitle;
    
    self.tableProvider = [[EKMenuTableProvider alloc] initWithDelegate:self];
    self.menuView.tableView.delegate = self.tableProvider;
	self.menuView.tableView.dataSource = self.tableProvider;
    
    self.calendarVC = [[EKCalendarViewController alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Menu actions

- (void)toCalendarViewController
{
	[self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    
	UINavigationController *foo = [[UINavigationController alloc] initWithRootViewController:self.calendarVC];
    
	[self.appDelegate.drawerController setCenterViewController:foo
	                                        withCloseAnimation:YES
	                                                completion:nil];
}

- (void)toTimeTrackViewController
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

#pragma mark - EKMenuTableViewDelegate

- (void)cellDidPressWithIndex:(NSUInteger)index
{
	switch (index) {
		case 0:
			[self toTimeTrackViewController];
			break;
            
		case 1:
			[self toCalendarViewController];
			break;
            
		case 2:
			break;
            
		default:
			break;
	}
}

@end
