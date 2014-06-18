//
//  EmailHelper.m
//  ZhongYan
//
//  Created by 袁树峰 on 13-3-11.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "EmailHelper.h"

@implementation EmailHelper
+(void)cleanAllDataWhenReportLoss
{
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from T_LOCALMESSAGE;"];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from T_DRAFT;"];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from T_OUTBOX;"];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from DATA_VER where sid = 'mail';"];
    NSString *filePath= [SKAttachManger mailPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath isDirectory:0])
    {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}



//清除操作
+(void)cleanLocalData
{
    [super cleanLocalData];
    //根据删除策略 首先删除七天以前的附件 然后删除三十天以前的列表和相应附件
    NSString *sql=@"SELECT MESSAGEID FROM T_LOCALMESSAGE where SENTDATE < datetime('now','localtime','-30 day');";
    NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
    if(oldRecordArray.count>0)
    {
        for (NSDictionary *amail in oldRecordArray)
        {
            NSString* messageID = [amail objectForKey:@"MESSAGEID"];
            NSString *filePath= [[SKAttachManger mailPath] stringByAppendingPathComponent:messageID];
            BOOL isDirectory = 0;
            BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (result && isDirectory)
            {
                NSString* sql = [NSString stringWithFormat:@"update T_LOCALMESSAGE set ISLOADED = 0 where MESSAGEID = '%@'",messageID];
                [[NSFileManager defaultManager]  removeItemAtPath:filePath error:nil];
                [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
            }
        }
    }
}

//获取邮件的size 的基本信息
+(NSString *)getSize
{
    NSString *str=[FileUtils formattedFileSize:[FileUtils folderSizeAtPath:[SKAttachManger mailPath]]];
    NSString *needCleanSizeStr=[FileUtils formattedFileSize:[self getNeedCleanSize]];
    NSString *result=[NSString stringWithFormat:@"%@(%@)",str,needCleanSizeStr];
    return result;
}

//可以清除的文件的大小
+(long long)getNeedCleanSize
{
    long long needCleanSize=0;//需要清理的大小
    NSString *sql=@"SELECT MESSAGEID FROM T_LOCALMESSAGE where SENTDATE < datetime('now','localtime','-30 day');";
    NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
    for (NSDictionary *amail in oldRecordArray)
    {
        NSString* messageID = [amail objectForKey:@"MESSAGEID"];
        NSString *filePath= [[SKAttachManger mailPath] stringByAppendingPathComponent:messageID];
        BOOL isDirectory = 0;
        BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (result && isDirectory)
        {
            needCleanSize+=[FileUtils folderSizeAtPath:filePath];
        }
        else
        {
            continue;
        }
    }
    return needCleanSize;
}

//是否有可以清除的数据
+(BOOL)needClean
{
    //一个月以前数据是否需要删除
    NSString *sql=@"SELECT MESSAGEID FROM T_LOCALMESSAGE where SENTDATE < datetime('now','localtime','-30 day');";
    NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
    if (oldRecordArray.count > 0)
    {
        for (NSDictionary* amail in oldRecordArray)
        {
            NSString* messageID = [amail objectForKey:@"MESSAGEID"];
            NSString *filePath= [[SKAttachManger mailPath] stringByAppendingPathComponent:messageID];
            BOOL isDirectory = 0;
            BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (result && isDirectory)
            {
                return YES;
            }
            else
            {
                continue;
            }

        }
    }
    return NO;
}
@end
