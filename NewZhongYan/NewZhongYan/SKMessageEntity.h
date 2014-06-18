//
//  SKMessageEntity.h
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, SKMessageAcition) {
    kActionSelect = 0,
    kActionInsert,
    kActionUpdate,
    kActionDelete
};
@interface SKMessageEntity : NSObject
{
    NSDictionary* entityDict;
}

@property(nonatomic,strong)NSError* praserError;

-(id)initWithData:(NSData*)JsonData;

+(id)entityWithData:(NSData*)JsonData;
#pragma  mark -- 基本属性
-(NSString*)MessageId;

/**
 * @return 数据的版本号
 **/
-(NSString*)MessageVesion;

/**
 * @return 数据的版类型 暂时没有用到
 **/
-(NSString*)MessageCode;

/**
 * @return 数据的来源
 **/
-(NSString*)MessageFrom;

/**
 * @return 数据的默认的操作方式
 **/
-(int)MessageDefaultAction;

/**
 * @return 获取到数据的时间
 **/
-(NSString*)MessageTime;

#pragma  mark -- 数据
/**
 * @return 数据的条数
 **/
-(NSInteger)dataItemCount;

/**
 * @param index 版本号
 * @return 返回index对应数据
 **/
-(NSMutableDictionary*)dataItem:(NSInteger)index;

/**
 * @return 返回需要的数据的数组
 **/
-(NSMutableArray*)dataItems;

/**
 * @param index 版本号
 * @return 返回index对应数据的操作方式
 **/
-(int)dataItemAction:(NSInteger)index;
@end
