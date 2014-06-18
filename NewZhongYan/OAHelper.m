//
//  OAHelper.m
//  ZhongYan
//
//  Created by 袁树峰 on 13-3-11.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "OAHelper.h"

@implementation OAHelper
+(void)cleanAllDataWhenReportLoss
{
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from T_REMINDS;"];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from DATA_VER where sid = 'remind';"];
    NSString *filePath= [SKAttachManger remindPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath isDirectory:0])
    {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

+(void)cleanLocalData
{
    //删除30天以前的列表数据
    NSDate *aMonthBefore=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*30];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:[NSString stringWithFormat:@"delete  FROM T_REMINDS where CRTM<'%@' and STATUS==0",aMonthBefore]];
    //删除7天以前的附件
    NSDate *aWeekBefore=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*7];
    NSString *strDate=[DateUtils dateToString:aWeekBefore DateFormat:sdateFormat];
    NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:[NSString stringWithFormat:@"SELECT AID FROM T_REMINDS where CRTM<'%@' and STATUS==0",strDate]];
    NSLog(@"%lu",(unsigned long)oldRecordArray.count);
    if(oldRecordArray.count>0)
    {
        for (NSDictionary *dic in oldRecordArray)
        {
            NSString *filePath= [SKAttachManger aIDPathWithoutCreate:[dic objectForKey:@"AID"]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:filePath isDirectory:0])
            {
                [fileManager removeItemAtPath:filePath error:nil];
            }
        }
    }
    
}

+(NSString *)getSize
{
    NSString *str=[FileUtils formattedFileSize:[FileUtils folderSizeAtPath:[SKAttachManger remindPath]]];
    
    NSString *needCleanSizeStr=[FileUtils formattedFileSize:[self getNeedCleanSize]];
    NSString *result=[NSString stringWithFormat:@"%@(%@)",str,needCleanSizeStr];
    return result;
}

+(long long)getNeedCleanSize
{
    long long needCleanSize=0;//需要清理的大小
    NSDate *aWeekBefore=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*7];
    NSString *weekDate=[DateUtils dateToString:aWeekBefore DateFormat:sdateFormat];
    NSString *weekSql=[NSString stringWithFormat:@"SELECT * FROM T_REMINDS where CRTM<'%@' and STATUS==0",weekDate];
    if ([[DBQueue sharedbQueue] CountOfQueryWithSQL:weekSql]>0)
    {
        NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:[NSString stringWithFormat:@"SELECT AID FROM T_REMINDS where CRTM<'%@' and STATUS==0",weekDate]];
        for (NSDictionary *dic in oldRecordArray)
        {
            NSString *filePath= [SKAttachManger aIDPathWithoutCreate:[dic objectForKey:@"AID"]];
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
    NSString *weekSql=[NSString stringWithFormat:@"SELECT * FROM T_REMINDS where CRTM<'%@' and STATUS==0",weekDate];
    if ([[DBQueue sharedbQueue] CountOfQueryWithSQL:weekSql]>0)
    {
        NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:[NSString stringWithFormat:@"SELECT AID FROM T_REMINDS where CRTM<'%@' and STATUS==0",weekDate]];
            for (NSDictionary *dic in oldRecordArray)
            {
                NSString *filePath= [SKAttachManger aIDPathWithoutCreate:[dic objectForKey:@"AID"]];
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
    NSString *monthSql=[NSString stringWithFormat:@"SELECT * FROM T_REMINDS where CRTM<'%@' and STATUS==0",monthDate];
    if ([[DBQueue sharedbQueue] CountOfQueryWithSQL:monthSql]>0)
    {
        return YES;
    }
    return NO;
}
@end
