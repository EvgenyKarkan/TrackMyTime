//
//  EKChartViewController.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 14.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKChartViewController.h"
#import "EKAppDelegate.h"
#import "EKRecordModel.h"
#import "EKDateModel.h"

@interface EKChartViewController ()

@property (nonatomic, strong) EKAppDelegate *appDelegate;

@end


@implementation EKChartViewController;

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (EKAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
    NSLog(@"MODELS %@", [self.dateModels description]);
    
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.appDelegate.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    
        //[self activitiesNoDuplicates];
    [self predicateStuff];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

- (void)setUpUI
{
    self.view.backgroundColor = [UIColor colorWithRed:0.898039f green:0.898039f blue:0.898039f alpha:1.0f];
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
	[[self navigationItem] setRightBarButtonItem:newBackButton];
}

- (NSMutableSet *)activitiesNoDuplicates
{
    NSMutableSet *noDuplicates = [[NSMutableSet alloc] init];
    
    for (EKDateModel *date in self.dateModels) {
        for (EKRecordModel *record in [date.toRecord allObjects]) {
            NSLog(@"<#   #> %@", record.activity);
            [noDuplicates addObject:record.activity];
        }
    }
    NSLog(@"No duplicates %@", [noDuplicates allObjects]);
    return noDuplicates;
}

- (NSMutableArray *)recordsFromGivenDates
{
    NSMutableArray *records = [@[] mutableCopy];
    
    for (EKDateModel *date in self.dateModels) {
        for (EKRecordModel *record in [date.toRecord allObjects]) {
            [records addObject:record];
        }
    }
    NSLog(@"Records all %@", [records description]);
    return records;
}

- (void)predicateStuff
{
    NSMutableArray *result = [@[] mutableCopy];
    
    for (NSInteger i = 0; i < [[[self activitiesNoDuplicates] allObjects] count]; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"activity == %@", [[self activitiesNoDuplicates] allObjects][i]];
        NSArray *mock = [[self recordsFromGivenDates] filteredArrayUsingPredicate:predicate];
        [result addObject:mock];
    }
    
    NSLog(@"Resulted array aft pred %@", [result description]);
    
    
}

@end
