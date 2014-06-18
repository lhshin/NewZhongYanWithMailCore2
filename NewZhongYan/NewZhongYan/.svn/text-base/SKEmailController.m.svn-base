//
//  SKEmalController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-1.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKEmailController.h"
#import "SKLToolBar.h"
#import "SKInboxCell.h"
#import "SKMessageEntity.h"
#import "SKMailDetailController.h"
#import "SKNewMailController.h"
#import "SKOutBoxCell.h"
#import "SKDraftboxCell.h"
@interface SKEmailController ()
{
    BOOL isRefresh;
    UIActionSheet* actionSheet;
    
}
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;


@end

@implementation SKEmailController
@synthesize dataArray = _dataArray;
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
    [helpImage setImage:[UIImage imageNamed:IS_IPHONE_5? @"iphone5_email" : @"iphone4_email"]];
    [helpImage setUserInteractionEnabled:YES];
    [helpImage setTag:1111];
    [self.view.window addSubview:helpImage];
    
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapForHelpImage:)];
    [helpImage addGestureRecognizer:tapGes];
    [helpImage fallIn:.4 delegate:nil completeBlock:^{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }];
}



- (IBAction)selectType:(UIButton *)sender {
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"我的邮箱"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"收件箱",@"发件箱",@"草稿箱",@"垃圾箱",nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];

}

-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:0];
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)actionSheet:(UIActionSheet *)as clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (selectedIndex == buttonIndex) {
        return;
    }
    selectedIndex = buttonIndex;
    switch (buttonIndex) {
        case 0:
        {
            [_titleButton setTitle:@"收件箱" forState:UIControlStateNormal];
            [self getMailFromDataBase];
            break;
        }
        case 1:
        {
            [_titleButton setTitle:@"发件箱" forState:UIControlStateNormal];
            [self getOutBoxMail];
            break;
        }
        case 2:
        {
            [_titleButton setTitle:@"草稿箱" forState:UIControlStateNormal];
            [self getDraftMail];
            break;
        }
        case 3:
        {
            [_titleButton setTitle:@"垃圾箱" forState:UIControlStateNormal];
            [self getTrashFromDataBase];
            break;
        }
        default:
            break;
    }
    [as setDelegate:nil];
}

-(void)setMailIsRead:(NSString *)MESSAGEID
{
    NSString *sql=[NSString stringWithFormat:@"update T_LOCALMESSAGE set ISREAD = 1 where MESSAGEID='%@'",MESSAGEID];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
}

//删除服务器已删除，而本地邮件还存在的功能 （完成这个操作的前提是，获取了服务器的邮件列表）
-(void)deleteEmailNotInServer
{
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from T_LOCALMESSAGE where ENABLED = 0;"];
}

//获取所有字符创的mesageid
-(NSString*)usrerid
{
    NSArray* array = [[DBQueue sharedbQueue] recordFromTableBySQL:@"SELECT MESSAGEID FROM T_LOCALMESSAGE;"];
    NSString* result = [NSString string];;
    for (NSDictionary* d in array) {
        result = [result stringByAppendingFormat:@",%@",[d objectForKey:@"MESSAGEID"]];
    }
    
    if (array.count >= 1) {
        result = [result substringFromIndex:1];
    }
    return result;
}

-(void)getMailFromDataBase
{
    NSString* sql = @"select * from T_LOCALMESSAGE where ENABLED = 1 AND STATUS = 0 order by SENTDATE desc;";
    [_dataArray setArray:[[DBQueue sharedbQueue] recordFromTableBySQL:sql]];
    [self.tableview reloadData];
}

-(void)getOutBoxMail
{
    NSString* sql = @"select * from T_OUTBOX ORDER BY SENTDATE DESC";
    [_dataArray setArray:[[DBQueue sharedbQueue] recordFromTableBySQL:sql]];
    [self.tableview reloadData];
}

-(void)getDraftMail
{
    NSString* sql = @"select * from T_DRAFT ORDER BY SENTDATE DESC";
    [_dataArray setArray:[[DBQueue sharedbQueue] recordFromTableBySQL:sql]];
    [self.tableview reloadData];
}

-(void)getTrashFromDataBase
{
    NSString* sql = @"select * from T_LOCALMESSAGE where STATUS = 1 order by SENTDATE desc;";
    [_dataArray setArray:[[DBQueue sharedbQueue] recordFromTableBySQL:sql]];
    [self.tableview reloadData];
}

