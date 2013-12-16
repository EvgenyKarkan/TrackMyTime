//
//  EKActivityProvider.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 10.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKActivityProvider.h"

static NSString * const kEKPlistName      = @"Activities";
static NSString * const kEKPlistExtension = @"plist";

@implementation EKActivityProvider

+ (NSArray *)activities
{
	NSString *path = [[NSBundle mainBundle] pathForResource:kEKPlistName ofType:kEKPlistExtension];
	NSArray *roughDescriptions = [[NSArray alloc] initWithContentsOfFile:path];
	NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[roughDescriptions count]];
    
	for (NSDictionary *dictionary in roughDescriptions) {
		EKActivity *activity = [[EKActivity alloc] initWithDictionary:dictionary];
        if (activity != nil) {
            [result addObject:activity];
        }
	}
    
	return result;
}

+ (EKActivity *)activityWithIndex:(NSUInteger)index
{
    NSParameterAssert(index >= 0);
    
	return [self activities][index];
}

+ (UIColor *)colorForActivity:(NSString *)activity
{
	NSParameterAssert(activity != nil);
    
	UIColor *color = nil;
    
	if ([activity isEqualToString:@"Meals"]) {
		color = [UIColor colorWithHexString:@"#FF9500"];
	}
	if ([activity isEqualToString:@"Personal care"]) {
		color = [UIColor colorWithHexString:@"#52EDC7"];
	}
	if ([activity isEqualToString:@"Transport"]) {
		color = [UIColor colorWithHexString:@"#C644FC"];
	}
	if ([activity isEqualToString:@"Working"]) {
		color = [UIColor colorWithHexString:@"#FFDB4C"];
	}
	if ([activity isEqualToString:@"Education"]) {
		color = [UIColor colorWithHexString:@"#34AADC"];
	}
	if ([activity isEqualToString:@"Dating"]) {
		color = [UIColor colorWithHexString:@"#007AFF"];
	}
	if ([activity isEqualToString:@"Self development"]) {
		color = [UIColor colorWithHexString:@"#FF2D55"];
	}
	if ([activity isEqualToString:@"Cleaning"]) {
		color = [UIColor colorWithHexString:@"#E4B7F0"];
	}
	if ([activity isEqualToString:@"Shopping"]) {
		color = [UIColor colorWithHexString:@"#E4DDCA"];
	}
	if ([activity isEqualToString:@"Sports"]) {
		color = [UIColor colorWithHexString:@"#FF4981"];
	}
	if ([activity isEqualToString:@"Cooking"]) {
		color = [UIColor colorWithHexString:@"#B3D557"];
	}
	if ([activity isEqualToString:@"Walking"]) {
		color = [UIColor colorWithHexString:@"#3A77A1"];
	}
	if ([activity isEqualToString:@"TV"]) {
		color = [UIColor colorWithHexString:@"#7F7B6B"];
	}
	if ([activity isEqualToString:@"Music"]) {
		color = [UIColor colorWithHexString:@"#FECC90"];
	}
	if ([activity isEqualToString:@"Games"]) {
		color = [UIColor colorWithHexString:@"#448B9D"];
	}
	if ([activity isEqualToString:@"Social networks"]) {
		color = [UIColor colorWithHexString:@"#C24655"];
	}
	if ([activity isEqualToString:@"Family"]) {
		color = [UIColor colorWithHexString:@"#FE9063"];
	}
	if ([activity isEqualToString:@"Friends"]) {
		color = [UIColor colorWithHexString:@"#4FA99F"];
	}
	if ([activity isEqualToString:@"Party"]) {
		color = [UIColor colorWithHexString:@"#CA4677"];
	}
	if ([activity isEqualToString:@"Hobby"]) {
		color = [UIColor colorWithHexString:@"#C79975"];
	}
	if ([activity isEqualToString:@"Procrastinating"]) {
		color = [UIColor colorWithHexString:@"#A5B087"];
	}
	if ([activity isEqualToString:@"Sleep"]) {
		color = [UIColor colorWithHexString:@"#F0D55D"];
	}
    
	return color;
}

@end
