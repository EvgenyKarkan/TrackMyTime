//
//  Record.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 11.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//


@class Date;

@interface Record : NSManagedObject

@property (nonatomic, retain) NSString * activity;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) Date *toDate;

@end
