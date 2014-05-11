//
//  EKMenuCell.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 17.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//


@interface EKMenuCell : UITableViewCell

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel     *title;

- (instancetype)initWithIndexPath:(NSIndexPath *)path;

@end
