//
//  SKPatternLockController.h
//  NewZhongYan
//
//  Created by lilin on 13-10-11.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawPatternLockView.h"
enum PatternLockStatus
{
    PatternLockStatusUnlocking,//解锁
    PatternLockStatusInputingOldPassword,//输入原始密码
    PatternLockStatusInputingNewPassword,//输入新密码
    PatternLockStatusConfirmingNewPassword,//确认新密码
};

@protocol drawPatternLockDelegate <NSObject>
/**
 *  屏保解锁成功
 */
-(void)onPatternLockSuccess;
@end

@interface SKPatternLockController : UIViewController
{
    __weak IBOutlet DrawPatternLockView *drawView;
    __weak IBOutlet UILabel *markLabel;
    enum PatternLockStatus status;//当前状态
    NSString *password;//原始密码
    NSString *firstPassword;//第一次输入的密码
    int errorCount;//错误次数
}

@property(nonatomic,assign) BOOL isChangePsw;//是否从设置保护密码界面进入此界面
@property(nonatomic,weak) id<drawPatternLockDelegate> delegate;

-(void)changePassWord;
@end


