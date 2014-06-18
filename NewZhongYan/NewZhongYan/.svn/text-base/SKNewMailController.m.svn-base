//
//  SKNewMailController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-4.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKNewMailController.h"
#import "SKLToolBar.h"
#import "SKAttachButton.h"
#import "SKAddressController.h"
#import "SKViewController.h"
#import "SKAttachManger.h"
#import "DataServiceURLs.h"
#define FIELDHEIGHT 46
#define CELLHEIGHT 42
@interface SKNewMailController ()
{
    SKLToolBar* myToolBar;
    __weak IBOutlet UIView *toolView;
    __weak IBOutlet UIScrollView *scrollView;
    BWStatusBarOverlay* statusBar;
    UITableView  *_resultsTable;
    NSMutableArray *_resultsArray;
    NSMutableArray   *attachmentItem;
    
    BOOL        isHaveDraft;
    CGFloat     keyboardHeight;
    CGFloat     resultTableY;
    
    UIView* toHorisonline;
    UIView* ccHorisonline;
    UIView* bccHorisonline;
    UIView* sHorisonline;
    SKPlaceholderTextView  *messageView;
    SKPlaceholderTextView  *personalInfoTextView;
    SKTokenField* CurTokenField;
}
@end

@implementation SKNewMailController
@synthesize toTokenField,CCTokenField,BCCTokenField,STokenField,messageView;

-(void)handleTapForHelpImage:(UIGestureRecognizer*)recognizer
{
    if (recognizer.state==UIGestureRecognizerStateEnded)
    {
        UIImageView* helpImage = (UIImageView*)[self.view.window viewWithTag:1111];
        [helpImage fallOut:.4 delegate:nil completeBlock:^{
            [helpImage performSelector:@selector(removeFromSuperview) withObject:0 afterDelay:0.4];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }] ;
    }
}

- (IBAction)help:(UIButton *)sender {
    UIImageView* helpImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [helpImage setImage:[UIImage imageNamed:IS_IPHONE_5? @"iphone5_email_edit" : @"iphone4_email_edit"]];
    [helpImage setUserInteractionEnabled:YES];
    [helpImage setTag:1111];
    [self.view.window addSubview:helpImage];
    
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapForHelpImage:)];
    [helpImage addGestureRecognizer:tapGes];
    [helpImage fallIn:.4 delegate:nil completeBlock:^{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }];
}


-(void)back:(id)sender
{
    if (toTokenField.tokenFieldText.length > 0 || STokenField.text.length > 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"废弃"
                                                        otherButtonTitles:@"保存草稿",nil];
        actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
        [actionSheet showInView:self.view];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)//删除
	{
        [self deleteEmailFromDraft];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (buttonIndex == 1){//保存
        [self saveEmailtoDB];
        [self.navigationController popViewControllerAnimated:YES];
    }
    //这里的释放还有疑问
    [actionSheet setDelegate:nil];
}

-(void)praseAttachmentItem
{
    attachmentItem = [[NSMutableArray alloc] init];
    NSString* attachmentString;
    if (_status==NewMailStatusFromDraft)
    {
        attachmentString = _attachments;
    }
    else
    {
        attachmentString = [self.dataDictionary objectForKey:@"ATTACHMENTS"];
    }
    NSArray* tmp = [attachmentString componentsSeparatedByString:@","];
    for (__strong NSString* string in tmp) {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\"[]"]];
        [attachmentItem addObject:string];
    }
}

-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

//获取联系人的名字字符串
-(NSString*)recipient
{
    NSString* sql;
    NSArray* array = [toTokenField.tokenFieldText componentsSeparatedByString:@","];
    NSString* recipient = [NSString string];;
    for (NSString* mailstr in array)
    {
        if (mailstr.length > 0)
        {
            sql = [NSString stringWithFormat:@"select CNAME from T_EMPLOYEE WHERE EMAIL = '%@';",mailstr];
            NSString* name = [[DBQueue sharedbQueue] stringFromSQL:sql ];
            if (!name)
            {
                name = mailstr;
            }
            recipient = [recipient stringByAppendingFormat:@"%@ ",name];
        }
    }
    return recipient;
}

