//
//  EKLayoutUtil.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 16.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKLayoutUtil.h"


@implementation EKLayoutUtil

+ (CGFloat)cirleCenterY
{
    CGFloat value = 0.0f;
    
    if (IS_IPHONE_5) {
        value = 440.0f;
    }
    else {
        value = 405.0f;
    }
    
    return value;
}

+ (CGFloat)activityLabelY
{
    CGFloat value = 0.0f;
    
    if (IS_IPHONE_5) {
        value = 425.0f;
    }
    else {
        value = 390.0f;
    }
    
    return value;
}


+ (CGFloat)activityNameLabelY
{
    CGFloat value = 0.0f;
    
    if (IS_IPHONE_5) {
        value = 430.0f;
    }
    else {
        value = 395.0f;
    }
    
    return value;
}

+ (CGFloat)timeLabelY
{
    CGFloat value = 0.0f;
    
    if (IS_IPHONE_5) {
        value = 455.0f;
    }
    else {
        value = 420.0f;
    }
    
    return value;
}

+ (CGFloat)totalLabelY
{
    CGFloat value = 0.0f;
    
    if (IS_IPHONE_5) {
        value = 495.0f;
    }
    else {
        value = 445.0f;
    }
    
    return value;
}

+ (CGFloat)totalTimeLabelY
{
    CGFloat value = 0.0f;
    
    if (IS_IPHONE_5) {
        value = 495.0f;
    }
    else {
        value = 445.0f;
    }
    
    return value;
}

@end
