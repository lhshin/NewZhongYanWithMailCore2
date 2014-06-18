//
//  element.m
//  ZhongYan
//
//  Created by linlin on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "element.h"

@implementation element
@synthesize value,elementDict,enode;
-(id)init
{
    self = [super init];
    if (self) {
        self.elementDict = [NSDictionary dictionary];
    }
    return self;
}

@end
