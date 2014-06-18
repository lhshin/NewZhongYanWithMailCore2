//
//  SKInboxCell.m
//  NewZhongYan
//
//  Created by lilin on 13-11-1.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKInboxCell.h"
#import "SKNewMailController.h"
@implementation SKInboxCell
{
    __weak NSDictionary* mailinfo;
}

-(void)deleteEmail
{

    NSString* sql = [NSString stringWithFormat:@"update  T_LOCALMESSAGE SET STATUS = 1 where MESSAGEID = '%@';",mailinfo[@"MESSAGEID"]];
    if ([[DBQueue sharedbQueue] updateDataTotableWithSQL:sql]){
        [_parentController getMailFromDataBase];
    }else{
        NSLog(@"删除邮件失败");
    }
}

//从服务器上彻底删除邮件
-(void)fullDeleteEmailFromServer:(NSString*)messageID
{
    NSString* urlStr = [[NSString stringWithFormat:@"%@/users/%@/%@/mail/%@/delete",ZZZobt,[APPUtils userUid],[APPUtils userPassword],messageID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    SKHTTPRequest *request = [SKHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setCompletionBlock:^{
        //添加侧彻底删除的界面处理
        NSString* sql = [NSString stringWithFormat:@"delete from T_LOCALMESSAGE where MESSAGEID = '%@';",messageID];
        [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
    }];
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [BWStatusBarOverlay showErrorWithMessage:@"删除邮件失败" duration:2 animated:1];
        });
    }];
    [request startAsynchronous];
}

//转发邮件
-(void)forwadEmail
{
    
    SKNewMailController* aEmail = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKNewMailController"];
    [aEmail setStatus:NewMailStatusForwad];
    [aEmail setDataDictionary:mailinfo];
    [self.parentController setMailIsRead:mailinfo[@"MESSAGEID"]];
    [[APPUtils visibleViewController].navigationController pushViewController:aEmail animated:YES];
}

//回复邮件
-(void)respondEmail
{
    SKNewMailController* aEmail = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKNewMailController"];
    [aEmail setStatus:NewMailStatusRespond];
    [aEmail setDataDictionary:mailinfo];
    [self.parentController setMailIsRead:mailinfo[@"MESSAGEID"]];
    [[APPUtils visibleViewController].navigationController  pushViewController:aEmail animated:YES];
}

//全部回复邮件
-(void)respondEmailAll
{
    SKNewMailController* aEmail =  [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKNewMailController"];
    [aEmail setStatus:NewMailStatusRespondAll];
    [aEmail setDataDictionary:mailinfo];
    [self.parentController setMailIsRead:mailinfo[@"MESSAGEID"]];
    [[APPUtils visibleViewController].navigationController  pushViewController:aEmail animated:YES];

}

-(void)moveEmailToInbox
{
    NSString* sql = [NSString stringWithFormat:@"update  T_LOCALMESSAGE SET STATUS = 0 where MESSAGEID = '%@';",mailinfo[@"MESSAGEID"]];
    if ([[DBQueue sharedbQueue] updateDataTotableWithSQL:sql]){
        [self.parentController getTrashFromDataBase];
    }else{
        NSLog(@"删除邮件失败");
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([mailinfo[@"STATUS"] intValue] == 0){
        switch (buttonIndex) {
            case 0://删除
            {
                [self deleteEmail];
                break;
            }
            case 1://彻底删除
            {
                [self fullDeleteEmailFromServer:mailinfo[@"MESSAGEID"]];
                [_parentController.dataArray removeObject:mailinfo];
                [_parentController.tableview reloadData];
                break;
            }
            case 2://转发
            {
                [self forwadEmail];
                break;
            }
            case 3://全部回复
            {
                [self respondEmailAll];
                break;
            }
            case 4://回复
            {
                [self respondEmail];
                break;
            }
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0://彻底删除
            {
                [self fullDeleteEmailFromServer:mailinfo[@"MESSAGEID"]];
                [_parentController.dataArray removeObject:mailinfo];
                [_parentController.tableview reloadData];
                break;
            }

            case 1://转发
            {
                [self forwadEmail];
                break;
            }
            case 2://全部回复
            {
                [self respondEmailAll];
                break;
            }
            case 3://回复
            {
                [self respondEmail];
                break;
            }
            case 4://彻底删除
            {
                [self moveEmailToInbox];
                break;
            }
            default:
                break;
        }
    }
    [actionSheet setDelegate:nil];
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer

{
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *actionSheet;
        if([mailinfo[@"STATUS"] intValue] == 0){
           actionSheet = [[UIActionSheet alloc] initWithTitle:mailinfo[@"SUBJECT"]
                                          delegate:self
                                 cancelButtonTitle:@"取消"
                            destructiveButtonTitle:@"删除"
                                 otherButtonTitles:@"彻底删除",@"转发",@"全部回复",@"回复",nil];
        }else{
            actionSheet = [[UIActionSheet alloc] initWithTitle:mailinfo[@"SUBJECT"]
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:@"彻底删除"
                                             otherButtonTitles:@"转发",@"回复全部",@"回复",@"恢复",nil];
        }

        actionSheet.actionSheetStyle = UIBarStyleBlack;
        [actionSheet showInView:[[APPUtils visibleViewController] view]];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPressReger.minimumPressDuration = 0.3;
        [self addGestureRecognizer:longPressReger];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString*)stringFromByte:(NSInteger)byteCount
{
    if(byteCount >= 0 && byteCount < 1024 * 1024){
        return [NSString stringWithFormat:@"%.1fK",byteCount/1024.0];
    }else{
        return [NSString stringWithFormat:@"%.1fM",byteCount/1048576.0];
    }
}

-(void)setMail:(NSDictionary*)mailInfo
{
    mailinfo = mailInfo;
    self.subjectLabel.text = mailInfo[@"SUBJECT"];
    self.senddateLabel.text = [[mailInfo[@"SENTDATE"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16];
    self.mailSizeLabel.text = [self stringFromByte:[mailInfo[@"SIZE"] intValue]];
    NSString* sender = mailInfo[@"SENDER"];
    self.recipientLabel.text = [[sender componentsSeparatedByString:@"<"] objectAtIndex:0];
    if ([mailInfo[@"ISREAD"] integerValue]==0)
    {
        [self.stateView setImage:[UIImage imageNamed:@"icon_unread.png"]];
    }
    else
    {
        [self.stateView setImage:[UIImage imageNamed:@"icon_read.png"]];
    }
    [self.attachView setHidden:![mailInfo[@"MIMETYPE"] isEqualToString:@"multipart/mixed"]];

}
@end