-(void)addAttachEmail
{
    [UIAlertView showAlertString:@"该功能稍后推出,尽请期待..."];
}
//将\n转换成br
-(NSString *)transformEnterToBr:(NSString *)inputStr
{
    return [inputStr stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
}

//发送邮件之前检查邮件基本信息是否完善
-(BOOL)isEmailComplete
{
    if(toTokenField.tokenFieldText.length <= 0){
        [UIAlertView showAlertString:@"收件箱为空..."];
        return NO;
    }
    
    NSString *toStr=toTokenField.tokenFieldText;
    NSArray *toArray=[toStr componentsSeparatedByString:@","];
    for (int i=0;i<toArray.count-1;i++)
    {
        NSString *str=[toArray objectAtIndex:i];
        if (![self isValidateEmail:str])
        {
            [UIAlertView showAlertString:@"请输入正确的邮箱地址"];
            return NO;
        }
    }
    if (toTokenField.text&&![toTokenField.text isEqualToString:@""]&&![toTokenField.text isEqualToString:@"\u200B"])
    {
        if (![self isValidateEmail:toTokenField.text])
        {
            [UIAlertView showAlertString:@"请输入正确的邮箱地址"];
            return NO;
        }
    }
    
    if (!STokenField.text || STokenField.text.length <= 0){
        [UIAlertView showAlertString:@"请输入主题..."];return NO;
    }
    return YES;
}

-(NSString *)originalMailInfo
{
    NSString *sender=[_dataDictionary objectForKey:@"SENDER"];
    NSString *sendTime=[_dataDictionary objectForKey:@"SENTDATE"];
    NSString *reciever=[_dataDictionary objectForKey:@"TO_LIST"];
    reciever=[reciever stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    reciever=[reciever stringByReplacingOccurrencesOfString:@">" withString:@"&gt;,"];
    NSString *title=[_dataDictionary objectForKey:@"SUBJECT"];
    NSString *resultStr=[NSString stringWithFormat:@"<div style=\"padding: 2px 0px; font-family: Arial Narrow; font-size: 12px;\">------------------&nbsp;原始邮件&nbsp;------------------</div><div style=\"background: rgb(239, 239, 239); padding: 8px; font-size: 12px;\"><div><b>发件人:</b>&nbsp;\"%@\"</div><div><b>发送时间:</b>&nbsp;%@</div><div><b>收件人:</b>&nbsp;</div><div>%@</div><div><b>主题:</b>&nbsp;%@</div></div><div><br></div>",sender,sendTime,reciever,title];
    return resultStr;
}

-(NSString *)contentString
{
    NSString *mailPath=[[FileUtils documentPath] stringByAppendingPathComponent:@"mail"];
    NSString *contentPath=[[mailPath stringByAppendingPathComponent:_messageID] stringByAppendingPathComponent:@"CONTENT"];
    NSString *resultStr=[NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:0];
    return resultStr;
}

-(void)insertEmailToOutBox
{
    if (self.draftID)
    {
        [self deleteEmailFromDraft];
    }
    NSString* sql;
    //是自己写的邮件
    if (_status==NewMailStatusWrite)
    {
        sql = [NSString stringWithFormat:@"INSERT INTO T_OUTBOX (OWUID,TO_LIST,CC_LIST,BCC_LIST,SUBJECT,CONTENT,STATE,TO_TEXT,PERSONALINFO,ISWRITTENBYSELF) VALUES ('%@','%@','%@','%@','%@','%@','%d','%@','%@','1');",
               [APPUtils userUid],
               toTokenField.tokenFieldText,
               CCTokenField.tokenFieldText,
               BCCTokenField.tokenFieldText,
               STokenField.text ? STokenField.text : @"",
               messageView.text,
               1,[self recipient],
               personalInfoTextView.text?personalInfoTextView.text:@""];
    }
    //是来自于草稿箱的邮件
    else if(_status==NewMailStatusFromDraft)
    {
        //如果来自于草稿箱的邮件是自己写的邮件
        if (_isDraftWrittenBySelf)
        {
            sql = [NSString stringWithFormat:@"INSERT INTO T_OUTBOX (OWUID,TO_LIST,CC_LIST,BCC_LIST,SUBJECT,CONTENT,STATE,TO_TEXT,PERSONALINFO,ISWRITTENBYSELF) VALUES ('%@','%@','%@','%@','%@','%@','%d','%@','%@','1');",
                   [APPUtils userUid],
                   toTokenField.tokenFieldText,
                   CCTokenField.tokenFieldText,
                   BCCTokenField.tokenFieldText,
                   STokenField.text ? STokenField.text : @"",
                   messageView.text,
                   1,[self recipient],
                   personalInfoTextView.text?personalInfoTextView.text:@""];
        }
        //如果来自于草稿箱的邮件不是自己写的邮件
        else
        {
            sql = [NSString stringWithFormat:@"INSERT INTO T_OUTBOX (OWUID,TO_LIST,CC_LIST,BCC_LIST,SUBJECT,CONTENT,STATE,TO_TEXT,MESSAGEID,ORIGINALINFO,PERSONALINFO,ATTACHMENTS,ISWRITTENBYSELF) VALUES ('%@','%@','%@','%@','%@','%@','%d','%@','%@','%@','%@','%@','0');",
                   [APPUtils userUid],
                   toTokenField.tokenFieldText,
                   CCTokenField.tokenFieldText,
                   BCCTokenField.tokenFieldText,
                   STokenField.text ? STokenField.text : @"",
                   messageView.text,
                   1,
                   [self recipient],
                   _messageID,
                   _originalInfo,
                   personalInfoTextView.text?personalInfoTextView.text : @"",
                   _attachments
                   ];
        }
        
    }
    else//如果时来自于回复，转发的邮件
    {
        sql = [NSString stringWithFormat:@"INSERT INTO T_OUTBOX (OWUID,TO_LIST,CC_LIST,BCC_LIST,SUBJECT,CONTENT,STATE,TO_TEXT,MESSAGEID,ORIGINALINFO,PERSONALINFO,ATTACHMENTS,ISWRITTENBYSELF) VALUES ('%@','%@','%@','%@','%@','%@','%d','%@','%@','%@','%@','%@','0');",
               [APPUtils userUid],
               toTokenField.tokenFieldText,
               CCTokenField.tokenFieldText,
               BCCTokenField.tokenFieldText,
               STokenField.text ? STokenField.text : @"",
               _inputTextView.text? _inputTextView.text : @"",
               1,[self recipient],
               _messageID,
               [self originalMailInfo],
               personalInfoTextView.text?personalInfoTextView.text : @"",
               [_dataDictionary objectForKey:@"ATTACHMENTS"]
               ];
    }
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
}

//两种情况:
//草稿发送成功删除草稿
//草稿退出时不保存草稿
-(void)deleteEmailFromDraft
{
    NSString *sql  = [NSString stringWithFormat:@"delete from T_DRAFT where ID = '%@'",self.draftID];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
}

//两种情况:
//草稿发送失败保存
//草稿退出时保存草稿
-(void)saveEmailtoDB
{
    NSString* sql;
    if (self.draftID)
    {
        if (_isDraftWrittenBySelf)
        {
            sql = [NSString stringWithFormat:
                   @"update T_DRAFT set OWUID = '%@',TO_LIST = '%@',CC_LIST= '%@',BCC_LIST = '%@',SUBJECT = '%@',CONTENT= '%@',TO_TEXT = '%@',PERSONALINFO='%@' where ID = '%@';",
                   [APPUtils userUid],
                   toTokenField.tokenFieldText,
                   CCTokenField.tokenFieldText,
                   BCCTokenField.tokenFieldText,
                   STokenField.text ? STokenField.text : @"",
                   messageView.text,
                   [self recipient],
                   personalInfoTextView.text?personalInfoTextView.text:@"",
                   self.draftID];
        }
        else
        {
            sql = [NSString stringWithFormat:
                   @"update T_DRAFT set OWUID = '%@',TO_LIST = '%@',CC_LIST= '%@',BCC_LIST = '%@',SUBJECT = '%@',CONTENT= '%@',TO_TEXT = '%@',MESSAGEID='%@',PERSONALINFO='%@' where ID = '%@';",
                   [APPUtils userUid],
                   toTokenField.tokenFieldText,
                   CCTokenField.tokenFieldText,
                   BCCTokenField.tokenFieldText,
                   STokenField.text ? STokenField.text : @"",
                   _inputTextView.text,
                   [self recipient],
                   _messageID,
                   personalInfoTextView.text?personalInfoTextView.text:@"",
                   self.draftID
                   ];
        }
        
    }else
    {
        if (_status==NewMailStatusWrite)
        {
            sql = [NSString stringWithFormat:@"INSERT INTO T_DRAFT (OWUID,TO_LIST,CC_LIST,BCC_LIST,SUBJECT,CONTENT,TO_TEXT,PERSONALINFO,ISWRITTENBYSELF) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','1');",
                   [APPUtils userUid],
                   toTokenField.tokenFieldText,
                   CCTokenField.tokenFieldText,
                   BCCTokenField.tokenFieldText,
                   STokenField.text ? STokenField.text : @"",
                   messageView.text,
                   [self recipient],
                   personalInfoTextView.text?personalInfoTextView.text:@""];
        }
        else
        {
            sql = [NSString stringWithFormat:@"INSERT INTO T_DRAFT (OWUID,TO_LIST,CC_LIST,BCC_LIST,SUBJECT,CONTENT,TO_TEXT,MESSAGEID,ORIGINALINFO,PERSONALINFO,ATTACHMENTS,ISWRITTENBYSELF) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','0');",
                   [APPUtils userUid],
                   toTokenField.tokenFieldText,
                   CCTokenField.tokenFieldText,
                   BCCTokenField.tokenFieldText,
                   STokenField.text ? STokenField.text : @"",
                   _inputTextView.text?_inputTextView.text : @"",
                   [self recipient],
                   _messageID,
                   [self originalMailInfo],
                   personalInfoTextView.text?personalInfoTextView.text : @"",
                   [_dataDictionary objectForKey:@"ATTACHMENTS"]
                   ];
        }
        
    }
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
}

-(void)mailDidSendSuccess{
    dispatch_async(dispatch_get_main_queue(), ^{
        [statusBar showSuccessWithMessage:@"邮件发送成功" duration:1 animated:1];
    });
    SKViewController* controller = [APPUtils AppRootViewController];
    [controller.navigationController popViewControllerAnimated:YES];
}

-(void)sendEmail:(id)sender
{
    static unsigned long long sentsize = 0;
    if (![self isEmailComplete]) return;
    [toTokenField resignFirstResponder];[CCTokenField resignFirstResponder];
    [BCCTokenField resignFirstResponder]; [STokenField resignFirstResponder];
    SKFormDataRequest *postMailRequest;
    if (attachmentItem.count>1) {
        postMailRequest =
        [SKFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/mail/send/attrs",ZZZobt]]];
    }
    else
    {
        postMailRequest =
        [SKFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/mail/send",ZZZobt]]];
    }
    
    [postMailRequest setPostValue:[APPUtils userUid] forKey:@"userid"];
    [postMailRequest setPostValue:[APPUtils userPassword]  forKey:@"password"];
    [postMailRequest setPostValue:toTokenField.tokenFieldText  forKey:@"to"];
    [postMailRequest setPostValue:CCTokenField.tokenFieldText   forKey:@"cc"];
    [postMailRequest setPostValue:BCCTokenField.tokenFieldText   forKey:@"bcc"];
    [postMailRequest setPostValue:STokenField.text  forKey:@"subject"];
    [postMailRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    if (_status==NewMailStatusWrite) //新建邮件
    {
        [postMailRequest setPostValue:messageView.text forKey:@"content"];
        [postMailRequest addPostValue:[self transformEnterToBr:personalInfoTextView.text] forKey:@"content"];
    }
    else                            //转发回复
    {    //如果带有附件
        if (attachmentItem.count>1)
        {
            for (int i=1;i<attachmentItem.count;i++)
            {
                NSString *attachString=[attachmentItem objectAtIndex:i];
                NSString *mailPath=[[FileUtils documentPath] stringByAppendingPathComponent:@"mail"];
                NSString *attachPath=[[mailPath stringByAppendingPathComponent:_messageID] stringByAppendingPathComponent:attachString];
                if ([[NSFileManager defaultManager] fileExistsAtPath:attachPath])
                {
                    //如果是第一个附件（attachmentItem中的第一个是content 这里指第一个附件）
                    if (i==1)
                    {
                        [postMailRequest setFile:attachPath forKey:@"attaList"];
                    }
                    else
                    {
                        [postMailRequest addFile:attachPath forKey:@"attaList"];
                    }
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [BWStatusBarOverlay showMessage:@"请完全收取这封邮件后再发送" duration:1.5 animated:YES];
                    });
                    return;
                }
            }
            
        }
        [postMailRequest setPostValue:[self transformEnterToBr:_inputTextView.text] forKey:@"content"];
        [postMailRequest addPostValue:[self originalMailInfo] forKey:@"content"];
        [postMailRequest addPostValue:[self contentString] forKey:@"content"];
        [postMailRequest addPostValue:@"<br>" forKey:@"content"];
        [postMailRequest addPostValue:[self transformEnterToBr:personalInfoTextView.text] forKey:@"content"];
    }
    
    //[postMailRequest setPostValue:messageView.text   forKey:@"content"];
    [postMailRequest setPostValue:@"false"   forKey:@"receipt"];
    
    [postMailRequest setStartedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            sentsize = 0;
            [statusBar showLoadingWithMessage:@"邮件正在发送..." animated:YES];
        });
        
    }];
    
    [postMailRequest  setBytesSentBlock:^(unsigned long long size,unsigned long long total){
        dispatch_async(dispatch_get_main_queue(), ^{
            sentsize += size;
            [statusBar setProgress:sentsize/(float)total animated:YES];
            [statusBar setMessage:[NSString stringWithFormat:@"正在发送邮件%.0f%%",sentsize/(float)total * 100] animated:NO];
            
        });
    }];
    
    __weak SKFormDataRequest* request = postMailRequest;
    [postMailRequest setCompletionBlock:^{
        [statusBar dismissAnimated:YES];
        if (request.responseStatusCode != CONNECTIONSUCCEED) {
            [BWStatusBarOverlay showMessage:@"网络异常请联系供应商" duration:1.5 animated:YES];
            [UIAlertView showAlertString:@"网络异常请联系供应商"];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
            return;
        }
        
        //发送成功 存到发件箱 并后退
        if ([request.responseString isEqualToString:@"您的邮件已成功发送"])
        {
            [self insertEmailToOutBox];
        }else{
            [self saveEmailtoDB];
        }
        [self performSelector:@selector(mailDidSendSuccess) withObject:0 afterDelay:1.5];
    }];
    
    [postMailRequest setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [statusBar showSuccessWithMessage:@"邮件发送失败" duration:1 animated:1];
        });
        [self saveEmailtoDB];
        SKViewController* controller = [APPUtils AppRootViewController];
        [controller.navigationController popViewControllerAnimated:YES];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }];
    [postMailRequest startAsynchronous];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

