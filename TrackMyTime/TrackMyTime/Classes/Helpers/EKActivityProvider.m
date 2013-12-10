//
//  EKActivityProvider.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 10.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKActivityProvider.h"

static NSString * const kEKPlistName = @"Activities";
static NSString * const kEKPlistExtension = @"plist";

@implementation EKActivityProvider

+ (NSArray *)activities
{
	NSString *path = [[NSBundle mainBundle] pathForResource:kEKPlistName ofType:kEKPlistExtension];
	NSArray *roughDescriptions = [[NSArray alloc] initWithContentsOfFile:path];
	NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[roughDescriptions count]];
    
	for (NSDictionary *dictionary in roughDescriptions) {
		EKActivity *activity = [[EKActivity alloc] initWithDictionary:dictionary];
		[result addObject:activity];
	}
    
	return result;
}

+ (EKActivity *)activityWithIndex:(NSUInteger)index
{
	return [self activities][index];
}

@end
