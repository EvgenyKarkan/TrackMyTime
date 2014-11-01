//
//  EKAppDelegate.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 07.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKAppDelegate.h"
#import "EKMenuViewController.h"
#import "EKTimeTrackViewController.h"
#import "MMDrawerVisualStateManager.h"
#import "EKCoreDataProvider.h"

static NSString * const kEKFlurryKey      = @"SRGSFCS9KF9CCB75GKK5";
static NSString * const kEKCrashlyticsKey = @"4760756e56b00e661fdfca38443023c06fd79797";
static NSString * const kEKRestorationID  = @"MMDrawer";
static CGFloat    const kEKTitleFontSize  = 18.0f;
static CGFloat    const kEKDrawerSize     = 260.0f;

@interface EKAppDelegate ()

@property (nonatomic, strong) EKTimeTrackViewController *timeTrackViewController;

@end


@implementation EKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    EKMenuViewController *menuViewController = [[EKMenuViewController alloc] init];
    self.timeTrackViewController = [[EKTimeTrackViewController alloc] init];
    
    UINavigationController *navigationViewControllerLeft = [[UINavigationController alloc] initWithRootViewController:menuViewController];
    
    self.navigationViewControllerCenter = [[UINavigationController alloc] initWithRootViewController:self.timeTrackViewController];
    
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:self.navigationViewControllerCenter
                                                            leftDrawerViewController:navigationViewControllerLeft];
    
    [self.drawerController setRestorationIdentifier:kEKRestorationID];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [self.drawerController setMaximumLeftDrawerWidth:kEKDrawerSize];
    [self.drawerController setShowsShadow:YES];
    self.drawerController.shouldStretchDrawer = NO;
    
    [[MMDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeParallax];
    
    [self.drawerController setDrawerVisualStateBlock: ^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [[MMDrawerVisualStateManager sharedManager] drawerVisualStateBlockForDrawerSide:drawerSide];
        if (block) {
            block(drawerController, drawerSide, percentVisible);
        }
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.drawerController];
    
    NSDictionary *textTitleOptions = @{NSFontAttributeName: [UIFont fontWithName:kEKFont3 size:kEKTitleFontSize],
                                      NSForegroundColorAttributeName: [UIColor blackColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    
    [[SVProgressHUD appearance] setHudForegroundColor:iOS7Blue];
    [[SVProgressHUD appearance] setHudFont:[UIFont fontWithName:kEKFont2 size:17.0f]];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
        //[[Crashlytics sharedInstance] setDebugMode:YES];
        //[Crashlytics startWithAPIKey:kEKCrashlyticsKey];
        //[Flurry startSession:kEKFlurryKey];
    
    [self setupUserDefaults];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[EKCoreDataProvider sharedInstance] saveContext];
}

#pragma mark - NSUserDefaults presets

- (void)setupUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
                                              forKey:@"version"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
