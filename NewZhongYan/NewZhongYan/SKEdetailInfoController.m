//
//  SKEdetailInfoController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-27.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKEdetailInfoController.h"
#import "SKLToolBar.h"
#import "UIColor+FlatUI.h"
#import "SKNewMailController.h"
#import "SKPathButton.h"
@interface SKEdetailInfoController ()
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation SKEdetailInfoController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)email:(UIButton *)sender {
    SKNewMailController* aEmail = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKNewMailController"];
    NSString* name = [[DBQueue sharedbQueue] stringFromSQL:
                      [NSString stringWithFormat:@"select CNAME from T_EMPLOYEE WHERE EMAIL = '%@';",[self.employeeInfo objectForKey:@"EMAIL"]]];
    if (!name) name = sender.titleLabel.text;
    SKToken* token = [[SKToken alloc] initWithTitle:name
                                  representedObject:[self.employeeInfo objectForKey:@"EMAIL"]];
    [aEmail.toTokenField addToken:token];
    [aEmail setStatus:NewMailStatusWrite];
    [[APPUtils visibleViewController].navigationController pushViewController:aEmail animated:YES];
}

-(void)phoneOnToolBar
{
    NSString* phone = [self.employeeInfo objectForKey:@"MOBILE"];
    if (phone && phone.length > 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phone]]];
    }
}

