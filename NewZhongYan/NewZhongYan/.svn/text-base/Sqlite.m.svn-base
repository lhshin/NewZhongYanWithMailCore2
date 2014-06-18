//
//  Sqlite.m
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "Sqlite.h"
#import "sqlite3.h"
#import "SKAttachManger.h"
#import "SKAgentLogonManager.h"
#import "SKDaemonManager.h"
#import "SKViewController.h"
static sqlite3 *dataBase = nil;
@implementation Sqlite
#pragma  mark -- 数据库的基本函数
id getColValue(sqlite3_stmt *stmt,int iCol);
//返回数据库文件的路径
+ (NSString *)dataBasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"zhongYan.db"];
}

//创建数据库文件的函数
+ (BOOL)createContactDbFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self dataBasePath]]) {
        return YES;
    }
    //不存在就导入数据
    if ([fileManager createFileAtPath:[self dataBasePath] contents:nil attributes:nil]){
        //[InsertInitData insertAllData];//???
        return YES;
    }
    NSLog(@"create contact db file failed");
    return NO;
}

//打开数据库
+ (BOOL)openDb
{
    if (sqlite3_open([[self dataBasePath] UTF8String], &dataBase) != SQLITE_OK){
        NSLog(@"openDatabaseError:%s",sqlite3_errmsg(dataBase));
        sqlite3_close(dataBase);
        return NO;
    }
    return YES;
}

//关闭数据库
+ (void)closeDb
{
    sqlite3_close(dataBase);
}

+(BOOL)beginTransaction
{
    char* error = 0;
    if (sqlite3_exec(dataBase,"BEGIN TRANSACTION;", 0, 0, &error) != SQLITE_OK) {
        NSLog(@"BEGIN TRANSACTION error:%s",error);
        return NO;
    }
    return YES;
}

+(BOOL)commitTransaction
{
    char* error = 0;
    if (sqlite3_exec(dataBase,"COMMIT TRANSACTION;", 0, 0, &error) != SQLITE_OK) {
        NSLog(@"COMMIT TRANSACTION error:%s",error);
        return NO;
    }
    return YES;
}
#pragma  mark -- 根据sql插入一条记录
//@"insert into %@(messageId ,sendTime,Message,messageType,messageState,isRecv) values('%@',datetime('%@'),'%@','%d','%d','%d')"
//这个函数用于批量插入数据 所以该函数没有打开数据库 ，必须在调用之前打开数据库
+(BOOL)insertDataToTableWithSQL:(NSString*)sql
{
    char *error;
    int result = sqlite3_exec(dataBase, [sql UTF8String], 0, 0, &error);
    if (result != SQLITE_OK)
    {
        NSLog(@"insert error:%s",error);
        NSLog(@"insert error:%@",[NSString stringWithUTF8String:error]);
        //return NO;
    }else if(result == SQLITE_BUSY){
        NSLog(@"SQLITE_BUSY");
        return NO;
    }
    return  YES;
}

#pragma  mark -- 根据sql删除记录
+(BOOL)deleteDataFromTableWithSQL:(NSString*)sql
{
    char *error;
    if(sqlite3_exec(dataBase, [sql UTF8String], 0, 0, &error) != SQLITE_OK)
    {
        NSLog(@"delete error:%s",error);
        return NO;
    }
    return YES;
}

#pragma  mark -- 根据sql跟新记录
+(BOOL)updateDataFromTableWithSQL:(NSString*)sql
{
    char *error;
    if(sqlite3_exec(dataBase, [sql UTF8String], 0, 0, &error) != SQLITE_OK)
    {
        NSLog(@"update error:%s",error);
        return NO;
    }
    return YES;
}

//获取指定列的数据
id getColValue(sqlite3_stmt *stmt,int iCol)
{
	int type = sqlite3_column_type(stmt, iCol);
	switch (type) {
		case SQLITE_INTEGER:
			return [NSNumber numberWithInt:sqlite3_column_int(stmt, iCol)];
			break;
		case SQLITE_FLOAT:
			return [NSNumber numberWithDouble:sqlite3_column_double(stmt, iCol)];
			break;
		case SQLITE_TEXT:
			return [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, iCol)];
			break;
		case SQLITE_BLOB:
			return [NSData dataWithBytes:sqlite3_column_blob(stmt, iCol) length:sqlite3_column_bytes(stmt, iCol)];
			break;
		case SQLITE_NULL:
			return @"";
			break;
		default:
			return @"NONE";
			break;
	}
}

