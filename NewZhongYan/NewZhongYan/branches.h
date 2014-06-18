//
//  branches.h
//  NewZhongYan
//
//  Created by lilin on 14-3-19.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface branches : NSObject
{
    NSDictionary        *attributeDictionary;     //选项名称
    NSMutableArray      *branchArray;//存储branch
}
@property(nonatomic,strong)NSDictionary    *attributeDictionary;     //默认的选择状态
@property(nonatomic,strong)NSMutableArray      *branchArray;
@end
