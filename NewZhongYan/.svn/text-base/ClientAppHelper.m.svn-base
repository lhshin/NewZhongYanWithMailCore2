//
//  ClientAppHelper.m
//  NewZhongYan
//
//  Created by lilin on 14-3-3.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "ClientAppHelper.h"

@implementation ClientAppHelper
{
    SKClientApp* _client;
    NSArray* channelIdInThisClientApp;
    NSArray* documentsInClientApp;
    NSString* clientFidlist;
}

-(void)getChanelIdInClientAPP
{
    NSString* sql = [NSString stringWithFormat:@"select FIDLIST from T_CHANNEL WHERE OWNERAPP = '%@' and LEVL <> 0;",_client.CODE];
    NSArray* array = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
    NSString* fidlist = [NSString string];
    for (NSDictionary* d in array) {
        fidlist = [fidlist stringByAppendingFormat:@",'%@'",d[@"FIDLIST"]];
    }
    clientFidlist = [fidlist substringFromIndex:1];
}

-(void)getDocumentsFromClientApp
{
    NSString* sql = [NSString stringWithFormat:@"select * from T_DOCUMENTS where CHANNELID in (%@)",clientFidlist];
    documentsInClientApp =  [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
}

-(id)initWithClientApp:(SKClientApp*)clientapp
{
    self = [super init];
    if (self) {
        _client = clientapp;
        [self getChanelIdInClientAPP];
        [self getDocumentsFromClientApp];
    }
    return self;
}

-(long long)getNeedCleanSize
{
    long long needCleanSize=0;//需要清理的大小
    NSDate *aWeekBefore=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*7];
    NSString *weekDate=[DateUtils dateToString:aWeekBefore DateFormat:sdateFormat];
    NSString *weekSql=[NSString stringWithFormat:@"SELECT PAPERID FROM T_DOCUMENTS where CHANNELID in (%@) and CRTM<'%@'",clientFidlist,weekDate];
    if ([[DBQueue sharedbQueue] CountOfQueryWithSQL:weekSql] > 0)
    {
        NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:[NSString stringWithFormat:
                                                                               @"SELECT PAPERID FROM T_DOCUMENTS where CHANNELID in (%@) and CRTM<'%@'",clientFidlist,weekDate]];
        for (NSDictionary *dic in oldRecordArray)
        {
            NSString* ecmPath = [[FileUtils documentPath] stringByAppendingPathComponent:@"ecm"];
            NSString* clientPath = [ecmPath stringByAppendingPathComponent:_client.CODE];
            NSString *filePath= [clientPath stringByAppendingPathComponent:dic[@"PAPERID"]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:filePath isDirectory:0]){
                needCleanSize+=[FileUtils folderSizeAtPath:filePath];
            }else{
                continue;
            }
        }
    }
    return needCleanSize;
}

-(void)cleanLocalData
{
    //根据删除策略 删除七天以前的附件
    NSDate *aWeekBefore=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*7];
    NSString *strDate=[DateUtils dateToString:aWeekBefore DateFormat:sdateFormat];
    NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:[NSString stringWithFormat:
                                                                           @"SELECT PAPERID FROM T_DOCUMENTS where CHANNELID in (%@) and CRTM<'%@';",clientFidlist,strDate]];
    if(oldRecordArray.count>0)
    {
        for (NSDictionary *dic in oldRecordArray)
        {
            NSString* ecmPath = [[FileUtils documentPath] stringByAppendingPathComponent:@"ecm"];
            NSString* clientPath = [ecmPath stringByAppendingPathComponent:_client.CODE];
            NSString *filePath= [clientPath stringByAppendingPathComponent:dic[@"PAPERID"]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:filePath isDirectory:0])
            {
                [fileManager removeItemAtPath:filePath error:nil];
            }
        }
    }
}

-(BOOL)needClean
{
    //一个星期以前数据是否需要删除
    NSDate *aWeekBefore=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*7];
    NSString *weekDate=[DateUtils dateToString:aWeekBefore DateFormat:sdateFormat];
    NSString *weekSql=[NSString stringWithFormat:@"SELECT PAPERID FROM T_DOCUMENTS where CHANNELID in (%@) and CRTM<'%@';",clientFidlist,weekDate];
    if ([[DBQueue sharedbQueue] CountOfQueryWithSQL:weekSql]>0)
    {
        NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:[NSString stringWithFormat:
                                                                               @"SELECT PAPERID FROM T_DOCUMENTS where CHANNELID in (%@) and CRTM<'%@';",clientFidlist,weekDate]];
        for (NSDictionary *dic in oldRecordArray)
        {
            NSString* ecmPath = [[FileUtils documentPath] stringByAppendingPathComponent:@"ecm"];
            NSString* clientPath = [ecmPath stringByAppendingPathComponent:_client.CODE];
            NSString *filePath= [clientPath stringByAppendingPathComponent:dic[@"PAPERID"]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:filePath isDirectory:0]){
                return YES;
            } else{
                continue;
            }
        }
        return NO;
    }
    return NO;
}

-(NSString*)clientAppSizeDocumentPath
{
    NSString* ecmPath = [[FileUtils documentPath] stringByAppendingPathComponent:@"ecm"];
    NSString* clientPath = [ecmPath stringByAppendingPathComponent:_client.CODE];
    NSString* clientDocumentSizeString = [FileUtils formattedFileSize:[FileUtils folderSizeAtPath:clientPath]];
    NSString *needCleanSizeStr=[FileUtils formattedFileSize:[self getNeedCleanSize]];
    NSString *result=[NSString stringWithFormat:@"%@(%@)",clientDocumentSizeString,needCleanSizeStr];
    return result;
}
@end
