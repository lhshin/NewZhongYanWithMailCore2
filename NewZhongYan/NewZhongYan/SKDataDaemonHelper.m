//
//  SKDataDaemonHelper.m
//  HNZYiPad
//
//  Created by lilin on 13-6-13.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import "SKDataDaemonHelper.h"
#import "DataServiceURLs.h"
#import "LocalMetaDataManager.h"
#import "SKMessageEntity.h"
static NSOperationQueue* _shareQueue = nil;

@implementation SKDataDaemonHelper
@synthesize delegate = _delegate;
@synthesize metaData = _metaData;
-(id)initWithLocalMetaData:(LocalDataMeta*)metaData delegate:(id <SKDataDaemonHelperDelegate>)delegate
{
    self = [super init];
    if (self) {
        _metaData = metaData;
        _urlHelper = [DataServiceURLs DataServiceURLs:metaData];
        _delegate = delegate;
    }
    return self;
}



-(void)dealloc{
    _metaData = nil;
    _pathHelper = nil;
    _urlHelper = nil;
}

+(void)synWithMetaData:(LocalDataMeta*)metaData delegate:(id<SKDataDaemonHelperDelegate>)delegate{
    for (SKDataDaemonHelper* helper  in [SKDataDaemonHelper sharedQueue].operations) {
        if ([helper.metaData.dataCode isEqualToString:metaData.dataCode]) {
            return;
        }
    }
    SKDataDaemonHelper* helper = [[SKDataDaemonHelper alloc] initWithLocalMetaData:metaData delegate:delegate];
    [[SKDataDaemonHelper sharedQueue] addOperation:helper];
}

+(void)cancelWithMetaData:(LocalDataMeta*)metaData{
    for (SKDataDaemonHelper* helper in [[SKDataDaemonHelper sharedQueue] operations]) {
        if ([helper.metaData.dataCode isEqualToString:metaData.dataCode])
        {
            helper.delegate = nil;
            helper.metaData = nil;
            [helper cancel];
        }
    }
}

+(void)cancelAllTask{
    for (SKDataDaemonHelper* helper in [[SKDataDaemonHelper sharedQueue] operations]){
        helper.delegate = nil;
        helper.metaData = nil;
        [helper cancel];
    }
}

+(NSOperationQueue*)sharedQueue
{
    if (_shareQueue == nil) {
        _shareQueue = [[NSOperationQueue alloc] init];
    }
    return _shareQueue;
}

-(SKMessageEntity*)messageEntityWithURL:(NSString*)url
{
    SKHTTPRequest* request = [SKHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];//完美解决中文编码乱码的问题
    [request setTimeOutSeconds:15];
    [request startSynchronous];
    if (request.error) {
        @throw [NSException exceptionWithName:@"请求失败"
                                       reason:request.error.localizedDescription
                                     userInfo:nil];
    }else if ([request responseStatusCode] != 200){
        @throw [NSException exceptionWithName:[NetUtils userInfoWhenRequestOccurError:[request error]]
                                       reason:request.error.localizedDescription
                                     userInfo:nil];
    }else{
        return  [[SKMessageEntity alloc] initWithData:[request responseData]];

    }
}

-(void)synDataWithServerVersion:(int)sv
                    ServerCount:(int)sc
                           From:(int)from
{
    if (_delegate && [_delegate respondsToSelector:@selector(didBeginSynData:)])
    {
        [_delegate didBeginSynData:_metaData];
    }
    
    @autoreleasepool {
        while (sc > 0 && from <= sc)
        {
            NSURL* rangeURL;
            if ([_metaData isECM]) {
                rangeURL = [NSURL URLWithString:_urlHelper.ECMVupdateURL];
            }else{
                rangeURL = [NSURL URLWithString:[_urlHelper rangeURL:from length:_metaData.pageSize]];
            }
            SKHTTPRequest* request = [SKHTTPRequest requestWithURL:rangeURL];
            [request setTimeOutSeconds:30];
            [request startSynchronous];
            if (![request error] && ![self isCancelled]){
                SKMessageEntity* entity = [[SKMessageEntity alloc] initWithData:[request responseData]];
                if ([[entity MessageCode] isEqualToString:[_metaData messageCode]]){
                    [[DBQueue sharedbQueue] insertDataToTableWithDataArray:entity LocalDataMeta:_metaData];
                    synedCount += entity.dataItemCount;
                }
            }else{
                @throw [NSException exceptionWithName:@"请求失败"
                                               reason:[[request error] localizedDescription]
                                             userInfo:nil];
                
            }
            [self.metaData snapInitDataWithVersion:sv lastCount:sc lastFrom:from Date:[NSDate curerntTime]];
            [LocalMetaDataManager flushMetaData:_metaData];
            from += _metaData.pageSize;
            if (_delegate && [_delegate respondsToSelector:@selector(didEndSynData:)]){
                [_delegate didEndSynData:_metaData];
            }
            [request clearDelegatesAndCancel];
        }
    }
}

