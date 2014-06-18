//
//  SKPatternLockController.m
//  NewZhongYan
//
//  Created by lilin on 13-10-11.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKPatternLockController.h"
#import "SKLoginViewController.h"
#import "SKIntroView.h"
#define MATRIX_SIZE 3
#define MAXCOUNT 3
@interface SKPatternLockController ()
{
    NSMutableArray* _paths;//路径
    NSMutableArray *touchedImages;
    UIButton *changePassWordBtn;
}
@end

@implementation SKPatternLockController
@synthesize delegate;
- (IBAction)quitApp:(id)sender {
    if (_isChangePsw) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [UIView animateWithDuration:2 animations:^{
            [self.view setAlpha:0.3];
        } completion:^(BOOL complete){
            exit(-1);
        }];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)help:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popupHelp" object:nil];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        touchedImages=[[NSMutableArray alloc] init];
        _paths = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)clearData
{
    //清楚数据
}

-(void)returnToLogin
{
    //消失
    [self dismissViewControllerAnimated:YES completion:^{
        [FileUtils setvalueToPlistWithKey:@"gpsw" Value:@""];
        [FileUtils setvalueToPlistWithKey:@"gpusername" Value:[APPUtils userUid]];
        [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from USER_REMS"];
        SKLoginViewController* loginController = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"loginController"];
        [[APPUtils visibleViewController] presentViewController:loginController animated:NO completion:^{
            [loginController.userField setText:[FileUtils valueFromPlistWithKey:@"gpusername"]];
            [loginController.userField setEnabled:NO];
        }];
    }];
}

//退出按钮
-(void)returnBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSelector:@selector(abortApp) withObject:nil afterDelay:2];
        
    }];
}

//忘记密码按钮
-(void)forgetPassWord:(id)sender
{
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"警告" message:@"本操作将清除本机保护密码，并要求重新输入门户密码登录，是否继续？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [self performSelector:@selector(returnToLogin) withObject:nil afterDelay:0.3];
    }
}

//获取滑动生成的key
- (NSString *)getKey
{
    NSMutableString *key;
    key = [[NSMutableString alloc] init];
    
    for (NSNumber *tag in _paths)
    {
        [key appendFormat:@"%d", tag.intValue];
    }
    return key;
}

-(void)turnImagesBackToNormal
{
    for (UIImageView *vi in touchedImages)
    {
        vi.Highlighted=NO;
        [vi setImage:[UIImage imageNamed:@"indicator_code_lock_point_area_default_holo.png"]];
    }
    [touchedImages removeAllObjects];
    [drawView setIsError:NO];
    [drawView clearDotViews];
    [drawView setNeedsDisplay];
}

