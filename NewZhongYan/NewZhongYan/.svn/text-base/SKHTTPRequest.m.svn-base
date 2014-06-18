//
//  SKHTTPRequest.m
//  HNZYiPad
//
//  Created by lilin on 13-6-14.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import "SKHTTPRequest.h"
#import "SKMessageEntity.h"
#import "DDXMLDocument.h"
#import "SKLoginViewController.h"
#import "SKAgentLogonManager.h"
@implementation SKHTTPRequest
@synthesize returncode;
@synthesize errorcode;
@synthesize errorinfo;
//这里一定要注意发布应用时会正式环境和测试环境会导致
-(id)initWithURL:(NSURL *)newURL
{
    self = [super initWithURL:newURL];
    if (self) {
            NSParameterAssert([APPUtils authcode] != nil);
            [self addRequestHeader:@"iv-user" value:[APPUtils userUid]];
            [self addRequestHeader:@"authcode" value:[APPUtils authcode]];
            [self setDefaultResponseEncoding:NSUTF8StringEncoding];//解决中文乱码问题
    }
    return self;
}

-(void)startAsynchronous
{
    
    if ([SKAppDelegate sharedCurrentUser].logged == YES) {
         [super startAsynchronous];
    }else{
        if([SKAppDelegate sharedCurrentUser].logging == YES){
            [self setErrorcode:101];
            [self setErrorinfo:@"还未登录"];
            self.error = [NSError errorWithDomain:@"还未登录"
                                             code:self.errorcode
                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.errorinfo,NSLocalizedDescriptionKey,nil]];
            [self reportFailure];
        }else{
            if([APPUtils currentReachabilityStatus] ==  NotReachable){
                self.error = [NSError errorWithDomain:@"网络连接错误"
                                                 code:0
                                             userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"网络连接错误",NSLocalizedDescriptionKey,nil]];
                [self reportFailure];
            }else{
                //[UIAlertView showAlertString:[NSString stringWithFormat:@"startAsynchronous%@",self.url]];
                [[APPUtils AppLogonManager] loginWithUser:[SKAppDelegate sharedCurrentUser] CompleteBlock:0 failureBlock:0];
            }
        }
    }
}

-(void)startSynchronous
{
    if ([SKAppDelegate sharedCurrentUser].logged == YES) {
         [super startSynchronous];
    }else{
        if([SKAppDelegate sharedCurrentUser].logging == YES){
            [self setErrorcode:101];
            [self setErrorinfo:@"登录中..."];
            self.error = [NSError errorWithDomain:@"登录中..."
                                             code:self.errorcode
                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.errorinfo,NSLocalizedDescriptionKey,nil]];
            [self reportFailure];
        }else{
            if([APPUtils currentReachabilityStatus] ==  NotReachable){
                self.error = [NSError errorWithDomain:@"网络连接错误"
                                                 code:0
                                             userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"网络连接错误",NSLocalizedDescriptionKey,nil]];
                [self reportFailure];
            }else{
                [[APPUtils AppLogonManager] loginWithUser:[SKAppDelegate sharedCurrentUser] CompleteBlock:0 failureBlock:0];
            }
        }
    }
}

+ (id)requestWithURL:(NSURL *)newURL
{
    return [[self alloc] initWithURL:newURL];
}

- (void)requestReceivedResponseHeaders:(NSMutableDictionary *)newResponseHeaders
{
    [super requestReceivedResponseHeaders:newResponseHeaders];
    if ([[newResponseHeaders allKeys] containsObject:@"returncode"])
    {
        self.returncode = [newResponseHeaders objectForKey:@"returncode"];
        if (![self.returncode isEqualToString:@"OK"])
        {
            self.errorcode = [[self.returncode  substringFromIndex:1] intValue];
            if (self.errorcode == ReportLossCode)
            {
                [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from USER_REMS"];
                [FileUtils setvalueToPlistWithKey:@"authcode" Value:@""];
                //[self handleOnReportLoss];
            }
            if (self.errorcode == RegistInfoCode)
            {
                [UIAlertView showAlertString:[NSString stringWithFormat:@"requestReceivedResponseHeaders%@--%@",self.returncode,self.url]];
                [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from USER_REMS"];
                [FileUtils setvalueToPlistWithKey:@"authcode" Value:@""];
                [FileUtils setvalueToPlistWithKey:@"gpusername" Value:[APPUtils userUid]];
                SKLoginViewController* loginController = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"loginController"];
                [[APPUtils visibleViewController] presentViewController:loginController animated:NO completion:^{
                    [loginController.userField setText:[FileUtils valueFromPlistWithKey:@"gpusername"]];
                    [loginController.userField setEnabled:NO];
                    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"" message:@"注册信息无效" delegate:0 cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [av show];
                }];
            }
        }
    }
}

-(NSString*)errorinfoWithErrorcode:(SKHTTPRequestErrorType)code
{
    if (code == SKHTTPRequestErrorDataNone) {
        return @"服务器上没有最新数据";
    }
    return @"服务器异常";
}

-(void)reportFinished
{
    if (self.errorcode)
    {
        SKMessageEntity* entity = [SKMessageEntity entityWithData:self.responseData];
        NSString *authorizeID =  [[entity dataItem:0] objectForKey:@"MESSAGE"];
        if (entity.praserError)
        {   //这里一般出现在代办处理中

            NSError* xmlerror = nil;
            DDXMLDocument* doc = [[DDXMLDocument alloc] initWithData:self.responseData options:0 error:&xmlerror];
            if (!xmlerror) {
                NSString* returndode =  [(DDXMLElement*)[[doc nodesForXPath:@"//returncode" error:0] objectAtIndex:0] stringValue];
                self.errorinfo = [[returndode componentsSeparatedByString:@","] lastObject];
            }
        }else{
            //这里一般为普通异常 如挂失 维护等等
            self.errorinfo = authorizeID ? authorizeID : @"服务器内部错误";
        }
        
        self.error = [NSError errorWithDomain:@"服务器内部错误"
                                         code:errorcode
                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.errorinfo,NSLocalizedDescriptionKey,nil]];
        [self reportFailure];
    }else if (self.responseStatusCode != 200){
        //这个地方还待xiugai
        self.errorcode = self.responseStatusCode;
        self.errorinfo = @"服务器内部错误";
        [self reportFailure];
    }else{
        [super reportFinished];
    }
}

- (void)failWithError:(NSError *)theError
{
    [super failWithError:theError];
    self.errorcode = theError.code;
    self.errorinfo = [NetUtils userInfoWhenRequestOccurError:[self error]];
}
@end

