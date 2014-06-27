//
//  SKMailCoreServiceProvider.m
//  NewZhongYan
//
//  Created by 海升 刘 on 14-6-11.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKMailCoreServiceProvider.h"
#import "FileUtils.h"
#import "SKMailConstants.h"

@implementation SKMailCoreServiceProvider

+ (void) initialize
{
    if (self == [SKMailCoreServiceProvider class]) {
        [self initialFolders];
    }
}

- (instancetype) init
{
    self = [super init];
    if (self) {
		
        NSString *folderPlist = [[SKMailCoreServiceProvider getMailFolderPathName] stringByAppendingPathComponent:FOLDER_PLIST];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:folderPlist]) {
            [SKMailCoreServiceProvider initialFolders];
        }
        NSData *fileData = [[NSData alloc] initWithContentsOfFile:folderPlist];
        self.syncStates = [NSPropertyListSerialization propertyListWithData:fileData options:NSPropertyListMutableContainersAndLeaves format:nil error:nil];
        
    }
    return self;
}

//获取邮件根目录
+ (NSString *) getMailFolderPathName {
    NSString *mailFolderPathName = [[FileUtils documentPath] stringByAppendingPathComponent:MAIL_FOLDER_NAME];
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:mailFolderPathName isDirectory:&isDir];
    if (!(isExist && isDir)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:mailFolderPathName withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return mailFolderPathName;
}

//获取邮件文件夹路径
+ (NSString *) getMailBoxPathName:(NSString *)folderPath {
    if (!folderPath) {
        return nil;
    }
    NSString *mailBoxPathName = [[SKMailCoreServiceProvider getMailFolderPathName] stringByAppendingPathComponent:folderPath];
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:mailBoxPathName isDirectory:&isDir];
    if (!(isExist && isDir)) {
        return nil;
    }
    return mailBoxPathName;
}


+ (void) initialFolders {
    NSString *mailFolderPathName = [SKMailCoreServiceProvider getMailFolderPathName];
    NSString *folderPlist = [mailFolderPathName stringByAppendingPathComponent:FOLDER_PLIST];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPlist]) {
        
        NSMutableArray *folderStates = [NSMutableArray array];
        
        NSArray *keys = [DEFAULT_FOLDERS_DICT allKeys];
        for(int i = 0; i < [keys count]; i++){
            NSString *key = [keys objectAtIndex:i];
            [folderStates addObject:@{FOLDER_PATH: key,
                                      FOLDER_DISPLAY_NAME: [DEFAULT_FOLDERS_DICT objectForKey:key],
                                      CURRENT_MESSAGE_COUNT: @0}];
            //为每个邮件文件夹建立单独的文件夹
            [[NSFileManager defaultManager] createDirectoryAtPath:[mailFolderPathName stringByAppendingString:key] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSMutableDictionary *props = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0", FOLDER_VERSION, folderStates, FOLDER_STATES_KEY, nil];
        if(![props writeToFile:folderPlist atomically:YES]) {
            NSLog(@"Unsuccessful in creating folders to file %@", folderPlist);
        }
    }
}



+ (SKMailCoreServiceProvider *) getSharedInstance
{
    static SKMailCoreServiceProvider *sharedSKMailCoreServiceProviderInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSKMailCoreServiceProviderInstance = [[self alloc] init];
    });
    return sharedSKMailCoreServiceProviderInstance;
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


