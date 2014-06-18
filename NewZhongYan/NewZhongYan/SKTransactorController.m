//
//  SKTransactorController.m
//  ZhongYan
//
//  Created by linlin on 10/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKTransactorController.h"
#import "utils.h"
#import "DataServiceURLs.h"
#import "utils.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "SKSToolBar.h"
#import "participant.h"
#import "BWStatusBarOverlay.h"
#import "SKViewController.h"
#import "SKAddressController.h"
@interface SKTransactorController ()
{
    UIView* titleView;
    UILabel* titleLabel;
    UIView* leftBlockView;
    NSString* currrentBid;
    NSMutableArray* bidArray;
}
-(void)drawView;
-(void)drawAddSignalView;
@end
@implementation SKTransactorController
@synthesize GTaskInfo,tableView = _tableView,pts,bid,branchname;
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([pRequest isExecuting]) {
        [pRequest clearDelegatesAndCancel];
    }
}

-(void)fitLabel:(UILabel*)label
{
    label.font = [UIFont systemFontOfSize:17];
    label.numberOfLines = 0;
    [label sizeToFit];
}

- (void)requestFailed:(SKHTTPRequest *)request
{
    //NSError *error = [request error];
    //[utils showTextOnView:self.view Text:[NetUtils userInfoWhenRequestOccurError:error]];
    [BWStatusBarOverlay showErrorWithMessage:request.error.localizedDescription duration:1 animated:1];
}

- (void)requestFinished:(SKHTTPRequest *)request
{
    if (request.responseStatusCode != 200) {
        [BWStatusBarOverlay showErrorWithMessage:@"网络异常请联系供应商" duration:1 animated:1];
        return;
    }
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:request.responseData options:0 error:0];
    DDXMLElement* element1 = (DDXMLElement*)[[doc nodesForXPath:@"//returncode" error:0] objectAtIndex:0];
    pts.returncode = [element1 stringValue];
    if (![pts.returncode isEqualToString:@"OK"]) {
        //[utils AlterView:self.view Title:@"尊敬的用户您好:" Deatil:[element1 stringValue]];
        for (UIView* v in [self.view subviews]) {
            if (v.tag == 1001) {
                [v removeFromSuperview];
            }
        }
        return;
    }
    
    DDXMLElement* element2 = (DDXMLElement*)[[doc nodesForXPath:@"//participants" error:0] objectAtIndex:0];
    pts.selection = [[[element2 attributes] objectAtIndex:0] stringValue];
    for (DDXMLElement* element in [doc nodesForXPath:@"//participant" error:0])
    {
        participant *pt = [[participant alloc] init];
        pt.type = [[element elementForName:@"type"] stringValue];
        if (pt.type.intValue == 0) {
            [self drawAddSignalView];
            return;
        }
        pt.pid = [[element elementForName:@"pid"] stringValue];
        pt.pname = [[element elementForName:@"pname"] stringValue];
        [self.pts.participantsArray addObject:pt];
    }
    [self drawView];
}

-(void)addSignalPeople
{
    SKAddressController* addressBook = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKAddressController"];
    addressBook.IsMail = YES;
    [self.navigationController pushViewController:addressBook animated:YES];
}

-(void)drawAddSignalView
{
    UILabel* addsigLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 5, 100, 20)];
    addsigLabel.text = @"加签人";
    [titleView addSubview:addsigLabel];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn setFrame:CGRectMake(320 - 30, CGRectGetMaxY(titleLabel.frame), 25, 25)];
    [btn addTarget:self action:@selector(addSignalPeople) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:btn];
    
    CGRect rect = titleView.frame;
    rect.size.height = CGRectGetMaxY(btn.frame);
    titleView.frame = rect;
    
    rect = leftBlockView.frame;
    rect.size.height = CGRectGetMaxY(btn.frame);
    leftBlockView.frame = rect;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), 320, 20)];
    if ([self.pts.selection isEqualToString:@"multi"]) {
        [label setText:@"   办理人选择 (多选)"];
    }else{
        [label setText:@"   办理人选择 (单选)"];
    }
    
    [label setTextColor:COLOR(96,96,96)];
    label.numberOfLines = 0;
    [label setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:label];

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) , 320,SCREEN_HEIGHT - 49 - CGRectGetMaxY(label.frame) )];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setBounces:NO];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if ([self.pts.selection isEqualToString:@"multi"]) {
        [_tableView setAllowsMultipleSelection:YES];
    }
    [self.view addSubview:_tableView];
}

