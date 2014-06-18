//
//  SKECMDetail.h
//  NewZhongYan
//
//  Created by 蒋雪莲 on 13-11-18.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKECMDetail : NSObject
{
    NSString *title;
    NSString *author;
    NSString *time;
    NSMutableArray *body;
    NSMutableArray *attachment;
    NSMutableArray *inscribe;
    NSMutableArray *addition;
}
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *author;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSMutableArray *body;
@property(nonatomic,strong)NSMutableArray *attachment;
@property(nonatomic,strong)NSMutableArray *inscribe;
@property(nonatomic,strong)NSMutableArray *addition;
@end
