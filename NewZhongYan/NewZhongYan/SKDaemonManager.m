//
//  SKDaemonManager.m
//  NewZhongYan
//
//  Created by lilin on 13-12-20.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKDaemonManager.h"
#import "SKMessageEntity.h"
#define ERRORDOMAIN     @"ECMRequestError"

#define RequestRepeatedError  1001//队列中已经有了相同的请求
#define RequestDataError      1002//获取详细数据时发生错误
#define RequestMetaError      1003//获取数据元信息的错误
#define RequestNoUpdateError       1004//服务器数据和本地数据相同



static NSOperationQueue* sharedQueue = nil;

@interface SKDaemonManager ()
@property(nonatomic,strong)NSString* Daemonidentify;
@property SKDaemontype daemontype;
@end


@implementation SKDaemonManager
{
    SKDaemonBasicBlock _completeBlock;
    SKDaemonBasicArrayBlock _completeArrayBlock;
    SKDaemonErrorBlock _faliureBlock;
    SKClientApp* _client;
    SKChannel* _channel;
    BOOL     _isUp;
}



+(NSOperationQueue*)sharedQueue
{
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    return sharedQueue;
}

//同步client
-(id)initChannelWithClientAppData:(SKClientApp*)client complete:(SKDaemonBasicBlock)completeBlock faliure:(SKDaemonErrorBlock)faliureBlock
{
    self = [super init];
    if (self) {
        _completeBlock = [completeBlock copy];
        _faliureBlock = [faliureBlock copy];
        _client = client;
    }
    return self;
}

//同步client
-(id)initUpdateInfoWithClientAppData:(SKClientApp*)client complete:(SKDaemonBasicArrayBlock)completeArrayBlock faliure:(SKDaemonErrorBlock)faliureBlock
{
    self = [super init];
    if (self) {
        _completeArrayBlock = [completeArrayBlock copy];
        _faliureBlock = [faliureBlock copy];
        _client = client;
    }
    return self;
}

//同步client
-(id)initDocumentsWithChannelData:(SKChannel*)channel
                         complete:(SKDaemonBasicBlock)completeBlock
                          faliure:(SKDaemonErrorBlock)faliureBlock
                             type:(BOOL)isUp
{
    self = [super init];
    if (self) {
        _completeBlock = [completeBlock copy];
        _faliureBlock = [faliureBlock copy];
        _channel = channel;
        _isUp = isUp;
    }
    return self;
}

+(void)SynMaxUpdateDateWithClient:(SKClientApp*)client
                         complete:(SKDaemonBasicArrayBlock)completeArrayBlock
                          faliure:(SKDaemonErrorBlock)faliureBlock
{
    for (SKDaemonManager* helper  in [SKDaemonManager sharedQueue].operations) {
        if ([helper.Daemonidentify isEqualToString:[NSString stringWithFormat:@"%@VersionInfo",client.CODE]]) {
            if (faliureBlock) {
                faliureBlock([NSError errorWithDomain:ERRORDOMAIN code:RequestRepeatedError userInfo:@{@"reason": @"已有相同频道的请求"}]);
            }
            return;
        }
    }
    SKDaemonManager* helper = [[SKDaemonManager alloc] initUpdateInfoWithClientAppData:client
                                                                              complete:completeArrayBlock
                                                                               faliure:faliureBlock];
    helper.Daemonidentify = [NSString stringWithFormat:@"%@VersionInfo",client.CODE];
    helper.daemontype = SKDaemonClientVersion;
    [[SKDaemonManager sharedQueue] addOperation:helper];
}

