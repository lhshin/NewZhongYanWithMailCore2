//
//  SKCommonLanguageController.m
//  ZhongYan
//
//  Created by linlin on 10/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKCommonLanguageController.h"
#import "UIImage+rescale.h"
#import "SKViewController.h"
#define TABLEHEIGHT [UIScreen mainScreen].bounds.size.height-49-44-20
#define DOWNY [UIScreen mainScreen].bounds.size.height-49-20
@interface SKCommonLanguageController()
{
    float changeDiff;//growingTextView变化的值
    NSMutableArray *editingIndexArray;//用来记录进入编辑状态下的cell的下标的数组
}
-(void)rigisterObbserver;
//注销监视
-(void)removeObbserver;
@end

@implementation SKCommonLanguageController
@synthesize PhraseArray;
@synthesize tableView = _tableView;
@synthesize textViewKey = _textViewKey;
@synthesize textViewText=_textViewText;
BOOL isEditing;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.PhraseArray = [NSMutableArray arrayWithArray:[FileUtils Phrase]];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

-(void)dismiss:(id)sender
{
    [self removeObbserver];
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addPhrase:(id)sender
{
    if (phraseTextField.text!=nil&&![phraseTextField.text isEqualToString:@""]) {
        [self.PhraseArray addObject:phraseTextField.text];
        [FileUtils setPhrase:self.PhraseArray];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.PhraseArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        phraseTextField.text = @"";
        
    }
}
#pragma mark - View lifecycle


- (void)roundTextView:(UIView *)txtView{
    txtView.layer.borderColor = UIColor.grayColor.CGColor;
    txtView.layer.borderWidth = 1;
    txtView.layer.cornerRadius = 3.0;
    txtView.layer.masksToBounds = YES;
    txtView.clipsToBounds = YES;
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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //添加编辑确定按钮通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(confirmEditing:)
                                                 name:@"confirmEditing"
                                               object:nil];
    
    self.title = @"常用语";
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TopY, 320,SCREEN_HEIGHT - 64 - 49) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:_tableView];
    
    downView=[[UIView alloc] initWithFrame:CGRectMake(0, BottomY - 49, 320, 49)];
    [self.view addSubview:downView];
    
    phraseTextField=[[HPGrowingTextView alloc] initWithFrame:CGRectMake(5, 5, 260, 35)];
    if (_textViewText&&![_textViewText isEqualToString:@""])
    {
        if (_textViewText.length>40)
        {
            _textViewText=[_textViewText substringToIndex:40];
        }
        phraseTextField.text=_textViewText;
    }
    [phraseTextField setDelegate:self];
    [phraseTextField setReturnKeyType:UIReturnKeyDone];
    [phraseTextField setMaxNumberOfLines:3];//最多两行]
    [phraseTextField setBackgroundColor:COLOR(208, 208, 208)];
    [downView addSubview:phraseTextField];
    
    UIButton *addBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"sigh_ecm"] forState:UIControlStateNormal];
    [addBtn setFrame:CGRectMake(270, 5, 45, 40)];
    [addBtn addTarget:self action:@selector(addPhrase:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:addBtn];
    isEditing=NO;
}

//完成编辑
-(void)confirmEditing:(NSNotification *)note
{
    [editingIndexArray removeObject:[[note userInfo] objectForKey:@"index"]];
    if (editingIndexArray.count>0)
    {
        isEditing=YES;
    }
    else
    {
        isEditing=NO;
    }
    self.PhraseArray=[FileUtils Phrase];
    [self.tableView reloadData];
}


