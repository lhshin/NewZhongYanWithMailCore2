//
//  APPUtils.m
//  NewZhongYan
//
//  Created by lilin on 13-10-8.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "APPUtils.h"
#import "SKAppDelegate.h"
#import "FileUtils.h"
#import "User.h"
#import "SKAgentLogonManager.h"
#import "SKViewController.h"
#import "SKEmailController.h"
@implementation APPUtils
+(SKAppDelegate*)APPdelegate
{
    SKAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    return delegate;
}

+(UIStoryboard*)AppStoryBoard
{
    SKAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    return delegate.mainStoryboard;
}

+(SKAgentLogonManager*)AppLogonManager
{
    SKAgentLogonManager* logonManager =  [[self APPdelegate] logonManager];
    if (!logonManager){
        [[self APPdelegate] setLogonManager:[[SKAgentLogonManager alloc] init]];
    }
    return  [[self APPdelegate] logonManager];
}

+(UIViewController*)visibleViewController
{
    SKAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    UINavigationController* nav =  (UINavigationController*)delegate.window.rootViewController;
    return [nav visibleViewController];
}

+(SKViewController*)AppRootViewController
{
    UINavigationController* nav =  (UINavigationController*)[[[self APPdelegate] window] rootViewController];
    NSLog(@"%d",nav.viewControllers.count);
    return (SKViewController*)nav.viewControllers[0];
}

+(SKEmailController*)AppSKEmailController;
{
    UINavigationController* nav =  (UINavigationController*)[[[self APPdelegate] window] rootViewController];
    for (UIViewController * controller in nav.viewControllers)
    {
        if ([controller isKindOfClass:[SKEmailController class]])
        {
            return (SKEmailController*)controller;
        }
    }
    return nil;
}
+(Reachability*)currentReachability
{
    return [[APPUtils APPdelegate] internetReachability];
}

+(NetworkStatus)currentReachabilityStatus
{
    return [[APPUtils APPdelegate] networkstatus];
}

+(void)back
{
    [[[self AppStoryBoard] instantiateInitialViewController]  popToRootViewControllerAnimated:YES];
}

+(UIButton*)backBarButtonItem{
    UIImage* buttonImage = [[UIImage imageNamed:@"navigationBarBackButton.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0.0];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    backBtn.titleLabel.textColor = [UIColor whiteColor];
    backBtn.titleLabel.shadowOffset = CGSizeMake(0,-1);
    backBtn.titleLabel.shadowColor = [UIColor darkGrayColor];
    backBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    backBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 9.0, 0, 3.0);
    backBtn.frame = CGRectMake(0, 0, buttonImage.size.width + 15, buttonImage.size.height);
    [backBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    return backBtn;
}

//获取当前登录用户
+(User*)loggedUser
{
    SKAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    return delegate.logonManager.loggedUser;
}

//获取用户ID
+(NSString*)authcode
{
    if ([FileUtils valueFromPlistWithKey:@"authcode"] && ![[FileUtils valueFromPlistWithKey:@"authcode"] isEqualToString:@""])
    {
        return [FileUtils valueFromPlistWithKey:@"authcode"];
    }else{
        return nil;
    }
}

//获取用户ID
+(NSString*)userUid
{
    return [[self loggedUser] uid];
}

//获取用户密码
+(NSString*)userPassword
{
    return [[self loggedUser] password];
}
//获取用户姓名
+(NSString*)userName
{
    return [[self loggedUser] name];
}

//获取用户部门ID
+(NSString*)userDepartmentID
{
    return [[self loggedUser] departmentId];
}

+(NSString*)userDepartmentName
{
    return [[self loggedUser] departmentName];
}

//获取用户职称
+(NSString*)userTitle
{
    return [[self loggedUser] title];
}

+(NSString*)userMobile
{
    return [[self loggedUser] mobile];
}

//+(NetworkStatus)currentReachabiliy
//{
//    SKAppDelegate* delegate = [[UIApplication sharedApplication] delegate];
//    return delegate.reachability.currentReachabilityStatus;
//}
@end
