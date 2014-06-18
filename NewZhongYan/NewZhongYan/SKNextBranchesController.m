//
//  SKNextBranchesController.m
//  ZhongYan
//
//  Created by linlin on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKNextBranchesController.h"
#import "utils.h"
#import "DataServiceURLs.h"
#import "utils.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "branch.h"
#import "SKTransactorController.h"
#import "SKSToolBar.h"
#import "SKViewController.h"
@interface SKNextBranchesController ()
{
    UILabel* titleLabel;
    UIView* titleView;
    NSString* currrentBid;
}
//构建视图
-(void)drawView;
@end

@implementation SKNextBranchesController
@synthesize GTaskInfo,uid,bid,nextBranches,tableView;

- (void)requestFailed:(SKHTTPRequest *)request
{
    NSError *error = [request error];
    [BWStatusBarOverlay showErrorWithMessage:[NetUtils userInfoWhenRequestOccurError:error] duration:1 animated:1];
}

- (void)requestFinished:(SKHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
    if (request.responseStatusCode == 500) {
        [BWStatusBarOverlay showErrorWithMessage:@"网络异常请联系供应商" duration:1 animated:1];
    }
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:request.responseData options:0 error:nil];
    DDXMLElement* element = (DDXMLElement*)[[doc nodesForXPath:@"//returncode" error:0] objectAtIndex:0];
    DDXMLElement* selectElement = (DDXMLElement*)[[doc nodesForXPath:@"//branches" error:0] objectAtIndex:0];
    self.nextBranches.selection =   [[selectElement attributesAsDictionary] objectForKey:@"selection"];
    self.nextBranches.returncode =  [element stringValue];
    
    //解析
    for (DDXMLElement* node in [doc nodesForXPath:@"//branches" error:0]) {
        branches* bs = [[branches alloc] init];
        bs.attributeDictionary = [(DDXMLElement*)node attributesAsDictionary];
        for (DDXMLElement* element in [node nodesForXPath:@"./branch" error:0])
        {
            branch *b = [[branch alloc] init];
            b.bid = [[element elementForName:@"bid"] stringValue];
            b.bname = [[element elementForName:@"bname"] stringValue];
            b.ifend = [[element elementForName:@"ifend"] stringValue];
            b.node =element;
            [bs.branchArray addObject:b];
            branchCount++;
        }
        [self.nextBranches.branchesArray addObject:bs];
    }
    [self drawView];
}

-(void)drawView
{
    _tableView = [[UITableView alloc] init];
    if (IS_IOS7) {
        [_tableView setFrame:CGRectMake(0,CGRectGetMaxY(titleView.frame),320,
                                        SCREEN_HEIGHT - 49 - CGRectGetMaxY(titleView.frame) - 5)];
    }else{
        [_tableView setFrame:CGRectMake(0,CGRectGetMaxY(titleView.frame),320,
                                        SCREEN_HEIGHT - 49 - CGRectGetMaxY(titleView.frame) - 5 - 64)];
    }
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:COLOR(239, 239, 239)];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.nextBranches.branchesArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    branches* bs = self.nextBranches.branchesArray[section];
    [_tableView setBounces:branchCount > 6];
    return [bs.branchArray count];
}

-(UITableViewCell*)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identify = @"radiobutton";
    UITableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.imageView.image =[[UIImage imageNamed:@"uncheck.png"] rescaleImageToSize:CGSizeMake(25, 25)];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    branches* bs =  (branches*)self.nextBranches.branchesArray[indexPath.section];
    branch* b = bs.branchArray[indexPath.row];
    cell.textLabel.text = b.bname;
    return cell;
}

-(void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [aTableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"check.png"];
    selectedRow = indexPath;
}

- (void)tableView:(UITableView *)aTableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [aTableView cellForRowAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"uncheck.png"];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headView = [[UIView alloc] init];
    [headView setBackgroundColor:COLOR(239, 239, 239)];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 320, 0)];
    branches* bs = self.nextBranches.branchesArray[section];
    if (bs.attributeDictionary[@"name"]) {
        [label setText:[NSString stringWithFormat:@"   %@ (单选)",bs.attributeDictionary[@"name"]]];
    }else{
        [label setText:@"   流程选择 (单选)"];
    }
    [label setTextColor:COLOR(96,96,96)];
    [label setBackgroundColor:COLOR(239, 239, 239)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    [label sizeToFit];
    [headView setFrame:CGRectMake(0, 0, 320, label.frame.size.height)];
    [headView addSubview:label];
    return headView;
}

-(void)dealloc
{
    if ([NBRequest isExecuting]) {
        [NBRequest clearDelegatesAndCancel];
    }
}

-(id)initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        selectedRow = nil;
        self.title = @"流程分支";
        self.GTaskInfo = dictionary;
        self.nextBranches = [[aNextBranches alloc] init];
        self.uid = [APPUtils userUid];
        self.bid = @"000";
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

