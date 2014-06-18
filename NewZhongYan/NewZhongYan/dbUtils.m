//
//  dbUtils.m
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "dbUtils.h"
#import "Sqlite.h"
#import "DBQueue.h"
@implementation dbUtils
//UPDATE Person SET Address = 'Zhongshan 23', City = 'Nanjing' WHERE LastName = 'Wilson' AND ID = '1'
+(NSString*)buildUpdateSQL:(NSString*)tableName SET:(NSDictionary*)setdict Where:(NSDictionary*)wheredict
{
    NSString* KeyString = [[NSString alloc] init] ;
    NSString* ValueString = [[NSString alloc] init] ;
    
    //SET
    for (id key in [setdict allKeys]) {
        if ([[setdict objectForKey:key] isKindOfClass:[NSDate class]]) {
            ValueString = [ValueString stringByAppendingFormat:@"%@ = datetime('now','localtime'),",key];
        }else{//关于nsnumber 的情况 目前测试是没有问题的
            ValueString = [ValueString stringByAppendingFormat:@"%@ = '%@',",key,[setdict objectForKey:key]];
        }
    }
    ValueString = [ValueString substringToIndex:[ValueString length] - 1];
    
    //WHERE
    if (wheredict)
    {
        for (id key in [wheredict allKeys]) {
            if ([[wheredict objectForKey:key] isKindOfClass:[NSDate class]]) {
                KeyString = [KeyString stringByAppendingFormat:@"%@ = datetime('%@') AND ",key,[wheredict objectForKey:key]];
            }else{
                KeyString = [KeyString stringByAppendingFormat:@"%@ = '%@' AND ",key,[wheredict objectForKey:key]];
            }
        }
        KeyString = [KeyString substringToIndex:[KeyString length] - 5];
        return [NSString stringWithFormat: @"UPDATE %@ SET %@ WHERE %@;", tableName,ValueString,KeyString];
    }
    return [NSString stringWithFormat: @"UPDATE %@ SET %@;", tableName,ValueString];
    
}



//@"INSERT INTO %@ (PAID, PNAME, PCONTENT,PNOTE,PREMARK) VALUES ('%d','%@','%@','%@','%@')"
+(NSString*)buildInsertSQL:(NSString*)tableName Value:(NSMutableDictionary*)dict
{
    for (NSString* key in [dict allKeys])
    {
        id value = [dict objectForKey:key];
        if ([value isKindOfClass:[NSString class]])
        {
            //针对敏感字符 单引号
            value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
            //别的敏感字符
        }
        [dict setObject:value forKey:key];
    }
    
    NSString* value = [NSString stringWithFormat:@"'%@'",[[dict allValues] componentsJoinedByString:@"','"]];
    return [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@)",tableName,[[dict allKeys] componentsJoinedByString:@","],value];
    
    
    //    NSString* KeyString = [NSString string];
    //    NSString* ValueString = [NSString string];
    //    //字段
    //    for (NSString* key in [dict allKeys])
    //    {
    //        KeyString = [KeyString stringByAppendingFormat:@",%@",key];
    //    }
    //    KeyString = [KeyString substringFromIndex:1]; //去掉逗号
    //
    //    //值
    //    for (id value in [dict allValues])
    //    {
    //        if ([value isKindOfClass:[NSString class]])
    //        {
    //            //针对敏感字符 单引号
    //            value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    //            //别的敏感字符
    //        }
    //        ValueString = [ValueString stringByAppendingFormat:@",'%@'",value];
    //    }
    //    ValueString = [ValueString substringFromIndex:1];
    //    return [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@);",tableName,KeyString,ValueString];//sql 要改变
}

