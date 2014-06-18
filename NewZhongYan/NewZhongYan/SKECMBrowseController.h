//
//  SKECMBrowseController.h
//  NewZhongYan
//
//  Created by lilin on 14-1-3.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMLazyScrollView.h"
@interface SKECMBrowseController : UIViewController<DMLazyScrollViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray      *viewControllers;   //详细内容  存储所有的内容
    NSMutableArray             *contentList;       //存储新闻的内容
    NSInteger           kNumberOfPages;
    NSInteger           KinitialPage;       //初始页面
    NSMutableArray*     viewControllerArray;
}

@property (nonatomic, strong) NSMutableArray *contentList;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, assign) NSMutableDictionary    *currentDictionary;
@property (strong, nonatomic) IBOutlet  DMLazyScrollView *lazyScrollView;
@property  NSInteger       kNumberOfPages;
@property (nonatomic,weak)SKChannel* channel;
@end
