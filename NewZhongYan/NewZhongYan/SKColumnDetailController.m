//
//  SKColumnDetailController.m
//  ZhongYan
//
//  Created by 李 林 on 2/25/13.
//  Copyright (c) 2013 surekam. All rights reserved.
//

#import "SKColumnDetailController.h"
#import "APPUtils.h"
#import "utils.h"
#import "BWStatusBarOverlay.h"
#import "MBProgressHUD.h"
@interface SKColumnDetailController ()

@end

@implementation SKColumnDetailController
#define TITLE_HEIGHT 0
#define CONTENT_WIDTH 320
#define CONTENT_TITLEHEIGHT 20
#define CONTENT_TOPEDGE 8
#define CONTENT_BUTTOMEDGE 8
#define NAMELABLE_HEIGHT 25
#define VERLINE_LEFT 95
#define VALUELABLE_WIDTH 198
#define VALUELABLE_LEFT 105
#define NAMELABLE_WIDTH 90
#define SIGNATURELABEL_HEIGHT 20
#define SIGNATURELABEL_WIDTH 100
#define MARKLABEL_WIDTH 20
#define MARKLABEL_HEIGHT 20
#define PHRASETEXTVIEW_HEIGHT 40
@synthesize flowInstanceID,uniqueID,from,tfrm,isHistory;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)handleTap:(UITapGestureRecognizer*)tap
{
    
}

-(void)getSignature:(id)sender
{
    
}

//竖线
-(UIView *)createVerticalLine:(float)lineHeight
{
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, lineHeight)];
    [v setBackgroundColor:[UIColor lightGrayColor]];
    return v ;
}

-(UIView *)createHorizonalLine:(float)lineWidth
{
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, lineWidth, 2)];
    [v setBackgroundColor:COLOR(239, 239, 239)];
    return v ;
}

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
    self.view.backgroundColor = [UIColor whiteColor];
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
    [self.view setBackgroundColor:COLOR(239, 239, 239)];
    
    [self setTitle:isHistory ? @"历史数据" : @"明细数据" ];
    mainScrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, TopY, 320, [UIScreen mainScreen].bounds.size.height-TopY)];
    [self.view addSubview:mainScrollview];
    [mainScrollview release];
    
    contentView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [mainScrollview addSubview:contentView];
    [contentView release];
    
    [self getColumnDetailFromServer];
}

-(void)dealloc
{
    [super dealloc];
    [flowInstanceID release];
}

-(void)getColumnDetailFromServer
{
    SKHTTPRequest *request;
    if (!isHistory){
        NSURL* columnDetailUrl = [DataServiceURLs getColumnDetails:[APPUtils userUid]
                                                 andFlowinstanceid:flowInstanceID
                                                       andUniqueid:uniqueID
                                                           andFrom:from];
        request= [SKHTTPRequest requestWithURL:columnDetailUrl];
    }else{
        NSURL*historyUrl = [DataServiceURLs getHistoryRecords:[APPUtils userUid]
                                                         TFRM:self.tfrm
                                               FLOWINSTANCEID:self.flowInstanceID];
        request= [SKHTTPRequest requestWithURL:historyUrl];
    }
    
    [request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseStatusCode != 200) {
            [BWStatusBarOverlay showMessage:@"服务器网络故障!" duration:1 animated:1];
            return;
        }
        NSLog(@"%@",request.responseString);
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        ParseOperation *parser =
        [[ParseOperation alloc] initWithData:[request responseData]
                           completionHandler:^(business *abusiness) {
                               self.aBusiness = abusiness;
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self createBusinessDetailViewWithData:self.aBusiness];
                                   if (![self.aBusiness.returncode isEqualToString:@"OK"]) {
                                       [BWStatusBarOverlay showMessage:[[self.aBusiness.returncode componentsSeparatedByString:@","] lastObject] duration:1 animated:1];
                                       if ([self.aBusiness.returncode rangeOfString:@"1002"].location != NSNotFound) {
                                       }
                                       return ;
                                   }
                               });
                           }];
        [queue addOperation:parser];
        
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [BWStatusBarOverlay showMessage:@"获取历史数据失败!" duration:1 animated:1];
    }];
    [request startAsynchronous];
    [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"加载中..."];
}

