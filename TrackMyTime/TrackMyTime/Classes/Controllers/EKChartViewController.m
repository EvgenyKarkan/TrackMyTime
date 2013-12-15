//
//  EKChartViewController.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 14.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKChartViewController.h"
#import "EKAppDelegate.h"

@interface EKChartViewController ()

@property (nonatomic, strong) EKAppDelegate *appDelegate;

@end


@implementation EKChartViewController;

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.898039f green:0.898039f blue:0.898039f alpha:1.0f];
    
    self.appDelegate = (EKAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    NSLog(@"MODELS %@", [self.dateModels description]);
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
	[[self navigationItem] setRightBarButtonItem:newBackButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
