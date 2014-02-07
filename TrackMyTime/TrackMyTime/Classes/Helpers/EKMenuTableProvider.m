//
//  EKMenuTableProvider.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 17.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKMenuTableProvider.h"
#import "EKMenuCell.h"

static NSString * const kSUReuseIdentifier = @"defaultCell";
static NSInteger  const kEKRowsNumber      = 3;
static CGFloat    const kEKHeightForRow    = 60.0f;


@implementation EKMenuTableProvider;

#pragma mark - Designated initializer

- (instancetype)initWithDelegate:(id <EKMenuTableViewDelegate> )delegate
{
    NSParameterAssert(delegate != nil);
    
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

#pragma mark - Tableview API

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kEKRowsNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSUReuseIdentifier];
    if (cell == nil) {
        cell = [[EKMenuCell alloc] initWithIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

@end