//同步已经存在的邮件，包含是否删除，已读，未读
- (void) syncExistMessageAtFolder:(NSMutableDictionary *)folderState {
    
    if ([[folderState objectForKey:MESSAGE_COUNT] unsignedIntegerValue] == 0) {
        return;
    }
    NSString *mailBoxPath = [SKMailCoreServiceProvider getMailBoxPathName:[folderState objectForKey:FOLDER_PATH]];
    BOOL isDir = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:mailBoxPath isDirectory:&isDir];
    if (!(isExist && isDir)) {
        return;
    }
    MCOIndexSet *uids = [MCOIndexSet indexSet];
    NSArray *uidFolders = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:mailBoxPath error:nil] pathsMatchingExtensions:[NSArray arrayWithObject:MESSAGE_FOLDER_EXTENSION]];
    for (NSString *uidString in uidFolders) {
        [uids addIndex:[[uidString stringByDeletingPathExtension] intValue]];
    }
    MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindFlags;
    
    MCOIMAPFetchMessagesOperation *fetchByuidOp = [self.imapSession fetchMessagesByUIDOperationWithFolder:[folderState objectForKey:FOLDER_PATH]
                                                                                              requestKind:requestKind
                                                                                                     uids:uids];
    
    [fetchByuidOp start:^(NSError *fetchUidError, NSArray *fetchUidMessages, MCOIndexSet *fetchUidVanishedMessages) {
        if (fetchUidError) {
            [self imapErrorHandler:fetchUidError];
            return;
        }
        
        NSArray *localMessages = [self readMCOIMAPMessageFromFolder:[folderState objectForKey:FOLDER_PATH]];
        
        NSMutableArray *deletedMsg = [NSMutableArray array];
        NSMutableArray *flagChangedMsg = [NSMutableArray array];
        //find the messages to delete, and the message whose flag should be changed
        for (MCOIMAPMessage *localMsg in localMessages) {
            for (MCOIMAPMessage *fetchMsg in fetchUidMessages) {
                if (localMsg.uid == fetchMsg.uid) {
                    if (localMsg.flags == fetchMsg.flags) {
                        continue;
                    } else {
                        [flagChangedMsg addObject:fetchMsg];
                    }
                } else if ([fetchMsg isEqual:[fetchUidMessages lastObject]]) {
                    [deletedMsg addObject:localMsg];
                }
            }
        }
        //TODO:更新文件夹plist文件
        
        [self deleteMCOIMAPMessageAtFolder:[folderState objectForKey:FOLDER_PATH] withMessage:deletedMsg];
        [self saveMCOIMAPMessageToFolder:[folderState objectForKey:FOLDER_PATH] withMessage:flagChangedMsg];
        
    }];

}


- (void) startSync
{
    //1.同步文件夹
    //2.同步各文件夹内容
    if (self.isSyncing) {
        return;
    }
    //检查账户是否有效
    MCOIMAPOperation *checkAccountOp = [self.imapSession checkAccountOperation];
    [checkAccountOp start:^(NSError *error) {
        if (error) {
            [self imapErrorHandler:error];
            return;
        }
    }];
    
    self.isSyncing = YES;
    MCOIMAPFetchFoldersOperation *folderOP = [self.imapSession fetchAllFoldersOperation];
    [folderOP start:^(NSError *error, NSArray *folders) {
        if (error) {
            [self imapErrorHandler:error];
            NSLog(@"Error fetching all folders:%@", error);
            self.isSyncing = NO;
            return;
        }

        NSArray *folderItems = [self.syncStates objectForKey:FOLDER_STATES_KEY];
        for (MCOIMAPFolder *folder in folders) {
            for (NSMutableDictionary *folderItem in folderItems) {
                //跳过只保存在本地的SENDBOX
                if ([[folderItem objectForKey:FOLDER_PATH] isEqualToString:SENDBOX]) {
                    continue;
                }
                if ([[folderItem objectForKey:FOLDER_PATH] isEqualToString:folder.path]) {
                    MCOIMAPFolderStatusOperation *folderStatusOP = [self.imapSession folderStatusOperation:folder.path];
                    [folderStatusOP start:^(NSError *error, MCOIMAPFolderStatus *status) {
                        if (error) {
                            [self imapErrorHandler:error];
                            NSLog(@"Error fetching folder %@ status:%@", folder.path, error);
                            return;
                        }
                        
                        //如果当前邮箱文件夹邮件数目与本地一致，则无需更新,但需要增加已同步的文件夹计数
                        if ([[folderItem objectForKey:CURRENT_MESSAGE_COUNT] intValue] == status.messageCount) {
                            self.syncFolderCount++;
                            return;
                        }
                        
                        [folderItem setObject:[NSNumber numberWithUnsignedInt:status.uidNext] forKey:UID_NEXT];
                        [folderItem setObject:[NSNumber numberWithUnsignedInt:status.uidValidity] forKey:UID_VALIDITY];
                        [folderItem setObject:[NSNumber numberWithUnsignedInt:status.recentCount] forKey:RECENT_COUNT];
                        [folderItem setObject:[NSNumber numberWithUnsignedInt:status.unseenCount] forKey:UNSEEN_COUNT];
                        [folderItem setObject:[NSNumber numberWithUnsignedInt:status.messageCount] forKey:MESSAGE_COUNT];
                        
                        //保持邮箱文件夹信息到文件
                        if(![self.syncStates writeToFile:[[SKMailCoreServiceProvider getMailFolderPathName] stringByAppendingPathComponent:FOLDER_PLIST] atomically:YES]) {
                            NSLog(@"Unsuccessful in save folders %@ to file:%@", folder.path, self.syncStates);
                        }
                        //文件夹同步完成，开始同步邮件列表
                        NSLog(@"Folder %@ sync completed", folder.path);
                        [self performSelector:@selector(syncMails:) withObject:folderItem];
                        
                    }];
                }
            }
        }
    }];
    __weak SKMailCoreServiceProvider *weakSelf = self;
    [self.imapSession setOperationQueueRunningChangeBlock:^{
        if ([weakSelf.imapSession isOperationQueueRunning]) {
            
        } else {
            weakSelf.isSyncing = NO;
        }
    }];
}