-(void)lastStep:(id)sender{
    SKViewController* controller = [APPUtils AppRootViewController];
    [controller.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableArray* bidArray = [NSMutableArray array];
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
        NSURL* commitUrl = [DataServiceURLs commitWorkItem];
        SKFormDataRequest *commitRequest = [SKFormDataRequest requestWithURL:commitUrl];
        [commitRequest setPostValue:[APPUtils userUid] forKey:@"userid"];
        [commitRequest setPostValue:[GTaskInfo objectForKey:@"TFRM"]  forKey:@"from"];
        [commitRequest setPostValue:[GTaskInfo objectForKey:@"AID"]  forKey:@"workitemid"];
        [commitRequest setPostValue:self.bid forKey:@"branchid"];
        [commitRequest setPostValue:@"" forKey:@"plist"];
        __weak SKFormDataRequest *req = commitRequest;
        [commitRequest setCompletionBlock:^{
            if (req.responseStatusCode == 500) {
                return;
            }
            if ([[req responseString] isEqualToString:@"OK"])
            {
                [BWStatusBarOverlay showMessage:@"办理成功" duration:1.5 animated:YES];
                for (UIViewController* controller  in self.navigationController.viewControllers){
                    NSString *classString = NSStringFromClass([controller class]);
                    if ([classString isEqualToString:@"SKGTaskViewController"]) {
                        [self.navigationController popToViewController:controller animated:YES];
                    }
                }
            }else{
                [BWStatusBarOverlay showMessage:[req responseString] duration:1.5 animated:YES];
            }
        }];
        //失败
        [commitRequest setFailedBlock:^{
            NSError *error = [req error];
            [BWStatusBarOverlay showMessage:[NetUtils userInfoWhenRequestOccurError:error] duration:1.5 animated:YES];
        }];
        [commitRequest startAsynchronous];
    }
}

-(void)nextStep:(id)sender{
    if (!selectedRow) {
        [BWStatusBarOverlay showErrorWithMessage:@"您还没有选择适当的流程分支!" duration:1 animated:YES];
        return;
    }
    branches* bs =  (branches*)self.nextBranches.branchesArray[selectedRow.section];
    branch* b = bs.branchArray[selectedRow.row];
    if ([b.ifend isEqualToString:@"nextto"]) {
        //➢	branchid，可供选择的分支途径。为String数组，如果某项流程是主流程下子流程，其格式为主流程id:子流程id
        SKNextBranchesController* nb = [[SKNextBranchesController alloc] initWithDictionary:self.GTaskInfo];
        nb.bid = b.bid;
        [self.navigationController pushViewController:nb animated:YES];
    } else {
        if ([b.ifend isEqualToString:@"YES"]) {
            currrentBid = b.bid;
            NSString* msg = [NSString stringWithFormat:@"流程将进入%@环节是否确认提交",b.bname];
            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [av show];
        }else{
            SKTransactorController* tc = [[SKTransactorController alloc] initWithDictionary:self.GTaskInfo BranchID:b.bid];
            tc.branchname = b.bname;
            [self.navigationController pushViewController:tc animated:YES];
        }
    }
}

#pragma mark - View lifecycle

-(UILabel*)selfAdaptionLable:(UIFont*)font Width:(CGFloat)width Text:(NSString*)text
{
    CGFloat height = [text sizeWithFont:font
                      constrainedToSize: CGSizeMake(width,MAXFLOAT)
                          lineBreakMode:NSLineBreakByWordWrapping].height; //expectedLabelSizeOne.height 就是内容的高度
    CGRect labelRect = CGRectMake(10, 2,width,height);
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
    [self.view setBackgroundColor:COLOR(239, 239, 239)];
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
    
    titleLabel = [self selfAdaptionLable:[UIFont boldSystemFontOfSize:18]
                                   Width:300
                                    Text:[self.GTaskInfo objectForKey:@"TITL"]];
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:titleView];
    
    UIView* leftBlockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5,CGRectGetMaxY(titleLabel.frame) + 20)];
    [leftBlockView setBackgroundColor:COLOR(177, 0, 4)];
    [titleView addSubview:titleLabel];
    [titleView addSubview:leftBlockView];
    [titleView setFrame: CGRectMake(0, TopY, 320, CGRectGetMaxY(titleLabel.frame) + 20)];
    
    SKSToolBar* myToolBar = [[SKSToolBar alloc] initWithFrame:CGRectMake(0, BottomY-49, 320, 49)];
    [myToolBar.homeButton addTarget:self action:@selector(backToRoot:) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.firstButton addTarget:self action:@selector(lastStep:) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.secondButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar setFirstItem:@"btn_last_ecm" Title:@"上一步"];
    [myToolBar setSecondItem:@"btn_next_ecm" Title:@"下一步"];
    [self.view addSubview:myToolBar];
    
    NSURL* nextBranchesURL = [DataServiceURLs getNextBranches:[APPUtils userUid]
                                                         TFRM:[GTaskInfo objectForKey:@"TFRM"]
                                                          AID:[GTaskInfo objectForKey:@"AID"]
                                                          BID:self.bid
                              ];
    
    NBRequest = [[SKHTTPRequest alloc] initWithURL:nextBranchesURL];
    [NBRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [NBRequest setDelegate:self];
    [NBRequest startAsynchronous];
}
@end
