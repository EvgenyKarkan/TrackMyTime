//
//  EKRecordModel.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 12.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//


@class Date;

@interface EKRecordModel : NSObject

@property (nonatomic, strong) NSString *activity;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, retain) Date *toDate;

@end
