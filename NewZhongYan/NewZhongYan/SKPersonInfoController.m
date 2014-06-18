//
//  SKPersonInfoController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-14.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKPersonInfoController.h"
#import "SKSToolBar.h"
#import "SKMessageEntity.h"
@interface SKPersonInfoController ()
{
    UIBarButtonItem *previousBtn;
    UIBarButtonItem *nextBtn;
    UIBarButtonItem *doneBtn;
    UIToolbar *textToolBar;
    
    CGFloat keyboardHeight;
    NSInteger currentTextViewIndex;
    NSDictionary* personInfoDictionary;
    float changeHeight;//增长的高度
    
}
@end

@implementation SKPersonInfoController
-(void)dealloc
{
    mobileTextField.delegate = nil;
    shortPhoneTextField.delegate = nil;
    telephoneTextField.delegate = nil;
    officeAddressTextField.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)roundTextView:(UIView *)txtView{
    txtView.layer.borderColor = UIColor.grayColor.CGColor;
    txtView.layer.borderWidth = 1;
    txtView.layer.cornerRadius = 3.0;
    txtView.layer.masksToBounds = YES;
    txtView.clipsToBounds = YES;
}

-(void)refreshViewWithNetData
{
    [departmentLabel setText:[personInfoDictionary objectForKey:@"deptName"]];
    [mailLabel setText:[[personInfoDictionary objectForKey:@"email"] stringByReplacingOccurrencesOfString:@"@" withString:@"\n@"]];
    [mobileTextField setText:[personInfoDictionary objectForKey:@"mobile"]];
    [shortPhoneTextField setText:[personInfoDictionary objectForKey:@"shortPhone"]];
    [telephoneTextField setText:[personInfoDictionary objectForKey:@"telephone"]];
    [officeAddressTextField setText:[personInfoDictionary objectForKey:@"officeAddress"]];
}

-(void)refreshViewWithLocalData
{
    [departmentLabel setText:[personInfoDictionary objectForKey:@"UCNAME"]];
    [mailLabel setText:[personInfoDictionary objectForKey:@"EMAIL"]];
    [mobileTextField setText:[personInfoDictionary objectForKey:@"MOBILE"]];
    [shortPhoneTextField setText:[personInfoDictionary objectForKey:@"SHORTPHONE"]];
    [telephoneTextField setText:[personInfoDictionary objectForKey:@"TELEPHONE"]];
    [officeAddressTextField setText:[personInfoDictionary objectForKey:@"OFFICEADDRESS"]];
}

