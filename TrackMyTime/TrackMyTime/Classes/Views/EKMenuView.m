//
//  EKMenuView.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 07.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKMenuView.h"


@implementation EKMenuView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.tableView = [[UITableView alloc] init];
        self.tableView.bounces = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tableView.frame = CGRectMake(0.0f, 0.0f, 245.0f, 250.0f);
}

@end
