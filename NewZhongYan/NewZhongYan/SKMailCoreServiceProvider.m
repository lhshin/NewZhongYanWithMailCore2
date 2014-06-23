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
		
        NSString *folderPathName = [SKMailCoreServiceProvider getFolderPathName];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:folderPathName]) {
            [SKMailCoreServiceProvider initialFolders];
        }
        NSData *fileData = [[NSData alloc] initWithContentsOfFile:folderPathName];
        self.syncStates = [NSPropertyListSerialization propertyListWithData:fileData options:NSPropertyListMutableContainersAndLeaves format:nil error:nil];
        
    }
    return self;
}

+ (NSString *) getFolderPathName {
    NSString *documentPath = [FileUtils documentPath];
    NSString *folderPathName = [documentPath stringByAppendingPathComponent:IMAP_FOLDER_PLIST];
    return folderPathName;
}

+ (void) initialFolders {
    NSString *folderPathName = [self getFolderPathName];

    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPathName]) {
        
        NSMutableArray *folderStates = [[NSMutableArray alloc] initWithCapacity:6];
        
        NSArray *keys = [DEFAULT_FOLDERS_DICT allKeys];
        for(int i = 0; i < [keys count]; i++){
            NSString *key = [keys objectAtIndex:i];
            [folderStates addObject:@{FOLDER_PATH: key, FOLDER_DISPLAY_NAME: [DEFAULT_FOLDERS_DICT objectForKey:key]}];
        }
        NSMutableDictionary *props = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"0", FOLDER_VERSION, folderStates, FOLDER_STATES_KEY, nil];
        if(![props writeToFile:folderPathName atomically:YES]) {
            NSLog(@"Unsuccessful in creating folders to file %@", folderPathName);
        }
    }
}



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
    if (self.isSyncing) {
        return;
    }
    self.isSyncing = YES;
    //[self.imapSession checkAccountOperation];
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
                if ([[folderItem objectForKey:FOLDER_PATH] isEqualToString:folder.path]) {
                    MCOIMAPFolderStatusOperation *folderStatusOP = [self.imapSession folderStatusOperation:folder.path];
                    [folderStatusOP start:^(NSError *error, MCOIMAPFolderStatus *status) {
                        if (error) {
                            [self imapErrorHandler:error];
                            NSLog(@"Error fetching folder %@ status:%@", folder.path, error);
                            return;
                        }

                        [folderItem setObject:[NSNumber numberWithUnsignedInt:status.uidNext] forKey:UID_NEXT];
                        [folderItem setObject:[NSNumber numberWithUnsignedInt:status.uidValidity] forKey:UID_VALIDITY];
                        [folderItem setObject:[NSNumber numberWithUnsignedInt:status.recentCount] forKey:RECENT_COUNT];
                        [folderItem setObject:[NSNumber numberWithUnsignedInt:status.unseenCount] forKey:UNSEEN_COUNT];
                        [folderItem setObject:[NSNumber numberWithUnsignedInt:status.messageCount] forKey:MESSAGE_COUNT];
                        
                        if(![self.syncStates writeToFile:[SKMailCoreServiceProvider getFolderPathName] atomically:YES]) {
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
}

- (void) syncMails:(NSMutableDictionary *)folderState {
    NSLog(@"syncMails----folderSates:%@", folderState);
    __block MCOIMAPMessagesRequestKind requestKind =  MCOIMAPMessagesRequestKindHeaders;
    
    MCOIndexSet *numbers = [MCOIndexSet indexSetWithRange:MCORangeMake(1, 10)];
//    int numberOfMessages = DEFAULT_MESSSAGE_NUM;
//    numberOfMessages -= 1;
//    NSLog(@"numberOfMessages:%i, after minus:%i",numberOfMessages, [[folderState objectForKey:MESSAGE_COUNT] intValue] - numberOfMessages);
//    MCOIndexSet *numbers = [MCOIndexSet indexSetWithRange:MCORangeMake([[folderState objectForKey:MESSAGE_COUNT] intValue] - numberOfMessages, numberOfMessages)];

    
    MCOIMAPFetchMessagesOperation *fetchOperation = [self.imapSession fetchMessagesByNumberOperationWithFolder:[folderState objectForKey:FOLDER_PATH]
                                                                                                   requestKind:requestKind                                                                                              numbers:numbers];

    
    [fetchOperation start:^(NSError *error, NSArray *messages, MCOIndexSet *vanishedMessages) {
        if ([[folderState objectForKey:FOLDER_PATH] isEqualToString:@"INBOX"]) {
            NSLog(@"inbox:%@", numbers);
        }
        if (error) {
            [self imapErrorHandler:error];
            NSLog(@"Error fetching folder %@ for mail:%@", [folderState objectForKey:FOLDER_PATH], error);
            return;
        }
        MCOIndexSet *uids = [MCOIndexSet indexSet];
        for (MCOIMAPMessage * message in messages) {
            NSLog(@"uid:%u, subject:%@", [message uid], message.header.subject);
            if (![[message.header.sender.displayName uppercaseString] isEqualToString:POSTMASTER]) {
                [uids addIndex:message.uid];
            }
            
        }
        if ([uids count]) {

            requestKind =  MCOIMAPMessagesRequestKindHeaders
                        | MCOIMAPMessagesRequestKindStructure
                        | MCOIMAPMessagesRequestKindInternalDate
                        | MCOIMAPMessagesRequestKindHeaderSubject
                        | MCOIMAPMessagesRequestKindFlags;
            
            MCOIMAPFetchMessagesOperation *fetchByuidOp = [self.imapSession fetchMessagesByUIDOperationWithFolder:[folderState objectForKey:FOLDER_PATH]
                                                                                                  requestKind:requestKind
                                                                                                         uids:uids];
        [fetchByuidOp start:^(NSError *fetchUidError, NSArray *fetchUidMessages, MCOIndexSet *fetchUidVanishedMessages) {
            if (fetchUidError) {
                [self imapErrorHandler:fetchUidError];
                NSLog(@"Error fetching folder %@ with uids %@ for mail:%@", [folderState objectForKey:FOLDER_PATH], uids, fetchUidError);
                return;
            }
            for (MCOIMAPMessage * fetchUidMessage in fetchUidMessages) {
                NSLog(@"fetchuid:%u, subject:%@", [fetchUidMessage uid], fetchUidMessage.header.subject);
            }
            
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

    
//    //MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake([info messageCount] - numberOfMessages, numberOfMessages)];
//    MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(1, UINT64_MAX)];
//    
//    MCOIMAPFetchMessagesOperation *fetchOperation = [self.imapSession fetchMessagesByUIDOperationWithFolder:@"INBOX"
//                                                                                            requestKind:requestKind
//                                                                                                   uids:uids];
//    
//    [fetchOperation start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
//        //We've finished downloading the messages!
//        //Let's check if there was an error:
//        if(error) {
//            [self imapErrorHandler:error];
//            NSLog(@"Error downloading message headers:%@", error);
//        }
//
//        //And, let's print out the messages...
//        NSLog(@"The post man delivereth:%@", fetchedMessages);
//        for (MCOIMAPMessage *message in fetchedMessages) {
//            MCOMessageHeader *header = message.header;
//            NSLog(@"header is:%@", header);
//        }
//    }];
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
