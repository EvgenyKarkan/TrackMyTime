//
//  EKBar.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 21.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//


@interface EKBar : UIControl

@property (nonatomic, strong) UIView *bar;

- (void)drawBarWithProgress:(CGFloat)progress animated:(BOOL)animated;

@end