-(void)getUserInfoFromServer
{
    NSString* urlStr =
    [[NSString stringWithFormat:@"%@/users/%@/userinfo",ZZZobt,[APPUtils userUid]]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    SKHTTPRequest *request = [SKHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    __weak SKHTTPRequest *req = request;
    [request setCompletionBlock:^{
        SKMessageEntity* entity = [[SKMessageEntity alloc] initWithData:req.responseData] ;
        personInfoDictionary = [[NSDictionary alloc] initWithDictionary:[entity dataItem:0]];
        [self refreshViewWithNetData];
    }];
    [request setFailedBlock:^{
        [BWStatusBarOverlay showMessage:@"获取个人信息失败" duration:1 animated:1];
        NSString* sql =[NSString stringWithFormat:
                        @"SELECT E.CNAME,E.MOBILE,E.EMAIL,E.MOBILE,E.SHORTPHONE,E.TELEPHONE,E.TNAME,E.OFFICEADDRESS,U.CNAME UCNAME,U.PNAME\
                        FROM T_UNIT U LEFT JOIN T_EMPLOYEE E\
                        ON U.DPID = E.DPID\
                        WHERE E.UID = '%@';",[APPUtils userUid]];
        personInfoDictionary = [[NSDictionary alloc] initWithDictionary:[[[DBQueue sharedbQueue] recordFromTableBySQL:sql] objectAtIndex:0]];
        [self refreshViewWithLocalData];
    }];
    [request startAsynchronous];
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createPersonInfoView
{
    CGRect titleRect = CGRectMake(0, 20, 320, 100);
    UIView* titleView = [[UIView alloc] initWithFrame:titleRect];
    titleView.layer.borderColor = COLOR(220, 220, 223).CGColor;
    titleView.layer.borderWidth = 1;
    [titleView setBackgroundColor:[UIColor whiteColor]];    [mainScrollView addSubview:titleView];
    
    CGRect headrect =  CGRectMake(20,10, 80, 80);
    UIButton* headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headBtn setFrame:headrect];
    [headBtn setImage:Image(@"avatar") forState:UIControlStateNormal];
    [titleView addSubview:headBtn];
    
    UIView* verView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headrect) + 10, 10, 1, 80)];
    [verView setBackgroundColor:[UIColor lightGrayColor]];
    [titleView addSubview:verView];
    
    CGRect namerect = CGRectMake(CGRectGetMaxX(headrect) + 20, 10, 195, 25);
    nameLabel = [[UILabel alloc] initWithFrame:namerect];
    nameLabel.text = [APPUtils userName];
    [titleView addSubview:nameLabel];
    
    CGRect departmentrect = CGRectMake(CGRectGetMaxX(headrect) + 20, CGRectGetMaxY(headrect) - 35, 195, 35);
    departmentLabel = [[UILabel alloc] initWithFrame:departmentrect];
    [titleView addSubview:departmentLabel];
    
    
    CGRect emailRect = CGRectMake(0, CGRectGetMaxY(titleView.frame) + 20, 320, 60);
    UIView* emaliView = [[UIView alloc] initWithFrame:emailRect];
    emaliView.layer.borderColor = COLOR(220, 220, 223).CGColor;
    emaliView.layer.borderWidth = 1;
    [emaliView setBackgroundColor:[UIColor whiteColor]];
    [mainScrollView addSubview:emaliView];
    
    UIImageView* emaliIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 16, 16)];
    emaliIcon.image = Image(@"contact_email.png");
    [emaliView addSubview:emaliIcon];
    
    UILabel* emailNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 80, 18)];
    emailNameLabel.text = @"邮      箱:";
    [emaliView addSubview:emailNameLabel];
    
    mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(emailNameLabel.frame),4, 200, 50)];
    [mailLabel setNumberOfLines:0];
    [emaliView addSubview:mailLabel];
    
    CGRect contactRect = CGRectMake(0, CGRectGetMaxY(emaliView.frame) + 20, 320, 132);
    UIView* contactView = [[UIView alloc] initWithFrame:contactRect];
    contactView.layer.borderColor = COLOR(220, 220, 223).CGColor;
    contactView.layer.borderWidth = 1;
    [contactView setBackgroundColor:[UIColor whiteColor]];
    [mainScrollView addSubview:contactView];

    //电话
    UIImageView* mobileicon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 16, 16)];
    mobileicon.image = Image(@"contact_mobile");
    [contactView addSubview:mobileicon];
    
    UILabel* mobileTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 80, 18)];
    mobileTitleLabel.text = @"移动电话:";
    [contactView addSubview:mobileTitleLabel];
    
    mobileTextField = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mobileTitleLabel.frame), 4, 180, 28)];
    [mobileTextField setBackgroundColor:COLOR(208, 208, 208)];
    [contactView addSubview:mobileTextField];
    
    //短号
    UIImageView* shortPhoneicon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 16, 16)];
    shortPhoneicon.image = Image(@"contact_shortnum");
    [contactView addSubview:shortPhoneicon];
    
    UILabel* shortPhoneTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 80, 18)];
    shortPhoneTitleLabel.text = @"短       号:";
    [contactView addSubview:shortPhoneTitleLabel];
    
    shortPhoneTextField = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mobileTitleLabel.frame), 46, 180, 28)];
    [shortPhoneTextField setBackgroundColor:COLOR(208, 208, 208)];
    [contactView addSubview:shortPhoneTextField];
    
    
    //办公电哈
    UIImageView* telephoneicon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 95, 16, 16)];
    telephoneicon.image = Image(@"contact_tel");
    [contactView addSubview:telephoneicon];
    
    UILabel* telephoneTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 95, 80, 18)];
    telephoneTitleLabel.text = @"办公电话:";
    [contactView addSubview:telephoneTitleLabel];
    
    telephoneTextField= [[HPGrowingTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mobileTitleLabel.frame),90,180,28)];
    [telephoneTextField setBackgroundColor:COLOR(208, 208, 208)];
    [contactView addSubview:telephoneTextField];
    
    CGRect addressRect = CGRectMake(0, CGRectGetMaxY(contactView.frame) + 20, 320, 50);
    UIView* addressView = [[UIView alloc] initWithFrame:addressRect];
    addressView.layer.borderColor = COLOR(220, 220, 223).CGColor;
    addressView.layer.borderWidth = 1;
    [addressView setBackgroundColor:[UIColor whiteColor]];
    [mainScrollView addSubview:addressView];
    
    UIImageView* officeAddressicon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 16, 16)];
    officeAddressicon.image = Image(@"contact_place");
    [addressView addSubview:officeAddressicon];
    
    UILabel* officeAddressTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 80, 18)];
    officeAddressTitleLabel.text = @"办公地址:";
    [addressView addSubview:officeAddressTitleLabel];
    
    officeAddressTextField = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mobileTitleLabel.frame), 4, 180, 28)];
    [officeAddressTextField setBackgroundColor:COLOR(208, 208, 208)];
    [addressView addSubview:officeAddressTextField];
    
    
    float maxViewHight = CGRectGetMaxY(addressView.frame);
    float contentHight = SCREEN_HEIGHT - 64 - 49 + 1;
    [mainScrollView setContentSize:CGSizeMake(320,maxViewHight > contentHight ? maxViewHight : contentHight)];
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
    
    [self createPersonInfoView];
    //添加键盘监视通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    SKSToolBar* myToolBar = [[SKSToolBar alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    [myToolBar.firstButton addTarget:self action:@selector(savePersonInfoToServer) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.secondButton addTarget:self action:@selector(getUserInfoFromServer) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar setFirstItem:@"btn_save_ecm" Title:@"保存"];
    [myToolBar setSecondItem:@"btn_refresh_ecm" Title:@"刷新"];
    [toolVIew addSubview:myToolBar];
    
    [mobileTextField.internalTextView setKeyboardType:UIKeyboardTypeNumberPad];
    [mobileTextField setDelegate:self];
    //[mobileTextField setMaxNumberOfLines:1];
    
    [telephoneTextField.internalTextView setKeyboardType:UIKeyboardTypeNumberPad];
    [telephoneTextField setDelegate:self];
    //[telephoneTextField setMaxNumberOfLines:1];
    
    [shortPhoneTextField.internalTextView setKeyboardType:UIKeyboardTypeNumberPad];
    [shortPhoneTextField setDelegate:self];
    //[shortPhoneTextField setMaxNumberOfLines:1];
    
    [officeAddressTextField.internalTextView setKeyboardType:UIKeyboardTypeDefault];
    [officeAddressTextField setDelegate:self];
    //[officeAddressTextField setMaxNumberOfLines:1];
    
    //键盘toolBar--------------------------
    previousBtn=[[UIBarButtonItem alloc] initWithTitle:@"上一项" style:UIBarButtonItemStyleBordered target:self action:@selector(previousText)];
    nextBtn=[[UIBarButtonItem alloc] initWithTitle:@"下一项" style:UIBarButtonItemStyleBordered target:self action:@selector(nextText)];
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    doneBtn=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(doneTextEditing)];
    textToolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, BottomY, 320, 44)];
    if (System_Version_Small_Than_(7)) {
        [textToolBar setBarStyle:UIBarStyleBlackTranslucent];
    }
    [textToolBar setItems:[NSArray arrayWithObjects:previousBtn,nextBtn,flexibleSpaceItem,doneBtn,nil]];

    [self.view addSubview:textToolBar];
    
    [self getUserInfoFromServer];
}