- (void) syncMails:(NSMutableDictionary *)folderState {
    //NSLog(@"syncMails----folderSates:%@", folderState);
    
    NSUInteger currentMessageCount = [[folderState objectForKey:CURRENT_MESSAGE_COUNT] unsignedIntegerValue];
    NSUInteger messageCount = [[folderState objectForKey:MESSAGE_COUNT] unsignedIntegerValue];
    BOOL totalNumberOfMessagesDidChange = currentMessageCount != messageCount;
    NSUInteger numberOfMessagesToLoad = MIN(messageCount, DEFAULT_LOAD_MESSSAGE_NUM);
    
    if (numberOfMessagesToLoad == 0) {
        return;
    }
    
    MCORange fetchRange;
    // If total number of messages did not change since last fetch,
    // assume nothing was deleted since our last fetch and just
    // fetch what we don't have
    if (!totalNumberOfMessagesDidChange && currentMessageCount) {
        
        numberOfMessagesToLoad -= currentMessageCount;
        fetchRange = MCORangeMake(messageCount - currentMessageCount - (numberOfMessagesToLoad - 1), (numberOfMessagesToLoad - 1));
    } else {
        // Else just fetch the last N messages
        fetchRange = MCORangeMake(messageCount - (numberOfMessagesToLoad - 1), (numberOfMessagesToLoad - 1));
    }
    
    MCOIndexSet *numbers = [MCOIndexSet indexSetWithRange:fetchRange];

    __block MCOIMAPMessagesRequestKind requestKind =  MCOIMAPMessagesRequestKindHeaders;
    MCOIMAPFetchMessagesOperation *fetchByNumOp = [self.imapSession fetchMessagesByNumberOperationWithFolder:[folderState objectForKey:FOLDER_PATH]
                                                                                                   requestKind:requestKind                                                                                              numbers:numbers];

    [fetchByNumOp start:^(NSError *error, NSArray *messages, MCOIndexSet *vanishedMessages) {
//        if ([[folderState objectForKey:FOLDER_PATH] isEqualToString:@"INBOX"]) {
//            NSLog(@"inbox:%@", numbers);
//        }
        if (error) {
            self.syncFolderCount++;
            [self imapErrorHandler:error];
            NSLog(@"Error fetching folder %@ for mail:%@", [folderState objectForKey:FOLDER_PATH], error);
            return;
        }
        MCOIndexSet *uids = [MCOIndexSet indexSet];
        for (MCOIMAPMessage * message in messages) {
//            if ([[folderState objectForKey:FOLDER_PATH] isEqualToString:@"INBOX"]) {
//                NSLog(@"uid:%u, subject:%@, sender:%@", [message uid], message.header.subject, message.header.sender.displayName);
//            }
            //过滤来自POSTMASTER得邮件
            if (![[message.header.sender.displayName uppercaseString] isEqualToString:POSTMASTER]) {
                [uids addIndex:message.uid];
            }
            
        }
//        NSLog(@"fetchUids:%@", uids);
        if ([uids count]) {

            requestKind = MCOIMAPMessagesRequestKindHeaders
                        | MCOIMAPMessagesRequestKindStructure
                        | MCOIMAPMessagesRequestKindInternalDate
                        | MCOIMAPMessagesRequestKindHeaderSubject
                        | MCOIMAPMessagesRequestKindFlags;
            
            MCOIMAPFetchMessagesOperation *fetchByuidOp = [self.imapSession fetchMessagesByUIDOperationWithFolder:[folderState objectForKey:FOLDER_PATH]
                                                                                                  requestKind:requestKind
                                                                                                         uids:uids];
            
            [fetchByuidOp start:^(NSError *fetchUidError, NSArray *fetchUidMessages, MCOIndexSet *fetchUidVanishedMessages) {
                if (fetchUidError) {
                    self.syncFolderCount++;
                    [self imapErrorHandler:fetchUidError];
                    NSLog(@"Error fetching folder %@ with uids %@ for mail:%@", [folderState objectForKey:FOLDER_PATH], uids, fetchUidError);
                    return;
                }
//                for (MCOIMAPMessage * fetchUidMessage in fetchUidMessages) {
//                    if ([[folderState objectForKey:FOLDER_PATH] isEqualToString:@"INBOX"]) {
//                        NSLog(@"fetchuid:%u, subject:%@", [fetchUidMessage uid], fetchUidMessage.header.subject);
//                    }
//                }
                //TODO:刷新展示邮件列表的view，需要判断当前同步的文件与展示的是否一致，考虑用代理实现。
                //保存邮件到文件
                [self saveMCOIMAPMessageToFolder:[folderState objectForKey:FOLDER_PATH] withMessage:fetchUidMessages];
                
                self.syncFolderCount++;
                if (self.syncFolderCount == [[self.syncStates objectForKey:FOLDER_STATES_KEY] count] - 1) {
                    NSNumber *ver = [NSNumber numberWithInt:[[self.syncStates objectForKey:FOLDER_VERSION] integerValue] + 1];
                    [self.syncStates setObject:ver forKey:FOLDER_VERSION];
                    self.syncFolderCount = 0;
                    self.isSyncing = NO;
                    NSLog(@"Sync END!");
                }
            }];
            
        } else {
            
            self.syncFolderCount++;
            if (self.syncFolderCount == [[self.syncStates objectForKey:FOLDER_STATES_KEY] count] - 1) {
                NSNumber *ver = [NSNumber numberWithInt:[[self.syncStates objectForKey:FOLDER_VERSION] integerValue] + 1];
                [self.syncStates setObject:ver forKey:FOLDER_VERSION];
                self.syncFolderCount = 0;
                self.isSyncing = NO;
                NSLog(@"Sync END!");
            }
        }

    }];
}

