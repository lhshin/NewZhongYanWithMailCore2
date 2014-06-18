//
//  DBQueue.m
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "DBQueue.h"
#import "SKMessageEntity.h"
static DBQueue *gSharedInstance = nil;

@implementation DBQueue
@synthesize dbQueue;
-(id)init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"zhongYan.db"]];
    }
    return self;
}


+(DBQueue*)sharedbQueue
{
    if (gSharedInstance == nil) {
        gSharedInstance = [[DBQueue alloc] init];
    }
    return gSharedInstance;
}


-(void)insertDataToTableWithDataArray:(SKMessageEntity*)entity TableName:(NSString*)table
{
    [self.dbQueue inTransaction:^(FMDatabase *db,BOOL *roolBack) {
        for (int i = 0; i < [entity dataItemCount]; i++)
        {
            NSMutableDictionary* dict = [entity dataItem:i];
                for (NSString* key in [dict allKeys])
                {
                    id value = [dict objectForKey:key];
                    if ([value isKindOfClass:[NSString class]])
                    {
                        //针对敏感字符 单引号
                        if ([value rangeOfString:@"'"].location != NSNotFound)
                        {
                            value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                            [dict setObject:value forKey:key];
                        }
                        //别的敏感字符
                    }
                }
                NSString* value = [NSString stringWithFormat:@"'%@'",[[dict allValues] componentsJoinedByString:@"','"]];
                NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@)",table,[[dict allKeys] componentsJoinedByString:@","],value];
                [db executeUpdate:sql];
                if ([db hadError])
                {
                    if (db.lastErrorCode == SQLITE_CONSTRAINT) {
                        continue;
                    }
                    NSLog(@"数据库插入错误:%@ 错误码%d",[db lastErrorMessage],db.lastErrorCode);
                }
        }
    }];
}

-(void)insertDataToTableWithDataArray:(SKMessageEntity*)entity LocalDataMeta:(LocalDataMeta*)dataMeta
{
    [self.dbQueue inTransaction:^(FMDatabase *db,BOOL *roolBack) {
        @autoreleasepool {
            for (int i = 0; i < [entity dataItemCount]; i++) {
                NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[entity dataItem:i]];
                if ([[dict allKeys] containsObject:[dataMeta identityName]])
                {
                    if ([dataMeta userOwner]) {
                        [dict setObject:[APPUtils userUid] forKey:@"OWUID"];
                    }
                    
                    for (NSString* key in [dict allKeys])
                    {
                        id value = [dict objectForKey:key];
                        if ([value isKindOfClass:[NSString class]])
                        {
                            //针对敏感字符 单引号
                            if ([value rangeOfString:@"'"].location != NSNotFound)
                            {
                                value = [value stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
                                [dict setObject:value forKey:key];
                            }
                            //别的敏感字符
                        }
                    }
                    NSString* value = [NSString stringWithFormat:@"'%@'",[[dict allValues] componentsJoinedByString:@"','"]];
                    NSString* sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@)",[dataMeta localName],[[dict allKeys] componentsJoinedByString:@","],value];
                    
                    [db executeUpdate:sql];
                    if ([db hadError])
                    {
                        if (db.lastErrorCode == SQLITE_CONSTRAINT) {
                            continue;
                        }
                        NSLog(@"数据库插入错误:%@ 错误码%d",[db lastErrorMessage],db.lastErrorCode);
                    }
                }
                [dict removeAllObjects],dict = nil;
            }
        }
    }];
}

-(BOOL)updateDataTotableWithSQL:(NSString*)sql
{
    __block BOOL result = YES;
    [self.dbQueue inTransaction:^(FMDatabase *db,BOOL *roolBack)
     {
         [db executeUpdate:sql];
         if ([db hadError]) {
             result = NO;
         }
     }];
    return result;
}

-(NSInteger)CountOfQueryWithSQL:(NSString*)sql
{
    __block NSInteger count = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:sql];
         if ([db hadError]) {
             NSLog(@"dberror = %@",[db lastErrorMessage]);
         }else{
             while ([rs next])
             {
                 count ++;
             }
         }
         [rs close];
     }];
    return count;
}

-(NSDictionary*)getSingleRowBySQL:(NSString*)sql
{
    __block NSDictionary* result =nil;
    [self.dbQueue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = [db executeQuery:sql];
         if ([db hadError]) {
             NSLog(@"---%@",[db lastErrorMessage]);
         }else{
             if ([rs next]) {
                 result = [NSDictionary dictionaryWithDictionary:rs.resultDictionary];
             }
         }
         [rs close];
     }];
    return result;
}

-(NSArray*)recordFromTableBySQL:(NSString*)sql
{
    __block NSMutableArray* result = [[NSMutableArray alloc] init];
    [self.dbQueue inTransaction:^(FMDatabase *db,BOOL *roolBack)
     {
         [db setShouldCacheStatements:YES];
         FMResultSet *rs = [db executeQuery:sql];
         if ([db hadError]) {
             NSLog(@"dberror = %@",[db lastErrorMessage]);
         }
         while ([rs next]) {
             [result addObject: rs.resultDictionary];
         }
         [rs close];
     }];
    return result;
}

-(NSArray*)arrayFromTableBySQL:(NSString*)sql
{
    __block NSMutableArray* result = [[NSMutableArray alloc] init];
    [self.dbQueue inTransaction:^(FMDatabase *db,BOOL *roolBack)
     {
         [db setShouldCacheStatements:YES];
         FMResultSet *rs = [db executeQuery:sql];
         if ([db hadError]) {
             NSLog(@"dberror = %@",[db lastErrorMessage]);
         }
         while ([rs next]) {
             [result addObject: [rs stringForColumnIndex:0]];
         }
         [rs close];
     }];
    return result;
}

-(FMResultSet*)RSFromTableBySQL:(NSString*)sql
{
    __block FMResultSet* result = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db,BOOL *roolBack)
     {
         [db setShouldCacheStatements:YES];
         if ([db hadError]) {
             NSLog(@"dberror = %@",[db lastErrorMessage]);
         }
         result = [db executeQuery:sql];
     }];
    return result;
}

//
//这里肯定只有一条记录
//
-(int)intValueFromSQL:(NSString*)sql
{
    __block int result = 0;
    [self.dbQueue inDatabase:^(FMDatabase *db){
        if ([db hadError]) {
            NSLog(@"dberror = %@",[db lastErrorMessage]);
        }
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next])
        {
            result = [rs intForColumnIndex:0];
        }
        [rs close];
    }];
    return result;
}

//
//这里可定只有一条记录 取得字符串
//
-(NSString*)stringFromSQL:(NSString*)sql
{
    __block NSString* result = nil;
    [self.dbQueue inDatabase:^(FMDatabase *db)   {
        if ([db hadError]) {
            NSLog(@"dberror = %@",[db lastErrorMessage]);
        }
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            result = [rs stringForColumnIndex:0];
        }
        [rs close];
    }];
    return result;
}

-(NSDate*)dateFromSql:(NSString*)sql
{
    __block NSDate* result = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db,BOOL *roolBack)
     {
         [db setShouldCacheStatements:YES];
         FMResultSet *rs = [db executeQuery:sql];
         if ([db hadError]) {
             NSLog(@"dberror = %@",[db lastErrorMessage]);
         }
         if ([rs next]) {
             result = [rs dateForColumnIndex:0];
         }
         [rs close];
     }];
    return result;
}
@end
