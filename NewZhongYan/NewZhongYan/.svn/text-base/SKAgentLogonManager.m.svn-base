 //
//  SKAgentLogonManager.m
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKAgentLogonManager.h"
#import "RegisterDevice.h"
#import "User.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "DBQueue.h"
#import "NSString+codec.h"
#import "dbUtils.h"
#import "NetUtils.h"
#import "SKAppDelegate.h"
@implementation SKAgentLogonManager
@synthesize loggedUser;
-(id)init
{
    self = [super init];
    if (self) {
        self.loggedUser = [SKAppDelegate sharedCurrentUser];
    }
    return self;
}


-(void)afterAgentLogon:(User*)user
{
    @try
    {
        RegisterDevice *registerDevice=[[RegisterDevice alloc] init];
        [registerDevice  rigisterCurrentDevice:loggedUser];
        NSMutableDictionary* ecvl  = [NSMutableDictionary dictionary];
        [ecvl setObject:[user uid] forKey:@"UID"];
        [ecvl setObject:[user name] forKey:@"CNAME"];
        [ecvl setObject:[user title] ? [user title] :@""  forKey:@"TNAME"];
        [ecvl setObject:[user departmentName] forKey:@"DNAME"];
        [ecvl setObject:[user departmentId] forKey:@"DPID"];
        [ecvl setObject:[user rememberPwd] ? [[user password] encrypted]: @"" forKey:@"WPWD"];
        [ecvl setObject:[NSNumber numberWithInt:[user rememberPwd]] forKey:@"RPWD"];
        [ecvl setObject:[NSNumber numberWithInt:[user logged]]forKey:@"LOGGED"];
        [ecvl setObject:[NSDate date] forKey:@"UPT"];
        [ecvl setObject:[user mobile] forKey:@"MOBILE"];
        if(![[DBQueue sharedbQueue] updateDataTotableWithSQL:[dbUtils buildInsertSQL:@"USER_REMS" Value:ecvl]])
        {
            NSLog(@"保存个人信息数据时发生错误");
        }
        [SKClientApp getClientAppWithCompleteBlock:^{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SynedClientApp"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } faliureBlock:^(NSError* error){
            
        }];
    }
    @catch (NSException *e) {
        @throw [NSException exceptionWithName:[e name] reason:[e reason] userInfo:nil];
    }
}

-(BOOL)isLoggedCookieValidity
{
    ASIHTTPRequest* validateLogonrequest =
    [ASIHTTPRequest requestWithURL:validloginurl];
    [validateLogonrequest setTimeOutSeconds:15];
    [validateLogonrequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [validateLogonrequest startSynchronous];
    if ([[validateLogonrequest responseData] length] == 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//使用默认的方式进行登录
-(void)logonAgentWithUid:(NSString*)uid Password:(NSString*)password
{
    return [self logonAgentWithUid:uid Password:password RememberPwd:YES];
}

-(void)logOut
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"http://tam.hngytobacco.com/pkmslogout.form"]];
    [request startSynchronous];
}

