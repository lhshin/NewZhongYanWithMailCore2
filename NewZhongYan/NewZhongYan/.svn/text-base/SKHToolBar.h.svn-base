//
//  SKHToolBar.h
//  test
//
//  Created by yangz on 14-5-13.
//  Copyright (c) 2014年 yangz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBadgeView.h"


@protocol SKHToolBarProtocol <NSObject>
@optional
- (void)onSingleOneDone:(long)viewTag;
@end

@interface SKHToolBar : UIView
{
    
}

@property (nonatomic, strong) NSObject<SKHToolBarProtocol> *owner;


@property(nonatomic,strong)UIButton* remindBtn;
@property(nonatomic,strong)UIButton* emailBtn;
@property(nonatomic,strong)UIButton* addressdBtn;
@property(nonatomic,retain)UIButton* settingBtn;

@property(nonatomic,strong)UILabel*  remindLabel;
@property(nonatomic,strong)UILabel*  emailLabel;
@property(nonatomic,strong)UILabel*  addressdLabel;
@property(nonatomic,strong)UILabel*  settingLabel;
@property(nonatomic,strong)JSBadgeView *remindBadge;
@property(nonatomic,strong)JSBadgeView *emailBadge;

@end
