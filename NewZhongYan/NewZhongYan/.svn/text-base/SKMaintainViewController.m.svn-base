//
//  SKMaintainViewController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKMaintainViewController.h"
#import "SKToolBar.h"
#import "EmailHelper.h"
#import "OAHelper.h"
#import "NewsHelper.h"
#import "NotifyHelper.h"
#import "AnnounceHelper.h"
#import "MeetingHelper.h"
#import "WorkNewsHelper.h"
#import "CODOCSHelper.h"
#import "ClientAppHelper.h"
#import "SKAppMaintainCell.h"
@interface SKMaintainViewController ()
{
    UIActivityIndicatorView *indicator;
    NSMutableArray *dataArray;
    NSMutableArray *clientAppArray;//ecm
    NSMutableArray *clientAppHelperArray;//ecm
    int currentTag;
    BOOL isClearAll;
    long long filesize;
}
@end

@implementation SKMaintainViewController

-(void)reload
{
    [dataArray removeAllObjects];
    NSDictionary *emailDic=[NSDictionary dictionaryWithObjectsAndKeys:
                            [UIImage imageNamed:@"icon_email.png"],@"image",@"邮件",@"title",[EmailHelper getSize],@"size",nil];
    NSDictionary *oaDic=[NSDictionary dictionaryWithObjectsAndKeys:
                         [UIImage imageNamed:@"icon_gtasks.png"],@"image",@"统一待办",@"title",
                         [OAHelper getSize],@"size",nil];
    [dataArray addObject:oaDic];
    [dataArray addObject:emailDic];
    
    clientAppArray = [NSMutableArray array];
    clientAppHelperArray = [NSMutableArray array];
    NSArray* array = [[DBQueue sharedbQueue] recordFromTableBySQL:@"select * from T_CLIENTAPP where HASPMS = 1 and ENABLED = 1 ORDER BY DEFAULTED;"];
    for (NSDictionary* dict in array) {
        SKClientApp* clientApp = [[SKClientApp alloc] initWithDictionary:dict];
        [clientAppArray addObject:clientApp];
    }
    for (SKClientApp* app in clientAppArray) {
        ClientAppHelper* clientHelper = [[ClientAppHelper alloc] initWithClientApp:app];
        NSDictionary *clientDic=[NSDictionary dictionaryWithObjectsAndKeys:
                             [UIImage imageNamed:@"icon_gtasks.png"],@"image",app.NAME,@"title",
                             [clientHelper clientAppSizeDocumentPath],@"size",clientHelper,@"apphelper",nil];
        [dataArray addObject:clientDic];
        [clientAppHelperArray addObject:clientHelper];
    }
    [tableview reloadData];
}

-(void)showAlert:(BOOL)needClean
{
    if (needClean) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"本次清理后系统仍然会为您保存最近的数据,确定清理吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"系统保存的是最近的数据,无需清理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)cleanData:(NSNotification *)note
{
    //首先判断是否需要清理 如果需要清理 加入询问是否清理
    int index=[[note.userInfo objectForKey:@"tag"] intValue];
    currentTag=index;
    isClearAll=NO;
    switch (index) {
        case 0:
            [self showAlert:[OAHelper needClean]];
            break;
        case 1:
            [self showAlert:[EmailHelper needClean]];
            break;
        default:
        {
            NSLog(@"ecm clean %@",[dataArray[index][@"apphelper"] class]);
            ClientAppHelper* helper = (ClientAppHelper*)dataArray[index][@"apphelper"];
            [self showAlert:[helper needClean]];
        };
    }
}

-(void)cleanAll
{
    
    isClearAll=YES;
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"本次清理后系统仍然会为您保存最近的数据，确定要清理吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        if (isClearAll)
        {
            [OAHelper cleanLocalData];
            [EmailHelper cleanLocalData];
            for (ClientAppHelper* helper in clientAppHelperArray) {
                [helper cleanLocalData];
            }
        }
        else
        {
            switch (currentTag)
            {
                case 0:
                    [OAHelper cleanLocalData];
                    break;
                case 1:
                    [EmailHelper cleanLocalData];
                    break;
                default:
                {
                    NSLog(@"ecm clean %@",[dataArray[currentTag][@"apphelper"] class]);
                    ClientAppHelper* helper = (ClientAppHelper*)dataArray[currentTag][@"apphelper"];
                    [helper cleanLocalData];
                };
            }
        }
        [self showIndicator];
    }
}

-(void)hideIndicator
{
    [indicator setHidden:YES];
    [indicator stopAnimating];
    [self reload];
}

-(void)showIndicator
{
    [indicator setHidden:NO];
    [indicator startAnimating];
    [self performSelector:@selector(hideIndicator) withObject:nil afterDelay:1.5];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)back:(id)sender{
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
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backItem;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanData:) name:@"cleanLocalDataNote" object:nil];
    dataArray=[[NSMutableArray alloc] init];
    NSString *basicPath=[[FileUtils documentPath] stringByAppendingPathComponent:@"zhongYan.db"];
    NSString* size = [[[NSFileManager defaultManager] attributesOfItemAtPath:basicPath error:0] objectForKey:@"NSFileSize"];
    filesize = size.longLongValue;
    
    CGRect toolRect = CGRectMake(0,0, 320, 49);
    SKToolBar* myToolBar = [[SKToolBar alloc] initMaintainWithFrame:toolRect Target:self Action:@selector(cleanAll)];
    [toolView addSubview:myToolBar];
    
    indicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setCenter:CGPointMake(160, (ScreenHeight/2))];
    [indicator setColor:[UIColor darkGrayColor]];
    [self.view addSubview:indicator];
    [indicator setHidden:YES];

    [self reload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"contentCell";
    static NSString *indexIdentifier = @"indexCell";
    static NSString *summaryIdentifier = @"summaryCell";
    SKAppMaintainCell *cell;
    if (indexPath.row == 0) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            cell = [tableView dequeueReusableCellWithIdentifier:indexIdentifier forIndexPath:indexPath];
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:indexIdentifier];
        }
    }else if (indexPath.row == dataArray.count + 1){
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            cell = [tableView dequeueReusableCellWithIdentifier:summaryIdentifier forIndexPath:indexPath];
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:summaryIdentifier];
        }
        UILabel* sizeLabel = (UILabel*)[cell.contentView viewWithTag:101];
        [sizeLabel setText:[FileUtils formattedFileSize:filesize]];
    }else{
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        cell.tag = indexPath.row - 1;
        [cell setDataInfo:dataArray[indexPath.row - 1]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
@end