- (void) saveMCOIMAPMessageToFolder:(NSString *)folder withMessage:(NSArray *)messages {
    NSString *mailBoxPath = [SKMailCoreServiceProvider getMailBoxPathName:folder];
    if (!(mailBoxPath && [messages count])) {
        return;
    }
    
    for (MCOIMAPMessage *msg in messages) {
        NSString *msgFolderPath = [mailBoxPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u.%@", msg.uid, MESSAGE_FOLDER_EXTENSION]];
        [[NSFileManager defaultManager] createDirectoryAtPath:msgFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *msgPath = [msgFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", msg.header.messageID, MESSAGE_BODY_EXTENSION]];
        NSMutableData *msgData = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:msgData];
        [archiver encodeObject:msg forKey:ENCODE_DECODE_KEY];
        [archiver finishEncoding];
        [msgData writeToFile:msgPath atomically:YES];
    }
}

- (NSArray *) readMCOIMAPMessageFromFolder:(NSString *)folder {
    
    NSString *mailBoxPath = [SKMailCoreServiceProvider getMailBoxPathName:folder];
    if (!mailBoxPath) {
        return nil;
    }
    NSArray *msgFileList = [[[NSFileManager defaultManager] subpathsOfDirectoryAtPath:mailBoxPath error:nil] pathsMatchingExtensions:[NSArray arrayWithObject:MESSAGE_BODY_EXTENSION]];
    if (![msgFileList count]) {
        return nil;
    }
    
    NSMutableArray *mailMsgs = [NSMutableArray array];
    for (NSString *msgFile in msgFileList) {
        NSString *msgFilePath = [mailBoxPath stringByAppendingPathComponent:msgFile];
        NSData *msgData = [[NSData alloc] initWithContentsOfFile:msgFilePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:msgData];
        MCOIMAPMessage *msg = [unarchiver decodeObjectForKey:ENCODE_DECODE_KEY];
        [unarchiver finishDecoding];
        [mailMsgs addObject:msg];
    }
    return mailMsgs;
}

- (void) deleteMCOIMAPMessageAtFolder:(NSString *)folder withMessage:(NSArray *)messages {
    NSString *mailBoxPath = [SKMailCoreServiceProvider getMailBoxPathName:folder];
    if (!(mailBoxPath && [messages count])) {
        return;
    }
    
    for (MCOIMAPMessage *msg in messages) {
        NSString *msgFolderPath = [mailBoxPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%u.%@", msg.uid, MESSAGE_FOLDER_EXTENSION]];
        [[NSFileManager defaultManager] removeItemAtPath:msgFolderPath error:nil];
    }
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
