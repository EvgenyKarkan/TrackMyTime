//
//  EKTimeTrackView.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 07.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//


typedef NS_ENUM (NSInteger, kTTCounter) {
	kTTCounterRunning = 0,
	kTTCounterStopped,
	kTTCounterReset,
	kTTCounterEnded
};


@protocol EKTimeTrackViewDelegate <NSObject>

- (void)startStopButtonDidPressed;
- (void)resetButtonDidPressed;
- (void)saveButtonDidPressed;

@end


@interface EKTimeTrackView : UIView

@property (nonatomic, strong) UIButton                    *startStop;
@property (nonatomic, strong) UIButton                    *reset;
@property (nonatomic, strong) UIButton                    *save;
@property (nonatomic, strong) UIPickerView                *picker;
@property (nonatomic, strong) UIImageView                 *clockIcon;
@property (nonatomic, strong) TTCounterLabel              *counterLabel;
@property (nonatomic, weak)   id<EKTimeTrackViewDelegate>  delegate;

- (void)updateUIForState:(kTTCounter)state;

@end
