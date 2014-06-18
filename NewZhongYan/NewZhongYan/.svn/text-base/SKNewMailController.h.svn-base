//
//  SKNewMailController.h
//  NewZhongYan
//
//  Created by lilin on 13-11-4.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTokenField.h"
#import "SKToken.h"
#import "SKPlaceholderTextView.h"
typedef enum {
    NewMailStatusWrite,
    NewMailStatusRespond,
    NewMailStatusRespondAll,
    NewMailStatusForwad,
    NewMailStatusFromDraft,
} NewMailStatus;
@interface SKNewMailController : UIViewController
<SKTokenFieldDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIWebViewDelegate>
{
    
}
@property(nonatomic,retain)SKTokenField* toTokenField;
@property(nonatomic,retain)SKTokenField* CCTokenField;
@property(nonatomic,retain)SKTokenField* BCCTokenField;
@property(nonatomic,retain)UITextField*  STokenField;
@property(nonatomic,retain)SKPlaceholderTextView * messageView;
@property(nonatomic,retain)SKPlaceholderTextView *inputTextView;
@property(nonatomic,strong)NSString*   draftID;
@property(nonatomic,assign)NewMailStatus status;
@property(nonatomic,strong)UIWebView *contentWebView;
@property(nonatomic,strong)NSDictionary *dataDictionary;
@property(nonatomic,strong)NSString *messageID;
@property(nonatomic,strong)NSString *personalInfo;
@property(nonatomic,strong)NSString *originalInfo;
@property(nonatomic,strong)NSString *attachments;
@property(nonatomic,strong)NSString *contentText;
@property BOOL isDraftWrittenBySelf;
@property BOOL isOpen;
@end
