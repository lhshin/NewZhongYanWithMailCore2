//
//  SKDataDaemonHelper.h
//  HNZYiPad
//
//  Created by lilin on 13-6-13.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SKDataDaemonHelperDelegate;
@class LocalDataMeta;
@class DataServiceURLs;
@class ASIHTTPRequest;

//协议
@protocol SKDataDaemonHelperDelegate<NSObject>
/**
 * 用于取消同步
 **/
-(void)didCancelSynData:(LocalDataMeta*)metaData;
/**
 * 同步数据出现错误
 * @param metaData   数据处理的类型
 **/
-(void)didErrorSynData:(LocalDataMeta*)metaData Reason:(NSString*)errorinfo;

/**
 * 同步数据完成
 * @param metaData   数据处理的类型
 * @param errorinfo  错误原因
 **/
-(void)didCompleteSynData:(LocalDataMeta*)metaData;


/**
 * 同步数据完成
 * @param sv   服务器版本号
 * @param sc   服务器版本号对应数据总数
 * @param lv   本地数据版本
 * @param metaData   数据处理的类型
 **/
-(void)didCompleteSynData:(NSString*)datacode SV:(int)sv SC:(int)sc LV:(int)lv;
/**
 * 数据同步开始完成
 * @param metaData   数据处理的类型
 **/
-(void)didBeginSynData:(LocalDataMeta*)metaData;

/**
 * 分页同步结束
 * @param metaData   数据处理的类型
 **/
-(void)didEndSynData:(LocalDataMeta*)metaData;
@end

@interface SKDataDaemonHelper : NSOperation
{
    LocalDataMeta* _metaData;
    DataServiceURLs* _pathHelper;
    DataServiceURLs* _urlHelper;
    
    int synedCount;
}
@property(nonatomic,strong) id<SKDataDaemonHelperDelegate> delegate;
@property(nonatomic,strong) LocalDataMeta* metaData;
/**
 * 用于构建一个后台数据处理对象
 * @param metaData   数据处理的类型
 * @param delegate   数据处理的代理
 * @return 返回一个数据处理的对象
 **/
-(id)initWithLocalMetaData:(LocalDataMeta*)metaData delegate:(id <SKDataDaemonHelperDelegate>)delegate;

/**
 * 直接后台数据处理的对象，不直接生成处理对象
 * @param metaData   数据处理的类型
 * @param delegate   数据处理的代理
 * @return 无返回值
 **/
+(void)synWithMetaData:(LocalDataMeta*)metaData delegate:(id<SKDataDaemonHelperDelegate>)delegate;

/**
 * 取消某一个指定的任务
 * @param metaData   指定任务的标识
 * @return 无返回值
 **/
+(void)cancelWithMetaData:(LocalDataMeta*)metaData;

/**
 * 取消所有的任务
 * @return 无返回值
 **/
+(void)cancelAllTask;
@end


