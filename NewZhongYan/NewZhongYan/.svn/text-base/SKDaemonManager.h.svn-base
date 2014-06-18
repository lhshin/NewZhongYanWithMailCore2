//
//  SKDaemonManager.h
//  NewZhongYan
//
//  Created by lilin on 13-12-20.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGOCache.h"
typedef enum
{
    SKDaemonClientApp,
    SKDaemonClientVersion,
    SKDaemonChannel,
    SKDaemonDocuments
}SKDaemontype;    //列的类型 决定 列如何显示

#if NS_BLOCKS_AVAILABLE
typedef void (^SKDaemonBasicBlock)(void);
typedef void (^SKDaemonBasicArrayBlock)(NSMutableArray *errorinfo);
typedef void (^SKDaemonErrorBlock)(NSError* error);
#endif

@interface SKDaemonManager : NSOperation
{
    
}

/**
 *  获取应用下频道列表
 *
 *  @param client        应用
 *  @param completeBlock 完成block
 *  @param faliureBlock  失败block
 */
+(void)SynChannelWithClientApp:(SKClientApp*)client
                      complete:(SKDaemonBasicBlock)completeBlock
                       faliure:(SKDaemonErrorBlock)faliureBlock;

/**
 *  获取频道下文档列表
 *
 *  @param channel       频道
 *  @param completeBlock 完成block
 *  @param faliureBlock  失败block
 *  @param isUp          取文档的方向
 */
+(void)SynDocumentsWithChannel:(SKChannel*)channel
                      complete:(SKDaemonBasicBlock)completeBlock
                       faliure:(SKDaemonErrorBlock)faliureBlock
                          Type:(BOOL)isUp;

/**
 *  获取最新的频道更新信息
 *  关于operation的唯一标示 采用 clientcode+@"VersionInfo"的形式
 *  @param channel       频道
 *  @param completeBlock 完成block
 *  @param faliureBlock  失败block
 */
+(void)SynMaxUpdateDateWithClient:(SKClientApp*)client
                          complete:(SKDaemonBasicArrayBlock)completeBlock
                           faliure:(SKDaemonErrorBlock)faliureBlock;
@end
