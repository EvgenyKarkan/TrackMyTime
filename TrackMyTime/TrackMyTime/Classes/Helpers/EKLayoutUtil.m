//
//  EKLayoutUtil.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 16.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKLayoutUtil.h"

CGFloat screenWidth(void);
CGFloat screenHeight(void);


@implementation EKLayoutUtil;

+ (CGFloat)cirleCenterY
{
    CGFloat value = 0.0f;
    
    if (IS_IPHONE_5) {
        value = 345.0f;
    }
    else {
        value = 310.0f;
    }
    
    return value;
}

+ (CGFloat)activityLabelY
{
    CGFloat value = 0.0f;
    
    if (IS_IPHONE_5) {
        value = 330.0f;
    }
    else {
        value = 295.0f;
    }
    
    return value;
}

+ (CGFloat)activityNameLabelY
{
    CGFloat value = 0.0f;
    
    if (IS_IPHONE_5) {
        value = 335.0f;
    }
    else {
        value = 300.0f;
    }
    
    return value;
}

+ (CGFloat)timeLabelY
{
    CGFloat value = 0.0f;
    
    if (IS_IPHONE_5) {
        value = 360.0f;
    }
    else {
        value = 325.0f;
    }
    
    return value;
}

+ (CGFloat)totalLabelY
{
    CGFloat value = 0.0f;
    
    if (IS_IPHONE_5) {
        value = 400.0f;
    }
    else {
        value = 350.0f;
    }
    
    return value;
}

+ (CGFloat)totalTimeLabelY
{
    CGFloat value = 0.0f;
    
    if (IS_IPHONE_5) {
        value = 400.0f;
    }
    else {
        value = 350.0f;
    }
    
    return value;
}

+ (CGFloat)scrollHeight
{
    CGFloat value = 0.0f;
    
    if (IS_IPHONE_5) {
        value = 530.0f;
    }
    else {
        value = 440.0f;
    }
    
    return value;
}

+ (NSArray *)layoutAttributesForBarOnHostView:(UIView *)view barCount:(NSInteger)count
{
    CGFloat frameCenterY = view.frame.size.height / 2;
    
    NSInteger n = count;
    CGFloat barHeight = view.frame.size.height * 0.66666f / n;
    CGFloat first = barHeight / 2;
    
    CGFloat calc = first + (n - 1) * 0.75f * barHeight; // <-- Arithmetic progression here
    CGFloat start = frameCenterY - (NSInteger)calc;
    
    return @[@(start), @(barHeight)];
}

CGFloat screenWidth()
{
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}

CGFloat screenHeight()
{
    return CGRectGetHeight([UIScreen mainScreen].bounds) - 20;
}

@end
