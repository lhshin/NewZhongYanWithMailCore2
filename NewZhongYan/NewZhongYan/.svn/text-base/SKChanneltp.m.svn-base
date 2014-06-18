//
//  SKChanneltp.m
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKChanneltp.h"
static NSMutableArray* sharedCodocsChanneltp = nil;


@implementation SKChanneltp


-(id)initWithDictionary:(NSDictionary*)channeltpinfo
{
    self = [super init];
    if (self) {
        _TID = channeltpinfo[@"TID"];
        _TNAME = channeltpinfo[@"TNAME"];
        _OWNER = channeltpinfo[@"OWNER"];
    }
    return self;
}

+(NSArray*)codocsChanneltps
{
    NSArray* array =
    [[DBQueue sharedbQueue] recordFromTableBySQL:@"select * from T_CHANNELTP where OWNER = 'copublicdocs' and ENABLED = 1;"];
    if (array.count) {
        NSMutableArray* result = [NSMutableArray array];
        for (NSDictionary* dict in array) {
            SKChanneltp* channeltp = [[SKChanneltp alloc] initWithDictionary:dict];
            [result addObject:channeltp];
        }
        return result;
    }else{
        return nil;
    }
}

+(NSArray*)sharedCodocsChanneltp
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSArray* array =
        [[DBQueue sharedbQueue] recordFromTableBySQL:@"select * from T_CHANNELTP where OWNER = 'copublicdocs' and ENABLED = 1;"];
        if (array.count){
            sharedCodocsChanneltp = [NSMutableArray array];
            for (NSDictionary* dict in array) {
                SKChanneltp* channeltp = [[SKChanneltp alloc] initWithDictionary:dict];
                [sharedCodocsChanneltp addObject:channeltp];
            }
        }
    });
    return sharedCodocsChanneltp;
}
@end
