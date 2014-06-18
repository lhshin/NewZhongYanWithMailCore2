//
//  SKMessageEntity.m
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKMessageEntity.h"
#import "JSONKit.h"
/**
 *  {"c":"EXCEPTION","f":"aaa","k":"EXCEPTION20131219193910117","t":"0","m":"2013-12-19T19:39:10.117","s":[{
 "v":{"MESSAGE":"转成消息结构体的Java数组或集合至少需要一个元素","CLASS":"com.surekam.dits.message.MessageException"}}]}
 */
// 3001 是没有查找到数据

@implementation SKMessageEntity
@synthesize praserError;
-(id)initWithData:(NSData*)JsonData
{
    self = [super init];
    if (self) {
        NSError* error = nil;
        entityDict = [JsonData objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&error];
        if (error) {
            self.praserError = error;
        }else{
            if ([[self MessageCode] isEqualToString:@"EXCEPTION"] && [[self dataItem:0][@"MESSAGE"] isEqualToString:@"转成消息结构体的Java数组或集合至少需要一个元素"]) {
                self.praserError = [NSError errorWithDomain:@"没有找到相应数据" code:DataNoneCode userInfo:@{@"reason": @"服务器上没有找到相应的数据"}];
            }
        }        
    }
    return self;
}

+(id)entityWithData:(NSData*)JsonData
{
    return [[SKMessageEntity alloc] initWithData:JsonData];
}

-(NSString*)MessageId
{
    if ([[entityDict allKeys] containsObject:@"k"]) {
        return [entityDict objectForKey:@"k"];
    }else{
        return nil;
    }
}

//消息版本号 k = 130622;
-(NSString*)MessageVesion
{
    return [self MessageId];
}

// c = USER;
-(NSString*)MessageCode
{
    if ([[entityDict allKeys] containsObject:@"c"]) {
        return [entityDict objectForKey:@"c"];
    }else{
        return nil;
    }
}

//数据来源
-(NSString*)MessageFrom
{
    if ([[entityDict allKeys] containsObject:@"f"]) {
        return [entityDict objectForKey:@"f"];
    }else{
        return nil;
    }
}

//数据默认要执行的操作
-(int)MessageDefaultAction{
    if ([[entityDict allKeys] containsObject:@"t"]) {
        return [[entityDict objectForKey:@"t"] intValue];
    }else{
        return kActionSelect;//默认
    }
}

-(NSString*)MessageTime{
    if ([[entityDict allKeys] containsObject:@"m"]) {
        return [entityDict objectForKey:@"m"];
    }else{
        return nil;
    }
}

//s 对应的值一般是数组
-(NSInteger)dataItemCount
{
    if ([[entityDict allKeys] containsObject:@"s"]) {
        return [[entityDict objectForKey:@"s"] count];
    }else{
        return 0;
    }
}

-(NSMutableDictionary*)dataItem:(NSInteger)index{
    NSArray* dataArray = [entityDict objectForKey:@"s"];
    if (dataArray.count > index)
    {
        NSMutableDictionary* v_dict = [dataArray objectAtIndex:index];
        return  [v_dict objectForKey:@"v"];
    }else{
        return nil;
    }
}

-(NSMutableArray*)dataItems{
    if ([[entityDict allKeys] containsObject:@"s"]) {
        return [entityDict objectForKey:@"s"];
    }else{
        return nil;
    }
}

-(int)dataItemAction:(NSInteger)index{
    if ([[entityDict allKeys] containsObject:@"s"]) {
        NSArray* dataArray = [entityDict objectForKey:@"s"];
        if (dataArray.count > index){
            return  [[[dataArray objectAtIndex:index] objectForKey:@"t"] intValue];
        }else{
            return kActionSelect;
        }
    }else{
        return kActionSelect;
    }
}

-(void)dealloc
{
    //NSLog(@"SKMessageEntity dealloc");
    entityDict = nil;
}
@end
