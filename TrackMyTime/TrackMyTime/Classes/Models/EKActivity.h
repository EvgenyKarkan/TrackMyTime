//
//  EKActivity.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 10.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//


@interface EKActivity : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *hexColor;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
