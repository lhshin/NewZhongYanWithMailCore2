//
//  SKMailDetailController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-2.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKMailDetailController.h"
#import "SKLToolBar.h"
#import "UIImage+rescale.h"
#import "SKAttachButton.h"
#import "DataServiceURLs.h"
#import "SKAttachManger.h"
#import "SKViewController.h"
#import "SKNewMailController.h"
#import "SKEmailController.h"
@interface SKMailDetailController ()
{
    NSMutableArray   *attachmentItem;
    BOOL isWrittenBySelf;
}
@property(nonatomic,strong)NSString         *toString;
@property(nonatomic,retain)NSString         *messageID;
@end

@implementation SKMailDetailController
@synthesize isSend;

-(void)handleTapForHelpImage:(UIGestureRecognizer*)recognizer
{
    if (recognizer.state==UIGestureRecognizerStateEnded)
    {
        UIImageView* helpImage = (UIImageView*)[self.view.window viewWithTag:1111];
        [helpImage fallOut:.4 delegate:nil completeBlock:^{
            [helpImage performSelector:@selector(removeFromSuperview) withObject:0 afterDelay:0.4];
            [self.navigationItem.rightBarButtonItem setEnabled:YES];
        }] ;
    }
}

- (IBAction)help:(UIButton *)sender {
    UIImageView* helpImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [helpImage setImage:[UIImage imageNamed:IS_IPHONE_5? @"iphone5_email_detailed" : @"iphone4_email_detailed"]];
    [helpImage setUserInteractionEnabled:YES];
    [helpImage setTag:1111];
    [self.view.window addSubview:helpImage];
    
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapForHelpImage:)];
    [helpImage addGestureRecognizer:tapGes];
    [helpImage fallIn:.4 delegate:nil completeBlock:^{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }];
}


//删除
-(void)deleteEmail
{
    NSString* sql = [NSString stringWithFormat:@"update  T_LOCALMESSAGE SET STATUS = 1 where MESSAGEID = '%@';",_messageID];
    if ([[DBQueue sharedbQueue] updateDataTotableWithSQL:sql])
    {
        
        SKEmailController *emailcon=[APPUtils AppSKEmailController];
        [emailcon getMailFromDataBase];
        SKViewController* controller = [APPUtils AppRootViewController];
        [controller.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"删除邮件失败");
    }
}

//转发
-(void)forwardEmail
{
    SKNewMailController* aEmail = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKNewMailController"];
    [aEmail setStatus:NewMailStatusForwad];
    [aEmail setDataDictionary:_emailDetailDictionary];
    [[APPUtils visibleViewController].navigationController pushViewController:aEmail animated:YES];
}

//回复
-(void)replyEmail
{
    SKNewMailController* aEmail = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKNewMailController"];
    [aEmail setStatus:NewMailStatusRespond];
    [aEmail setDataDictionary:_emailDetailDictionary];
    [[APPUtils visibleViewController].navigationController  pushViewController:aEmail animated:YES];
}

-(void)praseAttachmentItem
{
    if (!(isWrittenBySelf = [[self.emailDetailDictionary objectForKey:@"ISWRITTENBYSELF"] boolValue]))
    {
        attachmentItem = [[NSMutableArray alloc] initWithCapacity:0];
        NSString* attachmentString = [_emailDetailDictionary objectForKey:@"ATTACHMENTS"] ;
        NSArray* tmp = [attachmentString componentsSeparatedByString:@","];
        for (__strong NSString* string in tmp) {
            string = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\"[]"]];
            [attachmentItem addObject:string];
        }
    }else{
        NSLog(@"不是自己写的");
    }

}

-(void)init_To_List
{
    self.toString = @"收件人 : ";
    NSArray* components = [[_emailDetailDictionary objectForKey:@"TO_LIST"] componentsSeparatedByString:@","];
    for (NSString* toStr in components)
    {
        NSString* name = [[toStr componentsSeparatedByString:@"<"] objectAtIndex:0];
        if ([name rangeOfString:@"@"].location != NSNotFound)
        {
            name = [[DBQueue sharedbQueue] stringFromSQL:
                    [NSString stringWithFormat:@"select CNAME from T_EMPLOYEE WHERE EMAIL = '%@';",name]];
            
        }
        
        
        if(!name)
        {
            self.toString=[_toString stringByAppendingFormat:@"%@ ",toStr];
        }
        else
        {
            self.toString = [_toString stringByAppendingFormat:@"%@ ",name];
        }
    }
}

