//
//  participant.h
//  ZhongYan
//
//  Created by linlin on 10/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//<participant>
//<type>2</type>
//<pid>F7F5238A-1F13-4f52-ADD8-448B26D41CAC</pid>
//<pname>周昌贡</pname>
//</participant>

//type	参与人的类型，建议一个分支只单独对应办理部门或者办理人，而不是混合数据。	元素
//示例说明	取值：
//0为所有人，移动客户端会从离线数据库中提供人员查询功能；
//1为办理部门；
//2为办理人；
//3为岗位。
@interface participant : NSObject
{
    NSString* type;
    NSString* pid;
    NSString* pname;
    BOOL selected;
}

-(void)show;
@property BOOL selected;
@property(nonatomic,strong)NSString* type;
@property(nonatomic,strong)NSString* pid;
@property(nonatomic,strong)NSString* pname;
@end
