//
//  SKPathButton.h
//  NewZhongYan
//
//  Created by lilin on 14-2-26.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    GBPathButtonTypeCircle,
    GBPathButtonTypeSquare
} GBPathButtonType;


@interface SKPathButton : UIButton
@property (nonatomic) GBPathButtonType pathType;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *pathColor;
@property float pathWidth;


- (id)initWithFrame:(CGRect)frame
              image:(UIImage *)image;

- (id)initWithFrame:(CGRect)frame
              image:(UIImage *)image
           pathType:(GBPathButtonType)pathType
          pathColor:(UIColor *)pathColor
        borderColor:(UIColor *)borderColor
          pathWidth:(float)pathWidth;

- (void)draw;
@end