-(void)firstSynData{
    if ([_metaData isInitDataSnapped])
    {
        [self synDataWithServerVersion:_metaData.lastversion
                           ServerCount:_metaData.lastcount
                                  From:_metaData.lastfrom];
    }else{
        SKHTTPRequest* request = [SKHTTPRequest requestWithURL:[NSURL URLWithString:_urlHelper.metaURL]];
        [request setDefaultResponseEncoding:NSUTF8StringEncoding];//完美解决中文编码乱码的问题
        [request setTimeOutSeconds:15];
        [request startSynchronous];
        if (request.error) {
            @throw [NSException exceptionWithName:@"请求失败"
                                           reason:[[request error] localizedDescription]
                                         userInfo:nil];
        }else if ([request responseStatusCode] != 200){
            @throw [NSException exceptionWithName:[[request error] localizedDescription]
                                           reason:[[request error] localizedDescription]
                                         userInfo:nil];
        }else{
            SKMessageEntity* entity = [[SKMessageEntity alloc] initWithData:[request responseData]];
            NSDictionary* dict = [entity dataItem:0];
            if ([[entity MessageCode] isEqualToString: @"DCI"] && [[_metaData messageCode] isEqualToString:[dict objectForKey:@"c"]])
            {
                int sv = [[dict objectForKey:@"v"] intValue] <= 0 ? 1 :[[dict objectForKey:@"v"] intValue];
                int sc  = [[dict objectForKey:@"t"] intValue];//t 表示版本之间数据的多少
                //开始下载数据
                [self synDataWithServerVersion:sv
                                   ServerCount:sc
                                          From:1];
            }
            entity = nil;
        }
        [request clearDelegatesAndCancel];
    }
    
    if (![self isCancelled]) {
        [_metaData afterFinishedInitData];
        [LocalMetaDataManager flushMetaData:_metaData];
    }
}

-(void)synUpdateDataWithlocalVersion:(int)lv
                            ServerVersion:(int)sv
                              ServerCount:(int)sc
                                     From:(int)from
{
    if (_delegate && [_delegate respondsToSelector:@selector(didBeginSynData:)])
    {
        [_delegate didBeginSynData:_metaData];
    }
    @autoreleasepool {
        while (sc > 0 && from <= sc)
        {
            SKMessageEntity* entity;
            NSURL* url = [NSURL URLWithString:[_urlHelper updateRangeURL:lv from:from length:_metaData.pageSize]];
            SKHTTPRequest* request = [SKHTTPRequest requestWithURL:url];
            [request startSynchronous];
            if (![request error])
            {
                if (![self isCancelled]) {
                    entity = [[SKMessageEntity alloc] initWithData:[request responseData]];
                    if ([entity.MessageCode isEqualToString:_metaData.messageCode])
                    {
                        [[DBQueue sharedbQueue] insertDataToTableWithDataArray:entity LocalDataMeta:_metaData];
                        from += _metaData.pageSize;
                    }else{
                        @throw [NSException exceptionWithName:@"请求失败"
                                                       reason:@"请求已被取消"
                                                     userInfo:nil];
                    }
                }
            }else{
                @throw [NSException exceptionWithName:@"请求失败"
                                               reason:[[request error] localizedDescription]
                                             userInfo:nil];
            }
        }

    }
}

//增量更新模式
-(void)synUpdatedData
{
    int lv = (int)[_metaData version];
    //获取根据指定版本之后的变更元信息
    NSString* url;
    if ([_metaData isECM]) {
        url = [_urlHelper ECMMetaInfoWithVersion:lv];
    }else{
        url = [_urlHelper updateMetaURL:lv];
    }
    SKMessageEntity* entity = [self messageEntityWithURL:url];
    /*如果该任务没有被取消且*/
    NSDictionary* dict = [entity dataItem:0];
    @synchronized(dict)
    {
        if ([[entity MessageCode] isEqualToString:@"DCI"] && [[_metaData messageCode] isEqualToString:[dict objectForKey:@"c"]])
        {
            int sv = [[dict objectForKey:@"v"] intValue];
            if (sv == lv)
            {
                return;
            }
            else if(sv < lv)
            {
                @throw [NSException exceptionWithName:@"请求失败"
                                               reason:@"数据版本错误"
                                             userInfo:nil];
                
            }else{
                int sc = [[dict objectForKey:@"t"] intValue];
                [self synUpdateDataWithlocalVersion:lv ServerVersion:sv ServerCount:sc From:1];
                if (![self isCancelled]) {
                    [_metaData setVersion:sv];
                    [LocalMetaDataManager flushMetaData:_metaData];
                }
            }
            
        }
    }
}

-(void)main
{
    @autoreleasepool{
        int lv = [[_metaData dataCode] isEqualToString:@"versioninfo"] ? 0 :(int)[_metaData version];
        @try{
            if (lv <= 0){
                [self firstSynData];
            }else{
                [self synUpdatedData];
            }
        }
        @catch (NSException *exception){
            if (_delegate && [_delegate respondsToSelector:@selector(didErrorSynData:Reason:)]){
                [_delegate didErrorSynData:_metaData Reason:exception.reason];
            }
            return;
        }
        
        if (_delegate) {
            if ([_delegate respondsToSelector:@selector(didCompleteSynData:)]) {
                [self.delegate didCompleteSynData:_metaData];
            }
            if ([_delegate respondsToSelector:@selector(didCompleteSynData:SV:SC:LV:)]) {
                [self.delegate didCompleteSynData:_metaData.dataCode SV:(int)_metaData.version SC:synedCount LV:lv];
            }
        }
    }
}

-(void)cancel
{
    if (_delegate && [_delegate respondsToSelector:@selector(didCancelSynData:)])
    {
        [_delegate didBeginSynData:_metaData];
    }
    _delegate = nil;
    [super cancel];
}

@end