//
//  EKActivity.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 10.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKActivity.h"

static NSString * const kEKNameKey     = @"name";
static NSString * const kEKHexColorKey = @"hexColor";


@implementation EKActivity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.name = [dictionary valueForKey:kEKNameKey];
        self.hexColor = [dictionary valueForKey:kEKHexColorKey];
    }
    return self;
}

@end
