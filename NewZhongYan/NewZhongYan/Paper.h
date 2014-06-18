//
//  Paper.h
//  NewZhongYan
//
//  Created by lilin on 14-1-8.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Paper : NSObject
@property(nonatomic,strong)NSString *paperid;
@property(nonatomic,strong)NSString *channelid;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *author;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *url;
@end
