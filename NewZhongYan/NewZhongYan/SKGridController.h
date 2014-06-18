//
//  SKGridController.h
//  NewZhongYan
//
//  Created by lilin on 13-12-13.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "UIDragButton.h"
@interface SKGridController : UIViewController<UIDragButtonDelegate,EGOImageButtonDelegate>
@property SKClientApp* clientApp;
@property(nonatomic,weak)SKViewController* rootController;

/**
 *  更新本Client里面所有的App
 */
-(void)reloadData;
@end
