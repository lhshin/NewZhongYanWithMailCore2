//
//  branch.h
//  ZhongYan
//
//  Created by linlin on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXMLElement.h"
@interface branch : NSObject
{
    NSString    *bid;       //选项ID
    NSString    *bname;     //选项名称
    NSString    *ifend;     //默认的选择状态
    DDXMLElement* node;
}

-(void)show;
@property(nonatomic,strong)NSString    *bid;
@property(nonatomic,strong)NSString    *bname;     //选项名称
@property(nonatomic,strong)NSString    *ifend;     //默认的选择状态
@property(nonatomic,strong)DDXMLElement    *node;     //默认的选择状态
@end
