//
//  FHCircleView.m
//
//  Created by Florian Heiber on 25.02.13.
//  Copyright (c) 2013 rootof.net. All rights reserved.
//

#import "FHCircleView.h"

@implementation FHCircleView

const NSUInteger FHCircleViewDefaultDiameter = 10;

@synthesize color = _color;

+ (FHCircleView *)new {
    return [[FHCircleView alloc] initWithDiameter:FHCircleViewDefaultDiameter];
}

- (id)initWithDiameter:(NSUInteger)diameter {
    _diameter = diameter;
    return [self initWithFrame:CGRectMake(0, 0, _diameter, _diameter)];
}

- (id)initWithDiameter:(NSUInteger)diameter color:(UIColor *)color {
    _diameter = diameter;
    _color = color;
    return [self initWithFrame:CGRectMake(0, 0, _diameter, _diameter)];
}

- (id)initWithFrame:(CGRect)frame {
    // Check if the frame's width and height are equal. If not so do not create an object and return nil.
    if (frame.size.width != frame.size.height) {
        return nil;
    }
    
    if (self = [super initWithFrame:frame]) {
        // Clear the background.
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (UIColor *)color {
    if (!_color) {
        return [UIColor blueColor];
    } else {
        return _color;
    }
}

- (void)drawRect:(CGRect)rect {
    const CGFloat *components = CGColorGetComponents([[self color] CGColor]);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 2.0);
    CGContextSetFillColor(contextRef, components);
    CGContextSetStrokeColor(contextRef, components);
    CGContextFillEllipseInRect(contextRef, rect);
}

@end
