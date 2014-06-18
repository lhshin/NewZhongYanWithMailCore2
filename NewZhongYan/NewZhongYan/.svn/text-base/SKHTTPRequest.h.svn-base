//
//  SKHTTPRequest.h
//  HNZYiPad
//
//  Created by lilin on 13-6-14.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import "ASIHTTPRequest.h"
typedef enum  {
    SKHTTPRequestErrorDataNone = 3011,//没有获取到数据
    SKHTTPRequestErrorTypeReportLoss = 3004,//挂失
    SKHTTPRequestErrorTypeRegistInfo= 3005,//注册信息无效
    SKHTTPRequestErrorTypeAuthInfoCode = 3006,//验证失败
    SKHTTPRequestErrorDefault = -1
}SKHTTPRequestErrorType;

@interface SKHTTPRequest : ASIHTTPRequest
{
    NSString    *returncode;  //返回码
    NSString    *errorinfo;   //错误信息
    NSInteger    errorcode;   //错误码
}

@property(strong)NSString* returncode;
@property(strong)NSString* errorinfo;
@property NSInteger    errorcode;
@end
