//
//  SKSecretController.m
//  NewZhongYan
//
//  Created by lilin on 13-12-4.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKSecretController.h"
#import "SKSToolBar.h"
#import "TextDownView.h"
#import "SKPatternLockController.h"
#import "SKViewController.h"
@interface SKSecretController ()
{
    int currentTextViewindex;
    float currentTextViewYlocation;
    float keyboardHeight;
}
@end

@implementation SKSecretController
-(IBAction)modifySafePassWord:(id)sender
{
//    CGRect rect = [UIScreen mainScreen].bounds;
//    rect.origin.y += 20;
//    rect.size.height -= 20;
//    SKPatternLockVIew* pcv = [[SKPatternLockVIew alloc] initWithFrame:rect];
//    [pcv setIsChangePsw:YES];
//    [pcv changePassWord];
//    [[APPUtils APPdelegate].window addSubview:pcv];
//    [pcv release];
//    
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.2f;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.fillMode = kCAFillModeForwards;
//    animation.removedOnCompletion = YES;
//    animation.type = kCATransitionFade;
//    animation.subtype = kCATransitionFromTop;
//    [[APPUtils APPdelegate].window.layer addAnimation:animation forKey:@"animation"];
    
    UIViewController* controller = [APPUtils visibleViewController];
    UINavigationController* nav = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"patternlocknav"];
    SKPatternLockController* locker = (SKPatternLockController*)[nav topViewController];
    [controller presentViewController:nav animated:YES completion:^{
        [locker setIsChangePsw:YES];
        [locker changePassWord];
    }];

}

-(void)clearTextView
{
    [oldTextView setText:@""];
    [newATextView setText:@""];
    [newBTextView setText:@""];
}

-(BOOL)checkNewPassword
{
    return [newATextView.text isEqualToString:newBTextView.text];
}

