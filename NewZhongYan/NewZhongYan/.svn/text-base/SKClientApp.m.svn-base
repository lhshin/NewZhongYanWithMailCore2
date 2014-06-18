//
//  SKClientApp.m
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKClientApp.h"
#import "SKMessageEntity.h"
@implementation SKClientApp
//没有用到
-(void)initChanels
{
    NSString* sql = [NSString stringWithFormat:@"select * from T_CHANNEL where OWNERAPP = '%@' and LEVL = 1;",self.CODE];
    NSArray* array = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
    _channels = [NSMutableArray array];
    for (NSDictionary* dict in array) {
        SKChannel* channel = [[SKChannel alloc] initWithDictionary:dict];
        if (![channel.FIDLIST isEqual:[NSNull null]]) {
            [channel restoreVersionInfo];
        }
        [_channels addObject:channel];
    }
}

-(void)initCilentAppVersion
{
    NSString* sql = [NSString stringWithFormat:@"select VERSION from T_CLIENTVERSION where CODE = '%@';",self.CODE];
    self.version = [[DBQueue sharedbQueue] intValueFromSQL:sql];
}

-(id)initWithDictionary:(NSDictionary*)appinfo
{
    self = [super init];
    if (self) {
        _channels = nil;
        _CODE = appinfo[@"CODE"];
        _NAME = appinfo[@"NAME"];
        _DEPARTMENT = appinfo[@"DEPARTMENT"];
        _DEFAULTED = appinfo[@"DEFAULTED"];
        _APPTYPE = appinfo[@"APPTYPE"];
        [self initCilentAppVersion];
    }
    return self;
}

+(void)getClientAppWithCompleteBlock:(clientCompleteBlock)completeblock  faliureBlock:(clientfaliureBlock)faliureblock
{
    int localClientAppVersion = [[FileUtils valueFromPlistWithKey:@"CLIENTAPPVERSION"] intValue];
    SKHTTPRequest* request = [SKHTTPRequest requestWithURL:
                              [SKECMURLManager getClientAppVMetaInfoWithVersion:localClientAppVersion]];
    [request startSynchronous];
    //NSLog(@"%@",request.responseString);
    if (!request.error) {
        SKMessageEntity* entity = [[SKMessageEntity alloc] initWithData:[request responseData]];
        NSDictionary* dict = [entity dataItem:0];
        if ([[entity MessageCode] isEqualToString: @"DCI"] && [@"CLIENTAPP" isEqualToString:[dict objectForKey:@"c"]]){
            int sv = [[dict objectForKey:@"v"] intValue] <= 0 ? 1 :[[dict objectForKey:@"v"] intValue];
            int sc  = [[dict objectForKey:@"t"] intValue];//t 表示版本之间更新的数据有多少多少
            if (localClientAppVersion) {
                if (localClientAppVersion == sv) {
                    if (faliureblock) {
                        faliureblock([NSError errorWithDomain:@"ECMCLIENTAPPRequestError" code:1004 userInfo:@{@"reason": @"服务器数据和本地数据相同"}]);
                    }
                }else{
                    [self getClientAppWithCompleteBlock:completeblock];
                }
            }else{
                if (sc){
                    [self getClientAppWithCompleteBlock:completeblock];
                }
            }
        }
    }else{
        if (request.errorcode == DataNoneCode) {
            faliureblock([NSError errorWithDomain:@"ECMRequestError" code:DataNoneCode userInfo:@{@"reason": @"获取数据元信息错误"}]);
        }else{
            faliureblock([NSError errorWithDomain:@"ECMRequestError" code:1003 userInfo:@{@"reason": @"获取数据元信息错误"}]);
            
        }
    }
}

+(void)getClientAppWithCompleteBlock:(clientCompleteBlock)block
{
    SKHTTPRequest* request = [SKHTTPRequest requestWithURL:[SKECMURLManager getAllClientApp]];
    [request startSynchronous];
    if (request.error) {
        @throw [NSException exceptionWithName:@"获取应用列表失败" reason:request.errorinfo userInfo:nil];
    }else{
        SKMessageEntity* entity = [[SKMessageEntity alloc] initWithData:request.responseData];
        if (entity.praserError) {
            if (entity.praserError.code == DataNoneCode) {
                @throw [NSException exceptionWithName:@"获取应用列表失败" reason:@"该用户没有任何应用数据" userInfo:nil];
            }else{
                @throw [NSException exceptionWithName:@"获取应用列表失败" reason:@"服务器数据异常" userInfo:nil];
            }
        }else{
            [[DBQueue sharedbQueue] insertDataToTableWithDataArray:entity TableName:@"T_CLIENTAPP"];
            [FileUtils setvalueToPlistWithKey:@"CLIENTAPPVERSION" Value:entity.MessageVesion];
            if (block){
                block();
            }
        }
    }
}
@end
