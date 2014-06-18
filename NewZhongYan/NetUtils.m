//
//  NetUtils.m
//  HNZYiPad
//
//  Created by lilin on 13-6-5.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import "NetUtils.h"
#import "ASIHTTPRequest.h"
#import "SKAppDelegate.h"
@implementation NetUtils
+(NSString*)userInfoWhenRequestOccurError:(NSError *)error
{
    switch ([error code])
    {
        case ASIConnectionFailureErrorType:
            return @"请检查网络连接";
            break;
        case ASIRequestTimedOutErrorType:
            return @"网络超时...";
            break;
        case ASIAuthenticationErrorType:
            return @"账号或者密码错误,请重新输入账号或者密码";
            break;
        case ASIRequestCancelledErrorType:
            return @"数据请求被中断";
            break;
        case ASIUnableToCreateRequestErrorType:
            return @"创建请求失败,请检查URL是否正确";
            break;
        default:
            return @"网络异常";
            break;
    }
}
@end
