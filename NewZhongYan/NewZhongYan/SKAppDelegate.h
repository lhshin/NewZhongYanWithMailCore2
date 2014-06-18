//
//  SKAppDelegate.h
//  NewZhongYan
//
//  Created by lilin on 13-9-28.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LocalMetaDataManager;
@class SKAgentLogonManager;
@class User;
#define System_Version_Small_Than_(v) (DeviceSystemMajorVersion() < v)

@interface SKAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIStoryboard *mainStoryboard;
@property (strong,nonatomic)  Reachability *internetReachability;
@property (strong, nonatomic) NSOperationQueue    *queue;
@property (strong, nonatomic) LocalMetaDataManager* metaDataManager;
@property (strong, nonatomic) SKAgentLogonManager   * logonManager;
@property  NetworkStatus networkstatus;

/**
 *  采取宏的方式获取系统的版本号
 *
 *  @return 系统的版本号
 */
NSUInteger DeviceSystemMajorVersion();

+(User*)sharedCurrentUser;
@end
