//
//  EKChartView.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 15.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHCircleView.h"

@interface EKChartView : UIView

@property (nonatomic, strong) XYPieChart *chart;
@property (nonatomic, strong) FHCircleView *cirle;
@property (nonatomic, strong) UILabel *activityTime;
@property (nonatomic, strong) UILabel *annotationFromTo;
@property (nonatomic, strong) UILabel *activity;
@property (nonatomic, strong) UILabel *activityName;
@property (nonatomic, strong) UILabel *totalTime;
@property (nonatomic, strong) UILabel *total;

@end
