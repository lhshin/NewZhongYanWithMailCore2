//
//  DrawPatternLockView.h
//  NewZhongYan
//
//  Created by lilin on 13-10-11.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawPatternLockView : UIView
{
     UIImageView *helpImage;
}
@property (nonatomic,assign) BOOL isError;
@property (nonatomic,strong) NSMutableArray *dotViews;
@property (nonatomic,assign) CGPoint _trackPointValue;
@property (nonatomic,assign) int tapCount;//连续点击圆点的次数


- (void)clearDotViews;
- (void)addDotView:(UIView*)view;
- (void)drawLineFromLastDotTo:(CGPoint)pt;
@end
