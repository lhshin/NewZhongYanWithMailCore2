//
//  RegisterDevice.m
//  HNZYiPad
//
//  Created by lilin on 13-6-5.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import "RegisterDevice.h"
#import "ASIHTTPRequest.h"
#import "DataServiceURLs.h"
#import "UIDevice-Hardware.h"
#import "UIDevice+IdentifierAddition.h"
#import "User.h"

@implementation RegisterDevice
//注册失败
-(void)onRegsistFaild:(NSString*)errorinfo
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(onRegisterFaild)])
    {
        [self.delegate onRegisterFaild];
        
    }
    else
    {
        @throw [NSException exceptionWithName:@"注册失败"
                                       reason:errorinfo
                                     userInfo:nil];
    }
}

-(void)rigisterCurrentDevice:(User*)user
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[DataServiceURLs rigisterDevice]];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request addRequestHeader:@"username" value:[APPUtils userUid]];
    [request addRequestHeader:@"password" value:[APPUtils userPassword]];
    [request addRequestHeader:@"phone-brand" value:@"Apple"];
    [request addRequestHeader:@"phone-model" value:[[UIDevice currentDevice] platformString]];
    [request addRequestHeader:@"phone-os" value:@"iphone"];
    [request addRequestHeader:@"IMEI" value:[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]];
    [request startSynchronous];
    if (request.error)
    {
        [self onRegsistFaild:[NetUtils userInfoWhenRequestOccurError:[request error]]];
    }
    else
    {
        if (request.responseStatusCode != CONNECTIONSUCCEED)
        {
            [self onRegsistFaild:@"服务器内部错误"];
        }
        
        NSDictionary *dic = [[request responseData] objectFromJSONData];
        if (dic && [[dic allKeys] containsObject:@"s"])
        {
            NSArray* sarray = [dic objectForKey:@"s"];
            if (sarray.count > 0)
            {
                NSDictionary* vdic = [sarray objectAtIndex:0];
                if (vdic && [[vdic allKeys] containsObject:@"v"])
                {
                    NSDictionary* resultdic = [vdic objectForKey:@"v"];
                    if (dic && [[dic allKeys] containsObject:@"c"]) {
                        if ([[dic objectForKey:@"c"] isEqualToString:@"EXCEPTION"]) {
                            [self onRegsistFaild:[resultdic objectForKey:@"MESSAGE"]];
                        }
                    }
                    if (resultdic && [[resultdic allKeys] containsObject:@"AUTHCODE"])
                    {
                        NSString *authorizeID = [resultdic objectForKey:@"AUTHCODE"];
                        if (authorizeID && ![authorizeID isEqualToString:@""])
                        {
                            [FileUtils setvalueToPlistWithKey:@"authcode" Value:authorizeID];
                            [user setName:[resultdic objectForKey:@"USERNAME"]];
                            [user setDepartmentId:[resultdic objectForKey:@"UNITID"]];
                            [user setMobile:[resultdic objectForKey:@"PHONEPLACE"]];
                            [user setDepartmentName:[resultdic objectForKey:@"UNITNAME"]];
                            if (self.delegate && [self.delegate respondsToSelector:@selector(onRegisterSuccess)])
                            {
                                [self.delegate onRegisterSuccess];
                            }
                            NSLog(@"注册本机成功");
                        }else{
                            NSLog(@"注册本机失败");
                            [self onRegsistFaild:[NetUtils userInfoWhenRequestOccurError:request.error]];
                        }
                    }
                }
            }
        }
        
    }
}
@end