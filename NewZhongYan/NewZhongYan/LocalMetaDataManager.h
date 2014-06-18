//
//  LocalMetaDataManager.h
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LocalDataMeta;
@interface LocalMetaDataManager : NSObject
/**
 * 初始化所有的元数据信息
 **/
+(void)restoreAllMetaData;
/**
 * 一般用于从服务器获取数据时将本地数据的版本登其他信息提交到服务器的时候
 * @param metaData 数据元
 * @return 返回从本地恢复的metaData
 **/
+(LocalDataMeta*)restoreMetaData:(LocalDataMeta*)metaData;

/**
 * 一般用于从服务器下载数据到本地
 * @param metaData 数据元
 * @return 刷新metaData到本地
 **/
+(LocalDataMeta*)flushMetaData:(LocalDataMeta*)metaData;

/**
 * 一般用于判断本地数据是不是需要更新 在界面上表现为icon 上显示 new
 * @param metaData 数据元
 * @return 判断本地的某个数据是不是又新数据
 **/
+(BOOL)existedNewData:(LocalDataMeta*)metaData;

/**
 * 一般用于判断本地数据未阅读的数据的条数 在界面上表现为icon 上显示 1
 * @param metaData 数据元
 * @return 判断本地未阅读的数据的条数
 **/
+(NSString*)newDataItemCount:(LocalDataMeta*)metaData;

+(NSString*)newECMDataItemCount:(NSString*)currentFid;

/**
 *  这个不仅仅适用于会议也适用于通知了
 *
 *  @param currentFid <#currentFid description#>
 *
 *  @return <#return value description#>
 */
+(NSString*)newECMMeettingItemCount:(NSString*)currentFid;
@end
