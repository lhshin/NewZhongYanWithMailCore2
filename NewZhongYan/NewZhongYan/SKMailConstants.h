//
//  SKMailConstants.h
//  NewZhongYan
//
//  Created by 海升 刘 on 14-6-18.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#ifndef NewZhongYan_SKMailConstants_h
#define NewZhongYan_SKMailConstants_h

//存放imap文件夹的plist文件名
#define IMAP_FOLDER_PLIST @"imapFolders.plist"

//默认的文件夹,最后一个为本地文件夹
#define DEFAULT_FOLDERS_DICT @{@"INBOX": @"收件箱", @"&V4NXPpCuTvY-": @"垃圾邮件", @"&g0l6Pw-": @"草稿", @"&XfJT0ZABkK5O9g-": @"已发送邮件", @"&V4NXPnux-": @"垃圾箱", @"SENDBOX": @"发件箱"}

#define FOLDER_VERSION @"ver"

#define FOLDER_STATES_KEY @"folderStates"

#define FOLDER_PATH @"folderPath"

#define FOLDER_DISPLAY_NAME @"folderDisplayName"

#define UID_NEXT @"uidNext"

#define UID_VALIDITY @"uidValidity"

#define MODE_SEQUENCE_VALUE @"modeSequenceValue"

#define MESSAGE_COUNT @"messageCount"

#define RECENT_COUNT @"recentCount"

#define UNSEEN_COUNT @"unseenCount"

#define DEFAULT_MESSSAGE_NUM 50

#endif