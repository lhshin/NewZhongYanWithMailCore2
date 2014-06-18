//
//  SKCommonLanguageCell.m
//  ZhongYan
//
//  Created by 袁树峰 on 13-2-26.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKCommonLanguageCell.h"
#import "UIImage+rescale.h"
#import "FileUtils.h"
@implementation SKCommonLanguageCell
@synthesize CLLabel,CLTextView,confirmBtn,isEditing,indexForCell;
- (void)roundTextView:(UIView *)txtView{
    txtView.layer.borderColor = UIColor.grayColor.CGColor;
    txtView.layer.borderWidth = 1;
    txtView.layer.cornerRadius = 3.0;
    txtView.layer.masksToBounds = YES;
    txtView.clipsToBounds = YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // modified by lilin for leak
        UIImageView *stateView=[[UIImageView alloc] init];
        UIImage *stateImage = [[UIImage imageNamed:@"oa_title_shrinkbg"] rescaleImageToSize:CGSizeMake(20, 20)];
        stateView.image = stateImage;
        [stateView setFrame:CGRectMake(5, 20, 15, 15)];
        [self.contentView addSubview:stateView];
        
        CLLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 280, 20)];
        [CLLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [CLLabel setFont:[UIFont systemFontOfSize:15]];
        [CLLabel setNumberOfLines:0];
        [self.contentView addSubview:CLLabel];
        
        CLTextView =[[HPGrowingTextView alloc] initWithFrame:CGRectMake(25, 13, 240, 20)];
        [CLTextView setFont:[UIFont systemFontOfSize:15]];
        [CLTextView setDelegate:self];
        [CLTextView setReturnKeyType:UIReturnKeyDone];
        [CLTextView setBackgroundColor:COLOR(208, 208, 208)];
        [self.contentView addSubview:CLTextView];
        
        confirmBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [confirmBtn setFrame:CGRectMake(270, 14, 40, 30)];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:confirmBtn];
        //添加键盘监视通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShowCommonL:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHideCommonL:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

-(void) keyboardWillShowCommonL:(NSNotification *)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect tableViewFrame = self.superview.frame;
    //keyboardBounds = [self convertRect:keyboardBounds toView:nil];
    tableViewFrame.size.height =[UIScreen mainScreen].bounds.size.height-20-44 - keyboardBounds.size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [self.superview setFrame:tableViewFrame];
    //[mainScrollview scrollRectToVisible:rect animated:YES];
    [UIView commitAnimations];
}
-(void) keyboardWillHideCommonL:(NSNotification *)note
{
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect tableViewFrame =self.superview.frame;
    tableViewFrame.size.height =[UIScreen mainScreen].bounds.size.height-44-46;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [self.superview setFrame:tableViewFrame];
    //[mainScrollview scrollRectToVisible:rect animated:YES];
    [UIView commitAnimations];
}

-(void)confirm:(id)sender
{
    NSMutableArray *phraseArray=[[NSMutableArray alloc] initWithArray:[FileUtils Phrase]];
    [phraseArray replaceObjectAtIndex:indexForCell withObject:CLTextView.text];
    [FileUtils setPhrase:phraseArray];
    [CLTextView resignFirstResponder];
    isEditing=NO;
    [CLTextView setHidden:YES];
    [confirmBtn setHidden:YES];
    [CLLabel setHidden:NO];
    NSNotification *noti=[NSNotification notificationWithName:@"confirmEditing" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)indexForCell],@"index", nil]];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark -growingTextViewDelegate
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    //[self rigisterObbserver];
    return YES;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    if (isEditing)
    {
        float diff = (growingTextView.frame.size.height - height);
        if ((int)diff == 0) return;
        CGRect cellRect=self.frame;
        cellRect.size.height-=diff;
        self.frame=cellRect;
        //[(UITableView *)self.superview reloadData];
        //将当前cell下方的cell位置向下移动
        NSInteger rowsNumber= [self.superTableView numberOfRowsInSection:0];
        for (int i=0; i<rowsNumber; i++)
        {
            if (i>indexForCell)
            {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                CGRect rect=[self.superTableView cellForRowAtIndexPath:indexPath].frame;
                rect.origin.y-=diff;
                [self.superTableView cellForRowAtIndexPath:indexPath].frame=rect;
            }
        }
    }
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    NSInteger number = [growingTextView.text length];
    if (number > 40)
    {
        growingTextView.text = [growingTextView.text substringToIndex:40];
        //number = 40;
    }
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [growingTextView resignFirstResponder];
    return YES;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
