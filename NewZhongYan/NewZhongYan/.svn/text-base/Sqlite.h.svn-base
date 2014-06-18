//
//  Sqlite.h
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sqlite : NSObject

/**
 *  创建数据库文件
 *
 *  @return  是否创建成功
 */
+ (BOOL)createContactDbFile;

/**
 *  获取数据库文件的路径
 *
 *  @return 数据库文件的路径
 */
+ (NSString *)dataBasePath;

/**
 *  打开数据库
 *
 *  @return 是否打开成功
 */
+ (BOOL)openDb;

/**
 *  关闭数据库
 */
+ (void)closeDb;

/**
 *  开启一个事务
 *
 *  @return 是否开启成功
 */
+(BOOL)beginTransaction;

/**
 *  提交一个事物
 *
 *  @return 是否提交成功
 */
+(BOOL)commitTransaction;

//插入
+(BOOL)insertDataToTableWithSQL  :(NSString*)sql;

//删除
+(BOOL)deleteDataFromTableWithSQL:(NSString*)sql;

//跟新
+(BOOL)updateDataFromTableWithSQL:(NSString*)sql;

//执行sql
+(BOOL)executeSQL:(NSString*)sql;

+(BOOL)createAllTable;

/**
 *  设置本地数据库的版本
 */
+(void)setDBVersion;

/**
 *  返回某个sql查询结果会有几条记录
 *
 *  @param sql sql查询语句
 *
 *  @return 结果集个数
 */
+(NSInteger)CountOfQueryWithSQL:(NSString*)sql;

/**
 * 获取对应sql的值
 *
 *  @param sql sql语句
 *
 *  @return 查询结果
 */
+(NSDictionary*)getSingleRowBySQL:(NSString*)sql;


+(void)checkTableStructWithTableName:(NSString*)tableName;


+(NSArray*)getAllRecordFromTable:(NSString*)tableName;

//多功能查询函数
+(NSArray*)getRecordFromTableBySQL:(NSString*)sql;
@end
