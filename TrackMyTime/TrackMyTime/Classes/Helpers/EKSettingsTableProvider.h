//
//  EKSetingsTableProvider.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 24.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKSettingsCell.h"

@protocol EKSettingsTableViewDelegate <NSObject>

- (void)cellDidPressWithIndex:(NSUInteger)index;
- (void)switchDidPressed:(UISwitch *)sender;

@end


@interface EKSettingsTableProvider : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id <EKSettingsTableViewDelegate> delegate;
@property (nonatomic, strong) EKSettingsCell *settingsCell;

- (instancetype)initWithDelegate:(id <EKSettingsTableViewDelegate> )delegate;

@end
