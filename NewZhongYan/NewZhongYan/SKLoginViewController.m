//
//  SKLoginViewController.m
//  NewZhongYan
//
//  Created by lilin on 13-10-8.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKLoginViewController.h"
#import "SKPatternLockController.h"
#import "SKAgentLogonManager.h"
#import "SKViewController.h"
@interface SKLoginViewController ()

@end

@implementation SKLoginViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
//接收到消息后判断是否验证成功 成功就可以登录进去
-(void)LogginBack:(NSNotification*)aNotification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:NO completion:^{
            UINavigationController* nav = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"patternlocknav"];
            SKViewController* controller = (SKViewController*)[APPUtils visibleViewController];
            SKPatternLockController* locker = (SKPatternLockController*)[nav topViewController];
            [locker setDelegate:controller];
            [controller presentViewController:nav animated:NO completion:^{
                [self setLoginComponentStatus:YES];
            }];
        }];
    });
}
-(void)setLoginComponentStatus:(BOOL) status
{
    [_loginButton setEnabled:status];
    [_userField setEnabled:status];
    [_passField setEnabled:status];
    if (status) {
        [indicator stopAnimating];
    }else{
        [indicator startAnimating];
        [_userField  resignFirstResponder];
        [_passField resignFirstResponder];
    }
}

- (IBAction)login:(id)sender {
    if (_userField.text.length == 0 || _passField.text.length == 0)
    {
        [UIAlertView showAlertString:@"账号或者密码不能为空"];
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(LogginBack:)
                                                 name:@"LoginBack" object:nil];
    [self setLoginComponentStatus:NO];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        @try
        {
            [[APPUtils AppLogonManager] logonAgentWithUid:_userField.text Password:_passField.text] ;
        }
        @catch (NSException *exception)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setLoginComponentStatus:YES];
                UIAlertView* av = [[UIAlertView alloc] initWithTitle:[exception name]
                                                             message:[exception reason]
                                                            delegate:0
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:nil, nil];
                [av show];
            });
        }
    });
}

- (IBAction)cancel:(id)sender {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage* image = (IS_IPHONE_5)
    ? [UIImage imageNamed:@"login_bg_568"]
    :[UIImage imageNamed:@"login_bg"];
    _bgImageView.image = image;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:0 queue:0 usingBlock:^(NSNotification* note){
        NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        [UIView animateWithDuration:[duration floatValue] animations:^{
            [UIView setAnimationCurve:[curve intValue]];
            CGRect rect = [UIScreen mainScreen].bounds;
            rect.origin.y -= 216 -20 ;
            [self.view setFrame:rect];
        }];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:0 queue:0 usingBlock:^(NSNotification* note){
        NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        [UIView animateWithDuration:[duration floatValue] animations:^{
            [UIView setAnimationCurve:[curve intValue]];
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
                [self.view setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
            }else{
                [self.view setFrame:CGRectMake(0, 20, 320, [UIScreen mainScreen].bounds.size.height - 20)];
            }
        }];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (101 == textField.tag ) {
        [_passField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
