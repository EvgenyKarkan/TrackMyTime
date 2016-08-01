//
//  EKChartView.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 15.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKChartView.h"
#import "EKLayoutUtil.h"

static CGFloat const kEKPieRadius            = 120.0f;
static CGFloat const kEKPieLabelFontSize     = 14.0f;
static CGFloat const kEKPieLabelRadius       = 135.0f;
static CGFloat const kEKChartSideSize        = 320.0f;
static CGFloat const kEKChartCenterY         = 131.0f;

static NSString * const kEKActivityLabelText = @"Activity";
static NSString * const kEKTotalLabelText    = @"Total";
static NSString * const kEKClockIcon         = @"clock";


@implementation EKChartView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = APP_BACKGROUND_COLOR;
        
        self.scrollView                                = [[UIScrollView alloc] init];
        self.scrollView.pagingEnabled                  = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        self.chart = [[XYPieChart alloc] init];
        self.chart.pieRadius = kEKPieRadius;
        [self.chart setStartPieAngle:M_PI_2];
        [self.chart setUserInteractionEnabled:YES];
        [self.chart setShowPercentage:YES];
        [self.chart setPieBackgroundColor:APP_BACKGROUND_COLOR];
        [self.chart setLabelFont:[UIFont fontWithName:kEKFont size:kEKPieLabelFontSize]];
        [self.chart setLabelColor:[UIColor blackColor]];
        [self.chart setShowLabel:YES];
        [self.chart setLabelRadius:kEKPieLabelRadius];
        [self.scrollView addSubview:self.chart];
        
        self.activityTime               = [[UILabel alloc] init];
        self.activityTime.font          = [UIFont fontWithName:kEKFont size:17.0f];
        self.activityTime.textAlignment = NSTextAlignmentLeft;
        [self.scrollView addSubview:self.activityTime];
        
        self.cirle = [[FHCircleView alloc] initWithDiameter:15.0f];
        [self.scrollView addSubview:self.cirle];
        
        self.activityName               = [[UILabel alloc] init];
        self.activityName.font          = [UIFont fontWithName:kEKFont size:17.0f];
        self.activityName.textAlignment = NSTextAlignmentLeft;
        [self.scrollView addSubview:self.activityName];
        
        self.activity               = [[UILabel alloc] init];
        self.activity.font          = [UIFont fontWithName:kEKFont size:17.0f];
        self.activity.textAlignment = NSTextAlignmentRight;
        self.activity.text          = kEKActivityLabelText;
        [self.scrollView addSubview:self.activity];
        
        self.total               = [[UILabel alloc] init];
        self.total.font          = [UIFont fontWithName:kEKFont size:17.0f];
        self.total.textAlignment = NSTextAlignmentRight;
        self.total.text          = kEKTotalLabelText;
        [self.scrollView addSubview:self.total];
        
        self.totalTime               = [[UILabel alloc] init];
        self.totalTime.font          = [UIFont fontWithName:kEKFont size:17.0f];
        self.totalTime.textAlignment = NSTextAlignmentLeft;
        [self.scrollView addSubview:self.totalTime];
        
        self.clock = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kEKClockIcon]];
        [self.scrollView addSubview:self.clock];
        
        self.pageControl                          = [[FXPageControl alloc] init];
        self.pageControl.backgroundColor          = [UIColor clearColor];
        self.pageControl.numberOfPages            = 2;
        self.pageControl.defersCurrentPageDisplay = NO;
        self.pageControl.selectedDotColor         = iOS7Blue;
        self.pageControl.dotColor                 = [UIColor colorWithRed:0.827451f green:0.827451f blue:0.827451f alpha:1.0f];
        self.pageControl.dotSize                  = 12.0f;
        self.pageControl.dotSpacing               = 30.0f;
        self.pageControl.wrapEnabled              = YES;
        [self addSubview:self.pageControl];
        
        self.barChartView = [[EKBarChartView alloc] init];
        [self.scrollView addSubview:self.barChartView];
        
        self.cirle2 = [[FHCircleView alloc] initWithDiameter:15.0f];
        [self.barChartView addSubview:self.cirle2];
        
        self.activityName2               = [[UILabel alloc] init];
        self.activityName2.font          = [UIFont fontWithName:kEKFont size:17.0f];
        self.activityName2.textAlignment = NSTextAlignmentLeft;
        [self.barChartView addSubview:self.activityName2];
        
        self.clock2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kEKClockIcon]];
        [self.barChartView addSubview:self.clock2];
        
        self.activityTime2               = [[UILabel alloc] init];
        self.activityTime2.font          = [UIFont fontWithName:kEKFont size:17.0f];
        self.activityTime2.textAlignment = NSTextAlignmentLeft;
        [self.barChartView addSubview:self.activityTime2];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, [EKLayoutUtil scrollHeight]);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 2, self.scrollView.frame.size.height / 2);
    
    self.chart.frame = CGRectMake(0.0f, 20.0f, kEKChartSideSize, kEKChartSideSize);
    [self.chart setPieCenter:CGPointMake(self.frame.size.width / 2, kEKChartCenterY)];
    
    [self.cirle setCenter:CGPointMake(160.0f, [EKLayoutUtil cirleCenterY])];
    
    self.activityName.frame = CGRectMake(175.0f, [EKLayoutUtil activityNameLabelY], 125.0f, 20.0f);
    self.activityTime.frame = CGRectMake(175.0f, [EKLayoutUtil timeLabelY], 130.0f, 20.0f);
    self.clock.frame = CGRectMake(152.0f, [EKLayoutUtil timeLabelY] + 1.0f, 17.5f, 17.5f);
    
    self.activity.frame = CGRectMake(30.0f, [EKLayoutUtil activityLabelY], 105.0f, 30.0f);
    self.total.frame = CGRectMake(30.0f, [EKLayoutUtil totalLabelY], 105.0f, 30.0f);
    
    self.totalTime.frame = CGRectMake(154.0f, [EKLayoutUtil totalTimeLabelY], self.frame.size.width / 2, 30.0f);
    
    CGFloat pageControlHeight = 35.0f;
    self.pageControl.frame = CGRectMake(0.0f, self.frame.size.height - pageControlHeight, self.frame.size.width, pageControlHeight);
    
    [self.cirle2 setCenter:CGPointMake(35.0f, self.barChartView.frame.size.height + 10.0f)];
    self.activityName2.frame = CGRectMake(self.cirle2.frame.origin.x + 22.0f, self.barChartView.frame.size.height, 120.0f, 20.0f);
    self.clock2.frame = CGRectMake(180.0f, self.barChartView.frame.size.height + 2.0f, 17.5f, 17.5f);
    self.activityTime2.frame = CGRectMake(self.clock2.frame.origin.x + 22.0f, self.barChartView.frame.size.height, 110.0f, 20.0f);
}

@end
