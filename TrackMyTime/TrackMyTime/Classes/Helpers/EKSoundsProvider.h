//
//  EKSoundsProvider.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 12.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EKSoundsProvider : NSObject

+ (EKSoundsProvider *)sharedInstance;
- (void)startSound;
- (void)stopSound;
- (void)resetSound;
- (void)saveSound;

@end
