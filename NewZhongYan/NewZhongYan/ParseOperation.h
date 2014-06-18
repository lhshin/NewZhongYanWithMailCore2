//
//  ParseOperation.h
//  ZhongYan
//
//  Created by linlin on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "business.h"
#import "columns.h"
#import "column.h"
#import "element.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
typedef void (^ArrayBlock)(business *);
typedef void (^ErrorBlock)(NSError *);

@class workDetailModal;
@interface ParseOperation : NSOperation <NSXMLParserDelegate>
{
    @private
    NSData          *dataToParse;
    NSArray         *elementsToParse;
    business        *aBusiness; //一个业务详情
    columns         *cs;
    column          *c;
    element         *e;
    DDXMLDocument   *doc;//用来存储一个xml结构的数据 简单的说就是一个业务  
}

@property (nonatomic, copy) ErrorBlock errorHandler;
- (id)initWithData:(NSData *)data completionHandler:(ArrayBlock)handler;
@end

