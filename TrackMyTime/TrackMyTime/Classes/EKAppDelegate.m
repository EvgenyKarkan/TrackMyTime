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

@interface EKAppDelegate ()

@property (nonatomic, strong) EKTimeTrackViewController *timeTrackViewController;

@end


@implementation EKAppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	EKMenuViewController *menuViewController = [[EKMenuViewController alloc] init];
	self.timeTrackViewController = [[EKTimeTrackViewController alloc] init];
    
	UINavigationController *navigationViewControllerLeft = [[UINavigationController alloc] initWithRootViewController:menuViewController];
    
	self.navigationViewControllerCenter = [[UINavigationController alloc] initWithRootViewController:self.timeTrackViewController];
    
	self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:self.navigationViewControllerCenter
	                                                        leftDrawerViewController:navigationViewControllerLeft];
    
	[self.drawerController setRestorationIdentifier:@"MMDrawer"];
	[self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
	[self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
	[self.drawerController setMaximumLeftDrawerWidth:262.0f];
	[self.drawerController setShowsShadow:NO];
	self.drawerController.shouldStretchDrawer = NO;
    
	[[MMDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeNone];
    
	[self.drawerController setDrawerVisualStateBlock: ^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
	    MMDrawerControllerDrawerVisualStateBlock block;
	    block = [[MMDrawerVisualStateManager sharedManager] drawerVisualStateBlockForDrawerSide:drawerSide];
	    if (block) {
	        block(drawerController, drawerSide, percentVisible);
		}
	}];
    
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.window setRootViewController:self.drawerController];
    
    
	return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:kEKFont size:18.0f], NSFontAttributeName,
	                                  [UIColor blackColor], NSForegroundColorAttributeName, nil];
    
	[[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
	[self.window makeKeyAndVisible];
    
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[[EKCoreDataProvider sharedInstance] saveContext];
}

@end
