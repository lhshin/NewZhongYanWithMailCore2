//
//  Content.m
//  NewZhongYan
//
//  Created by 蒋雪莲 on 13-11-18.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "Content.h"

@implementation Content
@synthesize idatta,name,type,value;

- (id) init{
    self = [super init];
    return self;
}

-(void)show
{
     NSLog(@"\nidatta = %@\nname = %@\ntype = %@\nvalue = %@",idatta,name,type,value);
}
@end
