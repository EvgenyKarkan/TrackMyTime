//
//  EKSoundsProvider.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 12.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKSoundsProvider.h"

static NSString * const kEKStartSoundName = @"start";
static NSString * const kEKStopSoundName  = @"stop";
static NSString * const kEKResetSoundName = @"reset";
static NSString * const kEKSaveSoundName  = @"save";
static NSString * const kEKSliceSoundName = @"slice";
static NSString * const kEKExtentionName  = @"wav";


@implementation EKSoundsProvider;

#pragma mark Singleton stuff

static id _sharedInstance = nil;

+ (EKSoundsProvider *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[EKSoundsProvider alloc] init];
    });
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = nil;
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

+ (id)new
{
    NSException *exception = [[NSException alloc] initWithName:kEKException
                                                        reason:kEKExceptionReason
                                                      userInfo:nil];
    [exception raise];
    
    return nil;
}

#pragma mark - Public API

- (void)startSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kEKStartSoundName ofType:kEKExtentionName];
    [self playSoundFromPath:[NSURL fileURLWithPath:path]];
}

- (void)stopSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kEKStopSoundName ofType:kEKExtentionName];
    [self playSoundFromPath:[NSURL fileURLWithPath:path]];
}

- (void)resetSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kEKResetSoundName ofType:kEKExtentionName];
    [self playSoundFromPath:[NSURL fileURLWithPath:path]];
}

- (void)saveSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kEKSaveSoundName ofType:kEKExtentionName];
    [self playSoundFromPath:[NSURL fileURLWithPath:path]];
}

- (void)sliceSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kEKSliceSoundName ofType:kEKExtentionName];
    [self playSoundFromPath:[NSURL fileURLWithPath:path]];
}

#pragma mark - Private API

- (void)playSoundFromPath:(NSURL *)pathToSound
{
    NSParameterAssert(pathToSound != nil);
    
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"disableSounds"] boolValue]) {
        SystemSoundID audioEffect;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)pathToSound, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    }
}

@end
