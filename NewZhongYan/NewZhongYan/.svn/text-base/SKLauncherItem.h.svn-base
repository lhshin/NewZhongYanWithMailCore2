//
//  SKLauncherItem.h
//  ZhongYan
//
//  Created by linlin on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
@class CustomBadge;
//桌面上的主按钮
@interface SKLauncherItem : UIView
{
    EGOImageButton    *tapButton;
    UILabel     *titleLabel;
    CustomBadge *badge;
}

@property(nonatomic,strong) EGOImageButton    *tapButton;
@property(nonatomic,strong) UILabel     *titleLabel;
@property(nonatomic,strong) CustomBadge *badge;
-(void)setTitle:(NSString *)title;
-(void)setNormalImage:(NSString *)normalImage;
-(void)setHighlightedImage:(NSString *)highlightedImage;
-(void)setBadgeNumber:(NSString*)badgeNumber;
@end
