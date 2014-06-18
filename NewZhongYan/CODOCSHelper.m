//
//  CODOCSHelper.m
//  ZhongYan
//
//  Created by 袁树峰 on 13-3-11.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "CODOCSHelper.h"
#import "DateUtils.h"
#import "SKAttachManger.h"
@implementation CODOCSHelper
+(void)cleanAllDataWhenReportLoss
{
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from T_CODOCS;"];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from T_CODOCSTP;"];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from DATA_VER where sid = 'codocs';"];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from DATA_VER where sid = 'codocstype';"];
    NSString *filePath= [SKAttachManger codocsPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath isDirectory:0])
    {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

+(void)cleanLocalData
{
    [super cleanLocalData];
    //根据删除策略 删除七天以前的附件 然后删除三十天以前的列表和相应附件
    NSDate *aWeekBefore=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*7];
    NSString *strDate=[DateUtils dateToString:aWeekBefore DateFormat:sdateFormat];
    NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:[NSString stringWithFormat:
                                                                           @"SELECT TID FROM T_CODOCS where CRTM<'%@'",strDate]];
    if(oldRecordArray.count>0)
    {
        for (NSDictionary *dic in oldRecordArray)
        {
            NSString *filePath= [SKAttachManger TIDPathWithOutCreate:SKCodocs Tid:[dic objectForKey:@"TID"]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:filePath isDirectory:0])
            {
                [fileManager removeItemAtPath:filePath error:nil];
            }
        }
    }
    NSDate *aMonthBefore=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*30];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:[NSString stringWithFormat:@"delete  FROM T_CODOCS where CRTM<'%@'",aMonthBefore]];
}
+(NSString *)getSize
{
    NSString *str=[FileUtils formattedFileSize:[FileUtils folderSizeAtPath:[SKAttachManger codocsPath]]];
    
    NSString *needCleanSizeStr=[FileUtils formattedFileSize:[self getNeedCleanSize]];
    NSString *result=[NSString stringWithFormat:@"%@(%@)",str,needCleanSizeStr];
    return result;
}

+(long long)getNeedCleanSize
{
    long long needCleanSize=0;//需要清理的大小
    NSDate *aWeekBefore=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*7];
    NSString *weekDate=[DateUtils dateToString:aWeekBefore DateFormat:sdateFormat];
    NSString *weekSql=[NSString stringWithFormat:@"SELECT * FROM T_CODOCS where CRTM<'%@'",weekDate];
    if ([[DBQueue sharedbQueue] CountOfQueryWithSQL:weekSql]>0)
    {
        NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:[NSString stringWithFormat:
                                                                               @"SELECT TID FROM T_CODOCS where CRTM<'%@'",weekDate]];
        for (NSDictionary *dic in oldRecordArray)
        {
            NSString *filePath= [SKAttachManger TIDPathWithOutCreate:SKCodocs Tid:[dic objectForKey:@"TID"]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:filePath isDirectory:0])
            {
                needCleanSize+=[FileUtils folderSizeAtPath:filePath];
            }
            else
            {
                continue;
            }
        }
    }
    return needCleanSize;
}

+(BOOL)needClean
{
    //一个星期以前数据是否需要删除
    NSDate *aWeekBefore=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*7];
    NSString *weekDate=[DateUtils dateToString:aWeekBefore DateFormat:sdateFormat];
    NSString *weekSql=[NSString stringWithFormat:@"SELECT * FROM T_CODOCS where CRTM<'%@'",weekDate];
    if ([[DBQueue sharedbQueue] CountOfQueryWithSQL:weekSql]>0)
    {
        NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:[NSString stringWithFormat:
                                                                               @"SELECT TID FROM T_CODOCS where CRTM<'%@'",weekDate]];
        for (NSDictionary *dic in oldRecordArray)
        {
            NSString *filePath= [SKAttachManger TIDPathWithOutCreate:SKCodocs Tid:[dic objectForKey:@"TID"]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:filePath isDirectory:0])
            {
                return YES;
            }
            else
            {
                continue;
            }
        }
    }
    //一个月以前数据是否需要删除
    NSDate *aMonthBefore=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*30];
    NSString *monthDate=[DateUtils dateToString:aMonthBefore DateFormat:sdateFormat];
    NSString *monthSql=[NSString stringWithFormat:@"SELECT * FROM T_CODOCS where CRTM<'%@'",monthDate];
    if ([[DBQueue sharedbQueue] CountOfQueryWithSQL:monthSql]>0)
    {
        return YES;
    }
    return NO;
}
@end
