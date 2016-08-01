//
//  EKLayoutUtil.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 16.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//


#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568.0f) < DBL_EPSILON)

@interface EKLayoutUtil : NSObject

+ (CGFloat)cirleCenterY;
+ (CGFloat)activityLabelY;
+ (CGFloat)activityNameLabelY;
+ (CGFloat)timeLabelY;
+ (CGFloat)totalLabelY;
+ (CGFloat)totalTimeLabelY;
+ (CGFloat)scrollHeight;
+ (NSArray *)layoutAttributesForBarOnHostView:(UIView *)view barCount:(NSInteger)count;

CGFloat screenWidth();
CGFloat screenHeight();

@end
