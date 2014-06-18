//
//  SKChannel.m
//  NewZhongYan
//
//  Created by lilin on 13-12-19.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKChannel.h"
//默认时间是 1970-01-01T08:00:00.000
@implementation SKChannel
-(id)initWithDictionary:(NSDictionary*)channelInfo
{
    self = [super init];
    if (self) {
        _CODE = channelInfo[@"CODE"];
        _NAME = channelInfo[@"NAME"];
        _OWNERAPP = channelInfo[@"OWNERAPP"];
        _TYPELABLE = channelInfo[@"TYPELABLE"];
        _LOGO = channelInfo[@"LOGO"];
        _FIDLIST = channelInfo[@"FIDLIST"];
        _CURRENTID = channelInfo[@"CURRENTID"];
        _PARENTID = channelInfo[@"PARENTID"];
        _HASSUBTYPE = [channelInfo[@"HASSUBTYPE"] boolValue];
        _MAXUPTM = @"0";
        _MINUPTM = @"0";
        self.FIDLISTS = _FIDLIST;
        if (self.HASSUBTYPE) {
            NSString* sql = [NSString stringWithFormat:@"select * from T_CHANNEL WHERE PARENTID  = %@",self.CURRENTID];
            NSArray* subChannels = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
            NSString* fidlist = [NSString string];
            for (NSDictionary* dict in subChannels) {
                fidlist = [fidlist stringByAppendingFormat:@",%@",dict[@"FIDLIST"]];
            }
            fidlist = [fidlist substringFromIndex:1];
            self.FIDLISTS = fidlist;
        }
    }
    return self;
}

-(void)restoreVersionInfo
{
    NSString* sql = [NSString stringWithFormat:@"select max(uptm) MAXUPTM,min(uptm) MINUPTM from T_DOCUMENTS where channelid in (%@);",self.FIDLISTS];
    NSDictionary* dict = [[DBQueue  sharedbQueue] getSingleRowBySQL:sql];
    
    if (dict) {
        if (![dict[@"MAXUPTM"] isEqual:[NSNull null]]) {
            _MAXUPTM = dict[@"MAXUPTM"];
            NSTimeInterval time = [[[DateUtils stringToDate:_MAXUPTM DateFormat:dateTimeFormat] dateByAddingHours:0] timeIntervalSince1970];
            _MAXUPTM = [NSString stringWithFormat:@"%.0f",time*1000];
        }else{
            //NSLog(@"本地还没有%@的数据",self.CODE);
        }
        
        if (![dict[@"MINUPTM"] isEqual:[NSNull null]]) {
            _MINUPTM = dict[@"MINUPTM"];
            NSTimeInterval time = [[[DateUtils stringToDate:_MINUPTM DateFormat:dateTimeFormat] dateByAddingHours:0] timeIntervalSince1970];
            _MINUPTM = [NSString stringWithFormat:@"%.0f",time*1000];
            //NSLog(@"本地%@的数据最大时间和最小时间为:  %@  %@",self.CODE,_MAXUPTM,_MINUPTM);
        }else{
        
        }
    }
}
@end