-(void)initNavBar
{
    self.navigationItem.backBarButtonItem.title = @"返回";
    UIImage* navbgImage;
    if (System_Version_Small_Than_(7)) {
        navbgImage = [UIImage imageNamed:@"navbar44"] ;
        self.navigationController.navigationBar.tintColor = COLOR(0, 97, 194);
    }else{
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.navigationBar.translucent = YES;
        navbgImage = [UIImage imageNamed:@"navbar64"] ;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    [self.navigationController.navigationBar setBackgroundImage:navbgImage  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
}

//从plist文件中取出密码
-(void)getPassWord
{
    if ([FileUtils valueFromPlistWithKey:@"gpsw"]) {
        password=[[NSString alloc] initWithString:[FileUtils valueFromPlistWithKey:@"gpsw"]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavBar];
    
    //修改密码按钮
    changePassWordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [changePassWordBtn setTitle:@"修改保护密码" forState:UIControlStateNormal];
    [changePassWordBtn setFrame:CGRectMake(0, BottomY - 44 , 150,44)];
    [changePassWordBtn addTarget:self action:@selector(changePassWord) forControlEvents:UIControlEventTouchUpInside];
    [changePassWordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:changePassWordBtn];
    
    //忘记密码按钮
    UIButton *forgetPassWordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPassWordBtn setTitle:@"忘记保护密码" forState:UIControlStateNormal];
    [forgetPassWordBtn setFrame:CGRectMake(SCREEN_WIDTH-150, BottomY - 44, 150,44)];
    [forgetPassWordBtn addTarget:self action:@selector(forgetPassWord:) forControlEvents:UIControlEventTouchUpInside];
    [forgetPassWordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.view addSubview:forgetPassWordBtn];
    
    [self getPassWord];
    if (!password||[password isEqualToString:@""])
    {
        [markLabel setText:@"请设置新密码"];
        status=PatternLockStatusInputingNewPassword;
    }
    else
    {
        //设置当前状态为未解锁状态
        status=PatternLockStatusUnlocking;
        errorCount=0;
    }
    
    
    for (int i=0; i<MATRIX_SIZE; i++)
    {
        for (int j=0; j<MATRIX_SIZE; j++)
        {
            UIImage *dotImage = [UIImage imageNamed:@"indicator_code_lock_point_area_default_holo.png"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:dotImage
                                                       highlightedImage:[UIImage imageNamed:@"indicator_code_lock_point_area_green_holo.png"]];
            imageView.frame = CGRectMake(0, 0, 70,70);
            imageView.userInteractionEnabled = YES;
            imageView.tag = j * MATRIX_SIZE + i + 1;
            UITapGestureRecognizer *tapRec=
            [[UITapGestureRecognizer alloc] initWithTarget:drawView action:@selector(handleTap:)] ;
            [imageView addGestureRecognizer:tapRec];
            [drawView addSubview:imageView];
        }
    }
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"Intro"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Intro"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        SKIntroView *introView=[[SKIntroView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height)];
        [[APPUtils APPdelegate].window addSubview:introView];
    }
}

- (void)viewWillLayoutSubviews
{
    int w = drawView.frame.size.width/MATRIX_SIZE;
    int h = drawView.frame.size.height/MATRIX_SIZE;
    
    int i=0;
    for (UIView *view in drawView.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            int x = w*(i/MATRIX_SIZE) + w/2;
            int y = h*(i%MATRIX_SIZE) + h/2;
            view.center = CGPointMake(x, y);
            i++;
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray * touchesArr=[[event allTouches] allObjects];
    if (touchesArr.count > 1)
    {
        return;
    }
    if ([[touches anyObject] locationInView:self.view].y<=drawView.frame.origin.y||[[touches anyObject] locationInView:self.view].y>=drawView.frame.origin.y+drawView.frame.size.height)
    {
        return;
    }
    if ([[[touches anyObject] view] isKindOfClass:[UIImageView class]]) {
        [(UIImageView *)[[touches anyObject] view] setHighlighted:YES];
    }
    [_paths removeAllObjects];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray * touchesArr=[[event allTouches] allObjects];
    if (touchesArr.count > 1) {
        return;
    }
    if ([[touches anyObject] locationInView:self.view].y<=drawView.frame.origin.y||[[touches anyObject] locationInView:self.view].y>=drawView.frame.origin.y+drawView.frame.size.height)
    {
        [self turnImagesBackToNormal];
        return;
    }
    
    CGPoint pt = [[touches anyObject] locationInView:drawView];
    UIView *touched = [drawView hitTest:pt withEvent:event];
    [drawView drawLineFromLastDotTo:pt];
    
    if (touched!=drawView)
    {
        BOOL found = NO;
        for (NSNumber *tag in _paths) {
            found = tag.integerValue==touched.tag;
            if (found)
                break;
        }
        
        if (found) return;
        if (touched) {// add by lilin 做一个判断 有可能取不到
            [_paths addObject:[NSNumber numberWithInt:(int)touched.tag]];
            [drawView addDotView:touched];
            
            UIImageView* iv = (UIImageView*)touched;
            iv.highlighted = YES;
            [touchedImages addObject:iv];
        }
    }
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!drawView) {
        return;
    }
    NSArray * touchesArr=[[event allTouches] allObjects];
    if (touchesArr.count > 1) {
        return;
    }
    if ([[touches anyObject] locationInView:self.view].y<=drawView.frame.origin.y||[[touches anyObject] locationInView:self.view].y>=drawView.frame.origin.y+drawView.frame.size.height)
    {
        [self turnImagesBackToNormal];
        return;
    }
    
    for (UIView *view in drawView.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            [(UIImageView*)view setHighlighted:NO];
        }
    }
    drawView._trackPointValue = CGPointZero;
    [drawView setNeedsDisplay];
    if (_paths.count>1)
    {
        switch (status)
        {
            case PatternLockStatusUnlocking:
                [self OnpatternLockUnlockDone:[self getKey]];
                break;
            case PatternLockStatusInputingOldPassword:
                [self OnpatternLockInputOldPasswordDone:[self getKey]];
                break;
            case PatternLockStatusInputingNewPassword:
                [self OnpatternLockSetPasswordFirstTimeDone:[self getKey]];
                break;
            case PatternLockStatusConfirmingNewPassword:
                [self OnpatternLockConfirmPasswordDone:[self getKey]];
                break;
            default:
                break;
        }
    }
    else
    {
        [drawView clearDotViews];
        [drawView setNeedsDisplay];
    }
}


