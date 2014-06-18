//
//  dbUtils.h
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dbUtils : NSObject
//只有多个键值对
+(BOOL)existedKeyValues:(NSString*)tableName Key:(NSArray*)key Value:(NSArray*)value;

//一个键值对
+(BOOL)existedKeyValue:(NSString*)tableName Key:(NSString*)key Value:(NSString*)value;

//参数 表名 key  value 和要取出的列名s
+(NSDictionary*) getSingleRowByKeyValue:(NSString*)tableName Key:(NSString*)key Value:(NSString*)value column:(NSArray*)column;

//多个键值
+(NSDictionary*) getSingleRowByKeyValues:(NSString*)tableName Key:(NSArray*)key Value:(NSArray*)value column:(NSArray*)column;

+(void)saveDataToTableByKeyValue:(NSString*)tableName Key:(NSString*)idkey Value:(NSMutableDictionary*)dict;

//多个键值
+(void)saveDataToTableByKeyValues:(NSString*)tableName Key:(NSArray*)idkeys Value:(NSMutableDictionary*)dict;

//UPDATE Person SET Address = 'Zhongshan 23', City = 'Nanjing' WHERE LastName = 'Wilson' AND ID = '1'
//入口 表名 set where
+(NSString*)buildUpdateSQL:(NSString*)tableName SET:(NSDictionary*)setdict Where:(NSDictionary*)wheredict;

+(NSString*)buildInsertSQL:(NSString*)tableName Value:(NSMutableDictionary*)dict;

+(NSString*)buildDeleteSQL:(NSString*)tableName Where:(NSDictionary*)idkeys;

////SELECT A,B,C,D FROM TABLENAME WHERE E ＝ ‘a’ and F ＝ ‘b’ order by
+(NSString*)buildSelectSQL:(NSString*)tableName Column:(NSArray*)column
                     Where:(NSArray*)key Equal:(NSArray*)value Condition:(NSString*)condition;
@end
