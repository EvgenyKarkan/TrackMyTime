//
//  FHCircleView.h
//
//  Created by Florian Heiber on 25.02.13.
//  Copyright (c) 2013 rootof.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FHCircleView : UIView

/// The circle's color. Defaults to [UIColor blueColor].
@property (strong, nonatomic) UIColor *color;

/// The circle's diameter. Defaults to 10.
@property NSUInteger diameter;

/// Convenience method. Create's a FHCircleView instance with a diameter of 10.
+ (FHCircleView *)new;

/// Designated initializer. 
- (id)initWithDiameter:(NSUInteger)diameter;

/// Alternate initializer for setting the diameter and the color directly.
- (id)initWithDiameter:(NSUInteger)diameter color:(UIColor *)color;

@end
