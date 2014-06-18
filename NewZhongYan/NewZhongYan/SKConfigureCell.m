//
//  SKConfigureCell.m
//  ZhongYan
//
//  Created by 袁树峰 on 13-4-9.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKConfigureCell.h"

@implementation SKConfigureCell
@synthesize iconImageView,titleL;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 50, 50)];
        titleL=[[UILabel alloc] initWithFrame:CGRectMake(5, 61, 56, 21)];
        [titleL setBackgroundColor:[UIColor clearColor]];
        [titleL setFont:[UIFont systemFontOfSize:14]];
        [titleL setTextAlignment:NSTextAlignmentCenter];
        
        UIView *hLine=[[UIView alloc] initWithFrame:CGRectMake(0, 87, 66, 1)];
        [hLine setBackgroundColor:[UIColor colorWithRed:115.0/255.0 green:190.0/255.0 blue:247.0/255.0 alpha:1]];
        [self addSubview:hLine];
        [self addSubview:iconImageView];
        [self addSubview:titleL];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    //[self setBackgroundColor:[UIColor]]
    // Configure the view for the selected state
}

-(void)dealloc
{
}
@end