-(void)logonAgentWithUid:(NSString*)uid Password:(NSString*)password RememberPwd:(BOOL) rememberPwd
{
    
    if ([self isLoggedCookieValidity]) {
        [self logOut];
    }
    
    ASIFormDataRequest *loginrequest = [ASIFormDataRequest requestWithURL:loginurl];
    [loginrequest setDefaultResponseEncoding:NSUTF8StringEncoding];//完美解决中文编码乱码的问题
    [loginrequest setPostValue:uid forKey:@"userName"];
    [loginrequest setPostValue:password forKey:@"password"];
    [loginrequest setPostValue:@"pwd"   forKey:@"login-form-type"];
    [loginrequest setTimeOutSeconds:15];
    [loginrequest startSynchronous];
    if (loginrequest.error)
    {
        @throw [NSException exceptionWithName:@"登录失败"
                                       reason:[NetUtils userInfoWhenRequestOccurError:loginrequest.error]
                                     userInfo:nil];
    }
    else
    {
        if (loginrequest.responseStatusCode == 200)
        {
            if (![self isLoggedCookieValidity])
            {
                @throw [NSException exceptionWithName:@"登录失败" reason:@"帐号或者密码错误" userInfo:nil];
            }
            [loggedUser setUid:uid];
            [loggedUser setPassword:password];
            [loggedUser setRememberPwd:rememberPwd];
            [loggedUser setLogged:YES];
            [loggedUser setLastLoginDate:[NSDate date]];
            [self afterAgentLogon:self.loggedUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginBack" object:nil userInfo:nil];
        }
        else
        {
            @throw [NSException exceptionWithName:@"登录失败"
                                           reason:@"服务器异常"
                                         userInfo:nil];
        }
    }
}

-(void)loginWithUser:(User*)user CompleteBlock:(basicBlock)block
{
    if ([self isLoggedCookieValidity]) {
        [self logOut];
    }
    
    ASIFormDataRequest *loginrequest = [ASIFormDataRequest requestWithURL:loginurl];
    [loginrequest setDefaultResponseEncoding:NSUTF8StringEncoding];//完美解决中文编码乱码的问题
    [loginrequest setPostValue:user.uid forKey:@"userName"];
    [loginrequest setPostValue:user.password forKey:@"password"];
    [loginrequest setPostValue:@"pwd"   forKey:@"login-form-type"];
    [loginrequest setTimeOutSeconds:15];
    [loginrequest startSynchronous];
    if (loginrequest.error){
        @throw [NSException exceptionWithName:@"登录失败"
                                       reason:[NetUtils userInfoWhenRequestOccurError:loginrequest.error]
                                     userInfo:nil];
    }else{
        if (loginrequest.responseStatusCode == 200)
        {
            if (![self isLoggedCookieValidity])
            {
                @throw [NSException exceptionWithName:@"登录失败" reason:@"帐号或者密码错误" userInfo:nil];
            }else{
                [self.loggedUser setUid:user.uid];
                [self.loggedUser setPassword:user.password];
                [self.loggedUser setName:user.name];
                [self.loggedUser setTitle:user.title];
                [self.loggedUser setRememberPwd:user.rememberPwd];
                [self.loggedUser setDepartmentId:user.departmentId];
                [self.loggedUser setDepartmentName:user.departmentName];
                [self.loggedUser setMobile:user.mobile];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(block){
                        block();
                    }
                });
            }
        }else{
            @throw [NSException exceptionWithName:@"登录失败"
                                           reason:@"服务器异常"
                                         userInfo:nil];
        }
    }
}

-(void)loginWithUser:(User*)user CompleteBlock:(basicBlock)block failureBlock:(errorBlock)errorblock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [BWStatusBarOverlay showLoadingWithMessage:@"正在登录..." animated:YES];
    });
    [SKAppDelegate sharedCurrentUser].logging = YES;
    if ([self isLoggedCookieValidity]) {
        [self logOut];
    }
    
    ASIFormDataRequest *loginrequest = [ASIFormDataRequest requestWithURL:loginurl];
    [loginrequest setDefaultResponseEncoding:NSUTF8StringEncoding];//完美解决中文编码乱码的问题
    [loginrequest setPostValue:user.uid forKey:@"userName"];
    [loginrequest setPostValue:user.password forKey:@"password"];
    [loginrequest setPostValue:@"pwd"   forKey:@"login-form-type"];
    [loginrequest setTimeOutSeconds:10];
    [loginrequest startSynchronous];
    if (loginrequest.error){
        if (errorblock) {
            errorblock(@{@"name": @"登录失败",@"reason":[NetUtils userInfoWhenRequestOccurError:loginrequest.error]});
        }
        [SKAppDelegate sharedCurrentUser].logging = NO;
    } else{
        if (loginrequest.responseStatusCode == 200)
        {
            if (![self isLoggedCookieValidity]){
                if (errorblock) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView* av = [UIAlertView showAlertString:@"帐号或者密码已经被修改请重新登录"];
                        av.delegate = [APPUtils AppRootViewController];;
                        av.tag = 101;
                    });
                    //errorblock(@{@"name": @"登录失败",@"reason":@"帐号或者密码错误"});
                }
            }else{
                [loggedUser setLogged:YES];
                [loggedUser setLastLoginDate:[NSDate date]];
                if(block){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [BWStatusBarOverlay showSuccessWithMessage:@"登录成功" duration:1 animated:1];
                    });
                    block();
                }
            }
        }else {
            if (errorblock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BWStatusBarOverlay showErrorWithMessage:@"服务器异常" duration:1 animated:YES];
                });
                errorblock(@{@"name": @"登录失败",@"reason":@"服务器异常"});
            }
        }
        [SKAppDelegate sharedCurrentUser].logging = NO;
    }
}

