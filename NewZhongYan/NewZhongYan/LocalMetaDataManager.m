//
//  LocalMetaDataManager.m
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "LocalMetaDataManager.h"
#import "LocalDataMeta.h"
@implementation LocalMetaDataManager
+(LocalDataMeta*)restoreMetaData:(LocalDataMeta*)metaData
{
    NSString* uid = [APPUtils userUid];
    NSParameterAssert(uid.length > 0);
    //获取数据库本地的版本信息
    NSString* sql = [NSString stringWithFormat:@"select * from DATA_VER where OWUID = '%@' and SID = '%@';",uid,[metaData dataCode]];
    NSDictionary* verInfo = [[DBQueue sharedbQueue] getSingleRowBySQL:sql];
    if (verInfo) {
        [metaData setVersion:[[verInfo objectForKey:@"LCV"] intValue]];
        [metaData setUpdateTime:[verInfo objectForKey:@"UPT"] ];
    }else{
        [metaData setVersion:0];
        [metaData setUpdateTime:0];
    }
    
    //获取数据库本地的初始化信息
    sql = [NSString stringWithFormat:@"select * from DATA_INITS where OWUID = '%@' and DID = '%@';",uid,[metaData dataCode]];
    NSDictionary* initInfo = [[DBQueue sharedbQueue] getSingleRowBySQL:sql];
    //int lastfrom = [[DBQueue sharedbQueue] intValueFromSQL:[NSString stringWithFormat:@"select max(id) from %@;",[metaData localName]]] + 1;
    if (initInfo) {//表示中断过数据
        [metaData snapInitDataWithVersion:[[initInfo objectForKey:@"VS"] intValue] //version
                                lastCount:[[initInfo objectForKey:@"CT"] intValue] //count 服务器数据的条数
                                 lastFrom:[[initInfo objectForKey:@"LI"] intValue]
                                     Date:[initInfo objectForKey:@"UPT"]];
    }
    return metaData;
}

+(void)restoreAllMetaData
{
    [self restoreMetaData:[LocalDataMeta sharedNews]];
    [self restoreMetaData:[LocalDataMeta sharedOranizational]];
    [self restoreMetaData:[LocalDataMeta sharedEmployee]];
    [self restoreMetaData:[LocalDataMeta sharedSelfEmployee]];
    [self restoreMetaData:[LocalDataMeta sharedRemind]];
    [self restoreMetaData:[LocalDataMeta sharedNotify]];
    [self restoreMetaData:[LocalDataMeta sharedUnit]];
    [self restoreMetaData:[LocalDataMeta sharedWorkNews]];
    [self restoreMetaData:[LocalDataMeta sharedMeeting]];
    [self restoreMetaData:[LocalDataMeta sharedAnnouncement]];
    [self restoreMetaData:[LocalDataMeta sharedClientApp]];
    [self restoreMetaData:[LocalDataMeta sharedChannel]];
}