#pragma mark - View tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return PhraseArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* identify = @"phrase";
    SKCommonLanguageCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[SKCommonLanguageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPressReger.minimumPressDuration = 0.3;
        [cell addGestureRecognizer:longPressReger];
    }
    cell.CLLabel.numberOfLines = 0;
    cell.CLLabel.text = [self.PhraseArray objectAtIndex:indexPath.row];
    float lheight=[cell.CLLabel.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(cell.CLLabel.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
    CGRect rect=cell.CLLabel.frame;
    rect.size.height=lheight;
    cell.CLLabel.frame=rect;
    cell.CLTextView.text=[self.PhraseArray objectAtIndex:indexPath.row];
    cell.indexForCell=indexPath.row;
    cell.superTableView = _tableView;
    if (!isEditing)
    {
        [cell.CLTextView setHidden:YES];
        [cell.confirmBtn setHidden:YES];
        [cell.CLLabel setHidden:NO];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:[self.PhraseArray objectAtIndex:indexPath.row] forKey:self.textViewKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"phrase" object:0 userInfo:dict];
    SKViewController* controller = [APPUtils AppRootViewController];
    [controller.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString* text = [self.PhraseArray objectAtIndex:indexPath.row];
    CGFloat contentWidth = 280;
    // 计算出长宽
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(contentWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = size.height+35;
    
    NSString *index=[NSString stringWithFormat:@"%ld",(long)[indexPath row]];
    
    for (NSString *str in editingIndexArray)
    {
        if ([str isEqualToString:index])
        {
            CGSize tsize = [text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(240, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
            height=tsize.height+40;
        }
    }
    return height;
}

#pragma mark -growingTextViewDelegate
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    [self rigisterObbserver];
    return YES;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    if (!isEditing)
    {
        float diff = (growingTextView.frame.size.height - height);
        if ((int)diff == 0) return;
        changeDiff+=diff;
        CGRect downRect = downView.frame;
        downRect.size.height-=diff;
        downRect.origin.y+=diff;
        downView.frame=downRect;
        
        CGRect tableRect = _tableView.frame;
        tableRect.size.height+=diff;
        [_tableView setFrame:tableRect];
    }
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    NSInteger number = [growingTextView.text length];
    if (number > 40)
    {
        growingTextView.text = [growingTextView.text substringToIndex:40];
    }
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [growingTextView resignFirstResponder];
    return YES;
}


#pragma mark -KeyboardNotificationMethods
-(void) keyboardWillShowCommonL:(NSNotification *)note
{
    if (!isEditing)
    {
        CGRect keyboardBounds;
        [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
        NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        CGRect tableViewFrame = self.tableView.frame;
        CGRect downRect = downView.frame;
        
        keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
        tableViewFrame.size.height  = TABLEHEIGHT-keyboardBounds.size.height+changeDiff;
        downRect.origin.y=TABLEHEIGHT+TopY+changeDiff-keyboardBounds.size.height;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        [self.tableView setFrame:tableViewFrame];
        [downView setFrame:downRect];
        //[mainScrollview scrollRectToVisible:rect animated:YES];
        [UIView commitAnimations];
    }
    else
    {
        CGRect keyboardBounds;
        [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
        NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        CGRect tableViewFrame = self.tableView.frame;
        
        keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
        tableViewFrame.size.height =TABLEHEIGHT - keyboardBounds.size.height;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        [self.tableView setFrame:tableViewFrame];
        //[mainScrollview scrollRectToVisible:rect animated:YES];
        [UIView commitAnimations];
    }
}

-(void) keyboardWillHideCommonL:(NSNotification *)note
{
    if (!isEditing)
    {
        NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        CGRect mainFrame = self.view.frame;
        mainFrame.origin.y=0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        [self.tableView setFrame:CGRectMake(0, TopY, 320, TABLEHEIGHT+changeDiff)];
        [downView setFrame:CGRectMake(0, BottomY - 49 + changeDiff, 320, 49 - changeDiff)];
        [UIView commitAnimations];
    }
    else
    {
        CGRect keyboardBounds;
        [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
        NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        CGRect tableViewFrame = self.tableView.frame;
        tableViewFrame.size.height =TABLEHEIGHT;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        [self.tableView setFrame:tableViewFrame];
        //[mainScrollview scrollRectToVisible:rect animated:YES];
        [UIView commitAnimations];
    }
}


-(void) keyboardDidShowCommonL:(NSNotification *)note
{
    if ([phraseTextField isFirstResponder]) {
        if (PhraseArray.count) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.PhraseArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
    }
}

-(void)rigisterObbserver
{
    //添加键盘监视通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowCommonL:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowCommonL:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideCommonL:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//注销监视
-(void)removeObbserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"confirmEditing" object:nil];
}
#pragma mark -长按菜单
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView  indexPathForRowAtPoint:point];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更多操作"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"删除"
                                                        otherButtonTitles:@"编辑",nil];
        actionSheet.destructiveButtonIndex = 2;
        actionSheet.tag = indexPath.row;
        actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://删除
        {
            [self.PhraseArray removeObjectAtIndex:actionSheet.tag];
            [FileUtils setPhrase:self.PhraseArray];
            [self.tableView reloadData];
            break;
        }
        case 1://编辑
        {
            if (!editingIndexArray)
            {
                editingIndexArray=[[NSMutableArray alloc] init];
            }
            //当前下标
            NSString *currentIndex=[NSString stringWithFormat:@"%ld",(long)actionSheet.tag];
            //如果当前下标已经存在与下标编辑下标数组，不进入编辑状态
            for (NSString *str in editingIndexArray)
            {
                if ([str isEqualToString:currentIndex])
                {
                    return;
                }
            }
            [editingIndexArray addObject:currentIndex];
            
            NSIndexPath *indexP=[NSIndexPath indexPathForRow:actionSheet.tag inSection:0];
            SKCommonLanguageCell *cell=(SKCommonLanguageCell *)[self.tableView cellForRowAtIndexPath:indexP];
            //计算textView的行数
            CGSize tsize = [cell.CLTextView.text sizeWithFont:[cell.CLTextView font]];
            int tlength = tsize.height;
            int tRowNumber = cell.CLTextView.internalTextView.contentSize.height/tlength;
            //计算label的行数
            CGSize lsize = [cell.CLLabel.text sizeWithFont:[cell.CLLabel font]];
            int llength = lsize.height;
            int lRowNumber = cell.CLLabel.frame.size.height/llength;
            //如果textView行数大于label的行数
            if (lRowNumber<tRowNumber)
            {
                CGRect cellRect=cell.frame;
                cellRect.size.height+=25;
                cell.frame=cellRect;
                NSInteger rowsNumber= [self.tableView numberOfRowsInSection:0];
                for (int i=0; i<rowsNumber; i++)
                {
                    if (i>actionSheet.tag)
                    {
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                        CGRect rect=[self.tableView cellForRowAtIndexPath:indexPath].frame;
                        rect.origin.y+=25;
                        [self.tableView cellForRowAtIndexPath:indexPath].frame=rect;
                    }
                }
            }
            
            cell.isEditing=YES;
            [cell.CLLabel setHidden:YES];
            [cell.CLTextView setHidden:NO];
            [cell.confirmBtn setHidden:NO];
            isEditing=YES;
            [cell.CLTextView becomeFirstResponder];
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
            break;
        }
        default:
            break;
    }
    [actionSheet setDelegate:nil];
    
}
@end
