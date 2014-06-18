//
//  FileUtils.h
//  NewZhongYan
//
//  Created by lilin on 13-10-8.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "element.h"
#import "column.h"
typedef enum
{
    SKFile,
    SKtext,
    SKMixed,
 	SKImage
} SKColumnTyped;    //列的类型 决定 列如何显示

typedef enum
{
    SKAnyType,
    SKStringType,
    SKDateType,
 	SKIntType,
    SKBinaryType,
    SKNumberType,
    SKPhoneType,
    SKMAilType,
    SKUrlType
} SKColumnRWTyped;  //数据的操作权限

typedef enum
{
    SKNone,
    SKPhrase,       //常用语输入插件
    SKPhonecall,    //拨打电话插件
    SKEmailto,      //发送邮件插件
    SKSignature,    //签名插件
    SKDateinput,     //输入日期型插件
    SKColumnDetail     //明细插件
} SKExtendTyped;    //插件类型

typedef enum {
    rwTypeR=0,
    rwTypeW0=1,
    rwTypeW1=2,
    rwTypeWA0=3,
    rwTypeWA1=4,
    rwTypeWS0=5,
    rwTypeWS1=6,
    rwTypeWD0=7,
    rwTypeWD1=8,
    rwTypeWI0=9,
    rwTypeWI1=10,
    rwTypeWB0=11,
    rwTypeWB1=12,
    rwTypeWN0=13,
    rwTypeWN1=14,
    rwTypeWT0=15,
    rwTypeWT1=16,
    rwTypeWE0=17,
    rwTypeWE1=18,
    rwTypeWU0=19,
    rwTypeWU1=20,
} rwType;//rw类型

@interface FileUtils : NSObject
/**
 *  该函数用于把字节转换成常用的字符串 例如 11111111b  转换成 "？ kb" "？ Mb" "？ Gb"
 *
 *  @param size 输入的字节大小
 *
 *  @return 返回格式化的字符串
 */
+ (NSString *)formattedFileSize:(unsigned long long)size;

/**
 *  该函数 根据文件路径 获取该文件总大小
 *
 *  @param folderPath 文件路径
 *
 *  @return 大小
 */
+ (long long) folderSizeAtPath:(NSString*) folderPath;

/**
 *  返回document文件的路径
 *
 *  @return
 */
+ (NSString*)documentPath;

/**
 *  获取配置信息
 *
 *  @param keyString key
 *
 *  @return value
 */
+(id)valueFromPlistWithKey:(NSString*)keyString;

/**
 *  添加或修改配置信息
 *
 *  @param keyString   key
 *  @param valueString value
 */
+(void)setvalueToPlistWithKey:(NSString*)keyString Value:(id)valueString;

/**
 *  获取待办中的常用语
 *
 *  @return 常用语数组
 */
+(NSMutableArray*)Phrase;

/**
 *  设置新的常用语数组
 *
 *  @param phrase 即将被设置的常用语
 */
+(void)setPhrase:(NSMutableArray*)phrase;

#pragma  mark -- 待办工具函数的基本函数
/**
 *  获取待办column的类型 常见的有 application mixed  text image 
 *
 *  @param c column的值
 *
 *  @return SKColumnTyped
 */
+(SKColumnTyped)columnType:(column*)c;

/**
 *  判断某个element是不是可见的
 *  根据 visible 的值来判断
 *  @param e element
 *
 *  @return
 */
+(BOOL)isElementVisible:(element*)e;

/**
 *  根据rwstring 来判断是不是可写
 *
 *  @param rwString   例如"rw1"
 *
 *  @return
 */
+(BOOL)isWriteType:(NSString*)rwString;

/**
 *  //针对代办的column 和element
 *  //现在没有怎么用到
 *  @param dict
 *
 *  @return
 */
+(BOOL)isWrited:(NSDictionary*)dict;

/**
 *  现在 没有怎么用到
 *
 *  @param rwString <#rwString description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)isCanBeNull:(NSString*)rwString;

/**
 *  返回读写类型
 *
 *  @param rwString @"rw1"
 *
 *  @return <#return value description#>
 */
+(SKColumnRWTyped)ClassType:(NSString*)rwString;

/**
 *  获取cloumn 的插件类型
 *  phrase 常用语 signature 签名  现在暂时就用到了这2个
 *  @param c column
 *
 *  @return 
 */
+(SKExtendTyped)extendType:(column*)c;

/**
 *  获取element 的插件类型
 *  phrase 常用语 signature 签名  现在暂时就用到了这2个
 *  @param c element
 *
 *  @return
 */
+(SKExtendTyped)extendTypeWithElement:(element*)e;

/**
 *  获取元素的读写类型  这个函数 column 以及element 都适用
 *
 *  @param dic
 *
 *  @return 
 */
+(rwType)getRWType:(NSDictionary *)dic;
@end
