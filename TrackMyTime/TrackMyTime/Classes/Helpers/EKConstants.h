//
//  EKConstants.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 11.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#ifndef iKnowE_CommonConstants_h
#define iKnowE_CommonConstants_h

#define iOS7Blue       [UIColor colorWithRed:0.188235f green:0.564706f blue:0.980392f alpha:1.0f]
#define appBackground  [UIColor colorWithRed:0.898039f green:0.898039f blue:0.898039f alpha:1.0f]
#define menuBackground [UIColor colorWithRed:0.811765f green:0.807843f blue:0.823529f alpha:1.0f]

static NSString * const kEKFont               = @"HelveticaNeue-UltraLight";
static NSString * const kEKFont2              = @"Helvetica";
static NSString * const kEKFont3              = @"HelveticaNeue-Light";
static NSString * const kEKNavigationBarTitle = @"TrackMyTime";

static NSString * const kEKException          = @"Deprecated method";
static NSString * const kEKExceptionReason    = @"Class instance is singleton. It's not possible to call +new method directly. Use +sharedInstance instead";

static NSString * const kEKSavedWithSuccess   = @"Saved";
static NSString * const kEKErrorOnSaving      = @"Error";

static NSString * const kEKSuccessHUDIcon     = @"success";
static NSString * const kEKErrorHUDIcon       = @"error";


#endif