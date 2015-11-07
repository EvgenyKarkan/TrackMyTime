//
//  EKMenuTableProvider.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 17.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//


@protocol EKMenuTableViewDelegate <NSObject>

- (void)cellDidPressWithIndex:(NSUInteger)index;

@end


@interface EKMenuTableProvider : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id <EKMenuTableViewDelegate> delegate;

- (instancetype)initWithDelegate:(id <EKMenuTableViewDelegate> )delegate;

@end
