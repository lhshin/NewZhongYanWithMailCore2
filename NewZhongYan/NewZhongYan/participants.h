//
//  participants.h
//  ZhongYan
//
//  Created by linlin on 10/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface participants : NSObject
{  
    NSString    *returncode;
    NSString    *selection;                         //单选 还是多选
    NSMutableArray      *participantsArray;         //存储branch
    NSArray             *xmlNodes;                  //新添加的用于存储xml数据 将来便于返回
}

-(void)show;

@property(nonatomic,strong)NSString             *returncode;
@property(nonatomic,strong)NSString             *selection;
@property(nonatomic,strong)NSMutableArray       *participantsArray;
@property(nonatomic,strong)NSArray              *xmlNodes;
@end
