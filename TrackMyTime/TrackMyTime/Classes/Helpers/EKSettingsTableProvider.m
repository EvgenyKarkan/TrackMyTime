//
//  EKSetingsTableProvider.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 24.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKSettingsTableProvider.h"
#import "EKSettingsCell.h"

static NSString * const kSUReuseIdentifier = @"defaultCell";
static NSInteger  const kEKRowsNumber      = 3;
static CGFloat    const kEKHeightForRow    = 60.0f;


@implementation EKSettingsTableProvider

#pragma mark - Designated initializer

- (instancetype)initWithDelegate:(id <EKSettingsTableViewDelegate> )delegate
{
    NSParameterAssert(delegate != nil);
    
	self = [super init];
	if (self) {
		self.delegate = delegate;
	}
    
	return self;
}

#pragma mark - Tableview API

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return kEKRowsNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	EKSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:kSUReuseIdentifier];
	if (cell == nil) {
		cell = [[EKSettingsCell alloc] initWithIndexPath:indexPath];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.soundSwitch addTarget:self action:@selector(switchPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.soundSwitch.on = [[[NSUserDefaults standardUserDefaults] valueForKey:@"enableSounds"] boolValue];
        if (indexPath.row < 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
	}
    
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kEKHeightForRow;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.delegate cellDidPressWithIndex:indexPath.row];
}

#pragma mark - Switch action

- (void)switchPressed:(UISwitch *)sender
{
    [self.delegate switchDidPressed:sender];
}

@end