-(void)createBusinessDetailViewWithData:(business*)b
{
    for (columns* cs in b.columnsArray)
    {
        contentTotalHeight=0.0;
        [self addCustomViewWithColumns:cs];
    }
}

//加入customView到contentView中
-(void)addCustomViewWithColumns:(columns*)cs
{UIView *cv=[[UIView alloc] init];
    [cv setBackgroundColor:[UIColor whiteColor]];
    //加入标题********************************************
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320,CONTENT_TITLEHEIGHT)];
    [titleLabel setText:[NSString stringWithFormat:@"   %@",cs.columnsDict[@"name"]]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [titleLabel setTextColor:COLOR(96,96,96)];
    [titleLabel setBackgroundColor:COLOR(239, 239, 239)];
    [cv addSubview:titleLabel];
    //加入内容************************************************
    for (column* c in cs.columnsArray)
    {
        //如果是文字类型
        if([FileUtils columnType:c] == SKtext)
        {
            [self addTextToCvWithColumn:c andCv:cv];
        }
        //如果是图像
        else if([FileUtils columnType:c] == SKImage)
        {
            [self addImageToCvWithColumn:c andCv:cv];
        }
        //如果是混合类型
        else if([FileUtils columnType:c] == SKMixed)
        {
            for ( element* e in c.elementArray )
            {
                if ([[e.elementDict objectForKey:@"type"] isEqualToString:@"text/plain"])
                {
                    [self addTextToCvWithElement:e andColumn:c andCv:cv];
                }
                //如果是图像
                else if([[e.elementDict objectForKey:@"type"] isEqualToString:@"image/png"])
                {
                    [self addImageToCvWithElement:e andCv:cv];
                }
                else
                {
                    [self addTextToCvWithElement:e andColumn:c andCv:cv];
                }
            }
            UIView *horLine=[self createHorizonalLine:CONTENT_WIDTH];
            [horLine setFrame:CGRectMake(0, CONTENT_TITLEHEIGHT+contentTotalHeight, horLine.frame.size.width, horLine.frame.size.height)];
            contentTotalHeight+=1;
            [cv addSubview:horLine];
        }
    }
    [cv setFrame:CGRectMake(0, totalHeight, CONTENT_WIDTH, CONTENT_TITLEHEIGHT+contentTotalHeight)];
    totalHeight+=contentTotalHeight+CONTENT_TITLEHEIGHT;
    [contentView addSubview:cv];
    [contentView setFrame:CGRectMake(0, TITLE_HEIGHT, CONTENT_WIDTH, totalHeight)];
    [mainScrollview setContentSize:CGSizeMake(CONTENT_WIDTH, totalHeight+TITLE_HEIGHT)];
    [cv release];
}

