//
//  EKChartView.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 15.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "FHCircleView.h"
#import "FXPageControl.h"
#import "EKBarChartView.h"

@interface EKChartView : UIView

@property (nonatomic, strong) XYPieChart     *chart;
@property (nonatomic, strong) FHCircleView   *cirle;
@property (nonatomic, strong) FHCircleView   *cirle2;
@property (nonatomic, strong) FXPageControl  *pageControl;
@property (nonatomic, strong) EKBarChartView *barChartView;
@property (nonatomic, strong) UILabel        *activityTime;
@property (nonatomic, strong) UILabel        *activityTime2;
@property (nonatomic, strong) UILabel        *activity;
@property (nonatomic, strong) UILabel        *activityName;
@property (nonatomic, strong) UILabel        *activityName2;
@property (nonatomic, strong) UILabel        *totalTime;
@property (nonatomic, strong) UILabel        *total;
@property (nonatomic, strong) UIImageView    *clock;
@property (nonatomic, strong) UIImageView    *clock2;
@property (nonatomic, strong) UIScrollView   *scrollView;

@end
