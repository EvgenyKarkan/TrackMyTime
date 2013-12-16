//
//  EKChartView.h
//  TrackMyTime
//
//  Created by Evgeny Karkan on 15.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EKChartView : UIView

@property (nonatomic, strong) XYPieChart *chart;
@property (nonatomic, strong) UILabel *timeIndicator;

@end