#pragma  mark -- 执行非查询sql语句
//这里也执行非批量插入数据的执行函数
+(BOOL)executeSQL:(NSString*)sql
{
    char *error;
    [self openDb];
    if(sqlite3_exec(dataBase, [sql UTF8String], 0, 0, &error) != SQLITE_OK)
    {
        NSLog(@"%@ error:%s",[sql substringToIndex:6],error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}

#pragma  mark -- 查看表结构
//这个函数最好是不要用
//自定义查看表结构的函数 目前写的是数据库有纪录的情况下 没有记录不能获取他的字段名
+(void)checkTableStructWithTableName:(NSString*)tableName
{
    [self openDb];
    NSString* sql = [NSString stringWithFormat:@"select  * from %@",tableName];
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare(dataBase, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK)
    {
        //azResult是一个二级指针，它的值是有sqlite3_get_table()这个函数生成，我可以定义另外一个二级指针来保存这个值，不用的时候再调用sqlite3_free_table()来释放它。
        char** dbresult;
        int nrow;
        int ncol;
        char* errmsg;
        int result = sqlite3_get_table(dataBase, [sql UTF8String], &dbresult, &nrow, &ncol, &errmsg);
        if (SQLITE_OK == result)
        {
            int index = ncol; //前面说过 dbResult 前面第一行数据是字段名称，从 nColumn 索引开始才是真正的数据
            NSLog(@"查到%d条记录",nrow);
            for(int i = 0; i < 1 ; i++)
            {
                NSLog(@"第%i条记录",i+1);
                for(int j = 0 ; j < ncol; j++)
                {
                    NSLog(@"[字段名:%s]--[字段值:%s]",dbresult[j],dbresult[index]);
                    printf("[字段名:%s]--[字段值:%s]\n",dbresult[j],dbresult[index]);
                    index++;// dbResult 的字段值是连续的，从第0索引到第 nColumn - 1索引都是字段名称，从第 nColumn 索引开始，后面都是字段值，它把一个二维的表（传统的行列表示法）用一个扁平的形式来表示
                }
            }
        }
        sqlite3_free_table(dbresult);
    }
    sqlite3_finalize(stmt);
    [self closeDb];
}

#pragma  mark -- 获取某条sql会获取几条记录
//返回某条查询语句对应会返回几条记录 还没有测试
+(NSInteger)CountOfQueryWithSQL:(NSString*)sql
{
    [self openDb];
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare(dataBase, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK)
    {
        char** dbresult;
        int nrow;
        int ncol = 0;
        char* errmsg;
        sqlite3_get_table(dataBase, [sql UTF8String], &dbresult, &nrow, &ncol, &errmsg);
        sqlite3_free_table(dbresult);
        [self closeDb];
        return ncol;
    }
    else
    {
        NSLog(@"%d",sqlite3_prepare(dataBase, [sql UTF8String], -1, &stmt, NULL));
        NSLog(@"ERROR IN QUERY COUNT OF SQL:%s",sqlite3_errmsg(dataBase));
        [self closeDb];
        return 0;
    }
}

#pragma  mark -- 根据key 获取某条纪录
//查询 语句
//条件查询 single record 返回 dictionary
+(NSDictionary*)getSingleRowBySQL:(NSString*)sql
{
    [self openDb];
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare(dataBase, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK)
    {
        NSInteger count = sqlite3_column_count(stmt);//待验证 字段数
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:count];
        if (sqlite3_step(stmt) == SQLITE_ROW) //数据库存在对应的记录
        {
            for (int i = 0; i < count; i++) {
                NSString* key = [NSString stringWithUTF8String:sqlite3_column_name(stmt, i)];
                NSLog(@" columnname = %@",key);
                id value = getColValue(stmt, i);
                [dict setObject:value forKey:key];
            }
            sqlite3_finalize(stmt);
            [self closeDb];
            return dict;
        }
        else                                //数据库没有相应的记录
        {
            NSLog(@"数据库中没有对应的记录存在请确认");
            sqlite3_finalize(stmt);
            [self closeDb];
            return nil;
        }
    }
    else                                    //操作错误
    {
        NSLog(@"ERROR IN QUERY COUNT OF SQL:%s",sqlite3_errmsg(dataBase));
        sqlite3_finalize(stmt);
        [self closeDb];
        return nil;
    }
}

#pragma  mark -- 根据sql 获取纪录详细 select
//先定义一个多功能查询函数
+(NSArray*)getRecordFromTableBySQL:(NSString*)sql
{
    if (!sql) {
        return nil;
    }
    NSMutableArray *dataArray = [NSMutableArray array];
    [self openDb];
    [self beginTransaction];//add in 8 21
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare(dataBase, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK)
    {
        NSInteger count = sqlite3_column_count(stmt);//待验证 字段数
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:count];
            for (int i = 0; i < count; i++)
            {
                id value = getColValue(stmt, i);
                NSString* key = [NSString stringWithUTF8String:(const char *)sqlite3_column_name(stmt, i)];
                //NSLog(@"[字段名-%@]:[值-%@]",key,value);
                if ([[dict allKeys] containsObject:key]) {
                    key = [key stringByAppendingString:@"+"];
                }
                [dict setObject:value forKey:key];
            }
            [dataArray addObject:dict];
        }
    }
    sqlite3_finalize(stmt);
    [self commitTransaction];
    [self closeDb];
    if (!([dataArray count] > 0)) {
        NSLog(@"sql:%@ 没有取到数据",sql);
        return nil;
    }
    return dataArray;
}


//多个查询 返回nsarray

#pragma  mark -- 创建表的对应的函数
+ (BOOL)setKey:(NSString*)key {
#ifdef SQLITE_HAS_CODEC
    if (!key) {
        return NO;
    }
    
    int rc = sqlite3_key(_db, [key UTF8String], (int)strlen([key UTF8String]));
    
    return (rc == SQLITE_OK);
#else
    return NO;
#endif
}

