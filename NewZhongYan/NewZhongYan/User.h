//
//  User.h
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property(nonatomic,strong) NSString* uid;              //用户ID
@property(nonatomic,strong) NSString* name;             //用户名
@property(nonatomic,strong) NSString* title;            //职业
@property(nonatomic,strong) NSString* password;         //密码
@property(nonatomic,strong) NSString* departmentName;   //部门名
@property(nonatomic,strong) NSString* departmentId;     //部门ID
@property(nonatomic,strong) NSString* mobile;
@property(nonatomic,strong) NSString* email;            //
@property(nonatomic,strong) NSString* telephone;           //
@property(nonatomic,strong) NSString* officeaddress;           //
@property(nonatomic,strong) NSString* UCNAME;           //通讯录里面的值      人力资源部门
@property(nonatomic,strong) NSString* DPNAME;           //通讯录里面的部门位置 长沙
@property(nonatomic,strong) NSString* UDPID;            //通讯录里面的值      部门ID
@property(nonatomic,strong) NSDate*  lastLoginDate;
@property   BOOL logged;                                //是否已经登录
@property   BOOL logonabled;                            //能否登录
@property   BOOL enabled;                               //是不是无效用户s
@property   BOOL rememberPwd;
@property   BOOL logging;                                //是否已经登录
/**
 *  创建一个User的对象
 *
 *  @param userId       用户ID
 *  @param userPassword 用户密码
 *
 *  @return 返回一个用户
 */
-(id)initWithUid:(NSString*)userId
        Password:(NSString*)userPassword;

/**
 *  判断用户是否登陆
 *
 *  @return 用户登陆的状态
 */
-(BOOL)isLogged;
@end
