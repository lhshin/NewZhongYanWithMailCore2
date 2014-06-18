//
//  SKLauncherItem.m
//  ZhongYan
//
//  Created by linlin on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKLauncherItem.h"
#import "CustomBadge.h"
#import <QuartzCore/QuartzCore.h>
@implementation SKLauncherItem
@synthesize tapButton,badge,titleLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //self.backgroundColor = COLOR(57, 255, 171);
        tapButton = [EGOImageButton buttonWithType:UIButtonTypeCustom];
        tapButton.layer.cornerRadius = 10;
        [tapButton setFrame:CGRectMake(0, 0, 60, 60)];
        [self addSubview:tapButton];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tapButton.frame), CGRectGetWidth(tapButton.frame), 20)];
        titleLabel.text = @"";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
        
        self.badge = [CustomBadge customBadgeWithString:@""];
        badge.center = CGPointMake(55, 0);
        [self.badge setHidden:YES];
        [self addSubview:badge];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
}
-(void)setTitle:(NSString *)title
{
    if (title) {
        titleLabel.text = title;
    }
}

-(void)setNormalImage:(NSString *)normalImage
{
    if (normalImage) {
        [tapButton setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    }
}

-(void)setHighlightedImage:(NSString *)highlightedImage
{
    if (highlightedImage) {
        [tapButton setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    }
}

-(void)setBadgeNumber:(NSString*)badgeNumber
{
    [self.badge setHidden:!badgeNumber];
    if (badgeNumber) {
        [self.badge autoBadgeSizeWithString:badgeNumber];
    }
}

-(void)dealloc{
}
@end
