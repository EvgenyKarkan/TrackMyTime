//
//  Date.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 11.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//


@class Record;

@interface Date : NSManagedObject

@property (nonatomic, retain) NSDate *dateOfRecord;
@property (nonatomic, retain) NSSet *toRecord;

@end

@interface Date (CoreDataGeneratedAccessors)

- (void)addToRecordObject:(Record *)value;
- (void)removeToRecordObject:(Record *)value;

- (void)addToRecord:(NSSet *)values;
- (void)removeToRecord:(NSSet *)values;

@end
