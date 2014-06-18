//
//  aNextBranches.h
//  ZhongYan
//
//  Created by linlin on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface aNextBranches : NSObject
{
    NSString            *selection; //选择方式
    NSString            *returncode;
    NSMutableArray      *branchesArray;//存储branches
    NSArray             *xmlNodes;     //新添加的用于存储xml数据 将来便于返回
}

-(void)show;
@property(nonatomic,strong)NSString             *selection;
@property(nonatomic,strong)NSString             *returncode;
@property(nonatomic,strong)NSMutableArray       *branchesArray;//存储columns
@property(nonatomic,strong)NSArray              *xmlNodes;    
@end