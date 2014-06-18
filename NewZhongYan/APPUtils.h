//
//  APPUtils.h
//  NewZhongYan
//
//  Created by lilin on 13-10-8.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@class SKAgentLogonManager;
@class SKAppDelegate;
@class SKViewController;
@class SKEmailController;
@interface APPUtils : NSObject
//入口：
//出口：返回APP的delegate
//功能：返回APP的delwgate
//备注：实例函数
+(SKAppDelegate*)APPdelegate;

+(UIStoryboard*)AppStoryBoard;

+(SKAgentLogonManager*)AppLogonManager;

+(SKViewController*)AppRootViewController;

+(SKEmailController*)AppSKEmailController;

+(NetworkStatus)currentReachabilityStatus;

+(Reachability*)currentReachability;

+(User*)loggedUser;

//获取注册码
+(NSString*)authcode;

+(NSString*)userUid;

+(NSString*)userName;

+(NSString*)userPassword;

+(NSString*)userDepartmentID;

+(NSString*)userDepartmentName;

+(NSString*)userTitle;

+(NSString*)userMobile;

+(UIButton*)backBarButtonItem;

+(UIViewController*)visibleViewController;
@end
