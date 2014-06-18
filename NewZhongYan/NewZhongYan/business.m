//
//  business.m
//  ZhongYan
//
//  Created by linlin on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "business.h"
#import "column.h"
#import "columns.h"
#import "element.h"
//#import "utils.h"
@implementation business
@synthesize returncode,flowinstanceid,columnsArray,xmlNodes,step;
-(id)init
{
    self = [super init];
    if (self) {
        self.columnsArray = [NSMutableArray array];
    }
    return self;
}


//-(void)showABusiness
//{
//    NSLog(@"=====================================一个业务解析情况=====================================");
//    NSLog(@"step = %@",self.step);
//    NSLog(@"returncode = %@",self.returncode);
//    NSLog(@"flowinstanceid = %@",self.flowinstanceid);
//    for (id obj in columnsArray) {
//        if ([obj class] == [columns class]) {
//            columns* cs = (columns*)obj;
//            [utils Dlog:cs.columnsDict];
//            for (id obj in cs.columnsArray) 
//            {
//                if ([obj class] == [column class]) {
//                    column * c = (column*)obj;
//                    NSLog(@"   value %@",c.value);
//                    [utils Dlog:c.columnDict];
//                    for (id obj in c.elementArray) {
//                        element * e = (element*)obj;
//                        NSLog(@"     value %@",e.value);
//                        [utils Dlog:e.elementDict];
//                    }
//                }
//            }
//            
//        }
//    }
//    NSLog(@"=====================================一个业务解析情况=====================================");
//}
@end
