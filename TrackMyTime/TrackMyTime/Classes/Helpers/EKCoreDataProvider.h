//
//  EKCoreDataProvider.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 11.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EKRecordModel.h"
#import "EKDateModel.h"

@interface EKCoreDataProvider : NSObject

+ (EKCoreDataProvider *)sharedInstance;
- (void)saveContext;

- (void)saveRecord:(EKRecordModel *)recordModel withCompletionBlock:(void (^)(NSString *status))block;
- (NSArray *)allRecordModels;

- (NSArray *)fetchedDatesWithCalendarRange:(DSLCalendarRange *)rangeForFetch;

@end
