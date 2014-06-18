//
//  SKEdetailInfoController.h
//  NewZhongYan
//
//  Created by lilin on 13-11-27.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface SKEdetailInfoController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate>
@property(nonatomic,weak)NSMutableDictionary  *employeeInfo;
@end