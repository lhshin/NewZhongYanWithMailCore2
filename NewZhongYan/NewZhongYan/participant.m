//
//  participant.m
//  ZhongYan
//
//  Created by linlin on 10/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "participant.h"

@implementation participant
@synthesize type,pid,pname,selected;
-(void)show{
    NSLog(@"%@",selected ? @"选中" :@"未选中");
    NSLog(@"type = %@",type);
    NSLog(@"pid = %@",pid);
    NSLog(@"pname = %@",pname);
}


@end
