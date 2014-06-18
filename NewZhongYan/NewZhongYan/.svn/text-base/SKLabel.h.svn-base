//
//  SKLabel.h
//  SKLabelTest
//
//  Created by 李 林 on 12/30/12.
//  Copyright (c) 2012 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
// 该类的主要功能：是为了显示 部分关键字的颜色
@interface SKLabel : UILabel
{
    UIColor         *_keyWordColor; //关键字的颜色
    NSString         *_keyWord;
    NSMutableArray  *_keyWordArray; //用于存储关键字  就目前的业务来说关键字 有可能有很多个
    NSMutableAttributedString *attributedString;
}

//some property
@property(nonatomic,strong)UIColor *keyWordColor;
@property(nonatomic,strong)NSMutableArray *keyWordArray;
@property(nonatomic,strong)NSString       *keyWord;

-(void)addKeyWord:(NSString *)keyWord;

- (void)SetTextColor:(UIColor *) strColor KeyWordColor: (UIColor *) keyColor;

- (void) SetLabelText:(NSString *)string KeyWord:(NSString *)keyword;
//some interface
//设置关键字 和基本文字的颜色
//-(void)settextColor:(UIColor*)textColor KeyWordColor:(UIColor*)keyWordColor;

@end