-(void)getNewEmailFromServerCompleteBlock:(basicBlock)block
{
    if (isRefresh)  return;
    NSString* url = [NSString stringWithFormat:@"%@/users/mail/load/new",ZZZobt];
     SKFormDataRequest* Request = [SKFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    __weak SKFormDataRequest* request = Request;
    [Request setPostValue:[APPUtils userUid] forKey:@"userid"];
    [Request setPostValue:[APPUtils userPassword] forKey:@"password"];
    [Request setPostValue:[self usrerid] forKey:@"uidlist"];
    [Request setPostValue:@"10" forKey:@"count"];
    
    [Request setStartedBlock:^{
        isRefresh = YES;
    }];
    
    [Request setCompletionBlock:^{
        isRefresh = NO;
        SKMessageEntity* entity = [[SKMessageEntity alloc] initWithData:request.responseData];
        [[DBQueue sharedbQueue] insertDataToTableWithDataArray:entity LocalDataMeta:[LocalDataMeta sharedMail]];
        if (block) {
            block();
        }
    }];
    
    [Request setFailedBlock:^{
        isRefresh = NO;
        NSString* errormsg;
            if (3003 == request.errorcode) {
                errormsg = @"没有新的邮件";
            }else{
                errormsg = request.errorinfo;
            }
        dispatch_async(dispatch_get_main_queue(), ^{
            [BWStatusBarOverlay showMessage:errormsg duration:1 animated:1];
        });
        
        if (block) {
            block();
        }
    }];
    
    [Request startAsynchronous];
}

-(void)getMailFromDataBaseCompleteBlock:(basicBlock)block
{
    NSString* sql = @"select * from T_LOCALMESSAGE where ENABLED = 1 AND STATUS = 0 order by SENTDATE desc limit 50;";
    [_dataArray setArray:[[DBQueue sharedbQueue] recordFromTableBySQL:sql]];
    [self.tableview reloadData];
    if (block) {
        block();
    }
}


-(IBAction)getMoreEmailFromServer
{
    NSString* url = [NSString stringWithFormat:@"%@/users/mail/load/more",ZZZobt];
    SKFormDataRequest* request = [SKFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setPostValue:[APPUtils userUid] forKey:@"userid"];
    [request setPostValue:[APPUtils userPassword] forKey:@"password"];
    [request setPostValue:[self usrerid] forKey:@"uidlist"];
    [request setPostValue:[FileUtils valueFromPlistWithKey:@"EPSIZE"] forKey:@"count"];
    
    [request setStartedBlock:^{
        isRefresh = YES;
    }];
    
    __weak SKFormDataRequest* req = request;
    [request setCompletionBlock:^{
        isRefresh = NO;
        SKMessageEntity* entity = [[SKMessageEntity alloc] initWithData:req.responseData];
        [[DBQueue sharedbQueue] insertDataToTableWithDataArray:entity LocalDataMeta:[LocalDataMeta sharedMail]];
        [self getMailFromDataBase];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_dataArray.count - 2 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            [BWStatusBarOverlay showSuccessWithMessage:@"加载完成" duration:1 animated:1];
        });
    }];
    [request setFailedBlock:^{
        isRefresh = NO;
        if (3003 == req.errorcode ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [BWStatusBarOverlay showSuccessWithMessage:@"没有更多的的邮件" duration:1 animated:1];
            });
        }
    }];
    
    [request startAsynchronous];
}

-(void)writeEmail
{
    [self performSegueWithIdentifier:@"newmail" sender:self];
}

