//
//  MainHelper.m
//  ZhongYan
//
//  Created by 袁树峰 on 13-3-8.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "MainHelper.h"
@implementation MainHelper
+(void)cleanLocalData
{
    NSLog(@"Start clean Local Data!");
}

+(NSString*)getSize
{
    return nil;
}

+(NSString *)getAllSize
{
    NSString *str=[FileUtils formattedFileSize:[FileUtils folderSizeAtPath:[FileUtils documentPath]]];
    return str;
}

+(BOOL)needClean//是否需要清理内存
{
    return NO;
}

+(long long)getNeedCleanSize;//获取需要清理的内存大小
{
    return 0;
}
@end
