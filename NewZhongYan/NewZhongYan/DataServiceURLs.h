//
//  DataServiceURLs.h
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

/**
 *  功能: 封装对不同数据源类URL的解析与管理
 */
#import <Foundation/Foundation.h>
@class LocalDataMeta;
@interface DataServiceURLs : NSObject
@property(nonatomic,strong) NSString* metaURL;
@property(nonatomic,strong) NSString* updateMetaURL;
@property(nonatomic,strong) NSString* updateRangeURL;
@property(nonatomic,strong) NSString* versionURL;
@property(nonatomic,strong) NSString* searchURL;
@property(nonatomic,strong) NSString* dataByIdURL;
@property(nonatomic,strong) NSString* isExistedURL;
@property(nonatomic,strong) NSString* rangeURL;
@property(nonatomic,strong) NSString* postURL;
@property(nonatomic,strong) NSString* attmsURL;
@property(nonatomic,strong) NSString* ECMAllURL;
@property(nonatomic,strong) NSString* ECMVmetaURL;
@property(nonatomic,strong) NSString* ECMVupdateURL;

/**
 * 一般用于mknetworkkit
 * @param metaData 数据元
 * @return 返回该数据元对应的DataServiceURLs基础类
 **/
+(DataServiceURLs*)DataServicePath:(LocalDataMeta*)metaData;

/**
 * 一般用于asihttprequest
 * @param metaData 数据元
 * @return 返回该数据元对应的DataServiceURLs基础类
 **/
+(DataServiceURLs*)DataServiceURLs:(LocalDataMeta*)metaData;

-(NSString*)ECMVmetaInfoWithVersion:(int)version;

-(NSString*)ECMMetaInfoWithVersion:(int)version;

-(NSString*)ECMVupdateDataWithVersion:(int)version;

/**
 * @param idValue id值
 * @return 返回数据元dataByIdURL对应的URL值
 **/
-(NSString*)dataByIdURL:(NSString*)idValue;

/**
 * @param searchKey 所搜关键字
 * @return 返回数据元searchURL对应的URL值
 **/
-(NSString*)searchURL:(NSString*)searchKey;

/**
 * @param version 版本号
 * @param from 起点
 * @param length 长度
 * @return 返回数据元updateRangeURL对应的URL值
 **/
-(NSString*)updateRangeURL:(int)version from:(int)from length:(int)length;

/**
 * @param version 版本号
 * @return 返回数据元updateMetaURL对应的URL值
 **/
-(NSString*)updateMetaURL:(int)version;

/**
 * @param from 起点
 * @param length 长度
 * @return 返回数据元rangeURL对应的URL值
 **/
-(NSString*)rangeURL:(int)from length:(int)length;

/**
 * @param idValue id值 起点
 * @param length 长度
 * @return 返回数据元idExistedURL对应的URL值
 **/
-(NSString*)isExistedURL:(NSString*)idValue;

/**
 * @param idValue id值
 * @param attachIdValue 属性ID
 * @return 返回数据元attmsURL对应的URL值
 * 比如获取附件 idValue = CONTENT attachIdValue = 27123
 **/
-(NSURL*)attmsURL:(NSString*)idValue attach:(NSString*)attachIdValue;


#pragma  mark -- 附件
/**
 * @param msgid id值
 * @param attsname 属性ID
 * @return 返回获取邮件附件对应的URL
 **/
+(NSURL*)mailAttcnURL:(NSString*)msgid AttchName:(NSString*)attsname;

#pragma  mark -- 待办
/**
 * 保存业务数据（POST）
 * @param userid 当前处理业务的用户ID
 * @param from 应用系统(标识哪个应用系统来的公文)(TFRM)
 * @param workitemid 在ESB待办消息中获取的唯一待办消息ID (AID)
 * @param savexml 需要保存的数据
 * @return  1 表示成功 0 表示失败
 **/
+(NSURL*)saveData;

/**
 * 提交业务数据（POST）
 * @param userid 当前处理业务的用户ID
 * @param from 应用系统
 * @param workitemid 在ESB待办消息中获取的唯一待办消息ID
 * @param branchid 可供选择的分支途径
 * @paramplist 包含参与者类型和编码的String，为"参与者类型:参与者编码"用“,”隔开，如"1:userid,2:userid2"
 * @return 1 表示成功 0 表示失败
 **/
+(NSURL*)commitWorkItem;

+(NSURL*)userClientAppAll;

/**
 * 获取历史办理记录（GET）
 * @param uid 当前处理业务的用户ID
 * @param tfrm TFRM
 * @param fid FLOWINSTANCEID
 * @return url
 **/
+(NSURL*)getHistoryRecords:(NSString*)uid TFRM:(NSString*)tfrm FLOWINSTANCEID:(NSString*)fid;

/**
 * 获取待办详情（GET）
 * @param uid 当前处理业务的用户ID
 * @param tfrm TFRM
 * @param aid AID
 * @return url
 **/
+(NSURL*)getWorkItemDetails:(NSString*)uid TFRM:(NSString*)tfrm AID:(NSString*)aid;

/**
 * 获取已办详情（GET）
 **/
+(NSURL*)getWorkedItemDetails:(NSString*)uid TFRM:(NSString*)tfrm flowinstanceid:(NSString*)fid;

/**
 * 获取办理历史记录（GET）
 **/
+(NSURL*)getColumnDetails:(NSString*)uid andFlowinstanceid:(NSString*)fid andUniqueid:(NSString *)uniqueid andFrom:(NSString *)from;

/**
 * 获取流程分支（GET）
 **/
+(NSURL*)getNextBranches:(NSString*)uid TFRM:(NSString*)tfrm AID:(NSString*)aid BID:(NSString*)bid;

/**
 * 获取待办参与人（GET）
 **/
+(NSURL*)getParticipants:(NSString*)uid TFRM:(NSString*)tfrm Workitemid:(NSString*)wid BranchId:(NSString*)bid;

/**
 * 获取待办附件（GET）
 **/
+(NSURL*)getFile:(NSString*)uid TFRM:(NSString*)tfrm FLOWINSTANCEID:(NSString*)fid Filed:(NSString*)field;

/**
 * 获取待办签名（GET）
 * @param signstyle 需要获取的签名类型 1 文字签名 2 图片签名 3 数字签名 这里默认传 2
 **/
+(NSURL*)getSignature:(NSString*)uid TFRM:(NSString*)tfrm Style:(NSString*)signstyle;

#pragma  mark -- 更新
/**
 * 获取最新版本号（GET）
 * @param version 本地版本号
 **/
+(NSURL *)getNewVersion:(NSString *)version;

#pragma  mark -- 注册
/**
 * 向服务器注册本机器（GET）
 * @param username 当前用户账号
 * @param password 当前用户密码
 * @param phone-brand 手机分支 主要是 apple 和 安卓 的区别
 * @param phone-model 产品型号 如 iphone5 itouch 5
 * @param phone-os 产品类型 是iphone 还是ipad
 * @param IMEI 手机IMEI
 * @return url
 **/
+(NSURL *)rigisterDevice;
@end
