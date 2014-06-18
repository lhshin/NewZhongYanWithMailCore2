//
//  WorkNewsHelper.m
//  ZhongYan
//
//  Created by 袁树峰 on 13-3-11.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "WorkNewsHelper.h"

@implementation WorkNewsHelper
+(void)cleanAllDataWhenReportLoss
{
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from T_WORKNEWS;"];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from T_WORKNEWSTP;"];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from DATA_VER where sid = 'worknews';"];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from DATA_VER where sid = 'worknewstype';"];
    NSString *filePath= [SKAttachManger workNewsPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath isDirectory:0])
    {
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

+(void)cleanLocalData
{
    
}
+(NSString *)getSize
{
    NSString *str=[FileUtils formattedFileSize:[FileUtils folderSizeAtPath:[SKAttachManger workNewsPath]]];
    NSString *result=[NSString stringWithFormat:@"%@(0B)",str];
    return result;
}
+(BOOL)needClean
{
    return NO;
}
@end
