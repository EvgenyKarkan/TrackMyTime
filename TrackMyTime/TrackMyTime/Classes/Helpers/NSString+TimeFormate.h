//
//  NSString+TimeFormate.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 15.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//


@interface NSString (TimeFormate)

+ (NSString *)timeFormattedStringForValue:(unsigned long long)value withFraction:(BOOL)useFraction;

@end
