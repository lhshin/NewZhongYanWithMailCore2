//
//  SKIntroView.m
//  ZhongYan
//
//  Created by 袁树峰 on 13-5-9.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKIntroView.h"
#import "utils.h"
@implementation SKIntroView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSelf];
    }
    return self;
}

-(void)initSelf
{
    mainScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [mainScrollView setContentSize:CGSizeMake(self.frame.size.width*6, 0)];
    [mainScrollView setBounces:NO];
    [mainScrollView setShowsHorizontalScrollIndicator:NO];
    [mainScrollView setPagingEnabled:YES];
    [mainScrollView setDelegate:self];
    [self addSubview:mainScrollView];
    for (int i=0; i<6; i++)
    {
        UIView *vi=[[UIView alloc] initWithFrame:CGRectMake(320*i, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -20, vi.bounds.size.width, vi.bounds.size.height)];
        NSString *str;
        if ([UIScreen mainScreen].bounds.size.height>480) {
            str=[NSString stringWithFormat:@"help5_%d.png",i+1];
        } else {
            str=[NSString stringWithFormat:@"help4_%d.png",i+1];
        }
        [imageView setImage:[UIImage imageNamed:str]];
        [vi addSubview:imageView];
        if(i==5){
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundImage:[UIImage imageNamed:@"buttonStart"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"buttonStart_pressed"] forState:UIControlStateHighlighted];
            [button setFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height-42-20-20, 240, 40)];
            [button setTitle:@"开始使用" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
            [vi addSubview:button];
        }
        [mainScrollView addSubview:vi];
    }
    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(135, [UIScreen mainScreen].bounds.size.height-20-20, 50, 20)];
    [pageControl setNumberOfPages:6];
    pageControl.currentPage=0;
    [self addSubview:pageControl];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    pageControl.currentPage=scrollView.contentOffset.x/320;
}

-(void)start
{
    [UIView animateWithDuration:0.5 animations:^ {
        [self setAlpha:0.2];
    } completion:^(BOOL a){
        if (a){
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [self removeFromSuperview];
        }
    }];
}

-(void)dealloc
{
    
}
@end
