//
//  SKFormDataRequest.m
//  HNZYiPad
//
//  Created by lilin on 13-6-18.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import "SKFormDataRequest.h"
#import "SKMessageEntity.h"
#import "DDXMLDocument.h"
@implementation SKFormDataRequest
@synthesize returncode;
@synthesize errorcode;
@synthesize errorinfo;
//这里一定要注意发布应用时会正式环境和测试环境会导致
-(id)initWithURL:(NSURL *)newURL
{
    self = [super initWithURL:newURL];
    if (self) {
        //if ([APPUtils loginStatus] == SKUnLogin || [APPUtils userUid] == nil) {
        //    [self setErrorcode:101];
        //    [self setErrorinfo:@"登陆中..."];
        //}else{
            NSParameterAssert([APPUtils authcode] != nil);
            [self addRequestHeader:@"iv-user" value:[APPUtils userUid]];
            [self addRequestHeader:@"authcode" value:[APPUtils authcode]];
            [self addRequestHeader:@"User-Agent" value:@"iphone"];
        //}
    }
    return self;
}

+ (id)requestWithURL:(NSURL *)newURL
{
    return [[self alloc] initWithURL:newURL];
}

-(void)startAsynchronous
{
    if ([SKAppDelegate sharedCurrentUser].logged == YES) {
        [super startAsynchronous];
    }else{
        [self setErrorcode:101];
        [self setErrorinfo:@"还未登录"];
        self.error = [NSError errorWithDomain:@"还未登录"
                                         code:self.errorcode
                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.errorinfo,NSLocalizedDescriptionKey,nil]];
        [self reportFailure];
    }
}

-(void)startSynchronous
{
    if ([SKAppDelegate sharedCurrentUser].logged == YES) {
        [super startSynchronous];
    }else{
        [self setErrorcode:101];
        [self setErrorinfo:@"还未登录"];
        self.error = [NSError errorWithDomain:@"还未登录"
                                         code:self.errorcode
                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.errorinfo,NSLocalizedDescriptionKey,nil]];
        [self reportFailure];
    }
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
            }
            
            if (self.errorcode == RegistInfoCode)
            {
                [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from USER_REMS"];
                [FileUtils setvalueToPlistWithKey:@"authcode" Value:@""];
            }
            
            if (self.errorcode == AuthInfoCode)
            {
                [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from USER_REMS"];
                [FileUtils setvalueToPlistWithKey:@"authcode" Value:@""];
            }
        }
    }
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
        NSDictionary *dic = [[self responseData] objectFromJSONData];
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
                            NSLog(@"%@",[resultdic objectForKey:@"MESSAGE"]);
                            if ([[self.url absoluteString] isEqualToString:[NSString stringWithFormat:@"%@/users/mail/load/more",ZZZobt]]) {
                                NSLog(@"%@",@"aaaa");
                            }
                        }
                    }
                }
            }
        }

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
