//
//  SKEmalController.h
//  NewZhongYan
//
//  Created by lilin on 13-11-1.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
@interface SKEmailController : UIViewController
<UIActionSheetDelegate>
{
    NSInteger selectedIndex;
}
@property (weak, nonatomic) IBOutlet PullingRefreshTableView *tableview;
@property (strong, nonatomic)NSMutableArray  *dataArray;
-(void)getMailFromDataBase;
-(void)getOutBoxMail;
-(void)getDraftMail;
-(void)getTrashFromDataBase;
-(void)setMailIsRead:(NSString *)MESSAGEID;
@end
