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

@interface EKMenuViewController ()

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *fooButton;
@property (nonatomic, strong) EKAppDelegate *appDelegate;
@property (nonatomic, strong) EKCalendarViewController *calendarVC;

@end


@implementation EKMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (EKAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.view.backgroundColor = menuBackground;
    self.title = kEKNavigationBarTitle;
    
	self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.cancelButton setTitle:@"Calendar" forState:UIControlStateNormal];
	[self.cancelButton setTitleColor:[UIColor colorWithRed:0.419608 green:0.937255 blue:0.960784 alpha:1] forState:UIControlStateNormal];
	self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	self.cancelButton.frame = CGRectMake(0.0f, 100.0f, 100, 30);
	[self.cancelButton addTarget:self action:@selector(pressCalendar) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.cancelButton];
    

    self.fooButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.fooButton setTitle:@"Track" forState:UIControlStateNormal];
	[self.fooButton setTitleColor:[UIColor colorWithRed:0.000000 green:0.478431 blue:1.000000 alpha:1] forState:UIControlStateNormal];
	self.fooButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	self.fooButton.frame = CGRectMake(0.0f, 150.0f, 100.0f, 30.0f);
	[self.fooButton addTarget:self action:@selector(track) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.fooButton];
    
    self.calendarVC = [[EKCalendarViewController alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)pressCalendar
{
	[self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    
	UINavigationController *foo = [[UINavigationController alloc] initWithRootViewController:self.calendarVC];
    
	[self.appDelegate.drawerController setCenterViewController:foo
	                                        withCloseAnimation:YES
	                                                completion:nil];
}

- (void)track
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

@end
