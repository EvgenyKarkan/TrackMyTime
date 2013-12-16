//
//  EKChartView.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 15.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKChartView.h"

static CGFloat const kEKPieRadius        = 120.0f;
static CGFloat const kEKPieLabelFontSize = 14.0f;
static CGFloat const kEKPieLabelRadius   = 135.0f;
static CGFloat const kEKChartSideSize    = 320.0f;
static CGFloat const kEKChartCenterY     = 215.0f;


@implementation EKChartView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
        self.backgroundColor = appBackground;
		self.chart = [[XYPieChart alloc] init];
		self.chart.pieRadius = kEKPieRadius;
		[self.chart setStartPieAngle:M_PI_2];
		[self.chart setUserInteractionEnabled:YES];
		[self.chart setShowPercentage:YES];
		[self.chart setPieBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.0f]];
		[self.chart setLabelFont:[UIFont fontWithName:kEKFont size:kEKPieLabelFontSize]];
		[self.chart setLabelColor:[UIColor blackColor]];
		[self.chart setShowLabel:YES];
		[self.chart setLabelRadius:kEKPieLabelRadius];
		[self addSubview:self.chart];
        
		self.timeIndicator = [[UILabel alloc] init];
		self.timeIndicator.font = [UIFont fontWithName:kEKFont size:18.0f];
		self.timeIndicator.textAlignment = NSTextAlignmentRight;
		[self addSubview:self.timeIndicator];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.chart.frame = CGRectMake(0.0f, 0.0f, kEKChartSideSize, kEKChartSideSize);
	[self.chart setPieCenter:CGPointMake(self.frame.size.width / 2, kEKChartCenterY)];
	self.timeIndicator.frame = CGRectMake(self.frame.size.width / 2, 65.0f, self.frame.size.width / 2, 30.0f);
}

@end
