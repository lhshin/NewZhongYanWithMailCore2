//
//  SKMailCoreServiceProvider.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-6-11.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKMailCoreServiceProvider.h"


@implementation SKMailCoreServiceProvider
+ (SKMailCoreServiceProvider *) getSKMailCoreServiceProviderInstance
{
    static SKMailCoreServiceProvider *sharedSKMailCoreServiceProviderInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSKMailCoreServiceProviderInstance = [[self alloc] init];
    });
    return sharedSKMailCoreServiceProviderInstance;
}

+ (void) imapFolderTableCheck
{
    
}



- (MCOIMAPSession *) imapSession
{
    if (!_imapSession) {
        _imapSession = [[MCOIMAPSession alloc] init];
        [_imapSession setHostname:IMAP_HOST_NAME];
        [_imapSession setPort:IMAP_PORT];
        [_imapSession setUsername:[NSMutableString stringWithFormat:@"%@%@", [[APPUtils loggedUser] uid],@"@hngytobacco.com"]];
        [_imapSession setPassword:[[APPUtils loggedUser] password]];
        [_imapSession setConnectionType:MCOConnectionTypeClear];
    }
    return _imapSession;
}

- (void) startImapService
{
    //1.同步文件夹
    //2.同步各文件夹内容
    
    MCOIMAPFetchFoldersOperation *op = [self.imapSession fetchAllFoldersOperation];
    [op start:^(NSError *error, NSArray *folders) {
        if (error) {
            [self imapErrorHandler:error];
            NSLog(@"Error fetching all folders:%@", error);
        }

        //NSLog(@"The folders are:%@", folders);
        for (MCOIMAPFolder *folder in folders) {
        }
    }];
}

- (void) imapErrorHandler:(NSError *) error
{
    if (!error) {
        switch (error.code) {
            case MCOErrorAuthentication:
                //如果认证失败，说明密码已经被修改，此处应跳转到登录页面，并提示用户密码已经在别处被修改，需要重新登录。
                break;
                
            default:
                break;
        }
    }
}
@end
