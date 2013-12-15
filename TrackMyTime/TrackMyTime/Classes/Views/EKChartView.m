//
//  EKChartView.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 15.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKChartView.h"


@implementation EKChartView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		self.chart = [[XYPieChart alloc] init];
		self.chart.pieRadius = 105.0f;
		[self.chart setStartPieAngle:M_PI_2];
		[self.chart setUserInteractionEnabled:YES];
		[self.chart setShowPercentage:YES];
		[self.chart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1.0f]];
		[self.chart setLabelFont:[UIFont fontWithName:kEKFont size:14.0f]];
		[self.chart setLabelColor:[UIColor blackColor]];
		[self.chart setShowLabel:YES];
		[self.chart setLabelRadius:118.0f];
		[self addSubview:self.chart];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.chart.frame = CGRectMake(0.0f, 0.0f, 280.0f, 280.0f);
	[self.chart setPieCenter:CGPointMake(self.frame.size.width / 2, 200.0f)];
}

@end
