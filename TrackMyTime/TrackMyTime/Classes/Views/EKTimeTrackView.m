//
//  EKTimeTrackView.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 07.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKTimeTrackView.h"


@implementation EKTimeTrackView;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor colorWithRed:0.898039f green:0.898039f blue:0.898039f alpha:1.0f];
        
		self.startStop = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.startStop setTitle:@"Start" forState:UIControlStateNormal];
		[self.startStop.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50.0f]];
		[self.startStop setTitleColor:[UIColor colorWithRed:0.000000f green:0.478431f blue:1.000000f alpha:1.0f] forState:UIControlStateNormal];
		self.startStop.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[self.startStop addTarget:self action:@selector(startPress) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.startStop];
        
		self.reset = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.reset setTitle:@"Reset" forState:UIControlStateNormal];
		[self.reset.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50.0f]];
		[self.reset setTitleColor:[UIColor colorWithRed:0.000000f green:0.478431f blue:1.000000f alpha:1.0f] forState:UIControlStateNormal];
		self.reset.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[self.reset addTarget:self action:@selector(resetPress) forControlEvents:UIControlEventTouchUpInside];
		self.reset.hidden = YES;
		[self addSubview:self.reset];
        
		self.save = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.save setTitle:@"Save" forState:UIControlStateNormal];
		[self.save.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50.0f]];
		[self.save setTitleColor:[UIColor colorWithRed:0.000000f green:0.478431f blue:1.000000f alpha:1.0f] forState:UIControlStateNormal];
		self.save.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[self.save addTarget:self action:@selector(savePressed) forControlEvents:UIControlEventTouchUpInside];
		self.save.hidden = YES;
		[self addSubview:self.save];
        
		self.counterLabel = [[TTCounterLabel alloc] init];
		self.counterLabel.text = @"00:00:00.00";
		[self.counterLabel setBoldFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:55]];
		[self.counterLabel setRegularFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:55]];
		[self.counterLabel setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:25.0f]];
		self.counterLabel.textColor = [UIColor blackColor];
		[self.counterLabel updateApperance];
		[self addSubview:self.counterLabel];
        
		self.picker = [[UIPickerView alloc] init];
		self.picker.showsSelectionIndicator = YES;
		[self addSubview:self.picker];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
	self.startStop.frame = CGRectMake(0.0f, 170.0f, 320.0f, 30.0f);
	self.reset.frame = CGRectMake(0.0f, 220.0f, 320.0f, 30.0f);
	self.save.frame = CGRectMake(0.0f, 270.0f, 320.0f, 30.0f);
    self.counterLabel.frame = CGRectMake(20.0f, 65.0f, 280.0f, 100.0f);
    self.picker.frame = CGRectMake(10.0f, self.save.frame.origin.y + self.save.frame.size.height + 10.0f, 300.0f, 162.0f);
}

#pragma mark - Actions with delegated stuff

- (void)startPress
{
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
			[self.startStop setTitle:NSLocalizedString(@"Stop", @"Stop") forState:UIControlStateNormal];
			self.picker.userInteractionEnabled = NO;
			self.reset.hidden = YES;
			self.save.hidden = YES;
			break;
            
		case kTTCounterStopped:
			[self.startStop setTitle:NSLocalizedString(@"Start", @"Start") forState:UIControlStateNormal];
			self.reset.hidden = NO;
			self.save.hidden = NO;
			break;
            
		case kTTCounterReset:
			[self.startStop setTitle:NSLocalizedString(@"Start", @"Start") forState:UIControlStateNormal];
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
