//
//  EKCoreDataProvider.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 11.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKRecordModel.h"
#import "EKDateModel.h"

@interface EKCoreDataProvider : NSObject

+ (EKCoreDataProvider *)sharedInstance;
- (void)saveContext;

- (void)saveRecord:(EKRecordModel *)recordModel withCompletionBlock:(void (^)(NSString *status))block;
- (NSArray *)allDateModels;

- (NSArray *)fetchedDatesWithCalendarRange:(DSLCalendarRange *)rangeForFetch;
- (void)clearAllDataWithCompletionBlock:(void (^)(NSString *status))block;;

@end
