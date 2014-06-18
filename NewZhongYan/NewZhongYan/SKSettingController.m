//
//  SKSettingController.m
//  NewZhongYan
//
//  Created by lilin on 14-3-20.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKSettingController.h"
#import "SKAppConfiguration.h"
#import "SKNewMailController.h"
#import "UIColor+FlatUI.h"
#import "SKIntroView.h"
@implementation SKSettingController
-(void)back:(id)sender{
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
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backItem;
    }
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    [view setBackgroundColor:COLOR(239, 239, 239)];
    [self.tableView setTableFooterView:view];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 21)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:@"湖南中烟工业有限公司 版权所有"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:COLOR(194, 194, 194)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [view  addSubview:titleLabel];
    
    UILabel* subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(titleLabel.frame) + 1, 320, 21)];
    [subTitleLabel setBackgroundColor:[UIColor clearColor]];
    [subTitleLabel setText:@"copyright 2011-2014 All Rights Reserved"];
    [subTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [subTitleLabel setTextColor:COLOR(194, 194, 194)];
    [subTitleLabel setFont:[UIFont systemFontOfSize:14]];
    [view  addSubview:subTitleLabel];
    
    if (System_Version_Small_Than_(7)) {
        self.tableView.backgroundColor = [UIColor cloudsColor];
        self.tableView.opaque = NO;
        self.tableView.backgroundView = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView setContentOffset:CGPointZero];
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 5;
    }
    return 15.0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(void)deselect
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (System_Version_Small_Than_(7)) {
        UIView* bgView = [[UIView alloc] initWithFrame:cell.bounds];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        cell.backgroundView = bgView;
        if (indexPath.section == 1){
            if (indexPath.row != 4) {
                CGRect rect ;
                if (indexPath.row == 0) {
                    rect = CGRectMake(0, CGRectGetMaxY(cell.contentView.bounds), CGRectGetWidth(cell.contentView.bounds) + 10, 0.5);
                }else{
                    rect = CGRectMake(0, CGRectGetMaxY(cell.contentView.bounds), CGRectGetWidth(cell.contentView.bounds), 0.5);
                }
                UIView* v = [[UIView alloc] initWithFrame:rect];
                [v setBackgroundColor:[UIColor lightGrayColor]];
                [cell.contentView addSubview:v];
            }
        }else if(indexPath.section == 2){
            if (indexPath.row != 1) {
                CGRect rect ;
                if (indexPath.row == 0) {
                    rect = CGRectMake(0, CGRectGetMaxY(cell.contentView.bounds), CGRectGetWidth(cell.contentView.bounds) + 10, 0.5);
                }else{
                    rect = CGRectMake(0, CGRectGetMaxY(cell.contentView.bounds), CGRectGetWidth(cell.contentView.bounds), 0.5);
                }
                UIView* v = [[UIView alloc] initWithFrame:rect];
                [v setBackgroundColor:[UIColor lightGrayColor]];
                [cell.contentView addSubview:v];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSelector:@selector(deselect) withObject:0 afterDelay:1];
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
            {
                [_rootController performSegueWithIdentifier:@"userinfo" sender:0];
                break;
            }
            case 1:
            {
                [_rootController performSegueWithIdentifier:@"secret" sender:0];
                break;
            }
            case 2:
            {
                SKAppConfiguration *configure=[[SKAppConfiguration alloc] init];
                [[APPUtils visibleViewController].navigationController pushViewController:configure animated:YES];
                break;
            }
            case 3:
            {
                 [_rootController performSegueWithIdentifier:@"Maintain" sender:0];
                break;
            }
            case 4:
            {
                break;
            }
            default:
                break;
        }
    }else if(indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
            {
                SKIntroView *introView=[[SKIntroView alloc] initWithFrame:CGRectMake(0,20, SCREEN_WIDTH,SCREEN_HEIGHT)];
                [[APPUtils APPdelegate].window addSubview:introView];
                break;
            }
            case 1:
            {
                SKNewMailController* aEmail = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKNewMailController"];
                SKToken* token = [[SKToken alloc] initWithTitle:@"产品经理"
                                              representedObject:@"p_liuyang@hngytobacco.com"];
                [aEmail.toTokenField addToken:token];
                [aEmail setStatus:NewMailStatusWrite];
                [aEmail.STokenField setText:@"手机门户意见反馈"];
                [[APPUtils visibleViewController].navigationController pushViewController:aEmail animated:YES];
                break;
            }
            default:
                break;
        }
    }
}
@end
