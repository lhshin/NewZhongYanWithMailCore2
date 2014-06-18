//
//  LocalDataMeta.h
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalDataMeta : NSObject
@property(nonatomic,strong) NSString*   dataCode;         //数据代码，用于远程数据请求
@property(nonatomic,strong) NSString*   messageCode;      //消息代码
@property(nonatomic,strong) NSString*   localName;        //本地数据库表的名称
@property(nonatomic,strong) NSString*   identityName;     //标识符属性名
@property(nonatomic,strong) NSString*   updateTime;       //数据更新的间隔 表示每隔多久更新一次 //单位 毫秒  如果 等于0 表示永不更新
@property(nonatomic,strong) NSString*   lastupdatetime;
@property(nonatomic,strong) NSString*   pECMName;         //例如 app 的上一级为空  channel 的上一级为app
@property(nonatomic)        NSInteger   version;          //本地版本号 如果版本号为0，表示无本地数据

@property long  reInitDelay;       //再次刷新数据的间隔 表示经过多少天没有增量更新后 则更新初始化数据 如果小于0 则表示表示多长时间都不重新初始化
@property int   pageSize;           //分页大小
@property BOOL  userOwner;          //是否为用户所有
@property BOOL  isExistedSnap;
@property int   lastfrom;           //分页大小
@property int   lastcount;          //分页大小
@property int   lastversion;        //分页大小
@property BOOL  isECM;          //是否为用户所有

+ (LocalDataMeta *)sharedEmployee;
+ (LocalDataMeta *)sharedSelfEmployee;
+ (LocalDataMeta *)sharedUnit;
+ (LocalDataMeta *)sharedOranizational;
+ (LocalDataMeta *)sharedNews;
+ (LocalDataMeta *)sharedNewsType;
+ (LocalDataMeta *)sharedNotify;
+ (LocalDataMeta *)sharedMeeting;
+ (LocalDataMeta *)sharedAnnouncement;
+ (LocalDataMeta *)sharedRemind;
+ (LocalDataMeta *)sharedCompanyDocuments;
+ (LocalDataMeta *)sharedCompanyDocumentsType;
+ (LocalDataMeta *)sharedWorkNews;
+ (LocalDataMeta *)sharedWorkNewsType;
+ (LocalDataMeta *)sharedCMS;
+ (LocalDataMeta *)sharedVersionInfo;
+ (LocalDataMeta *)sharedMail;
+ (LocalDataMeta *)sharedClientApp;
+ (LocalDataMeta *)sharedChannel;
+ (LocalDataMeta *)sharedChannelType;
/**
 * 一般用于快照本地数据的状态 如 存储掉一批数据 后马上快照
 * @param version   上次下载服务器版本号
 * @param lastCount 上次下载服务器数据的总条数
 * @param lastFrom  上次下载终止的位置
 * @return 返回数据元updateRangeURL对应的URL值
 **/
-(void)snapInitDataWithVersion:(int)version
                     lastCount:(int)lastcount
                      lastFrom:(int)lastfrom
                          Date:(NSString*)updatetime;

/**
 * 数据同步完成
 **/
-(void) afterFinishedInitData;

/**
 * 判断是不是用户私有数据
 **/
-(BOOL)isUserOwner;

/**
 * 一般用于刷新本地数据的时候
 * @功能 判断是不是存在关于该数据源没有下载完成的数据
 **/
-(BOOL)isInitDataSnapped;

/**
 * 一般用于刷新本地数据的时候
 * @功能 判断该数据元对应的数据是不是通不过 （包括没有完全同步完成的情况）
 **/
-(BOOL)isDataLocalRooted;
@end