-(BOOL)validate
{
    if ([mobileTextField.text isEqualToString:@""])
    {
        [mobileTextField becomeFirstResponder];
        return NO;
    }
    else if([officeAddressTextField.text isEqualToString:@""])
    {
        [officeAddressTextField becomeFirstResponder];
        return NO;
    }
    else if([telephoneTextField.text isEqualToString:@""])
    {
        [telephoneTextField becomeFirstResponder];
        return NO;
    }
    return YES;
}

-(void)savePersonInfoToServer
{
    
    if (![self validate]) {
        return;
    }
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/users/userinfo/update",ZZZobt]];
    SKFormDataRequest *savePersonInfoRequest = [SKFormDataRequest requestWithURL:url];
    [savePersonInfoRequest setPostValue:[APPUtils userUid] forKey:@"userid"];
    [savePersonInfoRequest setPostValue:mobileTextField.text forKey:@"mobile"];
    [savePersonInfoRequest setPostValue:shortPhoneTextField.text forKey:@"shortPhone"];
    [savePersonInfoRequest setPostValue:telephoneTextField.text forKey:@"telephone"];
    [savePersonInfoRequest setPostValue:officeAddressTextField.text forKey:@"officeAddress"];
    __weak SKFormDataRequest *req = savePersonInfoRequest;
    [savePersonInfoRequest setCompletionBlock:^{
        if (req.responseStatusCode == 500){
            [BWStatusBarOverlay showErrorWithMessage:@"网络异常请联系供应商" duration:1 animated:1];
        }
        if ([[req responseString] isEqualToString:@"OK"]) {
            [BWStatusBarOverlay showSuccessWithMessage:@"保存成功" duration:1 animated:1];
        }else{
            [BWStatusBarOverlay showErrorWithMessage:@"服务器异常" duration:1 animated:1];
        }
    }];
    [savePersonInfoRequest setFailedBlock:^{
        NSError *error = [req error];
        [BWStatusBarOverlay showErrorWithMessage:[NetUtils userInfoWhenRequestOccurError:error] duration:1 animated:1];
    }];
    [savePersonInfoRequest startAsynchronous];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect toolbarFrame=textToolBar.frame;
    toolbarFrame.origin.y=BottomY;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [textToolBar setFrame:toolbarFrame];
    [mainScrollView setContentOffset:CGPointMake(0,0) animated:YES];
    [UIView commitAnimations];
}

