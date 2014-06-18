//
//  User.m
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize uid;
@synthesize name;
@synthesize title;
@synthesize password;
@synthesize rememberPwd;
@synthesize departmentId;
@synthesize departmentName;
@synthesize mobile;
@synthesize email;
@synthesize telephone;
@synthesize officeaddress;
@synthesize UCNAME;
@synthesize UDPID;
@synthesize DPNAME;
@synthesize logged;
@synthesize logonabled;
@synthesize enabled;
@synthesize lastLoginDate;
@synthesize logging;


-(id)initWithUid:(NSString*)userId Password:(NSString*)userPassword
{
    self = [super init];
    if (self) {
        self.uid = userId;
        //解密
        self.password = userPassword;
    }
    return self;
}

-(BOOL)isLogged
{
    NSString* str = [self.uid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (str.length == 0 || str == nil) {
        return NO;
    }
    return self.logged;
}

//判断该用户是不是anymouse 根据 函数的写法 估计是如果uid没有文字那么 它就是 anymouse
//Anonymous ：匿名 看这个单词是不是写错了
-(BOOL)isAnymouse
{
    NSString* str = [self.uid stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (str.length == 0 || str == nil) {
        return NO;
    }else{
        return YES;
    }
}

//判断该user是不是有效user  有效用户：处于登录状态的用户
//即如果某user 的uid 不为空 且 已经登录了 他才算一个有效用户
-(BOOL)isEnabled
{
    return ![self isAnymouse] && self.logged;
}

-(BOOL)isRememberPwd
{
    return self.rememberPwd;
}
@end
