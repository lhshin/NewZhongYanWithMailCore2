//
//  SKMailCoreServiceProvider.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-6-11.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>
@interface SKMailCoreServiceProvider : NSObject
@property (strong, nonatomic) MCOIMAPSession *imapSession;
@property (strong, nonatomic) NSMutableDictionary *syncStates;
//是否正在同步
@property BOOL isSyncing;
//用来记录当前正在同步的文件夹个数
@property int syncFolderCount;
+ (SKMailCoreServiceProvider *) getSharedInstance;
- (void) startSync;
@end
