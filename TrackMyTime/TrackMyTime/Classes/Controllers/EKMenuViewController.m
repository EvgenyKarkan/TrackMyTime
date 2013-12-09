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
    
    self.view.backgroundColor = [UIColor colorWithRed:0.725490 green:0.725490 blue:0.725490 alpha:1];
    self.title = @"Menu";
    
	NSDictionary *size = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20.0f], NSFontAttributeName, nil];
	self.navigationController.navigationBar.titleTextAttributes = size;
    
	self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.cancelButton setTitle:@"Calendar" forState:UIControlStateNormal];
	[self.cancelButton setTitleColor:[UIColor colorWithRed:0.419608 green:0.937255 blue:0.960784 alpha:1] forState:UIControlStateNormal];
	self.cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	self.cancelButton.frame = CGRectMake(0.0f, 100.0f, 100, 30);
	[self.cancelButton addTarget:self action:@selector(press) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.cancelButton];
    

    self.fooButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.fooButton setTitle:@"Track" forState:UIControlStateNormal];
	[self.fooButton setTitleColor:[UIColor colorWithRed:0.000000 green:0.478431 blue:1.000000 alpha:1] forState:UIControlStateNormal];
	self.fooButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
	self.fooButton.frame = CGRectMake(0.0f, 150.0f, 100, 30);
	[self.fooButton addTarget:self action:@selector(dress) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.fooButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)press
{
	self.calendarVC = [[EKCalendarViewController alloc] init];
	UINavigationController *foo = [[UINavigationController alloc] initWithRootViewController:self.calendarVC];
    
	[self.appDelegate.drawerController setCenterViewController:foo
	                                    withFullCloseAnimation:YES
	                                                completion:nil];
    
    [self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModePanningNavigationBar];
    
//	[self.appDelegate.drawerController setCenterViewController:foo
//	                                        withCloseAnimation:YES
//	                                                completion:nil];
    
    
}

- (void)dress
{
    [self.appDelegate.drawerController setCenterViewController:self.appDelegate.navigationViewControllerCenter
	                                    withFullCloseAnimation:YES
	                                                completion:nil];
    
    [self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
//    [self.appDelegate.drawerController setCenterViewController:self.appDelegate.navigationViewControllerCenter
//                                            withCloseAnimation:YES
//                                                    completion:nil];
}

@end
