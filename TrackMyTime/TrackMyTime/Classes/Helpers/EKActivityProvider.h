//
//  EKActivityProvider.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 10.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKActivity.h"
#import "EKRecordModel.h"

@interface EKActivityProvider : NSObject

+ (NSArray *)activities;
+ (EKActivity *)activityWithIndex:(NSUInteger)index;
+ (UIColor *)colorForActivity:(NSString *)activity;

@end
