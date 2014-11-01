//
//  EKSettingsView.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 24.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKSettingsView.h"


@implementation EKSettingsView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = APP_BACKGROUND_COLOR;
        
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
    
    self.tableView.frame = CGRectMake(0.0f, 0.0f, 300.0f, 250.0f);
}

@end
