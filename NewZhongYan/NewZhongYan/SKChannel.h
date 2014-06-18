//
//  SKChannel.h
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKChannel : NSObject
@property(nonatomic,strong)NSString* CODE;      //频道编码
@property(nonatomic,strong)NSString* NAME;      //频道名称
@property(nonatomic,strong)NSString* OWNERAPP;
@property(nonatomic,strong)NSString* TYPELABLE;
@property(nonatomic,strong)NSString* LOGO;
@property(nonatomic,strong)NSString* FIDLIST;
@property(nonatomic,strong)NSString* CURRENTID;
@property(nonatomic,strong)NSString* PARENTID;
@property(nonatomic,strong)NSString* LEVL;     //因为LEVEL 是数据库关键字 所以不叫LEVL 叫LEVEL
@property(nonatomic,strong)NSString* MAXUPTM;
@property(nonatomic,strong)NSString* MINUPTM;
@property(nonatomic,strong)NSString* FIDLISTS;
@property BOOL HASSUBTYPE;
@property(nonatomic,strong)NSMutableArray* channeltypes;
-(id)initWithDictionary:(NSDictionary*)channelInfo;
/**
 *  从数据库将最大和最小的时间的数据获取到model 中
 */
-(void)restoreVersionInfo;
@end