- (void)sendSMS
{
	if ([MFMessageComposeViewController canSendText]) {
		MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
		picker.messageComposeDelegate = self;
		picker.recipients = [NSArray arrayWithObject:[self.employeeInfo objectForKey:@"MOBILE"]];
		[self presentViewController:picker animated:YES completion:nil];
	}
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString* msg = [NSString string];
    if(result==MessageComposeResultSent){
        msg = @"发短信成功";
    }else if(result==MessageComposeResultCancelled){
        msg = @"发短信取消";
    }else if(result==MessageComposeResultFailed){
        msg = @"发短信失败";
    }
    [BWStatusBarOverlay showSuccessWithMessage:msg duration:1 animated:YES];
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
    
    SKLToolBar* myToolBar = [[SKLToolBar alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    [myToolBar setFirstItem:@"btn_call_ecm" Title:@"电话"];
    [myToolBar setSecondItem:@"btn_sms_ecm" Title:@"短信"];
    [myToolBar setThirdItem:@"btn_mail_ecm" Title:@"邮件"];
    [myToolBar.firstButton  addTarget:self action:@selector(phoneOnToolBar)  forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.secondButton addTarget:self action:@selector(sendSMS)   forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.thirdButton  addTarget:self action:@selector(email:) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:myToolBar];
    
    if (System_Version_Small_Than_(7)) {
        _tableview.backgroundColor = [UIColor cloudsColor];
        _tableview.opaque = NO;
        _tableview.backgroundView = nil;
    }
}

- (IBAction)stored:(UIButton*)storeBtn {
    DBQueue* queue = [DBQueue sharedbQueue];
    NSString* idx = [self.employeeInfo objectForKey:@"id"];
    if ([[self.employeeInfo objectForKey:@"STORED"] intValue]) {
        [storeBtn setBackgroundImage:[UIImage imageNamed:@"star_off"] forState:UIControlStateNormal];
        [storeBtn setBackgroundImage:[UIImage imageNamed:@"star_on"] forState:UIControlStateHighlighted];
        NSString* updatesql =
        [NSString stringWithFormat:@"UPDATE T_EMPLOYEE SET STORED = %d where id  = %@;",![[self.employeeInfo objectForKey:@"STORED"] intValue],idx];
        [queue updateDataTotableWithSQL:updatesql];
        [self.employeeInfo setObject:@"0" forKey:@"STORED"];
    }else{
        [storeBtn setBackgroundImage:[UIImage imageNamed:@"star_on"] forState:UIControlStateNormal];
        [storeBtn setBackgroundImage:[UIImage imageNamed:@"star_off"] forState:UIControlStateHighlighted];
        NSString* updatesql =
        [NSString stringWithFormat:@"UPDATE T_EMPLOYEE SET STORED = %d where id  = %@;",![[self.employeeInfo objectForKey:@"STORED"] intValue],idx];
        [queue updateDataTotableWithSQL:updatesql];
        [self.employeeInfo setObject:@"1" forKey:@"STORED"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"storeChanged" object:0];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        return 3;
    }else {
        return 2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    if (indexPath.section == 0) {
        CellIdentifier = @"baseinfo";
    }else if (indexPath.section == 1){
        CellIdentifier = @"mail";
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            CellIdentifier = @"mobile";
        }else if (indexPath.row == 1){
            CellIdentifier = @"shortno";
        }else if (indexPath.row == 2){
            CellIdentifier = @"officeno";
        }
    }else if(indexPath.section == 3){
        if (indexPath.row == 0) {
            CellIdentifier = @"department";
        }else if (indexPath.row == 1){
            CellIdentifier = @"officeplace";
        }
    }
    
    UITableViewCell *cell;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if (System_Version_Small_Than_(7)) {
        UIView* bgView = [[UIView alloc] initWithFrame:cell.bounds];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        cell.backgroundView = bgView;
        
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cell.contentView.bounds), CGRectGetWidth(cell.contentView.bounds), 0.5)];
        [v setBackgroundColor:[UIColor lightGrayColor]];
        if (indexPath.section == 2){
            if (indexPath.row != 2) {
                [cell.contentView addSubview:v];
            }
        }else if(indexPath.section == 3){
            if (indexPath.row == 0) {
                [cell.contentView addSubview:v];
            }
        }
    }
    
    if (indexPath.section == 0) {
        [(UILabel*)[cell.contentView viewWithTag:1] setText:_employeeInfo[@"CNAME"]];
        [(UILabel*)[cell.contentView viewWithTag:2] setText:_employeeInfo[@"TNAME"]];
        [(UILabel*)[cell.contentView viewWithTag:3] setText:_employeeInfo[@"UCNAME"]];
//        SKPathButton* btn = (SKPathButton*)[cell.contentView viewWithTag:5];
//        [btn setPathColor:[UIColor whiteColor]];
//        [btn setBorderColor:[UIColor darkGrayColor]];
//        [btn setPathWidth:5];
        
        UIButton* btn1 = (UIButton*)[cell.contentView viewWithTag:4];
        [btn1 addTarget:self action:@selector(stored:) forControlEvents:UIControlEventTouchUpInside];
        if ([[self.employeeInfo objectForKey:@"STORED"] intValue] == 1) {
            [btn1  setBackgroundImage:[UIImage imageNamed:@"star_on"] forState:UIControlStateNormal];
        }else{
            [btn1  setBackgroundImage:[UIImage imageNamed:@"star_off"] forState:UIControlStateNormal];
        }
    }else if (indexPath.section == 1){
        NSArray* email = [_employeeInfo[@"EMAIL"] componentsSeparatedByString:@"@"];
        [(UILabel*)[cell.contentView viewWithTag:1] setText:email[0]];
        [(UILabel*)[cell.contentView viewWithTag:2] setText:[@"@" stringByAppendingString:email[1]]];
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [(UILabel*)[cell.contentView viewWithTag:1] setText:_employeeInfo[@"MOBILE"]];
        }else if (indexPath.row == 1){
            [(UILabel*)[cell.contentView viewWithTag:1] setText:_employeeInfo[@"SHORTPHONE"]];
        }else if (indexPath.row == 2){
            [(UILabel*)[cell.contentView viewWithTag:1] setText:_employeeInfo[@"TELEPHONE"]];
        }
    }else if(indexPath.section == 3){
        if (indexPath.row == 0) {
            [(UILabel*)[cell.contentView viewWithTag:1] setText:_employeeInfo[@"PNAME"]];
        }else if (indexPath.row == 1){
            [(UILabel*)[cell.contentView viewWithTag:1] setText:_employeeInfo[@"OFFICEADDRESS"]];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section == 1){
        return 60;
    }else{
        return 44;
    }
}

/**
 *  Reducing the space between sections of the UITableView
 *
 *  @param tableView
 *  @param indexPath
 *
 *  @return
 */
-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 15;
    return 10.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}
@end
