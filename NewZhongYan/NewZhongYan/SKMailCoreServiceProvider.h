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
@property (strong, nonatomic) MCOIMAPSession * imapSession;
+ (SKMailCoreServiceProvider *) getSKMailCoreServiceProviderInstance;
+ (void) imapFolderTableCheck;
- (void) startImapService;
@end