//获取imageView的大小
-(CGRect)getImageViewSizeWithImageSize:(CGSize)imageSize andLimitedWidth:(float)limitedWidth andLeftMargin:(float)leftMargin
{
    //右边控件暂定宽为VALUELABLE_WIDTH的正方形区域
    float imageHeight=imageSize.height;
    float imageWidth=imageSize.width;
    float ratio=imageHeight/imageWidth; //高度和宽度的比值
    float returnHeight;
    float returnWidth;
    CGRect returnRect;
    if(imageHeight>limitedWidth){
        if (imageHeight<imageWidth){
            returnWidth=limitedWidth;
            returnHeight=limitedWidth*ratio;
            returnRect= CGRectMake(leftMargin, contentTotalHeight+CONTENT_TITLEHEIGHT+(limitedWidth-returnHeight)/2, returnWidth, returnHeight);
        }else{
            returnHeight=limitedWidth;
            returnWidth=limitedWidth/ratio;
            returnRect=CGRectMake(leftMargin+(limitedWidth-returnWidth)/2, contentTotalHeight+CONTENT_TITLEHEIGHT, returnWidth, returnHeight);
        }
    }else{
        if (imageHeight<imageWidth) {
            if (imageWidth>limitedWidth){
                returnWidth=limitedWidth;
                returnHeight=limitedWidth*ratio;
                returnRect= CGRectMake(leftMargin, contentTotalHeight+CONTENT_TITLEHEIGHT+(limitedWidth-returnHeight)/2, returnWidth, returnHeight);
            }else{
                returnWidth=imageWidth;
                returnHeight=imageHeight -10;
                returnRect= CGRectMake(leftMargin, contentTotalHeight+CONTENT_TITLEHEIGHT, returnWidth, returnHeight);
            }
        }else{
            returnWidth=imageWidth;
            returnHeight=imageHeight;
            returnRect= CGRectMake(leftMargin, contentTotalHeight+CONTENT_TITLEHEIGHT, returnWidth, returnHeight);
        }
    }
    return returnRect;
}