-(void)createToolBar
{
    myToolBar = [[SKLToolBar alloc] initWithFrame:CGRectMake(0,0,320,49)];
    [myToolBar setFirstItem:@"btn_sendmail_ecm"   Title:@"发送"];
    [myToolBar setSecondItem:@"btn_abandon_ecm" Title:@"废弃"];
    [myToolBar setThirdItem:@"btn_attachments_ecm"    Title:@"附件"];
    [myToolBar.firstButton  addTarget:self action:@selector(sendEmail:)  forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.secondButton addTarget:self action:@selector(back:)   forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.thirdButton  addTarget:self action:@selector(addAttachEmail) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:myToolBar];
    [self.view bringSubviewToFront:toolView];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
	CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardHeight = keyboardRect.size.height > keyboardRect.size.width ? keyboardRect.size.width : keyboardRect.size.height;
    [UIView animateWithDuration:[duration floatValue] animations:^{
        [UIView setAnimationCurve:[curve intValue]];
        [scrollView setFrame:CGRectMake(0, TopY, 320, self.view.bounds.size.height - keyboardHeight - TopY - 49)];
        [_resultsTable setFrame:CGRectMake(0, _resultsTable.frame.origin.y, 320,
                                           scrollView.bounds.size.height -  _resultsTable.frame.origin.y)];
        CGRect toolbarRect=toolView.frame;
        toolbarRect.origin.y = CGRectGetMaxY(scrollView.frame);
        toolView.frame=toolbarRect;
        [self.view bringSubviewToFront:toolView];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    [UIView animateWithDuration:[duration floatValue] animations:^{
        [UIView setAnimationCurve:[curve intValue]];
        [scrollView setFrame:CGRectMake(0, TopY, 320, self.view.bounds.size.height - TopY - 49)];
        [_resultsTable setFrame:CGRectMake(0, _resultsTable.frame.origin.y, 320,
                                           scrollView.bounds.size.height -  _resultsTable.frame.origin.y)];
        CGRect toolbarRect=toolView.frame;
        toolbarRect.origin.y=BottomY - 49;
        toolView.frame=toolbarRect;
    }];
}

-(void)addPerson:(NSNotification*)aNotification
{
    NSArray *arr=[[aNotification userInfo] objectForKey:@"employee"];
    for (NSDictionary *responseDict in arr)
    {
        SKToken* token = [[SKToken alloc] initWithTitle:[responseDict objectForKey:@"CNAME"]
                                      representedObject:[responseDict objectForKey:@"EMAIL"]];
        if (![CurTokenField.tokenObjects containsObject:[responseDict objectForKey:@"EMAIL"]]) {
            [CurTokenField addToken:token];
        }else{
            CurTokenField.text = @"";
        }
        [CurTokenField layoutTokensAnimated:NO];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _draftID = nil;
        _resultsArray = [[NSMutableArray alloc] init];
        toTokenField = [[SKTokenField alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        CCTokenField = [[SKTokenField alloc] initWithFrame:CGRectMake(0, toTokenField.frame.origin.y + FIELDHEIGHT, 320, 44)];
        BCCTokenField = [[SKTokenField alloc] initWithFrame:CGRectMake(0,CCTokenField.frame.origin.y + FIELDHEIGHT, 320, 44)];
        STokenField = [[SKTextField alloc] initWithFrame:CGRectMake(0, BCCTokenField.frame.origin.y + FIELDHEIGHT, 320, 44)];
        messageView = [[SKPlaceholderTextView alloc] initWithFrame:CGRectMake(0, STokenField.frame.origin.y + FIELDHEIGHT, 320, 237)];
    }
    return self;
}

-(void)addTokenWithString:(NSString *)str
{
    //如果只有邮箱
    if([str rangeOfString:@"<"].location==NSNotFound)
    {
        SKToken* token = [[SKToken alloc] initWithTitle:str
                                      representedObject:str];
        if (![toTokenField.tokenObjects containsObject:str]) {
            [CurTokenField addToken:token];
        }else{
            CurTokenField.text = @"";
        }
    }//既有邮箱又有姓名
    else
    {
        NSString *name=[[str componentsSeparatedByString:@"<"] objectAtIndex:0];
        
        NSString *representedObject=[[[str componentsSeparatedByString:@"<"] objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@">"]];
        SKToken* token = [[SKToken alloc] initWithTitle:name
                                      representedObject:representedObject];
        if (![toTokenField.tokenObjects containsObject:representedObject]) {
            [toTokenField addToken:token];
        }else{
            CurTokenField.text = @"";
        }
    }
}

-(void)initData
{
     statusBar =  [[BWStatusBarOverlay alloc] init];
    
    if (_status==NewMailStatusRespond || _status==NewMailStatusRespondAll ||_status==NewMailStatusForwad)
    {
        [self praseAttachmentItem];
        _messageID=[[NSString alloc] initWithString:[self.dataDictionary objectForKey:@"MESSAGEID"]];
    }
    else if(_status==NewMailStatusFromDraft&&!_isDraftWrittenBySelf)
    {
        [self praseAttachmentItem];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addPerson:)
                                                 name:@"EmailContact"
                                               object:nil];
    
    switch (_status) {
        case NewMailStatusForwad:
            STokenField.text=[NSString stringWithFormat:@"转发:%@",[_dataDictionary objectForKey:@"SUBJECT"]];
            break;
        case NewMailStatusRespond:
        {
            NSString *sender=[_dataDictionary objectForKey:@"SENDER"];
            [self addTokenWithString:sender];
            STokenField.text=[NSString stringWithFormat:@"回复:%@",[_dataDictionary objectForKey:@"SUBJECT"]];
            break;
        }
        case NewMailStatusRespondAll:
        {
            NSString *sender=[_dataDictionary objectForKey:@"SENDER"];
            [self addTokenWithString:sender];
            NSString *toList=[_dataDictionary objectForKey:@"TO_LIST"];
            for (NSString *str in [toList componentsSeparatedByString:@","])
            {
                [self addTokenWithString:str];
            }
            STokenField.text=[NSString stringWithFormat:@"回复:%@",[_dataDictionary objectForKey:@"SUBJECT"]];
            break;
        }
        case NewMailStatusFromDraft:
        {
            if (!_isDraftWrittenBySelf) {
                _inputTextView.text=_contentText;
            }
            break;
        }
        default:
            break;
            
    }
}

-(UIView *)createHorizonalLine:(float)lineWidth
{
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, lineWidth, 1)];
    [v setBackgroundColor:[UIColor lightGrayColor]];
    return v;
}

-(void)showContactsPicker:(UIButton*)btn{
    [self performSegueWithIdentifier:@"addperson" sender:self];
}

-(void)createNewMailView
{
    {
        [toTokenField setFrame:CGRectMake(0, 0, 320, 44 * toTokenField.numberOfLines)];
        toTokenField.tag = 0;
        [toTokenField setKeyboardType:UIKeyboardTypeASCIICapable];
        toTokenField.removesTokensOnEndEditing = NO;
        [toTokenField addTarget:self action:@selector(tokenFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
        [toTokenField addTarget:self action:@selector(tokenFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        [toTokenField addTarget:self action:@selector(tokenFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
        [toTokenField addTarget:self action:@selector(tokenFieldWillChangedEditState:) forControlEvents:UIControlEventEditingDidBegin];
        [toTokenField addTarget:self action:@selector(tokenFieldWillChangedEditState:) forControlEvents:UIControlEventEditingDidEnd];
        [toTokenField addTarget:self action:@selector(tokenFieldFrameWillChange:)forControlEvents:(UIControlEvents)SKTokenFieldControlEventFrameWillChange];
        [toTokenField addTarget:self action:@selector(tokenFieldFrameDidChange:) forControlEvents:(UIControlEvents)SKTokenFieldControlEventFrameDidChange];
        [toTokenField setTokenizingCharacters:[NSCharacterSet characterSetWithCharactersInString:@",;，；。"]];
        [toTokenField setDelegate:self];
        UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [addButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
        [toTokenField setRightView:addButton];
        [toTokenField setPromptText:@"收件人:"];
        [scrollView addSubview:toTokenField];
        toHorisonline = [self createHorizonalLine:320];
        [toHorisonline setFrame:CGRectMake(0, toTokenField.frame.size.height + 1, 320, 0.5)];
        [scrollView addSubview:toHorisonline];
    }
    
  
    {
        [CCTokenField setFrame:CGRectMake(0,toTokenField.frame.origin.y + toTokenField.frame.size.height + 2, 320, 44)];
        CCTokenField.tag = 1;
        [CCTokenField setKeyboardType:UIKeyboardTypeASCIICapable];
        CCTokenField.removesTokensOnEndEditing = NO;
        [CCTokenField addTarget:self action:@selector(tokenFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
        [CCTokenField addTarget:self action:@selector(tokenFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        [CCTokenField addTarget:self action:@selector(tokenFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
        [CCTokenField addTarget:self action:@selector(tokenFieldWillChangedEditState:) forControlEvents:UIControlEventEditingDidBegin];
        [CCTokenField addTarget:self action:@selector(tokenFieldWillChangedEditState:) forControlEvents:UIControlEventEditingDidEnd];
        [CCTokenField addTarget:self action:@selector(tokenFieldFrameWillChange:)forControlEvents:(UIControlEvents)SKTokenFieldControlEventFrameWillChange];
        [CCTokenField addTarget:self action:@selector(tokenFieldFrameDidChange:) forControlEvents:(UIControlEvents)SKTokenFieldControlEventFrameDidChange];
        [CCTokenField setTokenizingCharacters:[NSCharacterSet characterSetWithCharactersInString:@",;，；。"]];
        [CCTokenField setDelegate:self];
        UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [addButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
        [CCTokenField setRightView:addButton];
        [CCTokenField setPromptText:@"抄送:"];
        [scrollView addSubview:CCTokenField];
        
        ccHorisonline = [self createHorizonalLine:320];
        [ccHorisonline setFrame:CGRectMake(0, CCTokenField.frame.origin.y+CCTokenField.frame.size.height+1, 320, 0.5)];
        [scrollView addSubview:ccHorisonline];
    }
    
    {
        [BCCTokenField setFrame:CGRectMake(0,CCTokenField.frame.origin.y + CCTokenField.frame.size.height + 2, 320, 44)];
        BCCTokenField.tag = 2;
        [BCCTokenField setKeyboardType:UIKeyboardTypeASCIICapable];
        BCCTokenField.removesTokensOnEndEditing = NO;
        [BCCTokenField addTarget:self action:@selector(tokenFieldDidBeginEditing:) forControlEvents:UIControlEventEditingDidBegin];
        [BCCTokenField addTarget:self action:@selector(tokenFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        [BCCTokenField addTarget:self action:@selector(tokenFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
        [BCCTokenField addTarget:self action:@selector(tokenFieldWillChangedEditState:) forControlEvents:UIControlEventEditingDidBegin];
        [BCCTokenField addTarget:self action:@selector(tokenFieldWillChangedEditState:) forControlEvents:UIControlEventEditingDidEnd];
        [BCCTokenField addTarget:self action:@selector(tokenFieldFrameWillChange:) forControlEvents:(UIControlEvents)SKTokenFieldControlEventFrameWillChange];
        [BCCTokenField addTarget:self action:@selector(tokenFieldFrameDidChange:) forControlEvents:(UIControlEvents)SKTokenFieldControlEventFrameDidChange];
        [BCCTokenField setTokenizingCharacters:[NSCharacterSet characterSetWithCharactersInString:@",;，；。"]];
        [BCCTokenField setDelegate:self];
        UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [addButton addTarget:self action:@selector(showContactsPicker:) forControlEvents:UIControlEventTouchUpInside];
        [BCCTokenField setRightView:addButton];
        [BCCTokenField setPromptText:@"密送:"];
        [scrollView addSubview:BCCTokenField];
        
        bccHorisonline = [self createHorizonalLine:320];
        [bccHorisonline setFrame:CGRectMake(0, BCCTokenField.frame.origin.y+BCCTokenField.frame.size.height+1, 320, 0.5)];
        [scrollView addSubview:bccHorisonline];
    }
    
    {
        [STokenField setFrame:CGRectMake(0,BCCTokenField.frame.origin.y + BCCTokenField.frame.size.height + 2, 320, 44)];
        STokenField.tag = 3;
        STokenField.delegate = self;
        [STokenField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [STokenField setFont:[UIFont boldSystemFontOfSize:16]];
        [STokenField setLeftViewMode:UITextFieldViewModeAlways];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectZero];
        [label setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
        [label setText:@"  主题:"];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label sizeToFit];
        [STokenField setLeftView:label];
        [scrollView addSubview:STokenField];
        
        if (!(IS_IOS7)) {
            sHorisonline = [self createHorizonalLine:320];
            [sHorisonline setFrame:CGRectMake(0, STokenField.frame.origin.y+STokenField.frame.size.height+1, 320, 0.5)];
            [scrollView addSubview:sHorisonline];
        }        
    }
    
    {   //如果是自己写的邮件
        if(_status==NewMailStatusWrite||_isDraftWrittenBySelf)
        {
            [messageView setFrame:CGRectMake(0,STokenField.frame.origin.y + STokenField.frame.size.height + 2, 320, self.view.frame.size.height - STokenField.frame.origin.y - STokenField.frame.size.height -44)];
            [messageView setAutocorrectionType:UITextAutocorrectionTypeNo];
            [messageView setTag:4];
            [messageView setPlaceholder:@"邮件内容:"];
            [messageView setScrollEnabled:NO];
            [messageView setAutoresizingMask:UIViewAutoresizingNone];
            [messageView setDelegate:self];
            [messageView setFont:[UIFont systemFontOfSize:15]];
            [scrollView addSubview:messageView];
            
            CGRect newFrame=messageView.frame;
            UIView *pinfoLine = [self createHorizonalLine:320];
            [pinfoLine setFrame:CGRectMake(0,newFrame.origin.y+newFrame.size.height , 320, 0.5)];
            [scrollView addSubview:pinfoLine];
            
            personalInfoTextView=[[SKPlaceholderTextView alloc] initWithFrame:CGRectMake(0, newFrame.origin.y+newFrame.size.height+1, 320, 60)];
            NSString *userT;
            if ([APPUtils userTitle]&&![[APPUtils userTitle] isEqualToString:@""])
            {
                userT=[NSString stringWithFormat:@"(%@)",[APPUtils userTitle]];
            }
            else
            {
                userT=@"";
            }
            
            NSString *userM=[APPUtils userMobile]?[APPUtils userMobile]:@"";
            NSString *personalInfoStr=[NSString stringWithFormat:@"--\n%@  %@%@\n %@",[APPUtils userDepartmentName],[APPUtils userName],userT,userM];
            if (_status==NewMailStatusFromDraft&&!_isDraftWrittenBySelf) {
                personalInfoTextView.text=_personalInfo;
            }
            else
            {
                personalInfoTextView.text=personalInfoStr;
            }
            [scrollView addSubview:personalInfoTextView];
            [scrollView setContentSize:CGSizeMake(320,CGRectGetMaxY(personalInfoTextView.frame))];
        }
        else
        {
            //附件
            CGFloat curHeight = CGRectGetMaxY(STokenField.frame)+5;
            if ([attachmentItem count] > 1)
            {
                curHeight += 5;
                for (int i = 1; i < [attachmentItem count]; i++)
                {
                    if ([[attachmentItem objectAtIndex:i] length] < 1) {//可能要去掉
                        continue;
                    }
                    SKAttachButton* attachmentButton = [[SKAttachButton alloc] initWithFrame:CGRectMake(10, curHeight, 300, 48)];
                    [attachmentButton setTitle:[attachmentItem objectAtIndex:i] forState:UIControlStateNormal];
                    [scrollView addSubview:attachmentButton];
                    curHeight = curHeight + 48;
                }
            }
            UIView *inputLine = [self createHorizonalLine:320];
            [inputLine setFrame:CGRectMake(0, curHeight, 320, 0.5)];
            [scrollView addSubview:inputLine];
            //邮件内容
            _inputTextView=[[SKPlaceholderTextView alloc] initWithFrame:CGRectMake(0, curHeight+5, 320, 100)];
            [_inputTextView setPlaceholder:@"邮件内容"];
            [scrollView addSubview:_inputTextView];
            //content
            UIView *contentLine = [self createHorizonalLine:320];
            [contentLine setFrame:CGRectMake(0, curHeight+110, 320, 0.5)];
            [scrollView addSubview:contentLine];
            
            _contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(10, curHeight+111, 300,20)];
            [_contentWebView setTag:4];
            _contentWebView.delegate = self;
            UIScrollView* webScrollView =  (UIScrollView*)[[_contentWebView subviews] objectAtIndex:0];
            [webScrollView setBounces:NO];
            [scrollView addSubview:_contentWebView];
            [_contentWebView setBackgroundColor:[UIColor redColor]];
            [scrollView setContentSize:CGSizeMake(320,CGRectGetMaxY(_contentWebView.frame))];
            [self loadContentAttachment];
        }
    }
}

//该函数一般用于加载CONTENT
-(void)loadContentAttachment
{
    NSString* contentPath = [SKAttachManger mailAttachPath:_messageID attchName:@"CONTENT"];
    NSURL *URL = [DataServiceURLs mailAttcnURL:_messageID AttchName:@"CONTENT"];
    BOOL contentExisted = [SKAttachManger mailAttachExisted:self.messageID  attchName:@"CONTENT"];
    if (contentExisted)
    {
        NSString* string = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
        NSString *contentStr;
        if (_status==NewMailStatusFromDraft&&!_isDraftWrittenBySelf) {
            contentStr=[NSString stringWithFormat:@"%@%@",_originalInfo,string];
        }else{
            contentStr=[NSString stringWithFormat:@"%@%@",[self originalMailInfo],string];
        }
        [_contentWebView loadHTMLString:contentStr baseURL:0];
        return;
    }
    
    SKHTTPRequest* request = [SKHTTPRequest requestWithURL:URL];
    [request setDownloadDestinationPath:contentPath];
    __weak SKHTTPRequest* req = request;
    [request setCompletionBlock:^{
        if ([req responseStatusCode] != 200) {
            [ASIHTTPRequest removeFileAtPath:contentPath error:0];
        }
        NSString* contentstring = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
        NSString *contentStr;
        if (_status==NewMailStatusFromDraft&&!_isDraftWrittenBySelf) {
            contentStr=[NSString stringWithFormat:@"%@%@",_originalInfo,contentstring];
        }
        else
        {
            contentStr=[NSString stringWithFormat:@"%@%@",[self originalMailInfo],contentstring];
        }
        [_contentWebView loadHTMLString:contentStr baseURL:nil];
    }];
    [request setFailedBlock:^{
        [ASIHTTPRequest removeFileAtPath:contentPath error:0];
    }];
    [request startAsynchronous];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self createToolBar];
    [self createNewMailView];
    
    
    _resultsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [_resultsTable setSeparatorColor:[UIColor colorWithWhite:0.85 alpha:1]];
    [_resultsTable setBackgroundColor:[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1]];
    [_resultsTable setDelegate:self];
    [_resultsTable setDataSource:self];
    [scrollView addSubview:_resultsTable];
    [_resultsTable addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:0];
    
    UIButton* backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backbtn setFrame:CGRectMake(0, 0, 50, 30)];
    [backbtn setBackgroundImage:Image(@"back") forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)setSearchResultsVisible:(BOOL)visible{
    [_resultsTable setHidden:!visible];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self setSearchResultsVisible:_resultsArray.count];
    return _resultsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLHEIGHT;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentify = @"resultsCell";
    UITableViewCell* cell = [_resultsTable dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentify];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
    cell.textLabel.text =[[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"CNAME"];
    NSString* EMAIL = [[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"EMAIL"];
    if ([EMAIL isEqual:[NSNull null]]) {
        EMAIL = @"";
    }
    cell.detailTextLabel.text = EMAIL;
    
    NSString* UCNAME = [[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"UCNAME"];
    if ([UCNAME isEqual:[NSNull null]]) {
        UCNAME = @"";
    }
    UILabel* departmentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    departmentLabel.text = UCNAME;
    departmentLabel.font = [UIFont systemFontOfSize:14];
    [departmentLabel setBackgroundColor:[UIColor clearColor]];
    [departmentLabel sizeToFit];
    cell.accessoryView = departmentLabel;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_resultsArray.count) {
        return;
    }
    [_resultsTable deselectRowAtIndexPath:indexPath animated:YES];
    SKToken* token = [[SKToken alloc] initWithTitle:[[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"CNAME"]
                                  representedObject:[[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"EMAIL"]];
    
    if (![CurTokenField.tokenObjects containsObject:[[_resultsArray objectAtIndex:indexPath.row] objectForKey:@"EMAIL"]])
    {
        [CurTokenField addToken:token];
    }else{
        CurTokenField.text = @"";
    }
    [CurTokenField layoutTokensAnimated:NO];
    [self setSearchResultsVisible:NO];
    [scrollView setScrollEnabled:YES];
}

#pragma mark - tokenField代理
- (BOOL)tokenField:(SKTokenField *)tokenField willRemoveToken:(SKToken *)token {
	return YES;
}

- (void)tokenFieldWillChangedEditState:(SKTokenField *)aTokenField {
	[aTokenField setRightViewMode:(aTokenField.editing ? UITextFieldViewModeAlways : UITextFieldViewModeNever)];
}


- (void)tokenFieldDidBeginEditing:(SKTokenField *)field
{
    switch (field.tag)
    {
        case 0:
            CurTokenField = toTokenField;
            break;
        case 1:
            CurTokenField = CCTokenField;
            break;
        case 2:
            CurTokenField = BCCTokenField;
            break;
        default:
            break;
    }
    
}

- (void)tokenFieldDidEndEditing:(SKTokenField *)field
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (_resultsTable.isHidden) {
        [scrollView setScrollEnabled:YES];
    }else{
        [scrollView setScrollEnabled:NO];
    }
}

- (void)tokenFieldTextDidChange:(SKTokenField *)field
{
    
    NSString* keyString = [field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (keyString.length < 1){
        [_resultsArray removeAllObjects];
        [_resultsTable reloadData];
        return;
    }
    [scrollView bringSubviewToFront:_resultsTable];
    [_resultsTable setFrame:CGRectMake(0, CGRectGetMaxY(field.frame), 320, scrollView.bounds.size.height +scrollView.contentOffset.y -  CGRectGetMaxY(field.frame))];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* sql = [NSString stringWithFormat:@"SELECT E.CNAME,E.EMAIL,U.CNAME UCNAME FROM T_EMPLOYEE E,T_UNIT U ,T_ORGANIZATIONAL O WHERE E.UID = O.OID AND U.DPID = O.POID AND E.ENABLED = 1 AND (E.FNAME like '%@%%' or E.CNAME like '%@%%' or E.SNAME like '%@%%' or E.MOBILE like '%@%%' or E.EMAIL like '%@%%') order by E.SORTNO limit 50;",keyString,keyString,keyString,keyString,keyString];
        NSArray* array = [[NSArray alloc] initWithArray:[[DBQueue sharedbQueue] recordFromTableBySQL:sql]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_resultsArray setArray:array];
            [_resultsTable reloadData];
        });
    });

}

- (void)tokenFieldFrameWillChange:(SKTokenField *)field
{
    CGFloat tokenFieldBottom = CGRectGetMaxY(field.frame);
    CGFloat diff = 0;
    if (field == toTokenField) {
        diff  = tokenFieldBottom - toHorisonline.frame.origin.y - 1;
    }else if (field == CCTokenField){
        diff  = tokenFieldBottom - ccHorisonline.frame.origin.y - 1;
    }else if(field == BCCTokenField){
        diff  = tokenFieldBottom - bccHorisonline.frame.origin.y - 1;
    }
    
    for (UIView*view in scrollView.subviews) {
        if (view.frame.origin.y > field.frame.origin.y) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y + diff, view.frame.size.width, view.frame.size.height)];
        }
    }
    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height +diff)];
}

- (void)tokenFieldFrameDidChange:(SKTokenField *)field {
	//[self updateContentSize];
}

- (BOOL)textFieldShouldReturn:(SKTokenField *)field{
    if (field == toTokenField) {
        [CCTokenField becomeFirstResponder];
    }
    if (field == STokenField) {
        [field resignFirstResponder];
    }
    if (field == CCTokenField) {
        [BCCTokenField becomeFirstResponder];
    }
    if (field == BCCTokenField) {
        [STokenField becomeFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y) animated:YES];
}


#pragma mark webView代理
- (void)webViewDidFinishLoad:(UIWebView *) webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    float diff=actualSize.height-newFrame.size.height;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    
    UIView *pinfoLine = [self createHorizonalLine:320];
    [pinfoLine setFrame:CGRectMake(0,newFrame.origin.y+newFrame.size.height , 320, 0.5)];
    [scrollView addSubview:pinfoLine];
    
    personalInfoTextView=[[SKPlaceholderTextView alloc] initWithFrame:CGRectMake(0, newFrame.origin.y+newFrame.size.height+1, 320, 60)];
    NSString *userT;
    if ([APPUtils userTitle]&&![[APPUtils userTitle] isEqualToString:@""])
    {
        userT=[NSString stringWithFormat:@"(%@)",[APPUtils userTitle]];
    }
    else
    {
        userT=@"";
    }
    
    NSString *userM=[APPUtils userMobile]?[APPUtils userMobile]:@"";
    NSString *personalInfoStr=[NSString stringWithFormat:@"--\n%@  %@%@\n %@",[APPUtils userDepartmentName],[APPUtils userName],userT,userM];
    if (_status==NewMailStatusFromDraft&&!_isDraftWrittenBySelf) {
        personalInfoTextView.text=_personalInfo;
    }
    else
    {
        personalInfoTextView.text=personalInfoStr;
    }
    [scrollView addSubview:personalInfoTextView];
    CGSize scrollSize=[scrollView contentSize];
    scrollSize.height=scrollSize.height+diff+1+60;
    [scrollView setContentSize:scrollSize];
}

-(void)dealloc
{
    [_resultsTable removeObserver:self forKeyPath:@"hidden"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addperson"]) {
        SKAddressController *addresser = segue.destinationViewController;
        addresser.isMail = YES;
        [CurTokenField resignFirstResponder];
    }
}

@end
