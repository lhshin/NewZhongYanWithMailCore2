//
//  SKECMURLManager.h
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKECMURLManager : NSObject
#pragma mark -
#pragma mark ===========  应用接口  =========
#pragma mark -
/**
 *  用户获取应用列表接口
 *      iv-user不能为空，否则返回错误码：
 *      #3010,用户尚未登录成功
 *  @return 数据集合消息实体如果无数据则返回异常消息实体
 */
+(NSURL*)getAllClientApp;

/**
 *  返回指定版本至最新版本的数据集合元信息  从request头部获取iv-user用户名
 *
 *  @param version 指定版本号
 *
 *  @return 数据集合消息实体 如果无数据则返回异常消息实体
 */
+(NSURL*)getClientAppVMetaInfoWithVersion:(int)version;

/**
 *  用户更新应用列表接口
 *
 *  @param version 指定版本号
 *
 *  @return 数据集合消息实体如果无数据则返回异常消息实体
 */
+(NSURL*)getUpdateClientAppWithVersion:(int)version;

#pragma mark -
#pragma mark ===========  频道数据集合接口  =========
#pragma mark -

+(NSURL*)getUpdateClientAppWithClientCode:(NSString*)code QueryDate:(NSString*)date;

#pragma mark -
#pragma mark ===========  频道接口  =========
#pragma mark -
+(NSURL*)getAllChannelWithAppCode:(NSString*)code;

+(NSURL*)getChannelVmetaInfoWithAppCode:(NSString*)code ChannelVersion:(int)version;

+(NSURL*)getChannelUpdateInfoWithAppCode:(NSString*)code ChannelVersion:(int)version;

#pragma mark -
#pragma mark ===========  文档类型接口  =========
#pragma mark -
/**
 *  获取文档列表
 *  当查询时间为0时，默认返回最新的50条数据，当queryType为空时默认向上查询
 *  =============================================================
 *  @param code 频道编码
 *  @param date 指定查询时间
 *  @param isUP 查询方式:UP:向上（加载最新）；DOWN:向下
 *  =============================================================
 *  @return 查询url
 */
+(NSURL*)getDocunmentWithChannelCode:(NSString*)code QueryDate:(NSString*)date isUP:(BOOL)isUP;

#pragma mark -
#pragma mark ===========  ECM查询接口  =========
#pragma mark -

/**
 *  ECM查询标题
 *
 *  @param pagenum   起始页
 *  @param content   内容
 *  @param channelid 频道ID
 *
 *  @return 返回查询结果
 */
+(NSURL*)queryTitleWith:(int)pagenum ECMContent:(NSString*)content ChannelID:(NSString*)channelid;

/**
 *  ECM查询全文
 *
 *  @param pagenum   起始页
 *  @param content   内容
 *  @param channelid 频道ID
 *
 *  @return 返回查询结果
 */
+(NSURL*)queryContentWith:(int)pagenum ECMContent:(NSString*)content ChannelID:(NSString*)channelid;
@end