-(void)init_Height
{
    CGFloat height = [[_emailDetailDictionary objectForKey:@"SUBJECT"] sizeWithFont:[UIFont boldSystemFontOfSize:16]
                                                                      constrainedToSize: CGSizeMake(310,MAXFLOAT)
                                                                          lineBreakMode:NSLineBreakByWordWrapping].height + 5; //
    subjectHeight = height < 40 ? 40 : height;
    contentHeight = [UIScreen mainScreen].bounds.size.height - 20 - 44 - subjectHeight - 25;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initSubjectView
{
    subjectBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, subjectHeight)];
    [subjectBGView setBackgroundColor:[UIColor whiteColor]];
    [scrollview addSubview:subjectBGView];
    
    UILabel* subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, subjectHeight)];
    NSString* subject = [_emailDetailDictionary objectForKey:@"SUBJECT"];
    if ([subject isEqualToString:@""] || !subject || !subject.length) {
        subject = @"无主题";
    }
    [subjectLabel setText:subject];
    [subjectLabel setNumberOfLines:0];
    [subjectLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [subjectBGView addSubview:subjectLabel];
    
    UIImage* image = [UIImage imageNamed:@"cell_line"];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
    imageView.image = image;
    [imageView setCenter:CGPointMake(160, subjectHeight - 1)];
    [subjectBGView addSubview:imageView];
}

-(void)onSenderClick
{
    isOpen = !isOpen;
    CGFloat height =  [self.toString sizeWithFont:[UIFont systemFontOfSize:15]
                                constrainedToSize: CGSizeMake(300,MAXFLOAT)
                                    lineBreakMode:NSLineBreakByWordWrapping].height + 5;
    CGRect contentrect = contentBGView.frame;
    contentrect.origin.y = contentrect.origin.y + ( isOpen ? height : - height);
    [UIView animateWithDuration:0.3
                     animations:^{
                         if (isOpen)
                         {
                             [recieveBGView setFrame:CGRectMake(0, CGRectGetMaxY(senderBGView.frame), 320, height)];
                             [recieveBGView setHidden:NO];
                         }
                         else
                         {
                             [recieveBGView setFrame:CGRectMake(0, CGRectGetMaxY(senderBGView.frame) - height, 320, height)];
                             
                         }
                         [contentBGView setFrame:contentrect];
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             if (!isOpen) {
                                 [recieveBGView setHidden:YES];
                             }
                         }
                     }
     ];
}

-(void)initSendView
{
    senderBGView = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(subjectBGView.frame), 320, 25)];
    [senderBGView setBackgroundColor:[UIColor whiteColor]];
    [scrollview addSubview:senderBGView];
    
    UITapGestureRecognizer* taprecogizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSenderClick)];
    [senderBGView addGestureRecognizer:taprecogizer];
    
    UILabel* subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 25)];
    if (isSend) {
        subjectLabel.text = [NSString stringWithFormat:@"发件人 : %@",[APPUtils userUid]];
    }else{
        
        subjectLabel.text = [@"发件人 : " stringByAppendingString:[[[_emailDetailDictionary objectForKey:@"SENDER"] componentsSeparatedByString:@"<"] objectAtIndex:0]];
    }
    [subjectLabel setNumberOfLines:0];
    [subjectLabel setFont:[UIFont systemFontOfSize:15]];
    [senderBGView addSubview:subjectLabel];
    
    UILabel* sendDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 140, 25)];
    [sendDateLabel setFont:[UIFont systemFontOfSize:15]];
    [sendDateLabel setTextColor:[UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1]];
    [sendDateLabel setText:[[[_emailDetailDictionary objectForKey:@"SENTDATE"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16]];
    [senderBGView addSubview:sendDateLabel];
    
    UIImageView* accessoryView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"oa_title_unfoldbg.png"] rescaleImageToSize:CGSizeMake(15, 15)]];
    [accessoryView setFrame:CGRectMake(300,2, 16, 16)];
    [senderBGView addSubview:accessoryView];
    
    UIView *horisonline=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [horisonline setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_line"]]];
    [horisonline setCenter:CGPointMake(160, 24)];
    [senderBGView addSubview:horisonline];
}

-(void)initRecieveView
{
    CGFloat height =  [self.toString sizeWithFont:[UIFont systemFontOfSize:15]
                                constrainedToSize: CGSizeMake(300,MAXFLOAT)
                                    lineBreakMode:NSLineBreakByWordWrapping].height + 5;
    
    recieveBGView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(senderBGView.frame) - height, 320, 0)];
    [recieveBGView setHidden:YES];
    [scrollview addSubview:recieveBGView];
    
    UILabel* recieveLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, height)];
    [recieveLabel setText:self.toString];
    [recieveLabel setNumberOfLines:0];
    [recieveLabel setLineBreakMode:NSLineBreakByWordWrapping] ;
    [recieveLabel setFont:[UIFont systemFontOfSize:15]];
    [recieveBGView addSubview:recieveLabel];
    
    UIView *horisonline=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    [horisonline setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_line"]]];
    [horisonline setCenter:CGPointMake(160,height - 1)];
    [recieveBGView addSubview:horisonline];
    [scrollview sendSubviewToBack:recieveBGView];
}