//加入图像类型内容
-(void)addImageToCvWithColumn:(column *)c andCv:(UIView *)cv
{
    
    float nameLabelY;
    if (c.value==nil||[c.value isEqualToString:@""])
    {
        nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT;
        if ([FileUtils extendType:c]==SKSignature)
        {
            UIImageView *signatureImageView;
            signatureImageView=[[UIImageView alloc] init];
            [signatureImageView setFrame:CGRectMake(VALUELABLE_LEFT, contentTotalHeight+CONTENT_TITLEHEIGHT, 0, 40)];
            [cv addSubview:signatureImageView];
            [signatureImageView setUserInteractionEnabled:YES];
            NSString *imageSignatureID;
            imageSignatureID=[[NSString alloc] initWithString:[c.columnDict objectForKey:@"id"]];
            [imageSignatureID release];
            [signatureImageView release];
            cv.tag=1002;
            UIView *verLine=[self createVerticalLine:40+37];
            UIView *horLine=[self createHorizonalLine:CONTENT_WIDTH];
            [verLine setFrame:CGRectMake(VERLINE_LEFT, contentTotalHeight+CONTENT_TITLEHEIGHT, verLine.frame.size.width, verLine.frame.size.height)];
            [horLine setFrame:CGRectMake(0,contentTotalHeight+CONTENT_TITLEHEIGHT+ 40+37, horLine.frame.size.width, horLine.frame.size.height)];
            [cv addSubview:verLine];
            [cv addSubview:horLine];
            contentTotalHeight+=40+CONTENT_TOPEDGE+CONTENT_BUTTOMEDGE+37;//加上了textView和button的高度
        }
        else
        {
            UIView *verLine=[self createVerticalLine:NAMELABLE_HEIGHT];
            UIView *horLine=[self createHorizonalLine:CONTENT_WIDTH];
            [verLine setFrame:CGRectMake(VERLINE_LEFT, contentTotalHeight+CONTENT_TITLEHEIGHT, verLine.frame.size.width, verLine.frame.size.height)];
            [horLine setFrame:CGRectMake(0,contentTotalHeight+CONTENT_TITLEHEIGHT+ NAMELABLE_HEIGHT, horLine.frame.size.width, horLine.frame.size.height)];
            [cv addSubview:verLine];
            [cv addSubview:horLine];
            contentTotalHeight+=NAMELABLE_HEIGHT+1;
        }
        
    }
    else
    {
        if ([FileUtils extendType:c]==SKSignature)
        {
            nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT;
            UIImageView *signatureImageView;
            signatureImageView=[[UIImageView alloc] init];
            [signatureImageView setFrame:CGRectMake(VALUELABLE_LEFT, contentTotalHeight+CONTENT_TITLEHEIGHT, 0, 40)];
            [cv addSubview:signatureImageView];
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [signatureImageView setUserInteractionEnabled:YES];
            [signatureImageView addGestureRecognizer:tapRecognizer];
            [tapRecognizer release];
            
            
            UIImage *image=[UIImage imageWithData:[NSData dataFromBase64String:c.value]];
            [signatureImageView setImage:image];
            CGRect imageRect = [self getImageViewSizeWithImageSize:image.size andLimitedWidth:VALUELABLE_WIDTH andLeftMargin:VALUELABLE_LEFT];
            [signatureImageView setFrame:imageRect];
            
            NSString *imageSignatureID;
            imageSignatureID=[[NSString alloc] initWithString:[c.columnDict objectForKey:@"id"]];
            
            [imageSignatureID release];
            [signatureImageView release];
            
            cv.tag=1002;
            
            UIView *verLine=[self createVerticalLine:40+37];
            UIView *horLine=[self createHorizonalLine:CONTENT_WIDTH];
            [verLine setFrame:CGRectMake(VERLINE_LEFT, contentTotalHeight+CONTENT_TITLEHEIGHT, verLine.frame.size.width, verLine.frame.size.height)];
            [horLine setFrame:CGRectMake(0,contentTotalHeight+CONTENT_TITLEHEIGHT+ 40+37, horLine.frame.size.width, horLine.frame.size.height)];
            [cv addSubview:verLine];
            [cv addSubview:horLine];
            contentTotalHeight+=40+CONTENT_TOPEDGE+CONTENT_BUTTOMEDGE+37;//加上了textView和button的高度
        }
        else
        {
            NSData *imageData=[NSData dataFromBase64String:c.value];
            UIImage *image=[UIImage imageWithData:imageData];
            
            UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
            [imageView setFrame:[self getImageViewSizeWithImageSize:image.size andLimitedWidth:VALUELABLE_WIDTH andLeftMargin:VALUELABLE_LEFT]];
            [cv addSubview:imageView];
            
            
            nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT+ (imageView.frame.size.height-NAMELABLE_HEIGHT)/2;
            UIView *verLine=[self createVerticalLine:imageView.frame.size.height];
            UIView *horLine=[self createHorizonalLine:CONTENT_WIDTH];
            [verLine setFrame:CGRectMake(VERLINE_LEFT, contentTotalHeight+CONTENT_TITLEHEIGHT, verLine.frame.size.width, verLine.frame.size.height)];
            [horLine setFrame:CGRectMake(0,contentTotalHeight+CONTENT_TITLEHEIGHT+ imageView.frame.size.height, horLine.frame.size.width, horLine.frame.size.height)];
            [cv addSubview:verLine];
            [cv addSubview:horLine];
            contentTotalHeight+=imageView.frame.size.height+1;
            [imageView release];//add by lilin for leak
        }
    }
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, nameLabelY, NAMELABLE_WIDTH, NAMELABLE_HEIGHT)];
    [nameLabel setText:[c.columnDict objectForKey:@"name"]];
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setTextColor:[UIColor blackColor]];
    [cv addSubview:nameLabel];
    [nameLabel release];
    
    
}
//加入图像类型内容
-(void)addImageToCvWithElement:(element *)e andCv:(UIView *)cv
{
    float nameLabelY;
    if (e.value==nil||[e.value isEqualToString:@""])
    {
        nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT;
        if ([FileUtils extendTypeWithElement:e]==SKSignature)
        {
            UIImageView *signatureImageView;
            signatureImageView=[[UIImageView alloc] init];
            [signatureImageView setFrame:CGRectMake(VALUELABLE_LEFT, contentTotalHeight+CONTENT_TITLEHEIGHT, 160, 60)];
            [signatureImageView setUserInteractionEnabled:YES];
            NSString *imageSignatureID;
            imageSignatureID=[[NSString alloc] initWithString:[e.elementDict objectForKey:@"id"]];
            
            [cv addSubview:signatureImageView];
            [imageSignatureID release];
            [signatureImageView release];
            contentTotalHeight+=40+CONTENT_TOPEDGE+CONTENT_BUTTOMEDGE+37;//加上了textView和button的高度
        }
        else
        {
            contentTotalHeight+=NAMELABLE_HEIGHT;
        }
    }
    else
    {
        if ([FileUtils extendTypeWithElement:e]==SKSignature)
        {
            nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT;
            UIImageView *signatureImageView;
            signatureImageView=[[UIImageView alloc] init];
            [signatureImageView setUserInteractionEnabled:YES];
            UIImage *image=[UIImage imageWithData:[NSData dataFromBase64String:e.value]];
            [signatureImageView setImage:image];
            CGRect imageRect = [self getImageViewSizeWithImageSize:image.size andLimitedWidth:VALUELABLE_WIDTH andLeftMargin:VALUELABLE_LEFT];
            [signatureImageView setFrame:imageRect];
            
            NSString *imageSignatureID;
            imageSignatureID=[[NSString alloc] initWithString:[e.elementDict objectForKey:@"id"]];
            
            [cv addSubview:signatureImageView];
            [imageSignatureID release];
            [signatureImageView release];
            
            UIButton *signatureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [signatureBtn setBackgroundImage:[UIImage imageNamed:@"btn_home_bg.png"] forState:UIControlStateNormal];
            [signatureBtn setFrame:CGRectMake(CONTENT_WIDTH-65, contentTotalHeight+CONTENT_TITLEHEIGHT+40, 60, 37)];
            [signatureBtn addTarget:self action:@selector(getSignature:) forControlEvents:UIControlEventTouchUpInside];
            [cv addSubview:signatureBtn];
            //添加label解决图片遮盖文字
            UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, signatureBtn.frame.size.width, signatureBtn.frame.size.height)];
            [label setText:@"签名"];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setBackgroundColor:[UIColor clearColor]];
            [signatureBtn addSubview:label];
            [signatureBtn bringSubviewToFront:label];
            [label release];
            contentTotalHeight+=40+CONTENT_TOPEDGE+CONTENT_BUTTOMEDGE+37;//加上了textView和button的高度
        }
        else
        {
            UIImage *image=[UIImage imageWithData:[NSData dataFromBase64String:e.value]];
            UIImageView *imageView=[[UIImageView alloc] initWithImage:image];
            CGRect imageRect = [self getImageViewSizeWithImageSize:image.size andLimitedWidth:VALUELABLE_WIDTH andLeftMargin:VALUELABLE_LEFT];
            [imageView setFrame:imageRect];
            [cv addSubview:imageView];
            [imageView release];
            
            nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT+ (imageView.frame.size.height-NAMELABLE_HEIGHT)/2;
            contentTotalHeight+=imageView.frame.size.height;
        }
    }
    
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, nameLabelY, NAMELABLE_WIDTH, NAMELABLE_HEIGHT)];
    [nameLabel setText:[e.elementDict objectForKey:@"name"]];
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setTextColor:[UIColor blackColor]];
    [cv addSubview:nameLabel];
    [nameLabel release];
    
    
}

