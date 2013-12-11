//
//  EKCoreDataProvider.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 11.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EKCoreDataProvider : NSObject


+ (EKCoreDataProvider *)sharedInstance;


- (void)saveContext;


@end