+(LocalDataMeta*)flushMetaData:(LocalDataMeta*)metaData
{
    NSString* uid = [APPUtils userUid];
    NSParameterAssert(uid.length > 0);
    if ([metaData isDataLocalRooted]) {
        NSString* sql = nil;
        if (metaData.version > 0)
        {
            [[DBQueue sharedbQueue] updateDataTotableWithSQL:
             [NSString stringWithFormat:@"delete from DATA_INITS where OWUID = '%@' and DID = '%@'",uid,metaData.dataCode]];
            NSString* upt = metaData.updateTime ? metaData.updateTime :[NSDate curerntTime];
            NSInteger lcv = [metaData version];
            sql = [NSString stringWithFormat:
                   @"INSERT OR REPLACE INTO DATA_VER (UPT,LCV,SID,OWUID) VALUES ('%@',%ld,'%@','%@');",
                   upt,(long)lcv,metaData.dataCode,uid];
            
        }
        else if ([metaData isInitDataSnapped])
        {
            sql = [NSString stringWithFormat:
                   @"INSERT OR REPLACE INTO DATA_INITS (DID,VS,CT,LI,OWUID,UPT) VALUES ('%@',%d,%d,%d,'%@','%@');",
                   metaData.dataCode,metaData.lastversion,metaData.lastcount,metaData.lastfrom,uid,metaData.lastupdatetime];
        }
        else
        {
            sql = [NSString stringWithFormat:@"delete from DATA_INITS where OWUID = '%@' and DID = '%@'",uid,metaData.dataCode];
        }
        [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
    }else{
        [[DBQueue sharedbQueue] updateDataTotableWithSQL:
         [NSString stringWithFormat:@"delete from DATA_VER where OWUID = '%@' and SID = '%@'",uid,metaData.dataCode]];
        [[DBQueue sharedbQueue] updateDataTotableWithSQL:
         [NSString stringWithFormat:@"delete from DATA_INITS where OWUID = '%@' and DID = '%@'",uid,metaData.dataCode]];
    }
    return metaData;
}

+(BOOL)existedNewData:(LocalDataMeta*)metaData
{
    NSString *sql = [NSString stringWithFormat:@"select * from T_VERSIONINFO WHERE NAME = '%@';",[metaData dataCode]];
    NSDictionary* dataItems = [[DBQueue sharedbQueue] getSingleRowBySQL:sql];
    return metaData.version < [[dataItems objectForKey:@"VERSION"] intValue];
}

+(NSString*)newECMDataItemCount:(NSString*)currentFid
{
    NSString* sql = [NSString stringWithFormat:
                     @"select AID from T_DOCUMENTS where strftime('%%s','now','start of day','-8 hour','-1 day') <= strftime('%%s',crtm) AND CHANNELID in (%@) and ENABLED = 1 AND READED = 0;",currentFid];
    NSInteger count = [[DBQueue sharedbQueue] CountOfQueryWithSQL:sql];
    return count ? [NSString stringWithFormat:@"%ld",(long)count] : nil;
}

+(NSString*)newECMMeettingItemCount:(NSString*)currentFid
{
    NSString* sql = [NSString stringWithFormat:
                     @"select  AID from T_DOCUMENTS WHERE DATETIME(EDTM) > DATETIME('now','localtime') and CHANNELID in (%@) and ENABLED = 1;",currentFid];
    NSInteger count = [[DBQueue sharedbQueue] CountOfQueryWithSQL:sql];
    return count ? [NSString stringWithFormat:@"%ld",(long)count] : nil;
}

+(NSString*)newDataItemCount:(LocalDataMeta*)metaData;
{
    NSString *sql;
    NSString* datacode = [metaData dataCode];
    if ([datacode isEqualToString:@"news"] || [datacode isEqualToString:@"codocs"] || [datacode isEqualToString:@"worknews"])
    {
        sql = [NSString stringWithFormat:
               @"select TID from %@ WHERE strftime('%%s','now','start of day','-8 hour','-1 day') <= strftime('%%s',crtm) AND READED = 0;",
               [metaData localName]];
    }
    else if ([datacode isEqualToString:@"notify/31"])
    {//会议
        sql = [NSString stringWithFormat:
               @"select  TID from %@ WHERE DATETIME(EDTM) > DATETIME('now','localtime') AND ENABLED = 1;",[metaData localName]];
    }
    else if([datacode isEqualToString:@"remind"])
    {
        sql = [NSString stringWithFormat:
               @"select * from %@ where ENABLED = 1 and status = -1;",[metaData localName]];
    }
    else if([datacode isEqualToString:@"mail"])
    {
        sql = [NSString stringWithFormat:
               @"select * from %@ where ISREAD = 0;",[metaData localName]];
    }else{
        sql = [NSString stringWithFormat:
               @"select TID from %@ \
               WHERE TPID = '%@'\
               AND strftime('%%s','now','start of day','-8 hour','-1 day') <= strftime('%%s',crtm) \
               AND READED = 0;",
               [metaData localName],[datacode substringFromIndex:7]];
    }
    NSInteger count = [[DBQueue sharedbQueue] CountOfQueryWithSQL:sql];
    return count ? [NSString stringWithFormat:@"%ld",(long)count] : nil;
}
@end
