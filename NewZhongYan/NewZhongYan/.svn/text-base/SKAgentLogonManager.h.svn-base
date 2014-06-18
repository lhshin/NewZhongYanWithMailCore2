//
//  SKAgentLogonManager.h
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@interface SKAgentLogonManager : NSObject
@property (nonatomic,weak)User* loggedUser;

/**
 *  上次登录的时间
 */
@property(atomic,strong)NSDate* lastLoginDate;

/**
 * @param uid 用户名
 * @param password 密码
 * @param remembePwd 是否记住密码
 * @return 登录成功，则返回用户登录成功的用户
 **/
-(void)logonAgentWithUid:(NSString*)uid Password:(NSString*)password;

/**
 * @param uid 用户名
 * @param password 密码
 * @param remembePwd 是否记住密码
 * @return 登录成功，则返回用户登录成功的用户
 **/
-(void)logonAgentWithUid:(NSString*)uid Password:(NSString*)password RememberPwd:(BOOL) rememberPwd;

-(void)loginWithUser:(User*)user CompleteBlock:(basicBlock)block;

-(void)loginWithUser:(User*)user CompleteBlock:(basicBlock)block failureBlock:(errorBlock)errorblock;
/**
 *  用于非第一次登录的情况
 *
 *  @param user  用户
 *  @param block 执行代码
 */
//-(void)loginWithUser:(User*)user CompleteBlock:(basicBlock)block;
/**
 用户注销登录
 */
-(void)userLogout;

/**
 判断是否有用户登录
 */
-(BOOL)isUserlogged;

/*
 检验判断当前是否 有效的登录Cookie（去服务器判断）
 */
-(BOOL)isLoggedCookieValidity;

/*
 登出前的处理操作
 */
-(void)beforeAgentLogout;

/*
 登出后的处理操作
 */
-(void)afterAgentLogout;

/*
 登陆完成后的数据处理
 */
-(void)afterAgentLogon:(User*)user;

/*
 获取登录了的账户
 */
+ (User*)historyLoggedUsers;
@end