-(CGFloat)attactchMaxY
{
    CGFloat maxY;
    for (UIView* view in contentBGView.subviews) {
        maxY = MAX(maxY, CGRectGetMaxY(view.frame));
    }
    return maxY + 5;
}

-(void)initAttachView
{
    CGFloat contentsHeight = self.view.bounds.size.height - CGRectGetMaxY(senderBGView.frame);
    contentBGView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(senderBGView.frame),320,contentsHeight)];
    [scrollview addSubview:contentBGView];
    
    if (isWrittenBySelf)
    {
        UITextView* content = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, contentsHeight)];
        content.editable = NO;
        content.font = [UIFont systemFontOfSize:15];
        if ([_emailDetailDictionary objectForKey:@"PERSONALINFO"] != [NSNull null])
        {
            NSString *contentStr=[NSString stringWithFormat:@"%@\n%@",[self.emailDetailDictionary objectForKey:@"CONTENT"],[self.emailDetailDictionary objectForKey:@"PERSONALINFO"]];
            content.text=contentStr;
        }
        else
        {
            content.text = [self.emailDetailDictionary objectForKey:@"CONTENT"];
        }
        [contentBGView addSubview:content];
    }else{
        CGFloat curHeight = 0;
        if ([attachmentItem count] > 1)
        {
            curHeight += 5;
            for (int i = 1; i < [attachmentItem count]; ++i)
            {
                SKAttachButton* attachmentButton =
                [[SKAttachButton alloc] initWithFrame:CGRectMake(10, curHeight, 300, 48)];
                if ([[attachmentItem objectAtIndex:i] length] < 1) {//可能要去掉
                    continue;
                }
                NSString* attachName = [attachmentItem objectAtIndex:i];
                [attachmentButton setTitle:attachName forState:UIControlStateNormal];
                attachmentButton.filePath = [SKAttachManger mailAttachPath:self.messageID attchName:attachName];
                attachmentButton.attachUrl = [DataServiceURLs mailAttcnURL:self.messageID AttchName:attachName];
                attachmentButton.isAttachExisted = [SKAttachManger mailAttachExisted:self.messageID attchName:attachName];
                [contentBGView addSubview:attachmentButton];
                curHeight = curHeight + 53;
            }
        }
        
        
        //content
        mailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(5, [self attactchMaxY], 310,1)];
        UIScrollView* webScrollView =  (UIScrollView*)[[mailWebView subviews] objectAtIndex:0];
        [webScrollView setBounces:NO];
        [mailWebView setBackgroundColor:[UIColor greenColor]];
        [mailWebView setDataDetectorTypes:UIDataDetectorTypeNone];
        [mailWebView setDelegate:self];
        [contentBGView addSubview:mailWebView];
        [contentBGView setFrame:CGRectMake(0, CGRectGetMaxY(senderBGView.frame),320,[self attactchMaxY])];
        [scrollview setContentSize:CGSizeMake(320, [self attactchMaxY])];
        [self loadContentAttachment];
    }
}

