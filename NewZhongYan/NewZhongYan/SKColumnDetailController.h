//
//  SKColumnDetailController.h
//  ZhongYan
//
//  Created by 李 林 on 2/25/13.
//  Copyright (c) 2013 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "columns.h"
#import "column.h"
#import "element.h"

#import "SKLToolBar.h"

#import "DataServiceURLs.h"
#import "ParseOperation.h"
#import "NSData+Base64.h"
#import "SKHTTPRequest.h"

@interface SKColumnDetailController : UIViewController
{
    UIScrollView *mainScrollview;
    UIView *contentView;
    float totalHeight;                  //scrollview总高度
    float contentTotalHeight;           //业务内容总高度
}
@property (retain,nonatomic) business * aBusiness;
@property(nonatomic,retain) NSString *flowInstanceID;
@property(nonatomic,retain) NSString *uniqueID;
@property(nonatomic,retain) NSString *from;
@property(nonatomic,retain)NSString  *tfrm;
@property(nonatomic,assign)BOOL  isHistory;
@end