-(void)beforeAgentLogout
{
    NSString* uid = [loggedUser uid];
    NSString* sql =
    [NSString stringWithFormat:@"UPDATE USER_REMS SET LOGGED = 0,WPWD = '',RPWD = 0 WHERE UID = '%@'",uid];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
}

-(void)afterAgentLogout
{
    [loggedUser setName:nil];
    [loggedUser setUid:nil];
    [loggedUser setLogged:NO];
    [loggedUser setPassword:nil];
    [loggedUser setRememberPwd:NO];
}

-(void)userLogout
{
    [self beforeAgentLogout]; //在退出之前要对数据库进行更新 LOGGED ＝ 0 WPWD ＝ ‘’ RPWD ＝ 0 WHERE UID ＝ ‘’
    [self logOut];
    [self afterAgentLogout];
}

//待完善
//判断是否有用户登录
-(BOOL)isUserlogged
{
    return [loggedUser logonabled] && [loggedUser isLogged];
}

+(User*)historyLoggedUsers;
{
    User* user = nil;
    NSDictionary* item =[[DBQueue sharedbQueue] getSingleRowBySQL:@"select * from USER_REMS order by UPT DESC;"];
    if (item) {
        user= [[User alloc] init];
        [user setUid:[item objectForKey:@"UID"]];
        [user setName:[item objectForKey:@"CNAME"]];
        [user setTitle:[item objectForKey:@"TNAME"]];
        [user setDepartmentName:[item objectForKey:@"DNAME"]];
        [user setDepartmentId:[item objectForKey:@"DPID"]];
        [user setPassword:[[item objectForKey:@"WPWD"] decrypted]];
        [user setLogged:NO];
        [user setEnabled:YES];
        [user setMobile:[item objectForKey:@"MOBILE"]];
        NSString* sql = [NSString stringWithFormat:@"SELECT E.CNAME,E.DPNAME,E.MOBILE,E.TELEPHONE,E.OFFICEADDRESS,E.EMAIL,U.CNAME UCNAME,U.DPID UDPID FROM T_EMPLOYEE E,T_UNIT U ,T_ORGANIZATIONAL O WHERE E.UID = O.OID AND U.DPID = O.POID AND E.ENABLED = 1 AND (E.UID = '%@');",[item objectForKey:@"UID"]];
        item = nil;
        item =[[DBQueue sharedbQueue] getSingleRowBySQL:sql];
        if (item) {
            user.email = item[@"EMAIL"];
            user.telephone = item[@"TELEPHONE"];
            user.mobile = item[@"MOBILE"];
            user.officeaddress = item[@"OFFICEADDRESS"];
            user.DPNAME = item[@"DPNAME"];
            user.UDPID = item[@"UDPID"];
            user.UCNAME = item[@"UCNAME"];
        }
    }
    return user;
}

//删除某个人在本地的所有登录的有关信息
+(void)cleanUserLocalSessionWithUserName:(NSString*)uid
{
    NSString* sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE UID = '%@'",@"USER_REMS",uid];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
}

//删除某个人在本地的所有登录的有关信息
+(void)cleanUserLocalSessionWithUser:(User*)user
{
    [self cleanUserLocalSessionWithUserName:user.uid];
}

//恢复某个曾经登录过的用户有关的信息
-(NSDictionary*)restoreRemembereredLoggedSession:(NSString*)uid
{
    NSString* sql = [NSString stringWithFormat:@"select * from USER_REMS where uid = '%@';",uid];
    NSDictionary* dict = [[DBQueue sharedbQueue] getSingleRowBySQL:sql];
    return dict;
}

@end
