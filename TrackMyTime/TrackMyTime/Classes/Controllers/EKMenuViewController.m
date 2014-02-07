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

@interface EKMenuViewController () <EKMenuTableViewDelegate>

@property (nonatomic, strong) EKAppDelegate            *appDelegate;
@property (nonatomic, strong) EKCalendarViewController *calendarVC;
@property (nonatomic, strong) EKSettingsViewController *settingsVC;
@property (nonatomic, strong) EKMenuView               *menuView;
@property (nonatomic, strong) EKMenuTableProvider      *tableProvider;

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
            break;
            
        default:
            break;
    }
}

@end
