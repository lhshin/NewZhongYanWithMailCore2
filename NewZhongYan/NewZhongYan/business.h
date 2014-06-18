//
//  business.h
//  ZhongYan
//
//  Created by linlin on 9/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface business : NSObject
{
    NSString            *returncode;        //
    NSString            *step;              //当前办理的进度
    NSString            *flowinstanceid;    //
    NSMutableArray      *columnsArray;      //存储columns
    NSArray*            xmlNodes;           //新添加的用于存储xml数据 将来便于返回
}

//-(void)showABusiness;
@property(nonatomic,strong)NSString    *step;
@property(nonatomic,strong)NSString    *returncode;
@property(nonatomic,strong)NSString    *flowinstanceid;
@property(nonatomic,strong)NSMutableArray     *columnsArray;//存储columns
@property(nonatomic,strong)NSArray     *xmlNodes;    
@end