//加入文字类型内容
-(void)addTextToCvWithColumn:(column *)c andCv:(UIView *)cv
{
    float valueLabelHeight=0.0;
    float nameLabelHeight=0.0;
    NSString* nameLabelString = [c.columnDict objectForKey:@"name"];
    
    UILabel *valueLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    [valueLabel setText:c.value];
    [valueLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [valueLabel setNumberOfLines:0];
    if (nameLabelString.length)
    {
        valueLabelHeight=[c.value sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(VALUELABLE_WIDTH, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
        nameLabelHeight=[nameLabelString sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(NAMELABLE_WIDTH, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
        valueLabelHeight=valueLabelHeight<20?20:valueLabelHeight;
        valueLabelHeight=valueLabelHeight<=nameLabelHeight?nameLabelHeight:valueLabelHeight;
        [valueLabel setFrame:CGRectMake(VALUELABLE_LEFT, CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight, VALUELABLE_WIDTH, valueLabelHeight)];
    }else{
        valueLabelHeight=[c.value sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
        valueLabelHeight=valueLabelHeight<20?20:valueLabelHeight;
        [valueLabel setFrame:CGRectMake(10, CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight, 280, valueLabelHeight)];
    }
    [cv addSubview:valueLabel];
    [valueLabel release];
    
    if (nameLabelString.length)
    {
        float nameLabelY=CONTENT_TITLEHEIGHT+(valueLabelHeight+CONTENT_TOPEDGE+CONTENT_BUTTOMEDGE-NAMELABLE_HEIGHT)/2+contentTotalHeight;
        float lineHeight = valueLabelHeight+CONTENT_BUTTOMEDGE+CONTENT_TOPEDGE;
        UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, nameLabelY, NAMELABLE_WIDTH, valueLabelHeight)];
        [nameLabel setText:nameLabelString];
        [nameLabel setFont:[UIFont systemFontOfSize:16]];
        [nameLabel setNumberOfLines:0];
        [cv addSubview:nameLabel];
        [nameLabel release];
        UIView *verLine=[self createVerticalLine:lineHeight];
        [verLine setFrame:CGRectMake(VERLINE_LEFT, CONTENT_TITLEHEIGHT+contentTotalHeight,1,lineHeight)];
        [cv addSubview:verLine];
    }
    UIView *horLine=[self createHorizonalLine:300];
    [horLine setFrame:CGRectMake(0, CONTENT_TITLEHEIGHT+valueLabelHeight+CONTENT_TOPEDGE+CONTENT_BUTTOMEDGE+contentTotalHeight,300, 1)];
    [cv addSubview:horLine];
    
    contentTotalHeight+=valueLabelHeight+CONTENT_TOPEDGE+CONTENT_BUTTOMEDGE+1;
    
}

-(void)addTextToCvWithElement:(element *)e andColumn:(column *)c andCv:(UIView *)cv
{
    float valueLabelHeight=0.0;
    float nameLabelHeight=0.0;
    NSString* nameLabelString = [e.elementDict objectForKey:@"name"];
    
    UILabel *valueLabel;
    valueLabel=[[UILabel alloc] initWithFrame:CGRectMake(VALUELABLE_LEFT, CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight, VALUELABLE_WIDTH, valueLabelHeight)];
    
    [valueLabel setText:e.value];
    [valueLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [valueLabel setNumberOfLines:0];
    if (nameLabelString.length)
    {
        valueLabelHeight=[e.value sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(VALUELABLE_WIDTH, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
        valueLabelHeight=valueLabelHeight <= 20 ? 20 : valueLabelHeight;
        nameLabelHeight=[nameLabelString sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(NAMELABLE_WIDTH, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
        valueLabelHeight=valueLabelHeight<=nameLabelHeight?nameLabelHeight:valueLabelHeight;
        [valueLabel setFrame:CGRectMake(VALUELABLE_LEFT, CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight, VALUELABLE_WIDTH, valueLabelHeight)];
    }else{
        valueLabelHeight=[e.value sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
        valueLabelHeight=valueLabelHeight <= 20 ? 20 : valueLabelHeight;
        [valueLabel setFrame:CGRectMake(10, CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight, 280, valueLabelHeight)];
    }
    [cv addSubview:valueLabel];
    [valueLabel release];
    if (nameLabelString.length)
    {
        float nameLabelY=CONTENT_TITLEHEIGHT+(valueLabelHeight+CONTENT_TOPEDGE+CONTENT_BUTTOMEDGE-NAMELABLE_HEIGHT)/2+contentTotalHeight;
        UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, nameLabelY, NAMELABLE_WIDTH, valueLabelHeight)];
        
        [nameLabel setText:[e.elementDict objectForKey:@"name"]];
        [nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setFont:[UIFont systemFontOfSize:16]];
        [nameLabel setNumberOfLines:0];
        [cv addSubview:nameLabel];
        [nameLabel release];
    }
    contentTotalHeight+=valueLabelHeight+CONTENT_TOPEDGE+CONTENT_BUTTOMEDGE;
}
@end
