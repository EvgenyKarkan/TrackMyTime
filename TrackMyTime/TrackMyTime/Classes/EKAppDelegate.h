//
//  EKAppDelegate.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 07.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EKAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) MMDrawerController *drawerController;
@property (nonatomic, strong) UINavigationController *navigationViewControllerCenter;

@end
