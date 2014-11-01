//
//  EKBar.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 21.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKBar.h"


@implementation EKBar;

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor colorWithRed:0.827451f green:0.827451f blue:0.827451f alpha:1.0f];
        
        self.bar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, self.frame.size.height)];
        self.bar.userInteractionEnabled = NO;
        [self addSubview:self.bar];
    }
    return self;
}

#pragma mark - Public API

- (void)drawBarWithProgress:(CGFloat)progress animated:(BOOL)animated
{
    [UIView animateWithDuration:0.3f animations: ^{
        self.bar.frame = CGRectMake(0.0f, 0.0f, progress * self.frame.size.width, self.frame.size.height);
    }];
}

@end