+ (BOOL)createBaseables
{
    NSString *data_ver_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                              (\
                              id                   INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                              SID                  VARCHAR(48)         UNIQUE NOT NULL,\
                              OWUID                VARCHAR(48),\
                              LCV                  INTEGER,\
                              RDT                  INTEGER,\
                              UPT                  TIMESTAMP\
                              );",@"DATA_VER"];
    
    NSString *data_inits_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                                (\
                                id                   INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                                DID                  VARCHAR(48)         UNIQUE NOT NULL,\
                                OWUID                VARCHAR(48),\
                                VS                   INTEGER,\
                                CT                   INTEGER,\
                                LI                   INTEGER,\
                                UPT                  TIMESTAMP\
                                );",@"DATA_INITS"];
    
    NSString *user_rems_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                               (\
                               UID                  VARCHAR(24)         PRIMARY KEY,\
                               LOGGED               SMALLINT,\
                               WPWD                 VARCHAR(48),\
                               RPWD                 SMALLINT,\
                               UPT                  TIMESTAMP  DEFAULT (datetime('now','localtime')),\
                               CNAME                VARCHAR(64),\
                               TNAME                VARCHAR(128),\
                               DNAME                VARCHAR(128),\
                               MOBILE               VARCHAR(128),\
                               DPID                 VARCHAR(48)\
                               );",@"USER_REMS"];
    
    char *error = NULL;
    [self openDb];
    //data_ver 表
    if (sqlite3_exec(dataBase, [data_ver_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"DATA_VER",error);
        [self closeDb];
        return NO;
    }
    
    //data_init表
    if (sqlite3_exec(dataBase, [data_inits_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"DATA_INITS",error);
        [self closeDb];
        return NO;
    }
    //user_rems表
    if (sqlite3_exec(dataBase, [user_rems_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"USER_REMS",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}

+(NSArray*)getAllRecordFromTable:(NSString*)tableName
{
    NSString *select = [NSString stringWithFormat:@"select * from %@;",tableName];
    NSMutableArray *dataArray = [NSMutableArray array];
    [self openDb];
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare(dataBase, [select UTF8String], -1, &stmt, NULL) == SQLITE_OK)
    {
        NSInteger count = sqlite3_column_count(stmt);//待验证 字段数
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithCapacity:count];
            for (int i = 0; i < count; i++)
            {
                id value = getColValue(stmt, i);
                NSString* key = [NSString stringWithUTF8String:(const char *)sqlite3_column_name(stmt, i)];
                //NSLog(@"[字段名-%@]:[值-%@]",key,value);
                [dict setObject:value forKey:key];
            }
            [dataArray addObject:dict];
        }
    }
    sqlite3_finalize(stmt);
    [self closeDb];
    if (!([dataArray count] > 0)) {
        NSLog(@"%@ 中没有数据",tableName);
        return nil;
    }
    return dataArray;
}

//android  这里在测试版本第五版后有个修改字段的补丁
+(void)patchBaseTables
{
    //    ("ALTER TABLE DATA_VER ADD COLUMN OWUID VARCHAR(48)");
    //    ("ALTER TABLE DATA_INITS ADD COLUMN OWUID VARCHAR(48)");
    //    ("UPDATE DATA_VER SET OWUID = ''");
    //    ("UPDATE DATA_INITS SET OWUID = ''");
}

//同部门用户表
+(BOOL)createSameDepartmentContactTables
{
    NSString* s_employee_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                                (\
                                id                   INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                                OWUID                VARCHAR(48), UID                  VARCHAR(48) UNIQUE,\
                                CNAME                VARCHAR(48), FNAME                VARCHAR(128),\
                                SNAME                VARCHAR(24), TNAME                VARCHAR(128),\
                                SNUM                 VARCHAR(48), FNUM                 VARCHAR(128),\
                                DPID                 VARCHAR(24), DPNAME               VARCHAR(128),\
                                NID                  VARCHAR(2),  PID                  VARCHAR(2),\
                                GENDER               VARCHAR(1),  MARRIED              VARCHAR(2),\
                                PSTID                VARCHAR(12), CPSID                VARCHAR(2),\
                                IDCARD               VARCHAR(24), BORNDAY              DATE,\
                                BORNPLACE            VARCHAR(24), MOBILE               VARCHAR(48),\
                                TELEPHONE            VARCHAR(48), FAXNUMBER            VARCHAR(48),\
                                SHORTPHONE           VARCHAR(12), HOMEPHONE            VARCHAR(48),\
                                HOMEADDRESS          VARCHAR(128),OFFICEADDRESS        VARCHAR(128),\
                                HOMEPOST             VARCHAR(6),  EMAIL                VARCHAR(64),\
                                SORTNO               INTEGER,     EMPNO                VARCHAR(12),\
                                LOGGEG               SMALLINT,    ENABLED              SMALLINT,\
                                STORED               SMALLINT           DEFAULT 0\
                                );",@"S_EMPLOYEE"];
    
    NSString* s_unit_sql    = [NSString stringWithFormat:@"create table  if not exists %@\
                               (\
                               id                   INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                               OWUID                VARCHAR(48),\
                               DPID                 VARCHAR(24),\
                               CNAME                VARCHAR(128),\
                               FNAME                VARCHAR(256),\
                               SNAME                VARCHAR(24),\
                               UPSID                VARCHAR(2),\
                               INTERNAL             SMALLINT,\
                               ENABLED              SMALLINT\
                               );",@"S_UNIT"];
    
    char *error = NULL;
    [self openDb];
    //S_EMPLOYEE 表
    if (sqlite3_exec(dataBase, [s_employee_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"S_EMPLOYEE",error);
        [self closeDb];
        return NO;
    }
    
    //S_UNIT表
    if (sqlite3_exec(dataBase, [s_unit_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"S_UNIT",error);
        [self closeDb];
        return NO;
    }
    
    [self closeDb];
    return YES;
}

//企业通讯录相关表
+(BOOL)createEContactTables
{
    //人员信息
    NSString* t_employee_sql   = [NSString stringWithFormat:@"create table  if not exists %@\
                                  (\
                                  id                   INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                                  UID                  VARCHAR(48) UNIQUE, CNAME                VARCHAR(48),\
                                  FNAME                VARCHAR(128),SNAME                VARCHAR(24),\
                                  TNAME                VARCHAR(128),SNUM                 VARCHAR(48),\
                                  FNUM                 VARCHAR(128),DPID                 VARCHAR(24),\
                                  DPNAME               VARCHAR(128),NID                  VARCHAR(2),\
                                  PID                  VARCHAR(2),  GENDER               VARCHAR(1),\
                                  MARRIED              VARCHAR(2),  PSTID                VARCHAR(12),\
                                  CPSID                VARCHAR(2),  IDCARD               VARCHAR(24),\
                                  BORNDAY              DATE,        BORNPLACE            VARCHAR(24),\
                                  MOBILE               VARCHAR(48), TELEPHONE            VARCHAR(48),\
                                  FAXNUMBER            VARCHAR(48), SHORTPHONE           VARCHAR(12),\
                                  HOMEPHONE            VARCHAR(48), HOMEADDRESS          VARCHAR(128),\
                                  OFFICEADDRESS        VARCHAR(128),HOMEPOST             VARCHAR(6),\
                                  EMAIL                VARCHAR(64), SORTNO               INTEGER,\
                                  EMPNO                VARCHAR(12), LOGGED               SMALLINT,\
                                  STORED               SMALLINT           DEFAULT 0,\
                                  ENABLED              SMALLINT\
                                  );",@"T_EMPLOYEE"];
    
    //部门表
    NSString* t_unit_sql       = [NSString stringWithFormat:@"create table  if not exists %@\
                                  (\
                                  id                   INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                                  DPID                 VARCHAR(24) UNIQUE,\
                                  PDPID                VARCHAR(256),\
                                  CNAME                VARCHAR(128),\
                                  FNAME                VARCHAR(256),\
                                  SNAME                VARCHAR(24),\
                                  UPSID                VARCHAR(2),\
                                  INTERNAL             SMALLINT,\
                                  PNAME                VARCHAR(256),\
                                  ENABLED              SMALLINT\
                                  );",@"T_UNIT"];
    
    //组织结构表
    NSString* t_organizational = [NSString stringWithFormat:@"create table  if not exists %@\
                                  (\
                                  id                   INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                                  CID                  VARCHAR(48) UNIQUE,\
                                  OID                  VARCHAR(24),\
                                  POID                 VARCHAR(24),\
                                  SORTNO               INTEGER,\
                                  LEVEL                INTEGER,\
                                  LTYPE                INTEGER,\
                                  ENABLED              SMALLINT\
                                  );",@"T_ORGANIZATIONAL"];
    
    char *error = NULL;
    [self openDb];
    //data_ver 表
    if (sqlite3_exec(dataBase, [t_employee_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_EMPLOYEE",error);
        [self closeDb];
        return NO;
    }
    
    if (sqlite3_exec(dataBase, [@"CREATE INDEX INDEX_T_EMPLOYEE_DPID ON T_EMPLOYEE(DPID)" UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create indices %@ error:%s",@"T_EMPLOYEE",error);
        [self closeDb];
        return NO;
    }
    
    if (sqlite3_exec(dataBase, [@"CREATE INDEX INDEX_T_EMPLOYEE_SORTNO ON T_EMPLOYEE(SORTNO)" UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create indices %@ error:%s",@"T_EMPLOYEE",error);
        [self closeDb];
        return NO;
    }
    
    if (sqlite3_exec(dataBase, [@"CREATE INDEX INDEX_T_EMPLOYEE_MOBILE ON T_EMPLOYEE(MOBILE)" UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create indices %@ error:%s",@"T_EMPLOYEE",error);
        [self closeDb];
        return NO;
    }
    
    
    //T_UNIT
    if (sqlite3_exec(dataBase, [t_unit_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_UNIT",error);
        [self closeDb];
        return NO;
    }
    if (sqlite3_exec(dataBase, [@"CREATE INDEX INDEX_T_UNIT_DPID ON T_UNIT(DPID)" UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create indices %@ error:%s",@"T_UNIT",error);
        [self closeDb];
        return NO;
    }
    
    
    //T_ORGANIZATIONAL
    if (sqlite3_exec(dataBase, [t_organizational UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_ORGANIZATIONAL",error);
        [self closeDb];
        return NO;
    }
    
    NSString* poid_index = @"CREATE INDEX INDEX_T_ORGANIZATIONAL_POID ON T_ORGANIZATIONAL(POID)";
    if (sqlite3_exec(dataBase, [poid_index UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create indices %@ error:%s",@"T_ORGANIZATIONAL",error);
        [self closeDb];
        return NO;
    }
    
    NSString* oid_index = @"CREATE INDEX INDEX_T_ORGANIZATIONAL_OID ON T_ORGANIZATIONAL(OID)";
    if (sqlite3_exec(dataBase, [oid_index UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create indices %@ error:%s",@"T_ORGANIZATIONAL",error);
        [self closeDb];
        return NO;
    }
    
    [self closeDb];
    return YES;
}

//综合新闻相关表
+(BOOL)CreateNewsTables
{
    NSString* t_news_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                            (\
                            id                   INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                            TID                  VARCHAR(32) UNIQUE NOT NULL,\
                            OWUID                VARCHAR(48),\
                            TITL                 VARCHAR(256) NOT NULL,\
                            AUID                 VARCHAR(48),\
                            AUNAME               VARCHAR(48),\
                            CRTM                 TIMESTAMP,\
                            AUTM                 TIMESTAMP,\
                            TUID                 VARCHAR(48),\
                            DPID                 VARCHAR(48),\
                            TPID                 VATCHAR(24),\
                            ATTS                 VARCHAR(256),\
                            PMS                  VARCHAR(10),\
                            ENABLED              SMALLINT,\
                            STATUS               INTEGER,\
                            READ                 INTEGER DEFAULT 0,\
                            FID                  VARCHAR(10),\
                            READED               SMALLINT           DEFAULT 0\
                            );",@"T_NEWS"];
    
    NSString* t_newstp_sql  = [NSString stringWithFormat:@"create table  if not exists %@\
                               (\
                               id                   INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                               TID                  VARCHAR(24)         NOT NULL,\
                               TNAME                VARCHAR(128),\
                               ENABLED              SMALLINT\
                               );",@"T_NEWSTP"];
    char *error = NULL;
    [self openDb];
    //T_NEWS 表
    if (sqlite3_exec(dataBase, [t_news_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_NEWS",error);
        [self closeDb];
        return NO;
    }
    
    //T_NEWSTP表
    if (sqlite3_exec(dataBase, [t_newstp_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_NEWSTP",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}

//添加字段TPID
//通知公告相关表
+(BOOL)createNotifyTables
{
    NSString* t_notify_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                              (\
                              id                  INTEGER          PRIMARY KEY AUTOINCREMENT ,\
                              TID                 VARCHAR(32)      UNIQUE NOT NULL,\
                              OWUID               VARCHAR(48),\
                              TITL                VARCHAR(256)     NOT NULL,\
                              TPID                VARCHAR(24),\
                              CRTM                TIMESTAMP,\
                              BGTM                TIMESTAMP   DEFAULT (datetime('now','localtime','-10 day')),\
                              EDTM                TIMESTAMP   DEFAULT (datetime('now','localtime','-10 day')),\
                              AUID                VARCHAR(48),\
                              AUNAME              VARCHAR(48),\
                              AUTM                TIMESTAMP,\
                              TUID                VARCHAR(48),\
                              DPID                VARCHAR(48),\
                              ATTS                VARCHAR(256),\
                              PMS                 VARCHAR(10),\
                              ENABLED             SMALLINT,\
                              STATUS              INTEGER,\
                              READ                INTEGER DEFAULT 0,\
                              FID                 VARCHAR(10),\
                              READED              SMALLINT           DEFAULT 0\
                              );",@"T_NOTIFY"];
    char *error = NULL;
    [self openDb];
    //T_NOTIFY 表
    if (sqlite3_exec(dataBase, [t_notify_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_NOTIFY",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
    
}

//待办提醒相关表
//-1 待办 0
//handle
//0表示：不可处理
//1表示：仅阅读
//2表示：可处理
+(BOOL)createRemindTables
{
    NSString* t_remind_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                              (\
                              id                  INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                              AID                 VARCHAR(32)         UNIQUE NOT NULL,\
                              UID                 VARCHAR(48)         NOT NULL,\
                              OWUID               VARCHAR(48),\
                              TITL                VARCHAR(128),\
                              TLVL                INTEGER,\
                              TFRM                VARCHAR(64)        NOT NULL,\
                              CLAZZ               INTEGER,\
                              STATUS              INTEGER,\
                              CRTM                TIMESTAMP,\
                              FNTM                TIMESTAMP,\
                              HANDLE                INTEGER,\
                              ENABLED             SMALLINT,\
                              FLOWINSTANCEID      VARCHAR(256),\
                              URL                 VARCHAR(256)\
                              );",@"T_REMINDS"];
    
    char *error = NULL;
    [self openDb];
    //T_NOTIFY 表
    if (sqlite3_exec(dataBase, [t_remind_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_REMINDS",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}


//read 阅读的次数  readed 阅读状态
//TID TNAME
//--- -----
//30  发文
//90  公司发文
//91  办公室发文
//92  党组织发文
//31  收文
//32  签呈
//33  部门发函
//34  其它

//公司公文
+(BOOL)createCODOCSTables
{       //(PMS,TPID,AUTM,CRTM,FID,ENABLED,ATTS,READ,AUNAME,TITL,OWUID,AUID,TID)
    NSString* t_codocs_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                              (\
                              id                  INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                              TID                 VARCHAR(32)         UNIQUE NOT NULL,\
                              OWUID               VARCHAR(48),\
                              TITL                VARCHAR(256)        NOT NULL,\
                              AUID                VARCHAR(48),\
                              CRTM                TIMESTAMP,\
                              AUTM                TIMESTAMP,\
                              TUID                VARCHAR(48),\
                              DPID                VARCHAR(48),\
                              TPID                VARCHAR(24),\
                              ATTS                VARCHAR(256),\
                              PMS                 VARCHAR(10),\
                              ENABLED             SMALLINT,\
                              STATUS              INTEGER ,\
                              FAVOUR              SMALLINT,\
                              AUNAME              VARCHAR(48) ,\
                              FID                 VARCHAR(10),\
                              READED              SMALLINT           DEFAULT 0,\
                              READ                INTEGER           DEFAULT 0\
                              );",@"T_CODOCS"];
    
    NSString* t_codocstp_sql  = [NSString stringWithFormat:@"create table  if not exists %@\
                                 (\
                                 id                   INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                                 TID                  VARCHAR(24)         NOT NULL,\
                                 TNAME                VARCHAR(128),\
                                 ENABLED              SMALLINT\
                                 );",@"T_CODOCSTP"];
    
    
    char *error = NULL;
    [self openDb];
    //T_NOTIFY 表
    if (sqlite3_exec(dataBase, [t_codocs_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_CODOCS",error);
        [self closeDb];
        return NO;
    }
    
    //T_NEWSTP表
    if (sqlite3_exec(dataBase, [t_codocstp_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_CODOCSTP",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}

//read 阅读的次数  readed 阅读状态
//公司公文
+(BOOL)createWorkNewsTables
{       //(PMS,TPID,AUTM,CRTM,FID,ENABLED,ATTS,READ,AUNAME,TITL,OWUID,AUID,TID)
    NSString* t_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                       (\
                       id                  INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                       TID                 VARCHAR(32)         UNIQUE NOT NULL,\
                       OWUID               VARCHAR(48),\
                       TITL                VARCHAR(256)        NOT NULL,\
                       AUID                VARCHAR(48),\
                       CRTM                TIMESTAMP,\
                       AUTM                TIMESTAMP,\
                       TUID                VARCHAR(48),\
                       DPID                VARCHAR(48),\
                       TPID                VARCHAR(24),\
                       ATTS                VARCHAR(256),\
                       PMS                 VARCHAR(10),\
                       ENABLED             SMALLINT,\
                       STATUS              INTEGER ,\
                       FAVOUR              SMALLINT,\
                       AUNAME              VARCHAR(48) ,\
                       FID                 VARCHAR(10),\
                       READED              SMALLINT           DEFAULT 0,\
                       READ                INTEGER           DEFAULT 0\
                       );",@"T_WORKNEWS"];
    
    
    NSString* t_tp_sql  = [NSString stringWithFormat:@"create table  if not exists %@\
                           (\
                           id                   INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                           TID                  VARCHAR(24)         NOT NULL,\
                           TNAME                VARCHAR(128),\
                           ENABLED              SMALLINT\
                           );",@"T_WORKNEWSTP"];
    
    
    char *error = NULL;
    [self openDb];
    //T_NOTIFY 表
    if (sqlite3_exec(dataBase, [t_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_WORKNEWS",error);
        [self closeDb];
        return NO;
    }
    
    //T_NEWSTP表
    if (sqlite3_exec(dataBase, [t_tp_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_WORKNEWSTP",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}

// 1 成功
// 0 失败

//用来存储已经发送或者还没有发送成功的邮件
+(BOOL)createOutbox
{
    NSString* t_localmesage_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                                   (\
                                   ID             INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                                   OWUID          TEXT,\
                                   STATE          INTEGER  DEFAULT 0,\
                                   BCC_LIST       TEXT,\
                                   CC_LIST        TEXT,\
                                   SENTDATE       TIMESTAMP DEFAULT (datetime('now','localtime')),\
                                   SUBJECT        TEXT,\
                                   CONTENT        TEXT,\
                                   TO_TEXT        TEXT,\
                                   TO_LIST        TEXT,\
                                   MESSAGEID      TEXT,\
                                   ORIGINALINFO   TEXT,\
                                   PERSONALINFO   TEXT,\
                                   ATTACHMENTS    TEXT,\
                                   ISWRITTENBYSELF TEXT\
                                   );",@"T_OUTBOX"];
    
    char *error = NULL;
    [self openDb];
    
    //邮件 表
    if (sqlite3_exec(dataBase, [t_localmesage_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_OUTBOX",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}

+(BOOL)createDraft
{
    NSString* t_draft_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                             (\
                             ID             INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                             OWUID          TEXT,\
                             BCC_LIST       TEXT,\
                             CC_LIST        TEXT,\
                             SENTDATE       TIMESTAMP DEFAULT (datetime('now','localtime')),\
                             SUBJECT        TEXT,\
                             CONTENT        TEXT,\
                             TO_TEXT        TEXT,\
                             TO_LIST        TEXT,\
                             MESSAGEID      TEXT,\
                             ORIGINALINFO   TEXT,\
                             PERSONALINFO   TEXT,\
                             ATTACHMENTS    TEXT,\
                             ISWRITTENBYSELF TEXT\
                             );",@"T_DRAFT"];
    
    char *error = NULL;
    [self openDb];
    
    //邮件 表
    if (sqlite3_exec(dataBase, [t_draft_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_DRAFT",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}

//0 收件箱
//1 垃圾箱
// ISLOADED是否完全下载
// ENABLED 邮件的状态 0  删除 1 未删除
// STATUS  状态:1 表示已删除但是没有彻底删除 0:表示还没有删除
+(BOOL)createLocalMessageTables
{
    NSString* t_localmesage_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                                   (\
                                   ID             INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                                   OWUID          TEXT,\
                                   ATTACHMENTS    TEXT,\
                                   BCC_LIST       TEXT,\
                                   CC_LIST        TEXT,\
                                   SENDER         TEXT,\
                                   MESSAGEID      TEXT  UNIQUE,\
                                   MIMETYPE       TEXT,\
                                   SUBJECT        TEXT,\
                                   TO_LIST        TEXT,\
                                   SENTDATE       TIMESTAMP,\
                                   SIZE           INTEGER,\
                                   STATUS         INTEGER DEFAULT 0,\
                                   ISREAD         INTEGER DEFAULT 0,\
                                   ISLOADED       INTEGER DEFAULT 0,\
                                   ENABLED        INTEGER DEFAULT 0\
                                   );",@"T_LOCALMESSAGE"];
    
    char *error = NULL;
    [self openDb];
    
    //邮件 表
    if (sqlite3_exec(dataBase, [t_localmesage_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_LOCALMESSAGE",error);
        [self closeDb];
        return NO;
    }
    
    if (sqlite3_exec(dataBase, [@"CREATE INDEX INDEX_T_LOCALMESSAGE_MESSAGEID ON T_LOCALMESSAGE(MESSAGEID)" UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create indices %@ error:%s",@"T_LOCALMESSAGE",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}

+(BOOL)createMessageDateMapTables
{
    NSString* t_messageDateMap_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                                      (\
                                      ID             INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                                      MESSAGEID      TEXT,\
                                      SENTDATE       TEXT\
                                      );",@"T_MessageDateMap"];
    
    char *error = NULL;
    [self openDb];
    //邮件 表
    if (sqlite3_exec(dataBase, [t_messageDateMap_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_MessageDateMap",error);
        [self closeDb];
        return NO;
    }
    
    if (sqlite3_exec(dataBase, [@"CREATE INDEX INDEX_T_MessageDateMap_MESSAGEID ON T_MessageDateMap(MESSAGEID)" UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create indices %@ error:%s",@"T_LOCALMESSAGE",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}

+(BOOL)createVersionInfoTables
{
    NSString* t_version_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                               (\
                               ID                  INTEGER             PRIMARY KEY AUTOINCREMENT ,\
                               OWUID               VARCHAR(48),\
                               NAME                VARCHAR(48),\
                               VERSION             VARCHAR(48)\
                               );",@"T_VERSIONINFO"];
    
    char *error = NULL;
    [self openDb];
    //T_NOTIFY 表
    if (sqlite3_exec(dataBase, [t_version_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_VERSIONINFO",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}

+(BOOL)createClientApp
{
    NSString* t_ClientApp_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                               (\
                               CODE             VARCHAR(24) NOT NULL,\
                               NAME             VARCHAR(48),\
                               DEPARTMENT       VARCHAR(24),\
                               DEFAULTED 		SMALLINT,\
                               APPTYPE          VARCHAR(8),\
                               HASPMS           SMALLINT,\
                               ENABLED 			SMALLINT,\
                               constraint P_CLIENTAPP_KEY primary key (CODE)\
                               );",@"T_CLIENTAPP"];
    
    char *error = NULL;
    [self openDb];
    //T_NOTIFY 表
    if (sqlite3_exec(dataBase, [t_ClientApp_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_CLIENTAPP",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}

/*
{"v":{"CODE":"copublicnotice","NAME":"公司公告","OWNERAPP":"company","TYPELABLE":"","LOGO":"http://tam.hngytobacco.com/ZZZobta/public/icon/copublicnotice.png","FIDLIST":"1010101","HASSUBTYPE":"0","CURRENTID":"10002","PARENDID":"100","LEVL":"1","ENABLED":"1"}}
*/


/**
 *  FIDLIST     :
 *  CURRENTID   :当前的TID
 *  PARENDID    :父级的TID
 *  LEVL        :级别  一般client会是0级 频道是第一级 子频道是第二级
 */

+(BOOL)createChannel
{
    NSString* t_channel_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                                 (\
                                 CODE 				varchar(24) NOT NULL,\
                                 NAME 				varchar(48),\
                                 OWNERAPP 			varchar(24),\
                                 LOGO				varchar(128),\
                                 FIDLIST 			varchar(1024),\
                                 TYPELABLE          varchar(48),\
                                 HASSUBTYPE 		SMALLINT,\
                                 CURRENTID 		    varchar(24),\
                                 PARENTID 		    varchar(24),\
                                 LEVL 		        SMALLINT,\
                                 ENABLED 			SMALLINT,\
                                 constraint P_CLIENTAPP_KEY primary key (CODE)\
                                 );",@"T_CHANNEL"];
    
    
    char *error = NULL;
    [self openDb];
    //T_NOTIFY 表
    if (sqlite3_exec(dataBase, [t_channel_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_CHANNEL",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}

/**
 *  CODE        client的code
 *  VERSION     clint的版本号
 *  注: 当一个client中的频道同步完成后 会把这个client的版本号存下来  暂时还没有用到这个版本号
 */
+(BOOL)createCilentVersion
{
    NSString* t_client_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                               (\
                               CODE 				varchar(24) NOT NULL,\
                               VERSION 				varchar(48),\
                               constraint P_CLIENTVERSION_KEY primary key (CODE)\
                               );",@"T_CLIENTVERSION"];
    char *error = NULL;
    [self openDb];
    if (sqlite3_exec(dataBase, [t_client_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_CLIENTVERSION",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}

/*
 {"v":{"AID":"ECM_134118_2","PAPERID":"134118","CHANNELID":"1010201","TFRM":"ZYECM","URL":"http://tam.hngytobacco.com/ecmapp/tecmeai/content/paper/134118","CRTM":"2013-11-20T16:50:06.000","AUTM":"2013-11-20T16:50:40.162","ATTRLABLE":"attachment,bodyimage","ADDITION":"","PMS":"u:testmobile;u:czadmin;u:goodman;","TITL":"【调试】测试发送图片附件004","ENABLED":"0"}}
 */

/*
AID	主键ID
PAPERID	文章ID
CHANNELID	ECM栏目ID 值对应频道表的FIDLIST)
TITL	标题
TFRM	来源系统
URL	获取详情URL
CRTM	发布时间
AUTM	入库时间
BGTM	开始时间
EDTM	结束时间
ATTRLABLE	属性标识（bodyfile,attachment,bodyimage)
ADDITION	附加
PMS	权限
ENABLED	是否可用，1表示可用，0表示不可用（删除掉了）
*/
+(BOOL)createDocuments
{
    NSString* t_doc_sql = [NSString stringWithFormat:@"create table  if not exists %@\
                              (\
                              AID 				varchar(256) NOT NULL,\
                              PAPERID 			varchar(32),\
                              CHANNELID 		varchar(32),\
                              TITL 			    varchar(256),\
                              TFRM 			    varchar(64),\
                              URL 			    varchar(128),\
                              CRTM 			    TIMESTAMP,\
                              AUTM 			    TIMESTAMP,\
                              BGTM 			    TIMESTAMP,\
                              EDTM 			    TIMESTAMP,\
                              UPTM              TIMESTAMP,\
                              ATTRLABLE 		varchar(128),\
                              ADDITION 		    varchar(1024),\
                              PMS 		        varchar(256),\
                              READED            SMALLINT           DEFAULT 0,\
                              ENABLED 			SMALLINT,\
                              constraint P_CLIENTVERSION_KEY primary key (AID)\
                              );",@"T_DOCUMENTS"];
    char *error = NULL;
    [self openDb];
    if (sqlite3_exec(dataBase, [t_doc_sql UTF8String], 0, 0, &error) != SQLITE_OK) {
        NSLog(@"create table %@ error:%s",@"T_DOCUMENTS",error);
        [self closeDb];
        return NO;
    }
    [self closeDb];
    return YES;
}

+(void)DBVersion2DocumentPatch
{
    NSFileManager* filemanager = [NSFileManager defaultManager];
    //1 删除新闻文件夹
    [filemanager removeItemAtPath:[SKAttachManger newsPath] error:0];
    //2 删除通知文件夹
    [filemanager removeItemAtPath:[SKAttachManger notifyPath] error:0];
    //3 删除公告文件夹
    [filemanager removeItemAtPath:[SKAttachManger announcePath] error:0];
    //4 删除会议文件夹
    [filemanager removeItemAtPath:[SKAttachManger meetPath] error:0];
    //5 删除工作动态文件夹
    [filemanager removeItemAtPath:[SKAttachManger workNewsPath] error:0];
    //6 删除公司公文文件夹
    [filemanager removeItemAtPath:[SKAttachManger codocsPath] error:0];
    //7 删除配置文件main_config.xml
    [filemanager removeItemAtPath:[[FileUtils documentPath] stringByAppendingPathComponent:@"main_config.xml"] error:0];
    
    //删除表  DROP TABLE table-name
    // 1 新闻表 新闻类型表
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"DROP TABLE T_NEWS"];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"DROP TABLE T_NEWSTP"];
    // 2 通知表
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"DROP TABLE T_NOTIFY"];
    // 3 工作动态表 工作动态类型表
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"DROP TABLE T_WORKNEWS"];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"DROP TABLE T_WORKNEWSTP"];
    // 4 公司公告表 公司公告类型表
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"DROP TABLE T_CODOCS"];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"DROP TABLE T_CODOCSTP"];
    // 5 公司本部门表
    //[[DBQueue sharedbQueue] updateDataTotableWithSQL:@"DROP TABLE S_UNIT"];
    // 6 APP 信息表
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"DROP TABLE T_APPINFO"];
    // 7 删除公共文档表
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"DROP TABLE T_PUBDOCS"];
    //删除表
    
    //这里还需要修改
    //对数据库中的密码进行加密
    NSDictionary* item =[[DBQueue sharedbQueue] getSingleRowBySQL:@"select * from USER_REMS;"];
    if (item) {
        NSString* sql = [NSString stringWithFormat:@"update USER_REMS set WPWD = '%@' where uid = '%@'",[item[@"WPWD"] encrypted],item[@"UID"]];
        [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
    }
}

+(void)getClientChannelInfo
{
    [[APPUtils AppLogonManager] loginWithUser:[SKAppDelegate sharedCurrentUser]
                                CompleteBlock:^{
                                    [SKClientApp getClientAppWithCompleteBlock:^{
                                        
                                    } faliureBlock:0];
                                    //获取频道信息
                                    //NSLog(@"正在获取频道信息");
                                }failureBlock:^(NSDictionary* dict){
                                    NSLog(@"%@",dict);
                                }];
}

+(void)setDBVersion
{
    if (![FileUtils valueFromPlistWithKey:@"DBVERSION"] || [[FileUtils valueFromPlistWithKey:@"DBVERSION"] length] == 0)
    {
        [self openDb];
        char *error = NULL;
        NSString* oid_index = @"CREATE INDEX INDEX_T_ORGANIZATIONAL_OID ON T_ORGANIZATIONAL(OID)";
        if (sqlite3_exec(dataBase, [oid_index UTF8String], 0, 0, &error) != SQLITE_OK) {
            NSLog(@"create indices %@ error:%s",@"T_ORGANIZATIONAL",error);
            [self closeDb];
        }
        [FileUtils setvalueToPlistWithKey:@"DBVERSION" Value:@"1"];
        [self closeDb];
        return;
    }
    
    if ([[FileUtils valueFromPlistWithKey:@"DBVERSION"] intValue] == 1) {
        [self createClientApp];
        [self createChannel];
        [self createCilentVersion];
        [self createDocuments];
        [self DBVersion2DocumentPatch];
        [self getClientChannelInfo];
        [FileUtils setvalueToPlistWithKey:@"DBVERSION" Value:@"2"];
        return;
    }
}

+(BOOL)createAllTable
{
    [self createBaseables];
    [self createSameDepartmentContactTables];
    [self createEContactTables];
    [self createRemindTables];
    [self createVersionInfoTables];
    [self createLocalMessageTables];
    [self createMessageDateMapTables];
    [self createOutbox];
    [self createDraft];
    [self createClientApp];
    [self createChannel];
    [self createCilentVersion];
    [self createDocuments];
    [FileUtils setvalueToPlistWithKey:@"DBVERSION" Value:@"2"];
    return YES;
}

@end