-(void)drawView
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), 320, 20)];
    if ([self.pts.selection isEqualToString:@"multi"]) {
         [label setText:@"    办理人选择 (多选)"];
    }else{
         [label setText:@"    办理人选择 (单选)"];
    }
    [label setBackgroundColor:COLOR(239, 239, 239)];
    [label setTextColor:COLOR(96,96,96)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    [self.view addSubview:label];
    
    _tableView = [[UITableView alloc] init];
    if (IS_IOS7) {
        [_tableView setFrame:CGRectMake(0,CGRectGetMaxY(label.frame),320,SCREEN_HEIGHT - CGRectGetMaxY(label.frame) - 49)];
    }else{
        [_tableView setFrame:CGRectMake(0,CGRectGetMaxY(label.frame),320,ScreenHeight - CGRectGetMaxY(label.frame) - 49)];
    }
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if ([self.pts.selection isEqualToString:@"multi"]) {
        [_tableView setAllowsMultipleSelection:YES];
    }
    [self.view addSubview:_tableView];
}

-(id)initWithDictionary:(NSDictionary*)dictionary  BranchID:(NSString*)abid
{
    self = [super init];
    if (self) {
        selectedRow = -1;
        self.GTaskInfo = dictionary;
        self.pts = [[participants alloc] init];
        bidArray = [NSMutableArray array];
        currrentBid = abid;
    }
    return self;
}