-(void)keyboardWillShow:(NSNotification *)note
{
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    keyboardHeight=keyboardBounds.size.height;
    CGRect toolbarFrame=textToolBar.frame;
    toolbarFrame.origin.y=BottomY -  keyboardHeight - 44;
    [self setToolBarItemEnable];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [textToolBar setFrame:toolbarFrame];
    [UIView commitAnimations];
}

#pragma mark -textDelegate

-(void)doneTextEditing
{
    [mobileTextField resignFirstResponder];
    [officeAddressTextField resignFirstResponder];
    [telephoneTextField resignFirstResponder];
    [shortPhoneTextField resignFirstResponder];
}

-(void)setToolBarItemEnable
{
    [previousBtn setEnabled:![mobileTextField isFirstResponder]];
    [nextBtn setEnabled:![officeAddressTextField isFirstResponder]];
}

//上一项
-(void)previousText
{
    if ([mobileTextField isFirstResponder])
    {
        return;
    }
    else if([shortPhoneTextField isFirstResponder])
    {
        [mobileTextField becomeFirstResponder];
    }
    else if([telephoneTextField isFirstResponder])
    {
        [shortPhoneTextField becomeFirstResponder];
    }
    else if([officeAddressTextField isFirstResponder])
    {
        [telephoneTextField becomeFirstResponder];
    }
    
    [self setToolBarItemEnable];
}
//下一项
-(void)nextText
{
    if ([mobileTextField isFirstResponder])
    {
        [shortPhoneTextField becomeFirstResponder];
    }
    else if([shortPhoneTextField isFirstResponder])
    {
        [telephoneTextField becomeFirstResponder];
    }
    else if([telephoneTextField isFirstResponder])
    {
        [officeAddressTextField becomeFirstResponder];
    }
    else if([officeAddressTextField isFirstResponder])
    {
        return;
    }
    [self setToolBarItemEnable];
}

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    if (IS_IPHONE_5){
        if(growingTextView==officeAddressTextField)
        {
            [mainScrollView setContentOffset:CGPointMake(0,175) animated:YES];
        }else if(growingTextView==telephoneTextField){
            [mainScrollView setContentOffset:CGPointMake(0,110) animated:YES];
        }else if(growingTextView==mobileTextField){
            [mainScrollView setContentOffset:CGPointMake(0,20) animated:YES];
        }else if(growingTextView==shortPhoneTextField){
            [mainScrollView setContentOffset:CGPointMake(0,64) animated:YES];
        }
    }else{
        if(growingTextView==officeAddressTextField)
        {
            [mainScrollView setContentOffset:CGPointMake(0,265) animated:YES];
        }else if(growingTextView==mobileTextField){
            [mainScrollView setContentOffset:CGPointMake(0,110) animated:YES];
        }else if(growingTextView==shortPhoneTextField){
            [mainScrollView setContentOffset:CGPointMake(0,154) animated:YES];
        } else if(growingTextView==telephoneTextField){
            [mainScrollView setContentOffset:CGPointMake(0,196) animated:YES];
        }
    }
    
    TextDownView *tdView;
    if (growingTextView.textDownView)
    {
        tdView=growingTextView.textDownView;
    }
    else
    {
        tdView=[[TextDownView alloc] init];
        CGRect tdRect=[tdView frame];
        tdRect.origin.y=CGRectGetMaxY(growingTextView.frame)-3;
        tdRect.origin.x=growingTextView.frame.origin.x;
        tdRect.size.width=150;
        tdRect.size.height=20;
        tdView.frame=tdRect;
        
        CGRect labelRect=[tdView.noticeLabel frame];
        labelRect.size.width=135;
        
        tdView.noticeLabel.frame=labelRect;
        
        tdView.noticeLabel.font=[UIFont systemFontOfSize:12];
        [growingTextView.superview addSubview:tdView];
        growingTextView.textDownView=tdView;
    }
    [tdView setHidden:NO];
    if(growingTextView==mobileTextField)
    {
        tdView.noticeLabel.text=@"请输入移动电话号码";
    }
    else if(growingTextView==shortPhoneTextField)
    {
        tdView.noticeLabel.text=@"请输入短号";
    }
    else if(growingTextView==telephoneTextField)
    {
        tdView.noticeLabel.text=@"请输入办公电话";
    }
    else
    {
        tdView.noticeLabel.text=@"请输入办公地址";
    }
    [tdView.flagImage setImage:[UIImage imageNamed:@"warning.png"]];
    [tdView.noticeLabel setTextColor:[UIColor colorWithRed:0/255.0  green:89.0/255.0 blue:175.0/255.0 alpha:1]];
    return YES;
}