-(void)afterChangePasswordSuccess
{
    [[APPUtils loggedUser] setPassword:newBTextView.text];
    NSString* sql = [NSString stringWithFormat:@"UPDATE USER_REMS SET WPWD = '%@';",newBTextView.text];
    [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
}

//上一项
-(void)previousText
{
    if ([oldTextView isFirstResponder])
    {
        return;
    }
    else if([newATextView isFirstResponder])
    {
        [oldTextView becomeFirstResponder];
    }
    else if([newBTextView isFirstResponder])
    {
        [newATextView becomeFirstResponder];
    }
    [self setToolBarItemEnable];
}
//下一项
-(void)nextText
{
    if ([oldTextView isFirstResponder])
    {
        [newATextView becomeFirstResponder];
    }
    else if([newATextView isFirstResponder])
    {
        [newBTextView becomeFirstResponder];
    }
    else if([newBTextView isFirstResponder])
    {
        return;
    }
    [self setToolBarItemEnable];
    
}

//完成
-(void)doneTextEditing
{
    [oldTextView resignFirstResponder];
    [newBTextView resignFirstResponder];
    [newATextView resignFirstResponder];
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
    
    [self.view setBackgroundColor:COLOR(239, 239, 239)];
    
    [oldTextView setDelegate:self];
    [newATextView setDelegate:self];
    [newBTextView setDelegate:self];
    
    SKSToolBar* myToolBar = [[SKSToolBar alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    [myToolBar.firstButton addTarget:self action:@selector(clearTextView) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.secondButton addTarget:self action:@selector(savePasswordToServer) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar setFirstItem:@"btn_clean_ecm" Title:@"清除"];
    [myToolBar setSecondItem:@"btn_save_ecm" Title:@"保存"];
    [toolView addSubview:myToolBar];
    
    previousBtn=[[UIBarButtonItem alloc] initWithTitle:@"上一项"
                                                 style:UIBarButtonItemStyleBordered
                                                target:self
                                                action:@selector(previousText)];
    
    nextBtn=[[UIBarButtonItem alloc] initWithTitle:@"下一项"
                                             style:UIBarButtonItemStyleBordered
                                            target:self
                                            action:@selector(nextText)];
    
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
    doneBtn=[[UIBarButtonItem alloc] initWithTitle:@"确定"
                                             style:UIBarButtonItemStyleDone
                                            target:self
                                            action:@selector(doneTextEditing)];
    textToolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0,BottomY, 320, 44)];
    [textToolBar setItems:[NSArray arrayWithObjects:previousBtn,nextBtn,flexibleSpaceItem,doneBtn,nil]];
    if (System_Version_Small_Than_(7)) {
        [textToolBar setBarStyle:UIBarStyleBlackTranslucent];
    }
    [self.view addSubview:textToolBar];
    currentTextViewYlocation=0;
    [self rigisterObbserver];
}

-(void)rigisterObbserver
{
    //添加键盘监视通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//销毁监视
-(void)removeoObb
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)dealloc
{
    [self removeoObb];
}

-(void)savePasswordToServer
{
    if (![self checkNewPassword]) {
        [BWStatusBarOverlay showErrorWithMessage:@"两次输入的密码不一致" duration:1 animated:1];
        return;
    }
    NSURL* url = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@/users/userinfo/changePassword",ZZZobt]];
    SKFormDataRequest *savePasswordRequest = [SKFormDataRequest requestWithURL:url];
    [savePasswordRequest setPostValue:[APPUtils userUid] forKey:@"userid"];
    [savePasswordRequest setPostValue:[oldTextView text] forKey:@"oldPwd"];
    [savePasswordRequest setPostValue:[newBTextView text] forKey:@"newPwd"];
    __weak SKFormDataRequest* req = savePasswordRequest;
    [savePasswordRequest setCompletionBlock:^{
        if (req.responseStatusCode != 200) {
            [BWStatusBarOverlay showErrorWithMessage:@"网络异常..." duration:1 animated:1];return;
        }else if([[req responseString] isEqualToString:@"OK"]) {
            [BWStatusBarOverlay showErrorWithMessage:@"密码修改成功" duration:1 animated:1];
        }else{
            [BWStatusBarOverlay showErrorWithMessage:[req responseString] duration:1 animated:1];
        }
    }];
    [savePasswordRequest setFailedBlock:^{
        NSError *error = [req error];
        [BWStatusBarOverlay showErrorWithMessage:[NetUtils userInfoWhenRequestOccurError:error] duration:1 animated:1];
    }];
    [savePasswordRequest startAsynchronous];
}

#pragma mark -textDelegate
-(void)setScrollViewOffsetWithTextView
{
    //57 110 164
    if (currentTextViewYlocation==57)
    {
        [mainScrollView setContentOffset:CGPointMake(0, 52) animated:YES];
    }
    else if(currentTextViewYlocation==110)
    {
        [mainScrollView setContentOffset:CGPointMake(0, 52) animated:YES];
    }
    else
    {
        [mainScrollView setContentOffset:CGPointMake(0, 60) animated:YES];
    }
}

- (BOOL)textFieldShouldBeginEditing:(SKCTextField *)textField
{
    currentTextViewYlocation=textField.frame
    .origin.y;
    if ([UIScreen mainScreen].bounds.size.height!=568)
    {
        [self setScrollViewOffsetWithTextView];
    }
    
    TextDownView *tdView;
    if (textField.textDownView)
    {
        tdView=textField.textDownView;
    }
    else
    {
        tdView=[[TextDownView alloc] initWithFrame:CGRectMake(textField.frame.origin.x, CGRectGetMaxY(textField.frame), 150, 20)];
        tdView.noticeLabel.font=[UIFont systemFontOfSize:12];
        [mainScrollView addSubview:tdView];
        textField.textDownView=tdView;
    }
    if(textField==oldTextView)
    {
        tdView.noticeLabel.text=@"请输入原始密码";
    }
    else if(textField==newATextView)
    {
        tdView.noticeLabel.text=@"请输入新密码";
    }
    else
    {
        tdView.noticeLabel.text=@"请再次输入新密码";
    }
    [tdView.flagImage setImage:[UIImage imageNamed:@"warning.png"]];
    [tdView.noticeLabel setTextColor:[UIColor colorWithRed:0/255.0  green:89.0/255.0 blue:175.0/255.0 alpha:1]];
    return YES;
}

#pragma mark- 键盘show hide
-(void) keyboardWillShow:(NSNotification *)note
{
    
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    if ([UIScreen mainScreen].bounds.size.height!=568)
    {
        [mainScrollView setContentSize:CGSizeMake(320, 310)];
    }
    CGRect rect=self.view.frame;
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    keyboardHeight=keyboardBounds.size.height;
    CGRect toolbarFrame=textToolBar.frame;
    toolbarFrame.origin.y = BottomY - keyboardHeight - 44;
    [self setToolBarItemEnable];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [textToolBar setFrame:toolbarFrame];
    [self.view setFrame:rect];
    [UIView commitAnimations];
}

-(void)setToolBarItemEnable
{
    [previousBtn setEnabled:![oldTextView isFirstResponder]];
    [nextBtn setEnabled:![newBTextView isFirstResponder]];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    CGRect toolbarFrame=textToolBar.frame;
    toolbarFrame.origin.y= BottomY;
    [mainScrollView setContentSize:CGSizeMake(320, 237)];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [textToolBar setFrame:toolbarFrame];
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(SKCTextField *)textField;
{
    [self setToolBarItemEnable];
}

- (void)textFieldDidEndEditing:(SKCTextField *)textField
{
    TextDownView *tdView=textField.textDownView;
    [tdView setHidden:NO];
    if(textField==oldTextView)
    {
        if ([textField.text isEqualToString:@""])
        {
            
            tdView.noticeLabel.text=@"必须填写原始密码!";
        }
        else
        {
            [tdView setHidden:YES];
        }
    }
    else if(textField==newATextView)
    {
        if ([textField.text isEqualToString:@""])
        {
            tdView.noticeLabel.text=@"必须填写新密码!";
        }
        else
        {
            [tdView setHidden:YES];
        }
    }
    else
    {
        if (![newATextView.text isEqualToString:newBTextView.text])
        {
            tdView.noticeLabel.text=@"两次输入的密码不一致!";
        }
        else
        {
            [tdView setHidden:YES];
        }
    }
    [tdView.flagImage setImage:[UIImage imageNamed:@"error.png"]];
    [tdView.noticeLabel setTextColor:[UIColor redColor]];
}
@end