//将\n转换成br
-(NSString *)transformEnterToBr:(NSString *)inputStr
{
    return [inputStr stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
}

//该函数一般用于加载CONTENT
-(void)loadContentAttachment
{
    NSString* contentPath = [SKAttachManger mailAttachPath:self.messageID attchName:@"CONTENT"];
    NSURL *URL =  [DataServiceURLs mailAttcnURL:self.messageID AttchName:@"CONTENT"];
    BOOL contentExisted = [SKAttachManger mailAttachExisted:self.messageID  attchName:@"CONTENT"];
    if (contentExisted)
    {
        NSMutableString *htmlStr=[[NSMutableString alloc] init];
        //内容
        if ([self.emailDetailDictionary objectForKey:@"CONTENT"]&&![[self.emailDetailDictionary objectForKey:@"CONTENT"] isEqualToString:@"CONTENT"])
        {
            NSString *contentStr=[self transformEnterToBr:[self.emailDetailDictionary objectForKey:@"CONTENT"]] ;
            [htmlStr appendString:contentStr];
        }
        //原始信息
        if ([self.emailDetailDictionary objectForKey:@"ORIGINALINFO"]&&![[self.emailDetailDictionary objectForKey:@"ORIGINALINFO"] isEqualToString:@"ORIGINALINFO"])
        {
            NSString *originalInfo=[self transformEnterToBr:[self.emailDetailDictionary objectForKey:@"ORIGINALINFO"]] ;
            [htmlStr appendString:originalInfo];
        }
        //原网页
        NSString* string = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
        [htmlStr appendString:string];
        //个人信息
        if ([self.emailDetailDictionary objectForKey:@"PERSONALINFO"]&&![[self.emailDetailDictionary objectForKey:@"PERSONALINFO"] isEqualToString:@"PERSONALINFO"])
        {
            NSString *personalInfo=[self transformEnterToBr:[self.emailDetailDictionary objectForKey:@"PERSONALINFO"]];
            [htmlStr appendString:personalInfo];
            
        }
        [mailWebView loadHTMLString:htmlStr baseURL:0];
        
    }else{
        SKHTTPRequest* Request = [SKHTTPRequest requestWithURL:URL];
        [Request setDownloadDestinationPath:contentPath];
        [Request setDefaultResponseEncoding:NSUTF8StringEncoding];
        __weak SKHTTPRequest* request = Request;
        //[request setAllowResumeForFileDownloads:YES];
        [Request setCompletionBlock:^{
            if ([request responseStatusCode] != 200) {
                [ASIHTTPRequest removeFileAtPath:contentPath error:0];
            }
            NSMutableString *htmlStr=[[NSMutableString alloc] init];
            //内容
            if ([self.emailDetailDictionary objectForKey:@"CONTENT"]&&![[self.emailDetailDictionary objectForKey:@"CONTENT"] isEqualToString:@"CONTENT"])
            {
                NSString *contentStr=[self transformEnterToBr:[self.emailDetailDictionary objectForKey:@"CONTENT"]] ;
                [htmlStr appendString:contentStr];
            }
            //原始信息
            if ([self.emailDetailDictionary objectForKey:@"ORIGINALINFO"]&&![[self.emailDetailDictionary objectForKey:@"ORIGINALINFO"] isEqualToString:@"ORIGINALINFO"])
            {
                NSString *originalInfo=[self transformEnterToBr:[self.emailDetailDictionary objectForKey:@"ORIGINALINFO"]] ;
                [htmlStr appendString:originalInfo];
            }
            //原网页
            NSString* string = [NSString stringWithContentsOfFile:contentPath encoding:NSUTF8StringEncoding error:nil];
            [htmlStr appendString:string];
            //个人信息
            if ([self.emailDetailDictionary objectForKey:@"PERSONALINFO"]&&![[self.emailDetailDictionary objectForKey:@"PERSONALINFO"] isEqualToString:@"PERSONALINFO"])
            {
                NSString *personalInfo=[self transformEnterToBr:[self.emailDetailDictionary objectForKey:@"PERSONALINFO"]];
                [htmlStr appendString:personalInfo];
                
            }
            [mailWebView loadHTMLString:htmlStr baseURL:0];
        }];
        [Request setFailedBlock:^{
            [ASIHTTPRequest removeFileAtPath:contentPath error:0];
        }];
        [Request startAsynchronous];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *) webView{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    CGRect contentrect = contentBGView.frame;
    newFrame.size.height = actualSize.height;
    contentrect.size.height += newFrame.size.height;
    
    [contentBGView setFrame:contentrect];
    [scrollview setContentSize:CGSizeMake(320, CGRectGetMaxY(contentBGView.frame))];
    [webView setFrame:newFrame];
}

-(void)initMailView
{
    [self initSubjectView];
    [self initSendView];
    [self initRecieveView];
    [self initAttachView];
}

-(void)initToolBar
{
    SKLToolBar* myToolBar = [[SKLToolBar alloc] initWithFrame:CGRectMake(0,0,320,49)];
    [myToolBar setFirstItem:@"btn_clean_ecm" Title:@"删除"];
    [myToolBar setSecondItem:@"btn_forward_ecm" Title:@"转发"];
    [myToolBar setThirdItem:@"btn_reply_ecm" Title:@"回复"];
    [myToolBar.firstButton  addTarget:self action:@selector(deleteEmail)  forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.secondButton addTarget:self action:@selector(forwardEmail)   forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.thirdButton  addTarget:self action:@selector(replyEmail) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:myToolBar];
}

-(void)initData
{
    [self setMessageID:[self.emailDetailDictionary objectForKey:@"MESSAGEID"]];
    [self praseAttachmentItem];
    [self init_To_List];
    [self init_Height];
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
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backItem;
    }
    [self initData];
    [self initMailView];
    [self initToolBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
