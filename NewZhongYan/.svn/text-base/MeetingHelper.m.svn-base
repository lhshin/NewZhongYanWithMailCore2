//
//  MeetingHelper.m
//  ZhongYan
//
//  Created by 袁树峰 on 13-3-11.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "MeetingHelper.h"
#import "DateUtils.h"
#import "SKAttachManger.h"
@implementation MeetingHelper
+(void)cleanLocalData
{
    [super cleanLocalData];
    //根据删除策略 删除七天以前的已召开的附件附件
    NSDate *aWeekBefore=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*7];
    NSString *strDate=[DateUtils dateToString:aWeekBefore DateFormat:sdateFormat];
    NSString *strNow=[DateUtils dateToString:[NSDate date] DateFormat:sdateFormat];
    NSString *sql=[NSString stringWithFormat:@"SELECT TID FROM T_NOTIFY where FID=='31' and CRTM<'%@' and EDTM<'%@'",strDate,strNow];
    NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
    if(oldRecordArray.count>0)
    {
        for (NSDictionary *dic in oldRecordArray)
        {
            NSString *filePath= [SKAttachManger TIDPathWithOutCreate:SKMeet Tid:[dic objectForKey:@"TID"]];
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
    NSString *str=[FileUtils formattedFileSize:[FileUtils folderSizeAtPath:[SKAttachManger meetPath]]];
    
    NSString *needCleanSizeStr=[FileUtils formattedFileSize:[self getNeedCleanSize]];
    NSString *result=[NSString stringWithFormat:@"%@(%@)",str,needCleanSizeStr];
    return result;
}

+(long long)getNeedCleanSize
{
    long long needCleanSize=0;//需要清理的大小
    NSDate *aWeekBefore=[NSDate dateWithTimeIntervalSinceNow:-60*60*24*7];
    NSString *strDate=[DateUtils dateToString:aWeekBefore DateFormat:sdateFormat];
    NSString *strNow=[DateUtils dateToString:[NSDate date] DateFormat:sdateFormat];
    NSString *sql=[NSString stringWithFormat:@"SELECT TID FROM T_NOTIFY where FID=='31' and CRTM<'%@' and EDTM<'%@'",strDate,strNow];
    if ([[DBQueue sharedbQueue] CountOfQueryWithSQL:sql]>0)
    {
        NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
        for (NSDictionary *dic in oldRecordArray)
        {
            NSString *filePath= [SKAttachManger TIDPathWithOutCreate:SKMeet Tid:[dic objectForKey:@"TID"]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //只要有文件存在 就需要清理
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
    NSString *strDate=[DateUtils dateToString:aWeekBefore DateFormat:sdateFormat];
    NSString *strNow=[DateUtils dateToString:[NSDate date] DateFormat:sdateFormat];
    NSString *sql=[NSString stringWithFormat:@"SELECT TID FROM T_NOTIFY where FID=='31' and CRTM<'%@' and EDTM<'%@'",strDate,strNow];
    if ([[DBQueue sharedbQueue] CountOfQueryWithSQL:sql]>0)
    {
        NSArray *oldRecordArray= [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
        for (NSDictionary *dic in oldRecordArray)
        {
            NSString *filePath= [SKAttachManger TIDPathWithOutCreate:SKMeet Tid:[dic objectForKey:@"TID"]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //只要有文件存在 就需要清理
            if ([fileManager fileExistsAtPath:filePath isDirectory:0])
            {
                return YES;
            }
            else
            {
                continue;
            }
        }
        return NO;
    }
    return NO;
}
@end
