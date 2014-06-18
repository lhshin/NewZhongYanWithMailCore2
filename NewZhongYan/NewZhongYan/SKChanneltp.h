//
//  SKChanneltp.h
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKChanneltp : NSObject
@property(nonatomic,strong)NSString* TID;        //类别编号
@property(nonatomic,strong)NSString* TNAME;      //类别名称
@property(nonatomic,strong)NSString* OWNER;      //所属频道

-(id)initWithDictionary:(NSDictionary*)channeltpinfo;

/**
 *  动态的每次从数据库中获取公司公文的子频道分类
 *
 *  @return 频道分类
 */
+(NSArray*)codocsChanneltps;

/**
 *  单例的每次从数据库中获取公司公文的子频道分类
 *
 *  @return 频道分类
 */
+(NSArray*)sharedCodocsChanneltp;
@end
