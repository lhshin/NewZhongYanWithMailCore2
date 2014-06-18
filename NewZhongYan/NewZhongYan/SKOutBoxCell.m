//
//  SKOutBoxCell.m
//  NewZhongYan
//
//  Created by lilin on 13-11-4.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKOutBoxCell.h"

@implementation SKOutBoxCell
{
    __weak NSDictionary* mailinfo;
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

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"删除邮件"
                                                        otherButtonTitles:@"编辑邮件",nil];
        actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)//删除邮件
	{
        NSString* sql = [NSString stringWithFormat:@"delete from T_OUTBOX where ID = '%@'",
                         [mailinfo objectForKey:@"ID"]];
        [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
        [self.parentController getOutBoxMail];
    }else if (buttonIndex == 1){
        
    }else if(buttonIndex == 2){
        
    }
    //这里的释放还有疑问
    [actionSheet setDelegate:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMail:(NSDictionary*)mailInfo
{
    mailinfo = mailInfo;
    self.subjectLabel.text = [mailInfo objectForKey:@"SUBJECT"];
    self.recipientLabel.text = [mailInfo objectForKey:@"TO_TEXT"];
    NSDate* date = [DateUtils stringToDate:[mailInfo objectForKey:@"SENTDATE"] DateFormat:displayDateTimeFormat];
    self.senddateLabel.text =  [date dateToDetail];
}
@end
