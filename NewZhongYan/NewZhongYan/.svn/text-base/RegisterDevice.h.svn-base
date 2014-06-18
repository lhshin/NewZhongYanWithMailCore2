//
//  RegisterDevice.h
//  HNZYiPad
//
//  Created by lilin on 13-6-5.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import <Foundation/Foundation.h>
//注册协议 该协议暂时没有用到
@protocol RegisterDeviceProtocal <NSObject>
@optional
-(void)onRegisterSuccess;
-(void)onRegisterFaild;
@end

@class User;
@interface RegisterDevice : NSObject

//属性
@property (nonatomic,strong) id<RegisterDeviceProtocal> delegate;

//方法
-(void)rigisterCurrentDevice:(User*)user;
@end