//频道的更新是属于删除重建的更新
//关于operation的唯一标示 采用 clientcode+@"VersionInfo"的形式
+(void)SynChannelWithClientApp:(SKClientApp*)client
                      complete:(SKDaemonBasicBlock)completeBlock
                       faliure:(SKDaemonErrorBlock)faliureBlock
{
    for (SKDaemonManager* helper  in [SKDaemonManager sharedQueue].operations) {
        if ([helper.Daemonidentify isEqualToString:client.CODE]) {
            if (faliureBlock) {
                faliureBlock([NSError errorWithDomain:ERRORDOMAIN code:RequestRepeatedError userInfo:@{@"reason": @"已有相同频道的请求"}]);
            }
            return;
        }
    }
    
    SKDaemonManager* helper = [[SKDaemonManager alloc] initChannelWithClientAppData:client
                                                                           complete:completeBlock
                                                                            faliure:faliureBlock];
    helper.Daemonidentify = client.CODE;
    helper.daemontype = SKDaemonChannel;
    [[SKDaemonManager sharedQueue] addOperation:helper];
}

+(void)SynDocumentsWithChannel:(SKChannel*)channel
                      complete:(SKDaemonBasicBlock)completeBlock
                       faliure:(SKDaemonErrorBlock)faliureBlock
                          Type:(BOOL)isUp
{
    for (SKDaemonManager* helper  in [SKDaemonManager sharedQueue].operations) {
        if ([helper.Daemonidentify isEqualToString:channel.CODE]) {
            if (faliureBlock) {
                faliureBlock([NSError errorWithDomain:ERRORDOMAIN code:RequestRepeatedError userInfo:@{@"reason": @"已有相同频道的请求"}]);
            }
            return;
        }
    }
    
    SKDaemonManager* helper = [[SKDaemonManager alloc] initDocumentsWithChannelData:channel
                                                                           complete:completeBlock
                                                                            faliure:faliureBlock
                                                                               type:isUp];
    helper.Daemonidentify = channel.CODE;
    helper.daemontype = SKDaemonDocuments;
    [[SKDaemonManager sharedQueue] addOperation:helper];
}

-(void)synClientApp
{
    if (_client.version) {
        
    }else{
        //先获取服务器上数据元信息
        SKHTTPRequest* request = [SKHTTPRequest requestWithURL:[SKECMURLManager getClientAppVMetaInfoWithVersion:_client.version]];
        [request startSynchronous];
        if (!request.error) {
        }else{
        }
    }
}

