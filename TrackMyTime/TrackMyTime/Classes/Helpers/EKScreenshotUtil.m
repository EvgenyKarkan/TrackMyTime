//
//  EKScreenshotUtil.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 16.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKScreenshotUtil.h"

@implementation EKScreenshotUtil;

+ (UIImage *)convertViewToImage:(UIView *)view
{
    NSParameterAssert(view != nil);
    
    CGFloat imageScale = sqrtf(powf(view.transform.a, 2.f) + powf(view.transform.c, 2.f));
    CGFloat widthScale = view.bounds.size.width / view.frame.size.width;
    CGFloat heightScale = view.bounds.size.height / view.frame.size.height;
    CGFloat contentScale = MIN(widthScale, heightScale);
    CGFloat effectiveScale = imageScale * contentScale;
    
    CGSize captureSize = CGSizeMake(view.bounds.size.width / effectiveScale, view.bounds.size.height / effectiveScale);
    
    UIGraphicsBeginImageContextWithOptions(captureSize, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1 / effectiveScale, 1 / effectiveScale);
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
