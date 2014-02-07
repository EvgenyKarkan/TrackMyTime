//
//  NSString+TimeFormate.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 15.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "NSString+TimeFormate.h"


@implementation NSString (TimeFormate);

+ (NSString *)timeFormattedStringForValue:(unsigned long long)value withFraction:(BOOL)useFraction
{
    unsigned long long msperhour = 3600000;
    unsigned long long mspermin = 60000;
    
    unsigned long long hrs = value / msperhour;
    unsigned long long mins = (value % msperhour) / mspermin;
    unsigned long long secs = ((value % msperhour) % mspermin) / 1000;
    unsigned long long frac = value % 1000 / 10;
    
    NSString *formattedString = @"";
    
    if (useFraction) {
        if (hrs == 0) {
            if (mins == 0) {
                formattedString = [NSString stringWithFormat:@"%02llus.%02llu", secs, frac];
            }
            else {
                formattedString = [NSString stringWithFormat:@"%02llum %02llus.%02llu", mins, secs, frac];
            }
        }
        else {
            formattedString = [NSString stringWithFormat:@"%02lluh %02llum %02llus.%02llu", hrs, mins, secs, frac];
        }
    }
    else {
        if (hrs == 0) {
            if (mins == 0) {
                formattedString = [NSString stringWithFormat:@"%02llus", secs];
            }
            else {
                formattedString = [NSString stringWithFormat:@"%02llum %02llus", mins, secs];
            }
        }
        else {
            formattedString = [NSString stringWithFormat:@"%02lluh %02llum %02llus", hrs, mins, secs];
        }
    }
    
    return formattedString;
}

@end