-(void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    [self setToolBarItemEnable];
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    TextDownView *tdView=growingTextView.textDownView;
    [tdView setHidden:NO];
    if(growingTextView==mobileTextField)
    {
        if ([growingTextView.text isEqualToString:@""])
        {
            tdView.noticeLabel.text=@"必须填写电话号码!";
            
        }
        else
        {
            [tdView setHidden:YES];
        }
    }
    else if(growingTextView==shortPhoneTextField)
    {
        
        [tdView setHidden:YES];
        
    }
    else if(growingTextView==telephoneTextField)
    {
        if ([growingTextView.text isEqualToString:@""])
        {
            tdView.noticeLabel.text=@"必须填写办公电话!";
        }
        else
        {
            [tdView setHidden:YES];
        }
    }
    else if(growingTextView==officeAddressTextField)
    {
        if ([growingTextView.text isEqualToString:@""])
        {
            tdView.noticeLabel.text=@"必须填写办公地址!";
        }
        else
        {
            [tdView setHidden:YES];
        }
    }
    [tdView.flagImage setImage:[UIImage imageNamed:@"error.png"]];
    [tdView.noticeLabel setTextColor:[UIColor redColor]];
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    return YES;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    if ((int)diff <= 0) return;
    changeHeight+=diff;
    CGSize size = mainScrollView.contentSize;
    size.height-=diff;
    mainScrollView.contentSize=size;
    
    CGRect tRect=growingTextView.textDownView.frame;
    tRect.origin.y-=diff;
    growingTextView.textDownView.frame=tRect;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    NSInteger number = [growingTextView.text length];
    
    if (growingTextView!=officeAddressTextField)
    {
        if (number > 19)
        {
            growingTextView.text = [growingTextView.text substringToIndex:19];
            //number = 40;
        }
    }else
    {
        if (number > 40)
        {
            growingTextView.text = [growingTextView.text substringToIndex:40];
            //number = 40;
        }
    }
}

@end