-(void)createToolBar
{
    SKLToolBar* myToolBar = [[SKLToolBar alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    [myToolBar setFirstItem:@"btn_newmail_ecm" Title:@"写信"];
    [myToolBar setSecondItem:@"btn_moremail_ecm" Title:@"更多"];
    [myToolBar setThirdItem:@"btn_refresh_ecm" Title:@"最新"];
    [myToolBar.firstButton  addTarget:self action:@selector(writeEmail)
                     forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.secondButton addTarget:self action:@selector(getMoreEmailFromServer)
                     forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.thirdButton  addTarget:self.tableview action:@selector(launchRefreshing)
                     forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:myToolBar];
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initData
{
    [self.tableview setHeaderOnly:YES];
    _dataArray = [[NSMutableArray alloc] init];
    if (System_Version_Small_Than_(7)) {
        UIButton* backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backbtn setFrame:CGRectMake(0, 0, 50, 30)];
        [backbtn setBackgroundImage:Image(@"back") forState:UIControlStateNormal];
        [backbtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
        self.navigationItem.leftBarButtonItem = backItem;
    }else{
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backItem;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self createToolBar];
    [self deleteEmailNotInServer];
    
    [self getMailFromDataBaseCompleteBlock:^{
        [self getNewEmailFromServerCompleteBlock:^{
            if (_dataArray.count == 0) {
                [self getMailFromDataBase];
            }
        }];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[_titleButton titleForState:UIControlStateNormal] isEqualToString:@"草稿箱"]) {
        [self getDraftMail];
    }
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView != (UIScrollView*)self.tableview) return;
    [self.tableview tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView != (UIScrollView*)self.tableview)   return;
    [self.tableview tableViewDidEndDragging:scrollView];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    if (selectedIndex) {
        [self.tableview performSelector:@selector(tableViewDidFinishedLoading) withObject:0 afterDelay:1];
        return;
    }
    if (!isRefresh) {
        [self getNewEmailFromServerCompleteBlock:^{
            [self getMailFromDataBase];
            [self.tableview tableViewDidFinishedLoading];
        }];
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex == 0) {
        static NSString *CellIdentifier = @"inboxCell";
        SKInboxCell *cell;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.parentController = self;
        [cell setMail:_dataArray[indexPath.row]];
        return cell;
    }else if (selectedIndex == 1){
        static NSString *CellIdentifier = @"outboxCell";
        SKOutBoxCell *cell;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.parentController = self;
        [cell setMail:_dataArray[indexPath.row]];
        return cell;
    }else if (selectedIndex == 2){
        static NSString *CellIdentifier = @"draftCell";
        SKDraftboxCell *cell;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.parentController = self;
        [cell setMail:_dataArray[indexPath.row]];
        return cell;

    }else if (selectedIndex == 3){
        static NSString *CellIdentifier = @"inboxCell";
        SKInboxCell *cell;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.parentController = self;
        [cell setMail:_dataArray[indexPath.row]];
        return cell;
    }
    return 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"emailDetail"]) {
        SKMailDetailController *mailItem = segue.destinationViewController;
        NSIndexPath *selectindexpath = [self.tableview indexPathForSelectedRow];
        NSMutableDictionary* dataDict = _dataArray[selectindexpath.row];
        mailItem.EmailDetailDictionary = dataDict;
        
        if (![[dataDict objectForKey:@"READED"] intValue])
        {
            [dataDict setObject:@"1" forKey:@"ISREAD"];
            [self.tableview reloadRowsAtIndexPaths:@[selectindexpath] withRowAnimation:UITableViewRowAnimationNone];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self setMailIsRead: _dataArray[selectindexpath.row][@"MESSAGEID"]];
            });
        }
        [self.tableview deselectRowAtIndexPath:selectindexpath animated:YES];
    }
    if ([[segue identifier] isEqualToString:@"newmail"]) {
        SKNewMailController *newMailItem = segue.destinationViewController;
        [newMailItem setStatus:NewMailStatusWrite];
    }
    if ([[segue identifier] isEqualToString:@"outboxDetail"]) {
        SKMailDetailController *aEmail = segue.destinationViewController;
        aEmail.isSend = YES;
        NSIndexPath *selectindexpath = [self.tableview indexPathForSelectedRow];
        aEmail.EmailDetailDictionary = _dataArray[selectindexpath.row];
        [self.tableview deselectRowAtIndexPath:selectindexpath animated:YES];
    }
    if ([[segue identifier] isEqualToString:@"draftDetail"]) {
        SKNewMailController *aEmail = segue.destinationViewController;
        NSIndexPath *selectindexpath = [self.tableview indexPathForSelectedRow];
        NSDictionary* mailinfo = [_dataArray objectAtIndex:selectindexpath.row];
        aEmail.draftID = [mailinfo objectForKey:@"ID"];
        [aEmail setStatus:NewMailStatusFromDraft];

        //to
        NSMutableArray* toArray =
        [NSMutableArray arrayWithArray:[[mailinfo objectForKey:@"TO_LIST"] componentsSeparatedByString:@","]];
        [toArray removeLastObject];
        for (NSString* mailstr in toArray)
        {
            NSString* name = [[DBQueue sharedbQueue] stringFromSQL:
                              [NSString stringWithFormat:@"select CNAME from T_EMPLOYEE WHERE EMAIL = '%@';",mailstr]];
            if (!name)
                name = mailstr;
            SKToken* token = [[SKToken alloc] initWithTitle:name
                                          representedObject:mailstr];
            [aEmail.toTokenField addToken:token];
        }
        [aEmail.toTokenField layoutTokensAnimated:NO];
        
        NSMutableArray* ccArray =
        [NSMutableArray arrayWithArray:[[mailinfo objectForKey:@"CC_LIST"] componentsSeparatedByString:@","]];
        [ccArray removeLastObject];
        if (ccArray.count > 0) {
            aEmail.isOpen = YES;
            
            for (NSString* mailstr in ccArray)
            {
                NSString* name = [[DBQueue sharedbQueue] stringFromSQL:
                                  [NSString stringWithFormat:@"select CNAME from T_EMPLOYEE WHERE EMAIL = '%@';",mailstr]];
                if (!name)
                    name = mailstr;
                SKToken* token = [[SKToken alloc] initWithTitle:name
                                              representedObject:mailstr];
                [aEmail.CCTokenField addToken:token];
            }
        }
        [aEmail.CCTokenField layoutTokensAnimated:NO];
        
        NSMutableArray* bccArray =
        [NSMutableArray arrayWithArray:[[mailinfo objectForKey:@"BCC_LIST"] componentsSeparatedByString:@","]];
        [bccArray removeLastObject];
        if (bccArray.count > 0) {
            aEmail.isOpen = YES;
            for (NSString* mailstr in bccArray)
            {
                NSString* name = [[DBQueue sharedbQueue] stringFromSQL:
                                  [NSString stringWithFormat:@"select CNAME from T_EMPLOYEE WHERE EMAIL = '%@';",mailstr]];
                if (!name) name = mailstr;
                SKToken* token = [[SKToken alloc] initWithTitle:name representedObject:mailstr];
                [aEmail.BCCTokenField addToken:token];
            }
        }
        [aEmail.BCCTokenField layoutTokensAnimated:NO];
        
        aEmail.STokenField.text = [mailinfo objectForKey:@"SUBJECT"];
        [aEmail.messageView setText:[mailinfo objectForKey:@"CONTENT"]];
        //草稿是否自己写的
        if ([mailinfo objectForKey:@"ISWRITTENBYSELF"]
            &&![[mailinfo objectForKey:@"ISWRITTENBYSELF"] isEqualToString:@""])
        {
            BOOL isByself=[[mailinfo objectForKey:@"ISWRITTENBYSELF"] boolValue];
            aEmail.isDraftWrittenBySelf=isByself;
            //如果不是自己写的
            if (!isByself)
            {
                if ([mailinfo objectForKey:@"MESSAGEID"]
                    &&![[mailinfo objectForKey:@"MESSAGEID"] isEqualToString:@""])
                {
                    [aEmail setMessageID:[mailinfo objectForKey:@"MESSAGEID"]];
                }
                if ([mailinfo objectForKey:@"ORIGINALINFO"]
                    &&![[mailinfo objectForKey:@"ORIGINALINFO"] isEqualToString:@""])
                {
                    [aEmail setOriginalInfo:[mailinfo objectForKey:@"ORIGINALINFO"]];
                }
                if ([mailinfo objectForKey:@"PERSONALINFO"]
                    &&![[mailinfo objectForKey:@"PERSONALINFO"] isEqualToString:@""])
                {
                    [aEmail setPersonalInfo:[mailinfo objectForKey:@"PERSONALINFO"]];
                }
                if ([mailinfo objectForKey:@"ATTACHMENTS"]
                    &&![[mailinfo objectForKey:@"ATTACHMENTS"] isEqualToString:@""])
                {
                    [aEmail setAttachments:[mailinfo objectForKey:@"ATTACHMENTS"]];
                }
                if ([mailinfo objectForKey:@"CONTENT"]
                    &&![[mailinfo objectForKey:@"CONTENT"] isEqualToString:@""])
                {
                    [aEmail setContentText:[mailinfo objectForKey:@"CONTENT"]];
                }
            }
            
        }
        [self.tableview deselectRowAtIndexPath:selectindexpath animated:YES];
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
@end