// DELETE FROM USER_REMS WHERE UID = 'lilin87788' AND CNAME = 'lilin';
+(NSString*)buildDeleteSQL:(NSString*)tableName Where:(NSDictionary*)idkeys
{
    if (!idkeys) {
        return [NSString stringWithFormat:@"DELETE FROM %@;",tableName];
    }
    //WHERE
    NSString* KeyString = [[NSString alloc] init];
    for (NSString* key in [idkeys allKeys]) {
        KeyString = [KeyString stringByAppendingFormat:@"%@ = '%@' AND ",key,[idkeys objectForKey:key]];
    }
    KeyString = [KeyString substringToIndex:[KeyString length] - 5];
    return [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@;",tableName,KeyString];
}

//SELECT A,B,C,D FROM TABLENAME WHERE
+(NSString*)buildSelectSQL:(NSString*)tableName Column:(NSArray*)column
                     Where:(NSArray*)key Equal:(NSArray*)value Condition:(NSString*)condition
{
    //column
    NSString* columnString = [[NSString alloc] init];
    for (NSString* onecolumn in column) {
        columnString = [columnString stringByAppendingFormat:@"%@,",onecolumn];
    }
    columnString = [columnString substringToIndex:[columnString length] - 1];
    
    if (key && value) {
        //where
        NSString* whereString = [[NSString alloc] init];
        for (int i = 0; i < [key count]; i++) {
            whereString = [whereString stringByAppendingFormat:@"%@ = '%@' AND ",[key objectAtIndex:i],[value objectAtIndex:i]];
        }
        whereString = [whereString substringToIndex:[whereString length] - 5];
        return [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ %@;",columnString,tableName,whereString,condition];
    }else{
        return [NSString stringWithFormat:@"SELECT %@ FROM %@ %@;",columnString,tableName,condition];
    }
    
}

//只有多个键值对
+(BOOL)existedKeyValues:(NSString*)tableName Key:(NSArray*)key Value:(NSArray*)value
{
    NSString* sql = [self buildSelectSQL:tableName Column:[NSArray arrayWithObject:@"*"] Where:key Equal:value Condition:@""];
    DBQueue* queue = [DBQueue sharedbQueue];
    return [queue CountOfQueryWithSQL:sql];
}

//一个键值对
+(BOOL)existedKeyValue:(NSString*)tableName Key:(NSString*)key Value:(NSString*)value
{
    return [self existedKeyValues:tableName Key:[NSArray arrayWithObject:key] Value:[NSArray arrayWithObject:value]];
}


//TODO
+(NSDictionary*) getSingleRowByKeyValues:(NSString*)tableName Key:(NSArray*)key Value:(NSArray*)value column:(NSArray*)column
{
    NSString* sql = [self buildSelectSQL:tableName
                                  Column:column
                                   Where:key
                                   Equal:value
                               Condition:@""];
    
    return [[DBQueue sharedbQueue] getSingleRowBySQL:sql];//还没有测试
}

+(NSDictionary*) getSingleRowByKeyValue:(NSString*)tableName Key:(NSString*)key Value:(NSString*)value column:(NSArray*)column
{
    return [self getSingleRowByKeyValues:tableName Key:[NSArray arrayWithObject:key] Value:[NSArray arrayWithObject:value] column:column];
}

//如果是保存数据的话那么dict中肯定含有idkey这个字段
+(void)saveDataToTableByKeyValue:(NSString*)tableName Key:(NSString*)idkey Value:(NSMutableDictionary*)dict
{
    NSString *sql  = [self buildInsertSQL:tableName Value:dict];
    if(![[DBQueue sharedbQueue] updateDataTotableWithSQL:sql])
    {
        NSLog(@"插入数据库失败");
    }
}


+(void)saveDataToTableByKeyValues:(NSString*)tableName Key:(NSArray*)idkeys Value:(NSMutableDictionary*)dict
{
    DBQueue* queue = [DBQueue sharedbQueue];
    NSMutableArray* idvalues  = [NSMutableArray arrayWithCapacity:[idkeys count]];
    for (id key in idkeys) {
        [idvalues addObject:[dict objectForKey:key]];
    }
    NSString *sql;
    //BOOL itmEnable = [[dict allKeys] containsObject:@"ENABLED"] ? [[dict objectForKey:@"ENABLED"] intValue] == 1 :YES;
    //TODO 暂时设置为YES
    BOOL itmEnable;
    itmEnable = YES;
    if (itmEnable)
    {
        BOOL itmExisted = [self existedKeyValues:tableName Key:idkeys Value:idvalues];
        if (itmExisted)
        {
            NSMutableDictionary* wheredict = [NSMutableDictionary dictionary];// 新加的
            for (NSString* key in idkeys) {
                [wheredict setObject:[dict objectForKey:key] forKey:key];
            }
            
            sql = [self buildUpdateSQL:tableName SET:dict Where:wheredict];
            if (![queue updateDataTotableWithSQL:sql])
            {
                NSLog(@"更新数据库失败");
            }
        }
        else
        {
            sql = [self buildInsertSQL:tableName Value:dict];
            if(![queue updateDataTotableWithSQL:sql])
            {
                NSLog(@"插入数据库失败");
            }
        }
    }
    else
    {
        sql = [self buildDeleteSQL:tableName Where:dict];
        if (![Sqlite deleteDataFromTableWithSQL:sql]) {
            NSLog(@"删除数据库失败");
        }
    }
}

//数据库里面的数据还没有写
+(NSInteger)countRecords:(NSString*)tableName where:(NSDictionary*)where
{
    //WHERE
    NSString* KeyString = [[NSString alloc] init];
    for (NSString* key in [where allKeys]) {
        KeyString = [KeyString stringByAppendingFormat:@"%@ = '%@' AND ",key,[where objectForKey:key]];
    }
    KeyString = [KeyString substringToIndex:[KeyString length] - 5];
    NSString* sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@;",tableName,KeyString];    //执行
    DBQueue* queue = [DBQueue sharedbQueue];
    return [queue CountOfQueryWithSQL:sql];
}

@end