-(void)getAllChannelInfoWithserverVersion:(int)sv serverCount:(int)sc
{
    SKHTTPRequest* request = [SKHTTPRequest requestWithURL:[SKECMURLManager getAllChannelWithAppCode:_client.CODE]];
    [request startSynchronous];
    //NSLog(@"%@  %@",request.url,request.responseString);
    if (!request.error) {
        SKMessageEntity* entity = [[SKMessageEntity alloc] initWithData:[request responseData]];
        if (!entity.praserError) {
            [[EGOCache currentCache] clearCache];
            [[DBQueue sharedbQueue] insertDataToTableWithDataArray:entity TableName:@"T_CHANNEL"];
            _client.version = sv;
            NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO T_CLIENTVERSION (CODE,VERSION) VALUES ('%@','%d');",_client.CODE,_client.version];
            [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
            if (_completeBlock) {
                _completeBlock();
            }
        }else{
            if (_faliureBlock) {
                _faliureBlock([NSError errorWithDomain:ERRORDOMAIN code:RequestDataError userInfo:@{@"reason": @"服务器数据有误"}]);
            }
        }
    }else{
        if (request.errorcode == DataNoneCode) {
            _faliureBlock([NSError errorWithDomain:@"ECMRequestError" code:DataNoneCode userInfo:@{@"reason": @"获取数据元信息错误"}]);
        }else{
            _faliureBlock([NSError errorWithDomain:ERRORDOMAIN code:RequestDataError userInfo:@{@"reason": request.errorinfo}]);
        }
    }
}

-(void)synChannelInfo
{
    int sv = 0 ,sc = 0;
    SKHTTPRequest* request = [SKHTTPRequest requestWithURL:[SKECMURLManager getChannelVmetaInfoWithAppCode:_client.CODE ChannelVersion:_client.version]];
    [request startSynchronous];
    //NSLog(@"%@  %@",request.url,request.responseString);
    if (!request.error) {
        SKMessageEntity* entity = [[SKMessageEntity alloc] initWithData:[request responseData]];
        NSDictionary* dict = [entity dataItem:0];
        if ([[entity MessageCode] isEqualToString: @"DCI"] && [@"CHANNEL" isEqualToString:[dict objectForKey:@"c"]]){
            sv = [[dict objectForKey:@"v"] intValue] <= 0 ? 1 :[[dict objectForKey:@"v"] intValue];
            sc  = [[dict objectForKey:@"t"] intValue];//t 表示版本之间更新的数据有多少多少
            if (_client.version) {
                if (_client.version == sv) {
                    if (_faliureBlock) {
                        _faliureBlock([NSError errorWithDomain:ERRORDOMAIN code:RequestNoUpdateError userInfo:@{@"reason": @"服务器数据和本地数据相同"}]);
                    }
                }else{
                    [self getAllChannelInfoWithserverVersion:sv serverCount:sc];
                }
            }else{
                if (sc) {
                    [self getAllChannelInfoWithserverVersion:sv serverCount:sc];
                }
            }
        }
    }else{
        if (request.errorcode == DataNoneCode) {
            _faliureBlock([NSError errorWithDomain:@"ECMRequestError" code:DataNoneCode userInfo:@{@"reason": @"获取数据元信息错误"}]);
        }else{
            _faliureBlock([NSError errorWithDomain:ERRORDOMAIN code:RequestMetaError userInfo:@{@"reason": @"获取数据元信息错误"}]);
        }
        return;
    }
}

-(void)synDocumentInfo{
    NSURL* url = [SKECMURLManager getDocunmentWithChannelCode:_channel.CODE QueryDate:(_isUp ? _channel.MAXUPTM :_channel.MINUPTM) isUP:_isUp];
    SKHTTPRequest* request = [SKHTTPRequest requestWithURL:url];
    [request startSynchronous];
    //NSLog(@"%@ %@ ",request.url,request.responseString);
    if (!request.error) {
        SKMessageEntity* entity = [[SKMessageEntity alloc] initWithData:[request responseData]];
        if (!entity.praserError) {
            //先要删除本地的频道数据
            [[DBQueue sharedbQueue] insertDataToTableWithDataArray:entity TableName:@"T_DOCUMENTS"];
            [_channel restoreVersionInfo];
            if (_completeBlock) {
                _completeBlock();
            }
        }else{
            if (_faliureBlock) {
                _faliureBlock(entity.praserError);
            }
        }
    }else{
        if (request.errorcode == DataNoneCode) {
            _faliureBlock([NSError errorWithDomain:@"ECMRequestError" code:DataNoneCode userInfo:@{@"reason": @"获取数据元信息错误"}]);
        }else{
            _faliureBlock([NSError errorWithDomain:ERRORDOMAIN code:RequestMetaError userInfo:@{@"reason": @"获取文档列表错误"}]);
        }
        return;
    }
}

-(void)synChannelUpdateInfo{
    NSURL* url = [SKECMURLManager getUpdateClientAppWithClientCode:_client.CODE QueryDate:@"0"];
    SKHTTPRequest* request = [SKHTTPRequest requestWithURL:url];
    [request startSynchronous];
    if (!request.error) {
        SKMessageEntity* entity = [[SKMessageEntity alloc] initWithData:[request responseData]];
        if (!entity.praserError) {
            if (_completeArrayBlock) {
                _completeArrayBlock(entity.dataItems);
            }
        }else{
            if (_faliureBlock) {
                _faliureBlock(entity.praserError);
            }
        }
    }else{
        if (_faliureBlock) {
            _faliureBlock([NSError errorWithDomain:ERRORDOMAIN code:RequestMetaError userInfo:@{@"reason": [NSString stringWithFormat:@"获取平道更新信息错误 %@",request.errorinfo]}]);
        }
        return;
    }
}

-(void)main
{
    @autoreleasepool{
        if (self.daemontype == SKDaemonChannel) {
            [self synChannelInfo];
        }else if (self.daemontype == SKDaemonDocuments){
            [self synDocumentInfo];
        }
        else if (self.daemontype == SKDaemonClientVersion){
            [self synChannelUpdateInfo];
        }
    }
}

@end
