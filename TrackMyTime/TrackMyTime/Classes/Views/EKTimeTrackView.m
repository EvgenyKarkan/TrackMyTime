//
//  EKTimeTrackView.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 07.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKTimeTrackView.h"
#import "EKAttributedStringUtil.h"

static NSString * const kEKStartButton       = @"Start";
static NSString * const kEKStopOnStartButton = @"Stop";
static NSString * const kEKResetButton       = @"Reset";
static NSString * const kEKSaveButton        = @"Save";
static NSString * const kEKCounter           = @"00:00:00.00";


@implementation EKTimeTrackView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = APP_BACKGROUND_COLOR;
        
        self.startStop = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.startStop setTitle:kEKStartButton forState:UIControlStateNormal];
        [self.startStop.titleLabel setFont:[UIFont fontWithName:kEKFont size:50.0f]];
        [self.startStop setTitleColor:iOS7Blue forState:UIControlStateNormal];
        [self.startStop setAttributedTitle:[EKAttributedStringUtil attributeStringWithString:kEKStartButton] forState:UIControlStateHighlighted];
        self.startStop.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.startStop addTarget:self action:@selector(startPress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.startStop];
        
        self.reset = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.reset setTitle:kEKResetButton forState:UIControlStateNormal];
        [self.reset.titleLabel setFont:[UIFont fontWithName:kEKFont size:50.0f]];
        [self.reset setTitleColor:iOS7Blue forState:UIControlStateNormal];
        [self.reset setAttributedTitle:[EKAttributedStringUtil attributeStringWithString:kEKResetButton] forState:UIControlStateHighlighted];
        self.reset.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.reset addTarget:self action:@selector(resetPress) forControlEvents:UIControlEventTouchUpInside];
        self.reset.hidden = YES;
        [self addSubview:self.reset];
        
        self.save = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.save setTitle:kEKSaveButton forState:UIControlStateNormal];
        [self.save.titleLabel setFont:[UIFont fontWithName:kEKFont size:50.0f]];
        [self.save setTitleColor:iOS7Blue forState:UIControlStateNormal];
        [self.save setAttributedTitle:[EKAttributedStringUtil attributeStringWithString:kEKSaveButton] forState:UIControlStateHighlighted];
        self.save.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.save addTarget:self action:@selector(savePressed) forControlEvents:UIControlEventTouchUpInside];
        self.save.hidden = YES;
        [self addSubview:self.save];
        
        self.counterLabel = [[TTCounterLabel alloc] init];
        self.counterLabel.text = kEKCounter;
        [self.counterLabel setBoldFont:[UIFont fontWithName:kEKFont size:55]];
        [self.counterLabel setRegularFont:[UIFont fontWithName:kEKFont size:55]];
        [self.counterLabel setFont:[UIFont fontWithName:kEKFont size:25.0f]];
        self.counterLabel.textColor = [UIColor blackColor];
        [self.counterLabel updateApperance];
        [self addSubview:self.counterLabel];
        
        self.picker = [[UIPickerView alloc] init];
        self.picker.showsSelectionIndicator = YES;
        [self addSubview:self.picker];
        
        self.clockIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clock"]];
        self.clockIcon.hidden = YES;
        [self.picker addSubview:self.clockIcon];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.startStop.frame    = CGRectMake(0.0f, 170.0f, 320.0f, 30.0f);
    self.reset.frame        = CGRectMake(0.0f, 220.0f, 320.0f, 30.0f);
    self.save.frame         = CGRectMake(0.0f, 270.0f, 320.0f, 30.0f);
    self.counterLabel.frame = CGRectMake(20.0f, 65.0f, 280.0f, 100.0f);
    self.picker.frame       = CGRectMake(10.0f, self.frame.size.height - 172.0f, 300.0f, 162.0f);
    CGFloat clockIconRectSideSize = 15.0f;
    self.clockIcon.frame = CGRectMake(10, self.picker.frame.size.height / 2 - clockIconRectSideSize / 2, clockIconRectSideSize, clockIconRectSideSize);
}

#pragma mark - Actions with delegate stuff

- (void)startPress
{
    if (self.counterLabel.isRunning) {
        [self.startStop setAttributedTitle:[EKAttributedStringUtil attributeStringWithString:kEKStartButton] forState:UIControlStateHighlighted];
    }
    else {
        [self.startStop setAttributedTitle:[EKAttributedStringUtil attributeStringWithString:kEKStopOnStartButton] forState:UIControlStateHighlighted];
    }
    
    [self.delegate startStopButtonDidPressed];
}

- (void)resetPress
{
    [self.delegate resetButtonDidPressed];
}

- (void)savePressed
{
    [self.delegate saveButtonDidPressed];
}

#pragma mark - Public API

- (void)updateUIForState:(kTTCounter)state
{
    switch (state) {
        case kTTCounterRunning:
            [self.startStop setTitle:kEKStopOnStartButton forState:UIControlStateNormal];
            self.picker.userInteractionEnabled = NO;
            self.clockIcon.hidden = NO;
            self.reset.hidden = YES;
            self.save.hidden = YES;
            break;
            
        case kTTCounterStopped:
            [self.startStop setTitle:kEKStartButton forState:UIControlStateNormal];
            self.clockIcon.hidden = YES;
            self.reset.hidden = NO;
            self.save.hidden = NO;
            break;
            
        case kTTCounterReset:
            [self.startStop setTitle:kEKStartButton forState:UIControlStateNormal];
            self.picker.userInteractionEnabled = YES;
            self.reset.hidden = YES;
            self.save.hidden = YES;
            self.startStop.hidden = NO;
            break;
            
        case kTTCounterEnded:
            self.startStop.hidden = YES;
            self.reset.hidden = NO;
            self.save.hidden = NO;
            break;
            
        default:
            break;
    }
}

@end