-(void)errorHappened
{
    for (UIImageView *vi in touchedImages)
    {
        [vi setImage:[UIImage imageNamed:@"indicator_code_lock_point_area_red_holo.png"]];
    }
    [drawView setIsError:YES];
    [drawView setNeedsDisplay];
    [self performSelector:@selector(turnImagesBackToNormal) withObject:nil afterDelay:1.0];
}

//代理
-(void)OnpatternLockUnlockDone:(NSString *)key
{
    if (![key isEqualToString:password])
    {
        if (key.length<=4)
        {
            markLabel.text=@"密码必须大于5位";
            [self errorHappened];
            return;
        }
        errorCount+=1;
        if (errorCount==MAXCOUNT)
        {
            [self clearData];
            [self returnToLogin];
        }
        markLabel.text=[NSString stringWithFormat:@"密码错误，您还可以输入%d次",MAXCOUNT-errorCount];
        [self errorHappened];
        
    }
    else
    {
        [touchedImages removeAllObjects];
        [self dismissViewControllerAnimated:YES completion:^{
            if (delegate&&[delegate respondsToSelector:@selector(onPatternLockSuccess)])
            {
                [delegate onPatternLockSuccess];
            }
        }];
    }
}

//确认 修改密码输入旧密码
-(void)OnpatternLockInputOldPasswordDone:(NSString *)key
{
    if (![key isEqualToString:password])
    {
        markLabel.text=[NSString stringWithFormat:@"密码错误"];
        [self errorHappened];
    }
    else
    {
        [touchedImages removeAllObjects];
        markLabel.text=@"请设置新密码";
        status=PatternLockStatusInputingNewPassword;
        [drawView clearDotViews];
    }
}

//第一次设置密码完成
-(void)OnpatternLockSetPasswordFirstTimeDone:(NSString *)key
{
    if (key.length<=4)
    {
        markLabel.text=@"密码必须大于5位";
        [self errorHappened];
        return;
    }
    [touchedImages removeAllObjects];
    firstPassword=[[NSString alloc] initWithString:key];
    markLabel.text=@"请确认新密码";
    status=PatternLockStatusConfirmingNewPassword;
    [drawView clearDotViews];
}

//确认是否修改密码成功
-(void)OnpatternLockConfirmPasswordDone:(NSString *)key
{
    if (![key isEqualToString:firstPassword])
    {
        markLabel.text=[NSString stringWithFormat:@"两次输入密码不一致，请重新输入"];
        status = PatternLockStatusInputingNewPassword;
        [self errorHappened];
    }
    else
    {
        [FileUtils setvalueToPlistWithKey:@"gpsw" Value:key];
        if (delegate&&[delegate respondsToSelector:@selector(onPatternLockSuccess)])
        {
            [delegate onPatternLockSuccess];
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

//修改密码按钮
-(void)changePassWord
{
    markLabel.text=@"请输入旧密码";
    if (status==PatternLockStatusInputingNewPassword||status==PatternLockStatusConfirmingNewPassword)
    {
        return;
    }
    if (status!=PatternLockStatusInputingOldPassword)
    {
        status=PatternLockStatusInputingOldPassword;
        markLabel.text=@"请输入旧密码";
        [changePassWordBtn setTitle:@"输入保护密码" forState:UIControlStateNormal];
        
    }
    else
    {
        status=PatternLockStatusUnlocking;
        markLabel.text=@"请输入保护密码";
        [changePassWordBtn setTitle:@"修改保护密码" forState:UIControlStateNormal];
        
    }
}

@end
