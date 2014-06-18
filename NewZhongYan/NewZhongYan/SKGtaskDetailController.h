//
//  SKGtaskDetailController.h
//  NewZhongYan
//
//  Created by lilin on 13-11-6.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
@class  business;
@interface SKGtaskDetailController : UIViewController<HPGrowingTextViewDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) NSDictionary*GTaskDetailInfo;
@property (strong,nonatomic) business * aBusiness;
@end
