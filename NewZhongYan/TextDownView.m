//
//  TextDownView.m
//  NewZhongYan
//
//  Created by lilin on 13-11-6.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "TextDownView.h"

@implementation TextDownView
@synthesize flagImage;
@synthesize noticeLabel;
-(id)init
{
    self=[super init];
    if (self)
    {
        [self setFrame:CGRectMake(0, 0, 180, 20)];
        [self setBackgroundColor:[UIColor clearColor]];
        flagImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 10, 10)];
        [flagImage setBackgroundColor:[UIColor clearColor]];
        
        noticeLabel= [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 135, 20)];
        [noticeLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [noticeLabel setBackgroundColor:[UIColor clearColor]];
        [noticeLabel setFont:[UIFont systemFontOfSize:13]];
        [noticeLabel setTextColor:[UIColor colorWithRed:0/255.0  green:89.0/255.0 blue:175.0/255.0 alpha:1]];
        [self addSubview:flagImage];
        [self addSubview:noticeLabel];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        //[self setBackgroundColor:[UIColor greenColor]];
        flagImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 5.5, 10, 10)];
        [flagImage setImage:Image(@"warning.png")];
        
        noticeLabel= [[UILabel alloc] initWithFrame:CGRectMake(12,0.5, 115, 20)];
        [noticeLabel setBackgroundColor:[UIColor clearColor]];
        [noticeLabel setFont:[UIFont systemFontOfSize:13]];
        [noticeLabel setTextColor:[UIColor colorWithRed:0/255.0  green:89.0/255.0 blue:175.0/255.0 alpha:1]];
        [self addSubview:flagImage];
        [self addSubview:noticeLabel];
    }
    return self;
}
@end
