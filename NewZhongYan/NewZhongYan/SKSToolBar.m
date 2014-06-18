//
//  SKSToolBar.m
//  ZhongYan
//
//  Created by linlin on 10/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKSToolBar.h"
#import "UIImage+rescale.h"
#import "APPUtils.h"
#import "SKViewController.h"

@implementation SKSToolBar
@synthesize homeButton,firstButton,secondButton;
@synthesize firstLabel,secondLabel;
-(void)backToRoot:(id)sender
{
    SKViewController* controller = [APPUtils AppRootViewController];
    [controller.navigationController popToRootViewControllerAnimated:YES];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR(247, 247, 247);
        homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [homeButton setImage:Image(@"homepage") forState:UIControlStateNormal];
        [homeButton setImage:Image(@"homepage_blue") forState:UIControlStateSelected];
        [homeButton setImage:Image(@"homepage_blue") forState:UIControlStateHighlighted];
        [homeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
        [homeButton setFrame:CGRectMake(2, 0, 49, 49)];
        [homeButton addTarget:self action:@selector(backToRoot:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:homeButton];
        
        UILabel* homeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        homeLabel.text = @"首页";
        homeLabel.textAlignment = NSTextAlignmentCenter;
        homeLabel.backgroundColor = [UIColor clearColor];
        homeLabel.font = [UIFont systemFontOfSize:10];
        homeLabel.font = [UIFont systemFontOfSize:12];
        CGPoint labelCenter = homeButton.center;
        labelCenter.y += 15;
        [homeLabel setCenter:labelCenter];
        [self addSubview:homeLabel];

        firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [firstButton setFrame:CGRectMake(180, 0, 49, 49)];
        [firstButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
        [firstButton setImage:Image(@"btn_search_ecm") forState:UIControlStateNormal];
        [firstButton setImage:Image(@"btn_search_ecm_press") forState:UIControlStateSelected];
        [firstButton setImage:Image(@"btn_search_ecm_press") forState:UIControlStateHighlighted];
        [self addSubview:firstButton];
        
        firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        firstLabel.text = @"搜索";
        firstLabel.textAlignment = NSTextAlignmentCenter;
        firstLabel.backgroundColor = [UIColor clearColor];
        firstLabel.font = [UIFont systemFontOfSize:10];
        firstLabel.font = [UIFont systemFontOfSize:12];
        CGPoint searchLabelCenter = firstButton.center;
        searchLabelCenter.y += 15;
        [firstLabel setCenter:searchLabelCenter];
        [self addSubview:firstLabel];
        
        secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [secondButton setFrame:CGRectMake(260, 0, 49, 49)];
        [secondButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
        [secondButton setImage:[UIImage imageNamed:@"btn_refresh_ecm"] forState:UIControlStateNormal];
        [secondButton setImage:[UIImage imageNamed:@"btn_refresh_ecm_press"] forState:UIControlStateSelected];
        [secondButton setImage:[UIImage imageNamed:@"btn_refresh_ecm_press"] forState:UIControlStateHighlighted];
        [self addSubview:secondButton];
        
        secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        secondLabel.text = @"同步";
        secondLabel.textAlignment = NSTextAlignmentCenter;
        secondLabel.backgroundColor = [UIColor clearColor];
        secondLabel.font = [UIFont systemFontOfSize:10];
        secondLabel.font = [UIFont systemFontOfSize:12];
        CGPoint refreshlabelCenter = secondButton.center;
        refreshlabelCenter.y += 15;
        [secondLabel setCenter:refreshlabelCenter];
        [self addSubview:secondLabel];
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 0.5)];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:view];
    }
    return self;
}

-(void)setFirstItem:(NSString*)imageName Title:(NSString*)title
{
    [firstLabel setText:title];
    [firstButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [firstButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_press",imageName]] forState:UIControlStateSelected];
    [firstButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_press",imageName]] forState:UIControlStateHighlighted];
}

-(void)setSecondItem:(NSString*)imageName Title:(NSString*)title
{
    [secondLabel setText:title];
    [secondButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [secondButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_press",imageName]] forState:UIControlStateSelected];
    [secondButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_press",imageName]] forState:UIControlStateHighlighted];
}

-(void)setFirstItem:(NSString*)imageName Title:(NSString*)title Target:(id)target action:(SEL)action
{
    [self setFirstItem:imageName Title:title];
    [firstButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)setSecondItem:(NSString*)imageName Title:(NSString*)title Target:(id)target action:(SEL)action
{
    [self setSecondItem:imageName Title:title];
    [secondButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)addFirstTarget:(id)target action:(SEL)action
{
    [firstButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

-(void)addSecondTarget:(id)target action:(SEL)action
{
    [secondButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
