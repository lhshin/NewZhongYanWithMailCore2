//
//  DrawPatternLockView.m
//  NewZhongYan
//
//  Created by lilin on 13-10-11.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "DrawPatternLockView.h"
#define kLineColor RGBACOLOR(255.0, 252.0, 78.0, 0.9)

@implementation DrawPatternLockView
@synthesize dotViews,isError;
@synthesize _trackPointValue;
@synthesize tapCount;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popupHelp) name:@"popupHelp" object:nil];
    }
    return self;
}

- (void)clearDotViews{
    [dotViews removeAllObjects];
}

- (void)addDotView:(UIView *)view{
    if (view){
        if (!dotViews){
            dotViews = [[NSMutableArray alloc] init];
        }
        [dotViews addObject:view];
    }
}

- (void)drawLineFromLastDotTo:(CGPoint)pt
{
    _trackPointValue = pt;
    [self setNeedsDisplay];
}

-(void)handleTapForHelpImage:(UIGestureRecognizer *)tapGes
{
    if (tapGes.state==UIGestureRecognizerStateEnded) {
        [helpImage fallOut:.4 delegate:0 completeBlock:^{
            [self setUserInteractionEnabled:YES];
        }] ;
    }
}

-(void)popupHelp
{
    tapCount=0;
    //弹出帮助视图
    if (!helpImage)
    {
        helpImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [helpImage setImage:[UIImage imageNamed:[UIScreen mainScreen].bounds.size.height>480 ? @"iphone5_index" : @"iphone4_index"]];
        [helpImage setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapForHelpImage:)];
        [helpImage addGestureRecognizer:tapGes];
    }
    [self.superview addSubview:helpImage];
    [helpImage fallIn:.4 delegate:0 completeBlock:^{
        [self setUserInteractionEnabled:NO];
    }];
}

//功能: 点击dot三次 显示帮助界面
-(void)handleTap:(UITapGestureRecognizer *)tapRec
{
    if (tapRec.state==UIGestureRecognizerStateEnded)
    {
        [(UIImageView *)tapRec.view setHighlighted:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removePatternPath" object:nil];
        [self clearDotViews];
        [self setNeedsDisplay];
        tapCount++;
        if (tapCount==3) {
            [self popupHelp];
        }
    }
}

-(void)dealloc
{
    dotViews = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 7.0);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    UIView *lastDot=nil;
    CGPoint from=CGPointZero;
    if (!isError)
    {
        if (_trackPointValue.x>0)
        {
            if (dotViews.count) {//去掉系统报错
                CGFloat components[] = {171.0/255.0, 171.0/255.0, 171.0/255.0, 0.7};
                CGColorRef color = CGColorCreate(colorspace, components);
                CGContextSetStrokeColorWithColor(context, color);
                for (UIView *dotView in dotViews)
                {
                    from = dotView.center;
                    if (!lastDot)
                    {
                        CGContextMoveToPoint(context, from.x, from.y);
                    }
                    else//从第二个点开始才回执行
                    {
                        CGContextAddLineToPoint(context, from.x, from.y);
                    }
                    lastDot = dotView;
                }
                CGContextMoveToPoint(context, from.x, from.y);//去掉锯齿
                CGContextAddLineToPoint(context, _trackPointValue.x, _trackPointValue.y);
                CGContextDrawPath(context, kCGPathStroke);
                CGColorRelease(color);
                _trackPointValue = CGPointZero;
            }
        }
    }
    else
    {
        CGFloat components[] = {245/255.0, 245/255.0, 245/255.0, 0.7};
        CGColorRef color = CGColorCreate(colorspace, components);
        CGContextSetStrokeColorWithColor(context, color);
        
        for (UIView *dotView in dotViews)
        {
            from = dotView.center;
            if (!lastDot)
                CGContextMoveToPoint(context, from.x, from.y);
            else
                CGContextAddLineToPoint(context, from.x, from.y);
            
            lastDot = dotView;
        }
        CGContextStrokePath(context);
        CGColorRelease(color);
    }
    CGColorSpaceRelease(colorspace);
}
@end
