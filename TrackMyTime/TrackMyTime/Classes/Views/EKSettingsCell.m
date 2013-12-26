//
//  EKSettingsCell.m
//  TrackMyTime
//
//  Created by Evgeny Karkan on 24.12.13.
//  Copyright (c) 2013 EvgenyKarkan. All rights reserved.
//

#import "EKSettingsCell.h"

static NSString * const kEKTopIcon       = @"database_backup";
static NSString * const kEKTopTitle      = @"Export data";
static NSString * const kEKMiddleIcon    = @"trash";
static NSString * const kEKMiddleTitle   = @"Clear data";
static NSString * const kEKBottomIcon    = @"tones";
static NSString * const kEKBottomTitle   = @"Sounds";
static CGFloat    const kEKTitleFontSize = 20.0f;


@implementation EKSettingsCell;

- (instancetype)initWithIndexPath:(NSIndexPath *)path
{
	self = [super init];
    
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.icon = [[UIImageView alloc] init];
		[self addSubview:self.icon];
        
		self.title = [[UILabel alloc] init];
		self.title.textColor = [[UIColor blackColor] colorWithAlphaComponent:1.0f];
		self.title.font = [UIFont fontWithName:kEKFont size:kEKTitleFontSize];
		self.title.textAlignment = NSTextAlignmentLeft;
		[self addSubview:self.title];
        
		switch (path.row) {
			case 0:
				self.icon.image = [UIImage imageNamed:kEKTopIcon];
				self.title.text = kEKTopTitle;
				break;
                
			case 1:
				self.icon.image = [UIImage imageNamed:kEKMiddleIcon];
				self.title.text = kEKMiddleTitle;
				break;
                
			case 2:
				self.icon.image = [UIImage imageNamed:kEKBottomIcon];
				self.title.text = kEKBottomTitle;
				self.soundSwitch = [[UISwitch alloc] init];
                self.soundSwitch.tintColor = [UIColor colorWithRed:0.827451f green:0.827451f blue:0.827451f alpha:1.0f];
                self.soundSwitch.onTintColor = iOS7Blue;
                self.soundSwitch.on ? NSLog(@"ON") : NSLog(@"Off");
				[self addSubview:self.soundSwitch];
				break;
                
			default:
				break;
		}
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    
	self.soundSwitch.frame = CGRectMake(240.0f, 15.0f, 100.0f, 50.0f);
}

@end
