//
//  SKViewController.h
//  NewZhongYan
//
//  Created by lilin on 13-9-28.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDragButton.h"
#import "SKPatternLockController.h"

#import "SMPageControl.h"
@interface SKViewController : UIViewController<UIDragButtonDelegate,drawPatternLockDelegate,SKDataDaemonHelperDelegate,UITabBarDelegate>
{
    NSMutableArray* clientAppArray;
    BOOL isFirstLogin;
}

@property(nonatomic,weak)UIScrollView *bgScrollView;
@property(nonatomic,strong)SMPageControl* pageController;
- (void)scrollToPage:(int)page;
-(void)firstInitClientApp;
@end
