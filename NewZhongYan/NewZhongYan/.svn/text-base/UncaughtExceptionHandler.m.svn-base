//
//  UncaughtExceptionHandler.m
//  UncaughtExceptions
//
//  Created by Matt Gallagher on 2010/05/25.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "SKFormDataRequest.h"
#import "APPUtils.h"
#import "JSONKit.h"
#import "UIDevice-Hardware.h"
#import "FileUtils.h"
NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
NSString * const UncaughtExceptionHandlercallStackSymbols = @"UncaughtExceptionHandlercallStackSymbols";
volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

@implementation UncaughtExceptionHandler

+ (NSArray *)backtrace
{
	 void* callstack[128];
	 int frames = backtrace(callstack, 128);
	 char **strs = backtrace_symbols(callstack, frames);
	 
	 int i;
	 NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
	 for (
	 	i = UncaughtExceptionHandlerSkipAddressCount;
	 	i < UncaughtExceptionHandlerSkipAddressCount +
			UncaughtExceptionHandlerReportAddressCount;
		i++)
	 {
	 	[backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
	 }
	 free(strs);
	 
	 return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex
{
	if (anIndex == 0)
	{
		dismissed = YES;
	}
}

/*
 测试服务器(外网)前缀: http://tam.hngytobacco.com/ZZZobta/aaa-agents/avs
 
 ⑴客户端上传日志接口（POST）
 /commons/clientlog/upload
 Parameters:
 appsid  应用程序标识 android/iphone
 clientlog  Json格式的ClientLog 对象
 Return:
 OK 表示上传成功
 其它返回错误提示信息 表示失败
 
 Json格式的ClientLog 对象如：
 [{"uid":"testmobile","netstate":null,"information":null,"loglevel":null,"phoneos":null,"logtype":null,"appversion":"31","phonemodel":null,"description":null,"datetime":null,"dbversion":"49"}]
 
 ClientLog 对象
 
 public class ClientLog {
 
 protected String uid;                //用户名       VARCHAR(48),
 
 protected String phonemodel; //手机型号  VARCHAR(48),
 
 protected String phoneos;       //操作系统  VARCHAR(48),
 
 protected String appversion;//软件版本号 VARCHAR(12),
 
 protected String dbversion;  //数据库版本号  VARCHAR(12),
 
 protected String netstate;    //网络状态 VARCHAR(12),
 
 protected String loglevel;    //消息级别 VARCHAR(12),
 
 protected String logtype;     //类型          VARCHAR(12),
 
 protected String information;//日志信息 VARCHAR(1024),
 
 protected String description;//描述  VARCHAR(256),
 
 protected String datetime;      //触发时间 格式：2012-12-05 18:29:34
 */
- (void)handleException:(NSException *)exception
{
    NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate: [NSDate date]];
    NSString* reason = exception.reason;
    NSString* date = [[[NSDate date] dateByAddingTimeInterval:interval] description];
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:11];
    [dict setObject:[APPUtils userUid] ? [APPUtils userUid] :@"" forKey:@"uid"];//还待完善
    [dict setObject:@"wifi" forKey:@"netstate"];
    [dict setObject:reason forKey:@"description"];
    [dict setObject:@"1" forKey:@"loglevel"];
    [dict setObject:[[UIDevice currentDevice] systemVersion] forKey:@"phoneos"];
    [dict setObject:exception.name forKey:@"logtype"];
    [dict setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"appversion"];
    [dict setObject:[[UIDevice currentDevice] platformString] forKey:@"phonemodel"];
    if ([[[exception userInfo] allKeys] containsObject:UncaughtExceptionHandlercallStackSymbols]) {
        NSString* info  = [[exception userInfo] objectForKey:UncaughtExceptionHandlercallStackSymbols];
        [dict setObject:info forKey:@"information"];
    }
    [dict setObject:[date substringToIndex:19] forKey:@"datetime"];
    [dict setObject:[FileUtils valueFromPlistWithKey:@"DBVERSION"] forKey:@"dbversion"];
    NSArray* array = [NSArray arrayWithObject:dict];
    
    NSString* url = [NSString stringWithFormat:@"%@/commons/clientlog/upload",ZZZobt];
    SKFormDataRequest* request = [SKFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setPostValue:@"iphone" forKey:@"appsid"];
    [request setPostValue:[array JSONStringWithOptions:JKSerializeOptionValidFlags error:0] forKey:@"clientlog"];
    
    [request setCompletionBlock:^{
        NSLog(@"%@",[array JSONStringWithOptions:JKSerializeOptionValidFlags error:0]);
        NSLog(@"提交错误日志%@",request.responseString);
    }];
    
    [request setFailedBlock:^{
        NSLog(@"提交错误日志");
    }];
    
    [request startSynchronous];
    
	NSSetUncaughtExceptionHandler(NULL);
	signal(SIGABRT, SIG_DFL);
	signal(SIGILL, SIG_DFL);
	signal(SIGSEGV, SIG_DFL);
	signal(SIGFPE, SIG_DFL);
	signal(SIGBUS, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
	
	if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName])
	{
		kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
	}
	else
	{
		[exception raise];
	}
}

@end

void HandleException(NSException *exception)
{
	int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
	if (exceptionCount > UncaughtExceptionMaximum)
	{
		return;
	}
	
	NSArray *callStack = [UncaughtExceptionHandler backtrace];
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
	[userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [userInfo setObject:[[exception callStackSymbols] description] forKey:UncaughtExceptionHandlercallStackSymbols];
    
    
    NSException* except = [NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo];
    
    [[[[UncaughtExceptionHandler alloc] init] autorelease]
     performSelectorOnMainThread:@selector(handleException:)
     withObject:except
     waitUntilDone:YES];
}

void SignalHandler(int signal)
{
	int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
	if (exceptionCount > UncaughtExceptionMaximum)
	{
		return;
	}
	
	NSMutableDictionary *userInfo =
		[NSMutableDictionary
			dictionaryWithObject:[NSNumber numberWithInt:signal]
			forKey:UncaughtExceptionHandlerSignalKey];

	NSArray *callStack = [UncaughtExceptionHandler backtrace];
	[userInfo
		setObject:callStack
		forKey:UncaughtExceptionHandlerAddressesKey];
	
	[[[[UncaughtExceptionHandler alloc] init] autorelease]
		performSelectorOnMainThread:@selector(handleException:)
		withObject:
			[NSException
				exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
				reason:
					[NSString stringWithFormat:
						NSLocalizedString(@"Signal %d was raised.", nil),
						signal]
				userInfo:
					[NSDictionary
						dictionaryWithObject:[NSNumber numberWithInt:signal]
						forKey:UncaughtExceptionHandlerSignalKey]]
		waitUntilDone:YES];
}

void InstallUncaughtExceptionHandler(void)
{
	NSSetUncaughtExceptionHandler(&HandleException);
	signal(SIGABRT, SignalHandler);
	signal(SIGILL, SignalHandler);
	signal(SIGSEGV, SignalHandler);
	signal(SIGFPE, SignalHandler);
	signal(SIGBUS, SignalHandler);
	signal(SIGPIPE, SignalHandler);
}