- (void)backToRoot:(id)sender{
    for (UIViewController* controller  in self.navigationController.viewControllers){
        NSString *classString = NSStringFromClass([controller class]);
        if ([classString isEqualToString:@"SKMainViewController"]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)backToListView{
    for (UIViewController* controller  in self.navigationController.viewControllers){
        NSString *classString = NSStringFromClass([controller class]);
        if ([classString isEqualToString:@"SKGTaskViewController"]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

-(void)lastBranch:(id)sender
{
    SKViewController* controller = [APPUtils AppRootViewController];
    [controller.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSString* plist = [NSString string];
        for (participant* p in self.pts.participantsArray)
        {
            if (p.selected)
            {
                plist = [plist stringByAppendingFormat:@",%@:%@",p.type,p.pid];
            }
        }
        plist = [plist substringFromIndex:1];
        NSURL* commitUrl = [DataServiceURLs commitWorkItem];
        SKFormDataRequest *commitRequest = [SKFormDataRequest requestWithURL:commitUrl];
        [commitRequest setPostValue:[APPUtils userUid] forKey:@"userid"];
        [commitRequest setPostValue:[GTaskInfo objectForKey:@"TFRM"]  forKey:@"from"];
        [commitRequest setPostValue:[GTaskInfo objectForKey:@"AID"]  forKey:@"workitemid"];
        [commitRequest setPostValue:self.bid forKey:@"branchid"];
        [commitRequest setPostValue:plist forKey:@"plist"];
        __weak SKFormDataRequest *req = commitRequest;
        [commitRequest setCompletionBlock:^{
            if (req.responseStatusCode != 200) {
                //[utils AlterView:self.view Title:@"尊敬的用户您好:" Deatil:@"网络异常请联系供应商"]; return;
                return;
            }
            if ([[req responseString] isEqualToString:@"OK"]) {
                [BWStatusBarOverlay showMessage:@"办理成功" duration:1.5 animated:YES];
                [self backToListView];
            }else{
                [BWStatusBarOverlay showMessage:[req responseString] duration:1.5 animated:YES];
            }
        }];
        //失败
        [commitRequest setFailedBlock:^{
            NSError *error = [req error];
            //NSLog(@"error = %@",[NetUtils userInfoWhenRequestOccurError:error]);
            [BWStatusBarOverlay showMessage:[NetUtils userInfoWhenRequestOccurError:error] duration:1.5 animated:YES];
        }];
        [commitRequest startAsynchronous];
    }
}


-(void)submit:(id)sender
{
    NSString* name = [NSString string];
    for (participant* p in self.pts.participantsArray)
    {
        if (p.selected)
        {
            name = [name stringByAppendingFormat:@",%@",p.pname];
        }
    }
    if (name.length == 0) {
        [BWStatusBarOverlay showMessage:@"请选择流程办理人" duration:1.5 animated:YES];
        return;
    }
    name = [name substringFromIndex:1];
    NSString* msg = [NSString stringWithFormat:@"流程将进入%@环节\n办理人为:%@\n是否确认提交",self.branchname,name];
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [av show];
}

#pragma mark - View lifecycle
-(void)addPerson:(NSNotification*)aNotification
{
    NSArray *arr=[[aNotification userInfo] objectForKey:@"employee"];
    for (NSDictionary *responseDict in arr)
    {
        participant *pt = [[participant alloc] init];
        pt.type = @"0";
        pt.pid = [responseDict objectForKey:@"UID"];
        pt.pname = [responseDict objectForKey:@"CNAME"];
        
        BOOL isNeedContinue = NO;
        for (participant *p in self.pts.participantsArray) {//去重
            if ([p.pid isEqualToString:pt.pid]) {
                isNeedContinue = YES;
            }
        }
        if (isNeedContinue) {
            continue;
        }
        
        [self.pts.participantsArray addObject:pt];
    }
    [self.tableView reloadData];
}

-(UILabel*)selfAdaptionLable:(UIFont*)font Width:(CGFloat)width Text:(NSString*)text
{
    CGFloat height = [text sizeWithFont:font
                      constrainedToSize: CGSizeMake(width,MAXFLOAT)
                          lineBreakMode:NSLineBreakByWordWrapping].height; //expectedLabelSizeOne.height 就是内容的高度
    CGRect labelRect = CGRectMake(10, 5 ,width,height);
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;//上面两行设置多行显示s
    label.font = font;
    label.text = text;
    return label;
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (System_Version_Small_Than_(7)) {
        UIButton* backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backbtn setFrame:CGRectMake(0, 0, 50, 30)];
        [backbtn setBackgroundImage:Image(@"back") forState:UIControlStateNormal];
        [backbtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
        self.navigationItem.leftBarButtonItem = backItem;
    }else{
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backItem;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addPerson:)
                                                 name:@"EmailContact"
                                               object:nil];
    
    self.title = @"办理人";
    [self.view setBackgroundColor:COLOR(239, 239, 239)];
    
    titleLabel = [self selfAdaptionLable:[UIFont boldSystemFontOfSize:18]
                                   Width:300
                                    Text:[self.GTaskInfo objectForKey:@"TITL"]];
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:titleView];
    
    leftBlockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5,CGRectGetMaxY(titleLabel.frame) + 20)];
    [leftBlockView setBackgroundColor:COLOR(177, 0, 4)];
    [titleView addSubview:titleLabel];
    [titleView addSubview:leftBlockView];
    [titleView setFrame: CGRectMake(0, TopY, 320, CGRectGetMaxY(titleLabel.frame) + 20)];
    
    SKSToolBar* myToolBar = [[SKSToolBar alloc] initWithFrame:CGRectMake(0,BottomY - 49, 320, 49)];
    [myToolBar.secondButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.firstButton addTarget:self action:@selector(lastBranch:) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar setFirstItem:@"btn_last_ecm" Title:@"上一步"];
    [myToolBar setSecondItem:@"btn_submit" Title:@"提交"];
    [self.view addSubview:myToolBar];
    
    for(UIViewController* controller in self.navigationController.viewControllers)
    {
        if([controller class] == [SKNextBranchesController class])
        {
            SKNextBranchesController* nb = (SKNextBranchesController*)controller;
            [bidArray addObject:nb.bid];
        }
    }
    [bidArray addObject:currrentBid];
    [bidArray removeObjectAtIndex:0];
    self.bid = [bidArray componentsJoinedByString:@":"];
    NSURL* participantsURL = [DataServiceURLs getParticipants:[APPUtils userUid]
                                                         TFRM:[GTaskInfo objectForKey:@"TFRM"]
                                                   Workitemid:[GTaskInfo objectForKey:@"AID"]
                                                     BranchId:self.bid];
    pRequest = [[SKHTTPRequest alloc] initWithURL:participantsURL];
    [pRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [pRequest setDelegate:self];
    [pRequest startAsynchronous];
}

#pragma mark -TableView 代理
-(NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    [aTableView setBounces:[self.pts.participantsArray count] > 6];
    return [self.pts.participantsArray count];
}

-(UITableViewCell*)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"radiobutton";
    UITableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    participant* pt =  [self.pts.participantsArray objectAtIndex:indexPath.row];
    if (pt.selected) {
        cell.imageView.image =[[UIImage imageNamed:@"check.png"] rescaleImageToSize:CGSizeMake(25, 25)];
    }else{
        cell.imageView.image =[[UIImage imageNamed:@"uncheck.png"] rescaleImageToSize:CGSizeMake(25, 25)];
    }
    cell.textLabel.text =pt.pname;
    cell.textLabel.numberOfLines = 0;
    return cell;
}

-(void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    UITableViewCell* cell = [aTableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"check"];
    participant* pt =  [self.pts.participantsArray objectAtIndex:indexPath.row];
    pt.selected = YES;
    selectedRow = indexPath.row;
}
 
- (void)tableView:(UITableView *)aTableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    participant* pt =  [self.pts.participantsArray objectAtIndex:indexPath.row];
    pt.selected = NO;
    UITableViewCell* cell = [aTableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"uncheck"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    participant* pt =  [self.pts.participantsArray objectAtIndex:indexPath.row];
    CGFloat contentWidth = 280;
    UIFont *font = [UIFont systemFontOfSize:18];
    CGSize size = [pt.pname sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat height = size.height+30;
    return height;
}

@end
