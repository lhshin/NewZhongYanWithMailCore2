//
//  SKGtaskDetailController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-6.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKGtaskDetailController.h"
#import "SKColumnDetailController.h"
#import "SKLToolBar.h"
#import "DataServiceURLs.h"
#import "business.h"
#import "DDXMLNode.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "SKAttachButton.h"
#import "SKAttachManger.h"
#import "SKImageView.h"
#import "NSData+Base64.h"
#import "GDataXMLNode.h"
#import "SKViewController.h"
#import "SKNextBranchesController.h"
#import "SKCommonLanguageController.h"
#import "MBProgressHUD.h"
#pragma mark- 相关界面参数的宏定义
#define CONTENT_WIDTH 300
#define CONTENT_TITLEHEIGHT 20
#define CONTENT_TOPEDGE 8
#define CONTENT_BUTTOMEDGE 8
#define NAMELABLE_HEIGHT 25
#define VERLINE_LEFT 95
#define VALUELABLE_WIDTH 180
#define VALUELABLE_LEFT 105
#define NAMELABLE_WIDTH 90
#define SIGNATURELABEL_HEIGHT 20
#define SIGNATURELABEL_WIDTH 100
#define MARKLABEL_WIDTH 20
#define MARKLABEL_HEIGHT 20
#define PHRASETEXTVIEW_HEIGHT 40

#define ELEMENTLEVEL 5
#define COLUMNLEVEL 4
@interface SKGtaskDetailController ()
{
    __weak IBOutlet UIView *toolView;
    __weak IBOutlet UIScrollView *mainScrollview;
    SKLToolBar          *myToolBar;
    UILabel             *stepLabel;
    UIView              *contentView;
    UIBarButtonItem *previousBtn;
    UIBarButtonItem *nextBtn;
    UIBarButtonItem *doneBtn;
    UIToolbar *textToolBar;
    UIView* titleView;
    
    
    CGFloat  TITLE_HEIGHT;
    DDXMLDocument *mainDoc;
    BOOL isErrorHappened;//用于如果出现错误 则不弹出提示框 直接返回
    BOOL isBack;
    
    NSUInteger   currentTextViewindex;         //当前被选中textView的序号
    int   curretnDetailIndex;             //当前明细ID的下标
    int   currentImageViewIndex;               //当前ImageView下标
    float totalHeight;                  //scrollview总高度
    float contentTotalHeight;           //业务内容总高度
    float currentTextViewYlocation;     //当前textViewy轴位置
    
    NSDictionary   * GTaskDetailInfo;   //用来存储该代办的一些基本信息 根据这些基本信息 获取代办详情
    NSMutableArray *saveColumnsArray;   //保存时需要用到的columns数组
    NSMutableArray *saveTextViewArray;  //保存时需要用到的textView数组
    NSMutableArray *DetailIDArray;      //明细ID数组
    NSMutableArray *signatureImageViewArray; //签名imageView数组
    NSMutableArray *signatureIDArray;
    
    float keyboardHeight;
}
@end

@implementation SKGtaskDetailController
@synthesize GTaskDetailInfo;
/**
 *  返回到列表
 */
-(void)backtoItem
{
    SKViewController* controller = [APPUtils AppRootViewController];
    [controller.navigationController popViewControllerAnimated:YES];
}

/**
 *  处理帮助的手势
 *
 *  @param recognizer 手势
 */
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

/**
 *  点击帮助触发事件
 *
 *  @param sender 触发者
 */
- (IBAction)help:(id)sender {
    UIImageView* helpImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [helpImage setImage:[UIImage imageNamed:IS_IPHONE_5? @"iphone5_help_oadetailed" : @"iphone4_help_oadetailed"]];
    [helpImage setUserInteractionEnabled:YES];
    [helpImage setTag:1111];
    [self.view.window addSubview:helpImage];
    
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapForHelpImage:)];
    [helpImage addGestureRecognizer:tapGes];
    [helpImage fallIn:.4 delegate:nil completeBlock:^{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }];
}

/**
 *  解析待办数据
 *
 *  @param data 待解析的数据
 */
-(void)praserBusinessWithServerData:(NSData*)data
{
    _aBusiness = [[business alloc] init];
    mainDoc = [[DDXMLDocument alloc] initWithData:data options:0 error:0];
    _aBusiness.returncode =  [(DDXMLElement*)[[mainDoc nodesForXPath:@"//returncode" error:0] objectAtIndex:0] stringValue];
    if (![_aBusiness.returncode isEqualToString:@"OK"]) {
        return;
    }
    _aBusiness.flowinstanceid =  [(DDXMLElement*)[[mainDoc nodesForXPath:@"//flowinstanceid" error:0] objectAtIndex:0] stringValue];
    NSArray* steparray = [mainDoc nodesForXPath:@"//step" error:0];
    if (steparray.count) {
        _aBusiness.step =  [(DDXMLElement*)[steparray objectAtIndex:0] stringValue];
    }
    _aBusiness.xmlNodes = [mainDoc nodesForXPath:@"//columns" error:nil];
    for (DDXMLNode* csnode in [mainDoc nodesForXPath:@"//columns" error:0])
    {
        //NSLog(@"%@",[csnode XMLStringWithOptions:DDXMLNodePrettyPrint]);
        columns* cs = [[columns alloc] init];
        cs.columnsDict = [(DDXMLElement*)csnode attributesAsDictionary];
        cs.csnode = csnode;
        for (DDXMLNode* cnode in [csnode nodesForXPath:@"./column" error:0])
        {
            column* c = [[column alloc] init];
            c.columnDict = [(DDXMLElement*)cnode attributesAsDictionary];
            c.value = cnode.stringValue;
            c.cnode = cnode;
            for (DDXMLElement *enode in [cnode nodesForXPath:@"./element" error:0])
            {
                element* e = [[element alloc] init];
                e.elementDict = [(DDXMLElement*)enode attributesAsDictionary];
                e.value = enode.stringValue;
                e.enode = enode;
                [c.elementArray addObject:e];
            }
            [cs.columnsArray addObject:c];
        }
        [_aBusiness.columnsArray addObject:cs];
    }
}

/**
 *  获取待办数据
 NSData* data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"xml"]];
 [self praserBusinessWithServerData:data];
 if (![self.aBusiness.returncode isEqualToString:@"OK"])
 {
 isErrorHappened=YES;
 NSString* msg = @"获取待办失败";
 if ([self.aBusiness.returncode rangeOfString:@"1002"].location != NSNotFound)
 {
 msg = @"该待办已经办理";
 NSString* sql = [NSString stringWithFormat:@"update T_REMINDS set STATUS = 1 where AID  = '%@'",[GTaskDetailInfo objectForKey:@"AID"]];
 [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
 
 [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:0 userInfo:[NSDictionary dictionaryWithObject:[GTaskDetailInfo objectForKey:@"AID"] forKey:@"AID"]];
 }
 [BWStatusBarOverlay showMessage:msg duration:2 animated:YES];
 return ;
 }
 NSString* step = (self.aBusiness.step && ![self.aBusiness.step isEqualToString:@""])
 ?[NSString stringWithFormat:@"当前环节: %@",self.aBusiness.step]:@"";
 [stepLabel setText:step];
 [self createBusinessDetailViewWithData:self.aBusiness];
 [myToolBar.secondButton setEnabled:YES];
 [myToolBar.thirdButton setEnabled:YES];
 
 return;
 */
-(void)businessDataFromServer
{
    NSURL* workItemUrl = [DataServiceURLs getWorkItemDetails:[APPUtils userUid]
                                                        TFRM:[GTaskDetailInfo objectForKey:@"TFRM"]
                                                         AID:[GTaskDetailInfo objectForKey:@"AID"]];
    SKHTTPRequest *request = [SKHTTPRequest requestWithURL:workItemUrl];
    __weak SKHTTPRequest *req = request;
    [request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSData* data = req.responseData;
        [self praserBusinessWithServerData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self.aBusiness.returncode isEqualToString:@"OK"])
            {
                isErrorHappened=YES;
                NSString* msg = @"获取待办失败";
                if ([self.aBusiness.returncode rangeOfString:@"1002"].location != NSNotFound)
                {
                    msg = @"该待办已经办理";
                    NSString* sql = [NSString stringWithFormat:@"update T_REMINDS set STATUS = 1 where AID  = '%@'",[GTaskDetailInfo objectForKey:@"AID"]];
                    [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:0 userInfo:[NSDictionary dictionaryWithObject:[GTaskDetailInfo objectForKey:@"AID"] forKey:@"AID"]];
                }
                [BWStatusBarOverlay showMessage:msg duration:2 animated:YES];
                return ;
            }
            NSString* step = (self.aBusiness.step && ![self.aBusiness.step isEqualToString:@""])
            ?[NSString stringWithFormat:@"当前环节: %@",self.aBusiness.step]:@"";
            [stepLabel setText:step];
            [self createBusinessDetailViewWithData:self.aBusiness];
            if ([GTaskDetailInfo[@"HANDLE"] intValue] != 1)
            {
                [myToolBar.secondButton setEnabled:YES];
                [myToolBar.thirdButton setEnabled:YES];
            }
            currentTextViewindex = -1;
        });
    }];
    
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [BWStatusBarOverlay showMessage:req.errorinfo duration:1 animated:1];
        isErrorHappened=YES;
    }];
    [request startAsynchronous];
    [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"加载中..."];
    
}

/**
 *  获取已办数据
 */
-(void)getWorkedBusinessDataFromServer
{
    NSURL* workItemUrl = [DataServiceURLs getWorkedItemDetails:[APPUtils userUid] TFRM:[GTaskDetailInfo objectForKey:@"TFRM"] flowinstanceid:[GTaskDetailInfo objectForKey:@"FLOWINSTANCEID"]];
    SKHTTPRequest *request = [SKHTTPRequest requestWithURL:workItemUrl];
    __weak SKHTTPRequest *req = request;
    [request setCompletionBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (req.responseStatusCode != 200)
        {
            [BWStatusBarOverlay showMessage:@"服务器网络故障" duration:1.5 animated:YES];
            return;
        }
        ParseOperation *parser = [[ParseOperation alloc]
                                  initWithData:[req responseData]
                                  completionHandler:^(business *abusiness) {
                                      self.aBusiness = abusiness;
                                      NSString* step = (self.aBusiness.step && ![self.aBusiness.step isEqualToString:@""])
                                      ?[NSString stringWithFormat:@"当前环节: %@",self.aBusiness.step]
                                      :@"";
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          if (![self.aBusiness.returncode isEqualToString:@"OK"]) {
                                              isErrorHappened=YES;
                                              [BWStatusBarOverlay showMessage:[[self.aBusiness.returncode componentsSeparatedByString:@","] lastObject] duration:1 animated:1];
                                              if ([self.aBusiness.returncode rangeOfString:@"1002"].location != NSNotFound) {
                                                  
                                              }
                                              return ;
                                          }
                                          [stepLabel setText:step];
                                          [self createBusinessDetailViewWithData:self.aBusiness];
                                          currentTextViewindex = -1;
                                      });
                                  }];
        NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        [queue addOperation:parser];
        
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [BWStatusBarOverlay showMessage:@"获取待办数据失败" duration:1 animated:1];
        isErrorHappened=YES;
    }];
    [request startAsynchronous];
    [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"加载中..."];
}

/**
 *  初始化基本数据
 */
-(void)initData
{
    //常用语通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setCommonLanguage:)
                                                 name:@"phrase"
                                               object:nil];
    //签名通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setSignature:)
                                                 name:@"signature"
                                               object:nil];
    totalHeight=0;
    contentTotalHeight=0.0;
    currentTextViewYlocation=0.0;
    keyboardHeight=0.0;
    currentTextViewindex = 1;
    saveColumnsArray = [[NSMutableArray alloc] init];
    saveTextViewArray = [[NSMutableArray alloc] init];
    curretnDetailIndex=0;
    DetailIDArray=[[NSMutableArray alloc] init];
    signatureImageViewArray=[[NSMutableArray alloc] init];
    signatureIDArray=[[NSMutableArray alloc] init];
    currentImageViewIndex=1;
    TITLE_HEIGHT = 0;
}

-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
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
    
    myToolBar = [[SKLToolBar alloc] initWithFrame:CGRectMake(0,0, 320, 49)];
    [myToolBar setFirstItem:@"btn_history_ecm" Title:@"历史"];
    [myToolBar setSecondItem:@"btn_location_ecm" Title:@"定位"];
    [myToolBar setThirdItem:@"btn_next_ecm" Title:@"下一步"];
    [myToolBar.firstButton  addTarget:self action:@selector(getHistory)       forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.secondButton addTarget:self action:@selector(locateTextView)   forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.thirdButton  addTarget:self action:@selector(getNextBranches:) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar.secondButton setEnabled:NO];
    [myToolBar.thirdButton  setEnabled:NO];
    [toolView addSubview:myToolBar];
    
    CGFloat height = [self.GTaskDetailInfo[@"TITL"]
                      sizeWithFont:[UIFont boldSystemFontOfSize:18]
                      constrainedToSize: CGSizeMake(300,MAXFLOAT)
                      lineBreakMode:NSLineBreakByCharWrapping].height;
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 320,height)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [mainScrollview addSubview:titleView];
    
    UIView* leftBlockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5,height)];
    [leftBlockView setBackgroundColor:COLOR(177, 0, 4)];
    [titleView addSubview:leftBlockView];
    
    UILabel *titlelabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, CONTENT_WIDTH, height)];
    [titlelabel setText:self.GTaskDetailInfo[@"TITL"]];
    [titlelabel setFont:[UIFont boldSystemFontOfSize:18]];
    [titlelabel setNumberOfLines:0];
    [titlelabel setLineBreakMode:NSLineBreakByCharWrapping];
    [titleView addSubview:titlelabel];
    
    stepLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titlelabel.frame) + 2, CONTENT_WIDTH, 16.7)];
    [stepLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [stepLabel setFont:[UIFont systemFontOfSize:14]];
    [titleView addSubview:stepLabel];
    [leftBlockView setFrame:CGRectMake(0,0,5,CGRectGetMaxY(stepLabel.frame))];
    [titleView setFrame:CGRectMake(0,5,320,CGRectGetMaxY(stepLabel.frame))];
    TITLE_HEIGHT += CGRectGetMaxY(titleView.frame);
    
    contentView =[[UIView alloc] initWithFrame:CGRectMake(0,TITLE_HEIGHT, 0, 0)];
    [mainScrollview addSubview:contentView];
    
    
    previousBtn=[[UIBarButtonItem alloc] initWithTitle:@"上一项" style:UIBarButtonItemStyleBordered target:self action:@selector(previousText)];
    nextBtn=[[UIBarButtonItem alloc] initWithTitle:@"下一项" style:UIBarButtonItemStyleBordered target:self action:@selector(nextText)];
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    doneBtn=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(doneTextEditing)];
    textToolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, BottomY, 320, 44)];
    [textToolBar setItems:[NSArray arrayWithObjects:previousBtn,nextBtn,flexibleSpaceItem,doneBtn,nil]];
    [textToolBar setBarStyle:UIBarStyleDefault];
    if (System_Version_Small_Than_(7)) {
        [textToolBar setBarStyle:UIBarStyleBlackTranslucent];
    }
    [self.view addSubview:textToolBar];
    
    if ([[GTaskDetailInfo objectForKey:@"STATUS"] intValue] == 1) {//已办
        isErrorHappened = YES;//仅仅用于使得退出时不提示保存
        [self getWorkedBusinessDataFromServer];
        self.title = @"已办详情";
    }else{
        [self businessDataFromServer];
        self.title = @"待办详情";
    }
    
    if ([[GTaskDetailInfo objectForKey:@"STATUS"] intValue] == 1
        || [[GTaskDetailInfo objectForKey:@"HANDLE"] intValue] == 1)
    {
        UIImageView* onlyreadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(260, TopY, 60, 60)];
        onlyreadImageView.image = [UIImage imageNamed:@"onlyread"];
        [self.view addSubview:onlyreadImageView];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self rigisterObbserver];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeoObb];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark- 构件截面
/**
 *  构造界面
 *
 *  @param b 业务
 */
-(void)createBusinessDetailViewWithData:(business*)b
{
    for (columns* cs in b.columnsArray)
    {
        contentTotalHeight=0.0;
        [self addCustomViewWithColumns:cs];
    }
}

//竖线
-(UIView *)createVerticalLine:(float)lineHeight
{
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, lineHeight)];
    [v setBackgroundColor:[UIColor lightGrayColor]];
    return v ;
}

//横线
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

//加入customView到contentView中
-(void)addCustomViewWithColumns:(columns*)cs
{
    UIView *cv=[[UIView alloc] init];
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
        //如果是文档类型
        if ([FileUtils columnType:c] == SKFile)
        {
            [self addFileBtnToCvWithColumnDic:c.columnDict andCv:cv];
        }
        //如果是文字类型
        else if([FileUtils columnType:c] == SKtext)
        {
            [self addTextToCvWithColumn:c andCv:cv andCs:cs];
        }
        //如果是图像
        else if([FileUtils columnType:c] == SKImage)
        {
            [self addImageToCvWithColumn:c andCv:cv andCs:cs];
        }
        //如果是混合类型
        else if([FileUtils columnType:c] == SKMixed)
        {
            for ( element* e in c.elementArray )
            {
                //如果是文字
                if ([[e.elementDict objectForKey:@"type"] isEqualToString:@"text/plain"])
                {
                    [self addTextToCvWithElement:e andColumn:c andCv:cv andCs:cs];
                }
                //如果是图像
                else if([[e.elementDict objectForKey:@"type"] isEqualToString:@"image/png"])
                {
                    [self addImageToCvWithElement:e andCv:cv andCs:cs];
                }
                //如果是文档类型
                else if ([[e.elementDict objectForKey:@"type"] isEqualToString:@"application/msword"])
                {
                    [self addFileBtnToCvWithColumnDic:e.elementDict andCv:cv];
                }
            }
            UIView *horLine=[self createHorizonalLine:320];
            [horLine setFrame:CGRectMake(0, CONTENT_TITLEHEIGHT+contentTotalHeight,320,2)];
            contentTotalHeight+=2;
            [cv addSubview:horLine];
        }
    }
    
    [cv setFrame:CGRectMake(0, totalHeight, 320, CONTENT_TITLEHEIGHT+contentTotalHeight)];
    totalHeight+=contentTotalHeight+CONTENT_TITLEHEIGHT;
    [contentView addSubview:cv];
    [contentView setFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), 320, totalHeight)];
    [mainScrollview setContentSize:CGSizeMake(320, totalHeight+CGRectGetMaxY(titleView.frame))];
}

//加入文件按钮
-(void)addFileBtnToCvWithColumnDic:(NSDictionary *)cDic andCv:(UIView *)cv
{
    //如果是不可见的
    if ([cDic.allKeys containsObject:@"visible"]&&[[cDic objectForKey:@"visible"] isEqualToString:@"false"])
    {
        return;
    }
    NSURL* getFileUrl = [DataServiceURLs getFile:[APPUtils userUid]
                                            TFRM:[GTaskDetailInfo objectForKey:@"TFRM"]
                                  FLOWINSTANCEID:self.aBusiness.flowinstanceid
                                           Filed:[cDic objectForKey:@"id"]];
    NSString *aid=[GTaskDetailInfo objectForKey:@"AID"];
    NSString *filePath=[[SKAttachManger aIDPath:aid] stringByAppendingPathComponent:[cDic objectForKey:@"name"]];
    SKAttachButton *btn=[[SKAttachButton alloc] initNoBorderBtnWithFrame:CGRectMake(10,CONTENT_TITLEHEIGHT+contentTotalHeight, 300, 44)];
    [btn setTitle:[cDic objectForKey:@"name"] forState:UIControlStateNormal];
    [btn setFilePath:filePath];
    [btn setAttachUrl:getFileUrl];
    [btn setIsAttachExisted:[[NSFileManager defaultManager] fileExistsAtPath:filePath]];
    [cv addSubview:btn];
    contentTotalHeight += 44;
    [cv addSubview:btn];
}

-(void)addTextToCvWithColumn:(column *)c andCv:(UIView *)cv andCs:(columns*)cs
{
    //如果是不可见的
    if ([c.columnDict.allKeys containsObject:@"visible"]&&[[c.columnDict objectForKey:@"visible"] isEqualToString:@"false"])
    {
        return;
    }
    float valueLabelHeight=0.0;
    float nameLabelHeight=0.0;
    NSString* nameLabelString = [c.columnDict objectForKey:@"name"];
    rwType columntype = [FileUtils getRWType:c.columnDict];
    SKExtendTyped extendType=[FileUtils extendType:c];
    HPGrowingTextView *gTextView ;
    if (columntype) {
        valueLabelHeight=24;
        CGRect gTextViewRect=CGRectMake(VALUELABLE_LEFT - 5,CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight - 3,VALUELABLE_WIDTH,30);
        gTextView = [[HPGrowingTextView alloc]initWithFrame:gTextViewRect];
        gTextView.yLocation=totalHeight+CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight;
        [gTextView setCv:cv];
        [gTextView setReturnKeyType:UIReturnKeyDone];
        [gTextView setPlaceholder:c.value];
        [gTextView setDelegate:self];
        [gTextView setNode:c.cnode];
        [gTextView setCs:cs];
        [gTextView setTag:currentTextViewindex];
        [gTextView setBackgroundColor:COLOR(208, 208, 208)];
        [gTextView setCID:[c.columnDict objectForKey:@"id"]];
        [gTextView setExtendType:extendType];
        [cv addSubview:gTextView];
        
        [saveColumnsArray addObject:c];
        [saveTextViewArray addObject:gTextView];
        currentTextViewindex++;
    }else{
        UILabel *valueLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        [valueLabel setText:c.value];
        [valueLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [valueLabel setNumberOfLines:0];
        if (nameLabelString.length)
        {
            valueLabelHeight = [c.value sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(VALUELABLE_WIDTH, 1000) lineBreakMode:NSLineBreakByTruncatingTail].height;
            valueLabelHeight = valueLabelHeight <= 32 ? 32:valueLabelHeight;
            nameLabelHeight = [nameLabelString sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(NAMELABLE_WIDTH, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
            valueLabelHeight = valueLabelHeight <= nameLabelHeight ? nameLabelHeight : valueLabelHeight;
            [valueLabel setFrame:CGRectMake(VALUELABLE_LEFT - 5, CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight, VALUELABLE_WIDTH, valueLabelHeight)];
        }else{
            valueLabelHeight=[c.value sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
            valueLabelHeight = valueLabelHeight <= 32 ? 32 : valueLabelHeight;
            [valueLabel setFrame:CGRectMake(20, CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight, 280, valueLabelHeight)];
        }
        [cv addSubview:valueLabel];
    }
    
    if (nameLabelString.length)
    {
        float nameLabelY=CONTENT_TITLEHEIGHT + 10 + contentTotalHeight;
        if (columntype == rwTypeW1 || columntype == rwTypeWB1)
        {
            if(gTextView)
            {
                gTextView.isHadToBeFill=YES;
                [gTextView setNameLabelText:nameLabelString];
            }
        }
        UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, nameLabelY, NAMELABLE_WIDTH, valueLabelHeight)];
        if (columntype)[nameLabel setTag:currentTextViewindex - 1];
        [nameLabel setText:nameLabelString];
        [nameLabel setFont:[UIFont systemFontOfSize:16]];
        [nameLabel setNumberOfLines:0];
        [cv addSubview:nameLabel];
    }
    
    UIView *horLine=[self createHorizonalLine:320];
    [horLine setFrame:CGRectMake(0, CONTENT_TITLEHEIGHT+valueLabelHeight+CONTENT_TOPEDGE+CONTENT_BUTTOMEDGE+contentTotalHeight,320, 2)];
    [cv addSubview:horLine];
    
    if (extendType==SKPhrase&&columntype)
    {
        UIButton *phraseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [phraseBtn setBackgroundImage:Image(@"phrase_ecm") forState:UIControlStateNormal];
        [phraseBtn setFrame:CGRectMake(CGRectGetMaxX(gTextView.frame) + 5,CGRectGetMinY(gTextView.frame) + 0.1, 32, 32)];
        [phraseBtn addTarget:self action:@selector(getPhrase:) forControlEvents:UIControlEventTouchUpInside];
        [phraseBtn setTag:currentTextViewindex-1];//和textview对应起来
        [cv addSubview:phraseBtn];
    }else if(extendType==SKSignature&&columntype){
        [gTextView setEditable:NO];
        UIButton *signatureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [signatureBtn setBackgroundImage:[UIImage imageNamed:@"sigh_ecm"] forState:UIControlStateNormal];
        [signatureBtn setFrame:CGRectMake(CGRectGetMaxX(gTextView.frame) + 6,CGRectGetMinY(gTextView.frame) + 0.1, 32, 32)];
        [signatureBtn addTarget:self action:@selector(getSignatureWithTextView:) forControlEvents:UIControlEventTouchUpInside];
        [gTextView setIsTextSignature:YES];
        [signatureBtn setTag:(currentTextViewindex-1)];//和textview对应起来
        [cv addSubview:signatureBtn];
    }
    contentTotalHeight+=valueLabelHeight+CONTENT_TOPEDGE+CONTENT_BUTTOMEDGE;
}

//加入图像类型内容
-(void)addImageToCvWithColumn:(column *)c andCv:(UIView *)cv andCs:(columns *)cs
{
    //如果是不可见的
    if ([c.columnDict.allKeys containsObject:@"visible"]&&[[c.columnDict objectForKey:@"visible"] isEqualToString:@"false"])
    {
        return;
    }
    float nameLabelY;
    if (c.value==nil||[c.value isEqualToString:@""])
    {
        nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT;
        if ([FileUtils extendType:c] == SKSignature)
        {
            HPGrowingTextView *gTextView=[[HPGrowingTextView alloc] initWithFrame:CGRectMake(VALUELABLE_LEFT - 5, contentTotalHeight+CONTENT_TITLEHEIGHT, 0.01, 50)];
            gTextView.isForSignature=YES;
            gTextView.yLocation=totalHeight+CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight;
            [gTextView setTag:currentTextViewindex];
            [gTextView setDelegate:self];
            [gTextView setCv:cv];
            [cv addSubview:gTextView];
            [saveTextViewArray addObject:gTextView];
            currentTextViewindex++;
            TextDownView *tdView=[[TextDownView alloc] init];
            CGRect tdRect = tdView.frame;
            tdRect.origin.y=CGRectGetMaxY(gTextView.frame)+8;
            tdRect.origin.x=gTextView.frame.origin.x;
            tdView.frame=tdRect;
            tdView.noticeLabel.text=@"使用签名按键签名!";
            [tdView.flagImage setImage:[UIImage imageNamed:@"warning.png"]];
            [cv addSubview:tdView];
            
            SKImageView *signatureImageView;
            signatureImageView=[[SKImageView alloc] init];
            signatureImageView.frame = CGRectMake(VALUELABLE_LEFT - 5, contentTotalHeight+CONTENT_TITLEHEIGHT, 0.01, 40);
            signatureImageView.tag=currentImageViewIndex*1001;
            signatureImageView.tdView=tdView;
            [cv addSubview:signatureImageView];
            nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT+ (signatureImageView.frame.size.height-NAMELABLE_HEIGHT)/2;
            
            rwType columnType = [FileUtils getRWType:c.columnDict];
            if (columnType==rwTypeW1||columnType==rwTypeWB1) {
                signatureImageView.textView=gTextView;
                gTextView.isHadToBeFill=YES;
            }
            [signatureImageView setXmlnode:c.cnode];
            [signatureImageView setCs:cs];
            [signatureImageView.cs setIsWritenColumns:YES];
            signatureImageView.nameLabelText=[c.columnDict objectForKey:@"name"];
            [signatureImageViewArray addObject:signatureImageView];
            NSString *imageSignatureID;
            imageSignatureID=[[NSString alloc] initWithString:[c.columnDict objectForKey:@"id"]];
            [signatureIDArray addObject:imageSignatureID];
            
            UIButton *signatureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [signatureBtn setBackgroundImage:[UIImage imageNamed:@"sigh_ecm"] forState:UIControlStateNormal];
            [signatureBtn setFrame:CGRectMake(CGRectGetMaxX(tdView.frame) + 6,CGRectGetMinY(tdView.frame) - 12, 32, 32)];
            [signatureBtn addTarget:self action:@selector(getSignature:) forControlEvents:UIControlEventTouchUpInside];
            [cv addSubview:signatureBtn];
            [signatureBtn setTag:currentImageViewIndex*100];
            currentImageViewIndex++;
            
            UIView *horLine=[self createHorizonalLine:320];
            [horLine setFrame:CGRectMake(0,contentTotalHeight+CONTENT_TITLEHEIGHT+ 40+37,320,2)];
            [cv addSubview:horLine];
            contentTotalHeight = CGRectGetMaxY(horLine.frame) - CONTENT_TITLEHEIGHT;
        }else {
            //这里需要测试
            UIView *horLine=[self createHorizonalLine:320];
            [horLine setFrame:CGRectMake(0,contentTotalHeight+CONTENT_TITLEHEIGHT+ NAMELABLE_HEIGHT,320,2)];
            [cv addSubview:horLine];
            contentTotalHeight+=NAMELABLE_HEIGHT+2;
        }
    }
    else
    {
        if ([FileUtils extendType:c]==SKSignature)
        {
            nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT;
            UIImage *image=[UIImage imageWithData:[NSData dataFromBase64String:c.value]];
            CGRect imageRect = [self getImageViewSizeWithImageSize:image.size andLimitedWidth:VALUELABLE_WIDTH andLeftMargin:VALUELABLE_LEFT - 5];
            SKImageView *signatureImageView;
            signatureImageView = [[SKImageView alloc] init];
            signatureImageView.tag=currentImageViewIndex*1001;
            [signatureImageView setImage:image];
            [signatureImageView setFrame:imageRect];
            [cv addSubview:signatureImageView];
            nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT+ (signatureImageView.frame.size.height-NAMELABLE_HEIGHT)/2;
            
            [signatureImageViewArray addObject:signatureImageView];
            NSString *imageSignatureID;
            imageSignatureID=[[NSString alloc] initWithString:[c.columnDict objectForKey:@"id"]];
            [signatureIDArray addObject:imageSignatureID];
            TextDownView *tdView=[[TextDownView alloc] init];
            CGRect tdRect=[tdView frame];
            tdRect.origin.y=CGRectGetMaxY(signatureImageView.frame)+8;
            tdRect.origin.x=signatureImageView.frame.origin.x;
            tdView.frame=tdRect;
            tdView.noticeLabel.text=@"使用签名按键签名!";
            [tdView.flagImage setImage:[UIImage imageNamed:@"warning.png"]];
            [cv addSubview:tdView];
            
            UIButton *signatureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [signatureBtn setBackgroundImage:[UIImage imageNamed:@"sigh_ecm"] forState:UIControlStateNormal];
            [signatureBtn setFrame:CGRectMake(CGRectGetMaxX(tdView.frame) + 6,CGRectGetMinY(tdView.frame) - 12, 32, 32)];
            [signatureBtn addTarget:self action:@selector(getSignature:) forControlEvents:UIControlEventTouchUpInside];
            [cv addSubview:signatureBtn];
            [signatureBtn setTag:currentImageViewIndex*100];
            currentImageViewIndex++;
            
            UIView *horLine=[self createHorizonalLine:320];
            [horLine setFrame:CGRectMake(0,contentTotalHeight+CONTENT_TITLEHEIGHT+ signatureImageView.frame.size.height + 32,320,2)];
            [cv addSubview:horLine];
            contentTotalHeight = CGRectGetMaxY(horLine.frame) - CONTENT_TITLEHEIGHT;
        }else{
            NSData *imageData=[NSData dataFromBase64String:c.value];
            UIImage *image=[UIImage imageWithData:imageData];
            SKImageView *imageView=[[SKImageView alloc] initWithImage:image];
            imageView.base64String = c.value;
            [imageView setFrame:[self getImageViewSizeWithImageSize:image.size andLimitedWidth:VALUELABLE_WIDTH andLeftMargin:VALUELABLE_LEFT - 5]];
            [cv addSubview:imageView];
            nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT+ (imageView.frame.size.height-NAMELABLE_HEIGHT)/2;
           
            UIView *horLine=[self createHorizonalLine:320];
            [horLine setFrame:CGRectMake(0,contentTotalHeight+CONTENT_TITLEHEIGHT+ imageView.frame.size.height,320,2)];
            [cv addSubview:horLine];
            contentTotalHeight = CGRectGetMaxY(horLine.frame) - CONTENT_TITLEHEIGHT;
        }
    }
    
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, nameLabelY, NAMELABLE_WIDTH, NAMELABLE_HEIGHT)];
    [nameLabel setText:[c.columnDict objectForKey:@"name"]];
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setTextColor:[UIColor blackColor]];
    [cv addSubview:nameLabel];
}

-(void)addTextToCvWithElement:(element *)e andColumn:(column *)c andCv:(UIView *)cv andCs:(columns *)cs
{
    //如果是不可见的
    if ([e.elementDict.allKeys containsObject:@"visible"]&&[[e.elementDict objectForKey:@"visible"] isEqualToString:@"false"])
    {
        return;
    }
    float valueLabelHeight=0.0;
    float nameLabelHeight=0.0;
    NSString* nameLabelString = [e.elementDict objectForKey:@"name"];
    rwType elementype = [FileUtils getRWType:e.elementDict];
    SKExtendTyped extendType= [FileUtils extendTypeWithElement:e];
    HPGrowingTextView *gTextView;
    //如果需要填写
    if (elementype)
    {
        valueLabelHeight=24;
        gTextView = [[HPGrowingTextView alloc]
                     initWithFrame:CGRectMake(VALUELABLE_LEFT - 5,
                                              CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight,
                                              VALUELABLE_WIDTH, 30)];
        gTextView.yLocation=totalHeight+CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight;
        [gTextView setTag:currentTextViewindex];
        [gTextView setDelegate:self];
        [gTextView setCv:cv];
        [gTextView setCs:cs];
        [gTextView setPlaceholder:e.value];
        [gTextView setReturnKeyType:UIReturnKeyDone];
        [gTextView setCID:[e.elementDict objectForKey:@"id"]];
        [gTextView setNode:e.enode];
        [gTextView setExtendType:extendType];
        [gTextView setBackgroundColor:COLOR(208, 208, 208)];
        [cv addSubview:gTextView];
        [saveColumnsArray addObject:e];
        [saveTextViewArray addObject:gTextView];
        currentTextViewindex++;
    }else{
        UILabel *valueLabel;
        valueLabel=[[UILabel alloc] initWithFrame:CGRectMake(VALUELABLE_LEFT, CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight, VALUELABLE_WIDTH, valueLabelHeight)];
        [valueLabel setText:e.value];
        [valueLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [valueLabel setNumberOfLines:0];
        [cv addSubview:valueLabel];
        if (nameLabelString.length)
        {
            valueLabelHeight=[e.value sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(VALUELABLE_WIDTH, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
            valueLabelHeight=valueLabelHeight <=32 ? 32 : valueLabelHeight;
            nameLabelHeight=[nameLabelString sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(NAMELABLE_WIDTH, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
            valueLabelHeight=valueLabelHeight<=nameLabelHeight?nameLabelHeight:valueLabelHeight;
            [valueLabel setFrame:CGRectMake(VALUELABLE_LEFT - 5, CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight,VALUELABLE_WIDTH, valueLabelHeight)];
        }else{
            valueLabelHeight=[e.value sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(280, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
            valueLabelHeight=valueLabelHeight <=32 ? 32 : valueLabelHeight;
            [valueLabel setFrame:CGRectMake(20, CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight, 280, valueLabelHeight)];
        }
        //如果有明细
        if (extendType==SKColumnDetail)
        {
            UIButton *detailBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [detailBtn setImage:[UIImage imageNamed:@"btn_oaotherdetail"] forState:UIControlStateNormal];
            [detailBtn setFrame:CGRectMake(CGRectGetMaxX(valueLabel.frame) + 5,CGRectGetMinY(valueLabel.frame), 32, 32)];
            [DetailIDArray addObject:c.columnDict[@"id"]];
            [detailBtn setTag:curretnDetailIndex];
            [detailBtn addTarget:self action:@selector(getColumnDetail:) forControlEvents:UIControlEventTouchUpInside];
            [cv addSubview:detailBtn];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getColumnDetail:)];
            tap.view.tag = curretnDetailIndex;
            valueLabel.userInteractionEnabled=YES;
            [valueLabel addGestureRecognizer:tap];
            curretnDetailIndex++;
        }
    }
    if (nameLabelString.length)
    {
        //如果时必填项
        if (elementype == rwTypeW1 || elementype == rwTypeWB1)
        {
            if(gTextView)
            {
                gTextView.isHadToBeFill=YES;
                [gTextView setNameLabelText:nameLabelString];
            }
        }
        float nameLabelY=CONTENT_TITLEHEIGHT+10+contentTotalHeight;
        UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, nameLabelY, NAMELABLE_WIDTH, valueLabelHeight)];
        [nameLabel setText:[e.elementDict objectForKey:@"name"]];
        [nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setFont:[UIFont systemFontOfSize:16]];
        [nameLabel setNumberOfLines:0];
        if (elementype)[nameLabel setTag:currentTextViewindex - 1];
        [cv addSubview:nameLabel];
    }
    
    if (extendType==SKPhrase&&elementype){
        UIButton *phraseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [phraseBtn setBackgroundImage:Image(@"phrase_ecm") forState:UIControlStateNormal];
        [phraseBtn setFrame:CGRectMake(CGRectGetMaxX(gTextView.frame) + 5,CGRectGetMinY(gTextView.frame) + 0.1, 32, 32)];
        [phraseBtn addTarget:self action:@selector(getPhrase:) forControlEvents:UIControlEventTouchUpInside];
        [phraseBtn setTag:currentTextViewindex-1];//和textview对应起来
        [cv addSubview:phraseBtn];
    }else if(extendType==SKSignature&&elementype){
        [gTextView setEditable:NO];
        UIButton *signatureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [signatureBtn setBackgroundImage:[UIImage imageNamed:@"sigh_ecm"] forState:UIControlStateNormal];
        [signatureBtn setFrame:CGRectMake(CGRectGetMaxX(gTextView.frame) + 6,CGRectGetMinY(gTextView.frame) + 0.1, 32, 32)];
        [signatureBtn addTarget:self action:@selector(getSignatureWithTextView:) forControlEvents:UIControlEventTouchUpInside];
        [gTextView setIsTextSignature:YES];
        [signatureBtn setTag:(currentTextViewindex-1)];//和textview对应起来
        [cv addSubview:signatureBtn];
    }
    contentTotalHeight+=valueLabelHeight+CONTENT_TOPEDGE+CONTENT_BUTTOMEDGE;
}

//加入图像类型内容
-(void)addImageToCvWithElement:(element *)e andCv:(UIView *)cv andCs:(columns *)cs
{
    //如果是不可见的
    if ([e.elementDict.allKeys containsObject:@"visible"]&&[[e.elementDict objectForKey:@"visible"] isEqualToString:@"false"])
    {
        return;
    }
    float nameLabelY;
    if (e.value==nil||[e.value isEqualToString:@""])
    {
        nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT;
        if ([FileUtils extendTypeWithElement:e]==SKSignature)
        {
            HPGrowingTextView *gTextView=[[HPGrowingTextView alloc] initWithFrame:CGRectMake(VALUELABLE_LEFT - 5, contentTotalHeight+CONTENT_TITLEHEIGHT, 0.01, 50)];
            gTextView.isForSignature=YES;
            gTextView.yLocation=totalHeight+CONTENT_TITLEHEIGHT+CONTENT_TOPEDGE+contentTotalHeight;
            [gTextView setTag:currentTextViewindex];
            [gTextView setDelegate:self];
            [gTextView setCv:cv];
            [cv addSubview:gTextView];
            [saveTextViewArray addObject:gTextView];
            currentTextViewindex++;
            
            TextDownView *tdView=[[TextDownView alloc] init];
            CGRect tdRect=[tdView frame];
            tdRect.origin.y=CGRectGetMaxY(gTextView.frame)+8;
            tdRect.origin.x=gTextView.frame.origin.x;
            tdView.frame=tdRect;
            tdView.noticeLabel.text=@"使用签名按键签名!";
            [tdView.flagImage setImage:[UIImage imageNamed:@"warning.png"]];
            [cv addSubview:tdView];
            
            SKImageView *signatureImageView;
            signatureImageView=[[SKImageView alloc] init];
            [signatureImageView setFrame:CGRectMake(VALUELABLE_LEFT, contentTotalHeight+CONTENT_TITLEHEIGHT, 160, 60)];
            [signatureImageView setUserInteractionEnabled:YES];
            signatureImageView.tag=currentImageViewIndex*1001;
            
            signatureImageView.tdView=tdView;
            rwType columnType = [FileUtils getRWType:e.elementDict];
            if (columnType==rwTypeW1||columnType==rwTypeWB1) {
                signatureImageView.textView=gTextView;
                gTextView.isHadToBeFill=YES;
                [gTextView setNameLabelText:e.elementDict[@"name"]];
            }
            [signatureImageView setXmlnode:e.enode];
            [signatureImageView setCs:cs];
            [signatureImageView.cs setIsWritenColumns:YES];
            signatureImageView.nameLabelText=[e.elementDict objectForKey:@"name"];
            [signatureImageViewArray addObject:signatureImageView];
            [signatureIDArray addObject:e.elementDict[@"id"]];
            [cv addSubview:signatureImageView];
            
            UIButton *signatureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [signatureBtn setBackgroundImage:[UIImage imageNamed:@"sigh_ecm"] forState:UIControlStateNormal];
            [signatureBtn setFrame:CGRectMake(CGRectGetMaxX(tdView.frame) + 6,CGRectGetMinY(tdView.frame) - 12, 32, 32)];
            [signatureBtn addTarget:self action:@selector(getSignature:) forControlEvents:UIControlEventTouchUpInside];
            [cv addSubview:signatureBtn];
            [signatureBtn setTag:currentImageViewIndex*100];
            currentImageViewIndex++;
            contentTotalHeight += 40 + CONTENT_TOPEDGE + CONTENT_BUTTOMEDGE + 37;//加上了textView和button的高度
        }
        else
        {
            contentTotalHeight += NAMELABLE_HEIGHT;
        }
    }
    else
    {
        if ([FileUtils extendTypeWithElement:e]==SKSignature)
        {
            nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT;
            UIImage *image=[UIImage imageWithData:[NSData dataFromBase64String:e.value]];
            CGRect imageRect = [self getImageViewSizeWithImageSize:image.size andLimitedWidth:VALUELABLE_WIDTH andLeftMargin:VALUELABLE_LEFT - 5];
            SKImageView *signatureImageView;
            signatureImageView=[[SKImageView alloc] init];
            signatureImageView.tag=currentImageViewIndex*1001;
            signatureImageView.image =image;
            [signatureImageView setBase64String:e.value];
            [signatureImageView setFrame:imageRect];
            [cv addSubview:signatureImageView];
            
            nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT+ (signatureImageView.frame.size.height-NAMELABLE_HEIGHT)/2;
            [signatureImageViewArray addObject:signatureImageView];
            [signatureIDArray addObject:e.elementDict[@"id"]];
            
            TextDownView *tdView=[[TextDownView alloc] init];
            CGRect tdRect=[tdView frame];
            tdRect.origin.y=CGRectGetMaxY(signatureImageView.frame)+8;
            tdRect.origin.x=signatureImageView.frame.origin.x;
            tdView.frame=tdRect;
            tdView.noticeLabel.text=@"使用签名按键签名!";
            [tdView.flagImage setImage:[UIImage imageNamed:@"warning.png"]];
            [cv addSubview:tdView];
            
            UIButton *signatureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [signatureBtn setBackgroundImage:[UIImage imageNamed:@"sigh_ecm"] forState:UIControlStateNormal];
            [signatureBtn setFrame:CGRectMake(CGRectGetMaxX(tdView.frame) + 6,CGRectGetMinY(tdView.frame) - 12, 32, 32)];
            [signatureBtn addTarget:self action:@selector(getSignature:) forControlEvents:UIControlEventTouchUpInside];
            [cv addSubview:signatureBtn];
            [signatureBtn setTag:currentImageViewIndex*100];
            currentImageViewIndex++;
            contentTotalHeight = CGRectGetMaxY(signatureBtn.frame) - CONTENT_TITLEHEIGHT;//加上了textView和button的高度
        }else{
            UIImage *image=[UIImage imageWithData:[NSData dataFromBase64String:e.value]];
            SKImageView *imageView=[[SKImageView alloc] initWithImage:image];
            imageView.base64String = e.value;
            CGRect imageRect = [self getImageViewSizeWithImageSize:image.size andLimitedWidth:VALUELABLE_WIDTH andLeftMargin:VALUELABLE_LEFT];
            [imageView setFrame:imageRect];
            [cv addSubview:imageView];
            nameLabelY=contentTotalHeight+CONTENT_TITLEHEIGHT+ (imageView.frame.size.height-NAMELABLE_HEIGHT)/2;
            contentTotalHeight+=imageView.frame.size.height;
        }
    }
    
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, nameLabelY, NAMELABLE_WIDTH, NAMELABLE_HEIGHT)];
    [nameLabel setText:[e.elementDict objectForKey:@"name"]];
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setTextColor:[UIColor blackColor]];
    [cv addSubview:nameLabel];
    
    
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
    if(imageHeight>limitedWidth)//图像高度大于右边控件宽度
    {
        if (imageHeight<imageWidth) //图像高度小于图像宽度
        {
            returnWidth=limitedWidth;
            returnHeight=limitedWidth*ratio;
            returnRect= CGRectMake(leftMargin, contentTotalHeight+CONTENT_TITLEHEIGHT+(limitedWidth-returnHeight)/2, returnWidth, returnHeight);
        }
        else                        //图像高度大于等于图像宽度
        {
            returnHeight=limitedWidth;
            returnWidth=limitedWidth/ratio;
            returnRect=CGRectMake(leftMargin+(limitedWidth-returnWidth)/2, contentTotalHeight+CONTENT_TITLEHEIGHT, returnWidth, returnHeight);
        }
    }
    else                            //图像高度小于等于右边控件宽度
    {
        if (imageHeight<imageWidth) //图像高度小于图像宽度
        {
            if (imageWidth>limitedWidth) //图像宽度大于右边控件宽度
            {
                returnWidth=limitedWidth;
                returnHeight=limitedWidth*ratio;
                returnRect= CGRectMake(leftMargin, contentTotalHeight+CONTENT_TITLEHEIGHT+(limitedWidth-returnHeight)/2, returnWidth, returnHeight);
            }
            else
            {
                returnWidth=imageWidth;
                returnHeight=imageHeight -10;
                returnRect= CGRectMake(leftMargin, contentTotalHeight+CONTENT_TITLEHEIGHT, returnWidth, returnHeight);
            }
        }
        else
        {
            returnWidth=imageWidth;
            returnHeight=imageHeight;
            returnRect= CGRectMake(leftMargin, contentTotalHeight+CONTENT_TITLEHEIGHT, returnWidth, returnHeight);
        }
    }
    return returnRect;
}

#pragma mark- 键盘show hide
-(void) keyboardWillShow:(NSNotification *)note
{
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect scrollViewFrame = mainScrollview.frame;
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    keyboardHeight = keyboardBounds.size.height;
    scrollViewFrame.size.height =[UIScreen mainScreen].bounds.size.height-44-20 - keyboardBounds.size.height-textToolBar.frame.size.height;
    HPGrowingTextView *textView = (HPGrowingTextView*)[saveTextViewArray objectAtIndex:currentTextViewindex];
    CGRect rect = [textView.superview convertRect:textView.frame toView:mainScrollview];
    rect.origin.y += 2;
    
    CGRect toolbarFrame=textToolBar.frame;
    toolbarFrame.origin.y = BottomY - keyboardHeight - 44;
    [self setToolBarItemEnable];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    [textToolBar setFrame:toolbarFrame];
    [mainScrollview setFrame:scrollViewFrame];
    [mainScrollview scrollRectToVisible:rect animated:YES];
    [UIView commitAnimations];
}

/**
 *  设置工具条的上一步下一步 是否可用
 */
-(void)setToolBarItemEnable
{
    [previousBtn setEnabled:currentTextViewindex > 0];
    [nextBtn setEnabled:currentTextViewindex < saveTextViewArray.count-1];
}

-(void) keyboardWillHide:(NSNotification *)note
{
    keyboardHeight = 0;
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect mainFrame = self.view.frame;
    mainFrame.origin.y=0;
    
    CGRect toolbarFrame=textToolBar.frame;
    toolbarFrame.origin.y=BottomY;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    self.view.frame = mainFrame;
    [mainScrollview setFrame:CGRectMake(0, TopY, 320, [UIScreen mainScreen].bounds.size.height-44-20-49)];
    [textToolBar setFrame:toolbarFrame];
    [UIView commitAnimations];
}

/**
 *  得到手写签名数据的通知后重新构造界面 显示签名图片
 *  该方法 暂时不用了
 *  @param note 通知 内包含签名的图片数据
 */
-(void)setSignature:(NSNotification *)note
{
    NSDictionary *dict=[note userInfo];
    UIImage *image=[dict objectForKey:@"image"];
    NSNumber *number=[dict objectForKey:@"tag"];
    NSInteger stag=[number integerValue];
    SKImageView *signatureImageView=(SKImageView *)[self.view viewWithTag:stag];
    NSData * imageData = UIImagePNGRepresentation(image);
    signatureImageView.base64String = [[imageData base64EncodedString] stringByReplacingOccurrencesOfString:@"&#13;" withString:@"-----"];
    
    [signatureImageView setFrame:CGRectMake(signatureImageView.frame.origin.x, signatureImageView.frame.origin.y, image.size.width, 40)];
    [signatureImageView setImage:image];
}

/**
 *  设置常用语通知处理函数
 *
 *  @param note 通知内包含常用语数据
 */
-(void)setCommonLanguage:(NSNotification *)note
{
    NSDictionary* dict = [note userInfo];
    NSString* key = [[dict allKeys] objectAtIndex:0];
    NSString *text=[NSString stringWithString:[dict objectForKey:key]];
    HPGrowingTextView *textV=(HPGrowingTextView *)[self.view viewWithTag:[key integerValue]];
    NSRange range=[text rangeOfString:@"**"];
    text=[text stringByReplacingOccurrencesOfString:@"**" withString:@""];
    [textV setText:text];
    range.length=0;
    [textV setSelectedRange:range];
    [textV becomeFirstResponder];
}


#pragma mark- HPGrowingTextView代理函数
/**
 *  当某个HPGrowingTextView 换行时整个界面元素需要下移
 *
 *  @param textView 需要换行的HPGrowingTextView
 *  @param diff     改变的高度
 */
-(void)setCustomFrame:(HPGrowingTextView *)textView andChangeHeight:(float)diff
{
    float ylocation = textView.frame.origin.y;
    for (UIView *v in textView.cv.subviews){
        if (v.frame.origin.y > ylocation){
            CGRect vRect=v.frame;
            vRect.origin.y-=diff/((v.tag == textView.tag) + 1);
            v.frame=vRect;
        }
    }
    
    CGRect cvrect = textView.cv.frame;
    cvrect.size.height-=diff;
    textView.cv.frame=cvrect;
    
    CGRect contentRect=contentView.frame;
    contentRect.size.height-=diff;
    contentView.frame=contentRect;
}

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    currentTextViewYlocation=growingTextView.yLocation;
    if ([saveTextViewArray containsObject:growingTextView])
    {
        currentTextViewindex = [saveTextViewArray indexOfObject:growingTextView];
        SKExtendTyped extendType= growingTextView.extendType;
        if ((growingTextView.isHadToBeFill||extendType==SKPhrase||extendType==SKSignature)&&growingTextView.textDownView==nil)
        {
            TextDownView *tdView=[[TextDownView alloc] init];
            CGRect tdRect=[tdView frame];
            tdRect.origin.y=CGRectGetMaxY(growingTextView.frame);
            tdRect.origin.x=CGRectGetMinX(growingTextView.frame);
            tdView.frame=tdRect;
            switch (extendType)
            {
                case SKSignature:
                    tdView.noticeLabel.text=@"使用签名按键签名";
                    break;
                case SKPhrase:
                    tdView.noticeLabel.text=@"可使用常用语";
                    break;
                default:
                    if (growingTextView.isHadToBeFill)
                    {
                        tdView.noticeLabel.text=@"此项为必填项!";
                    }
                    break;
            }
            [tdView.flagImage setImage:[UIImage imageNamed:@"warning.png"]];
            [growingTextView.cv addSubview:tdView];
            growingTextView.textDownView=tdView;
            
            
            if (!growingTextView.hasBtnDownside)
            {
                [mainScrollview setContentSize:CGSizeMake(mainScrollview.contentSize.width, mainScrollview.contentSize.height+tdRect.size.height)];
                float diff = tdRect.size.height;
                float ylocation = CGRectGetMinY(tdRect);
                for (UIView *v in growingTextView.cv.subviews)
                {
                    if (v.frame.origin.y > ylocation) //如果是在textView下面 则修改其位置
                    {
                        CGRect vRect=v.frame;
                        vRect.origin.y+=diff;
                        v.frame=vRect;
                    }
                }
                //设置整个contentView的高度
                CGRect contentRect=contentView.frame;
                contentRect.size.height+=diff;
                contentView.frame=contentRect;
                
                CGRect cvrect = growingTextView.cv.frame;
                cvrect.size.height+=diff;
                growingTextView.cv.frame=cvrect;
                
                //设置contentView种其他CustomView的Y轴位置
                for (UIView *v in contentView.subviews)
                {
                    float ylocation=v.frame.origin.y;
                    if (ylocation > growingTextView.cv.frame.origin.y)
                    {
                        CGRect vRect=v.frame;
                        vRect.origin.y+=diff;
                        v.frame=vRect;
                    }
                }
            }
        }
        else if(growingTextView.textDownView)
        {
            TextDownView *tdView=growingTextView.textDownView;
            switch (extendType)
            {
                case SKSignature:
                    tdView.noticeLabel.text=@"使用签名按键签名";
                    break;
                case SKPhrase:
                    tdView.noticeLabel.text=@"可使用常用语";
                    break;
                default:
                    if (growingTextView.isHadToBeFill)
                    {
                        tdView.noticeLabel.text=@"此项为必填项!";
                    }
                    break;
            }
            [tdView.flagImage setImage:[UIImage imageNamed:@"warning.png"]];
            [tdView.noticeLabel setTextColor:[UIColor colorWithRed:0/255.0  green:89.0/255.0 blue:175.0/255.0 alpha:1]];
        }
        
    }
    return YES;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    if ((int)diff == 0) return;
    [mainScrollview setContentSize:CGSizeMake(mainScrollview.contentSize.width, mainScrollview.contentSize.height-diff)];
    [self setCustomFrame:growingTextView andChangeHeight:diff];
    
    for (UIView *v in contentView.subviews)
    {
        float ylocation=v.frame.origin.y;
        if (ylocation > growingTextView.cv.frame.origin.y)
        {
            CGRect vRect=v.frame;
            vRect.origin.y-=diff;
            v.frame=vRect;
        }
    }
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    return YES;
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    if(growingTextView.isHadToBeFill)
    {
        [growingTextView.textDownView setHidden:NO];
        if (![growingTextView.text isEqualToString:@""])
        {
            //[growingTextView.textDownView setHidden:YES];
        }
        else
        {
            [growingTextView.textDownView.flagImage setImage:[UIImage imageNamed:@"error.png"]];
            [growingTextView.textDownView.noticeLabel setTextColor:[UIColor redColor]];
            [growingTextView.textDownView.noticeLabel setText:@"必须填写此项!"];
        }
    }
}

//添加监视通知
-(void)rigisterObbserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//销毁监视通知
-(void)removeoObb
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  点击工具条上的完成按钮 键盘消失
 */
-(void)doneTextEditing
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

/**
 *  根据HPGrowingTextView 设置mainscrollView的便宜位置
 *
 *  @param textView HPGrowingTextView
 */
-(void)setScrollViewOffsetWithTextView:(HPGrowingTextView *)textView
{
    if (textView.isForSignature)
    {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        if([UIScreen mainScreen].bounds.size.height>480)
        {
            [mainScrollview setContentOffset:CGPointMake(0, textView.yLocation-240-88) animated:YES];
        }
        else
        {
            [mainScrollview setContentOffset:CGPointMake(0, textView.yLocation-240) animated:YES];
        }
    }
    else
    {
        if (keyboardHeight==216.0)
        {
            if ([UIScreen mainScreen].bounds.size.height>480)
            {
                [mainScrollview setContentOffset:CGPointMake(0, currentTextViewYlocation-116) animated:YES];
            }
            else
            {
                [mainScrollview setContentOffset:CGPointMake(0, currentTextViewYlocation-36) animated:YES];
            }
            
        }
        else
        {
            if (IS_IPHONE_5)
            {
                [mainScrollview setContentOffset:CGPointMake(0, currentTextViewYlocation-80) animated:YES];
            }
            else
            {
                [mainScrollview setContentOffset:CGPointMake(0, currentTextViewYlocation) animated:YES];
            }
        }
    }
}

/**
 *  定位到需要填写的textView
 */
-(void)locateTextView
{
    if (saveTextViewArray.count > 0) {
        currentTextViewindex = currentTextViewindex >= saveTextViewArray.count-1 ? -1 :currentTextViewindex;
        currentTextViewindex++;
        HPGrowingTextView *textView = [saveTextViewArray objectAtIndex:currentTextViewindex];
        if (!textView.isForSignature)
        {
            [textView becomeFirstResponder];
        }
        else
        {
            currentTextViewYlocation=textView.yLocation;
        }
        [self setScrollViewOffsetWithTextView:textView];
        
    }
}

/**
 * 上一项
 */
-(void)previousText
{
    
    if (saveTextViewArray.count > 1)
    {
        currentTextViewindex--;
        HPGrowingTextView *textView = [saveTextViewArray objectAtIndex:currentTextViewindex];
        if (!textView.isForSignature)
        {
            [textView becomeFirstResponder];
        }
        else
        {
            //            HPGrowingTextView *lasttextView = [saveTextViewArray objectAtIndex:currentTextViewindex+1];
            //            if (lasttextView)
            //            {
            //                [lasttextView resignFirstResponder];
            //            } 收起键盘的代码
            
            currentTextViewYlocation=textView.yLocation;
        }
        [self setScrollViewOffsetWithTextView:textView];
    }
    [self setToolBarItemEnable];
}
/**
 *  下一项
 */
-(void)nextText
{
    if (saveTextViewArray.count > 1)
    {
        currentTextViewindex = currentTextViewindex >= saveTextViewArray.count-1 ? -1 :currentTextViewindex;
        currentTextViewindex++;
        HPGrowingTextView *textView = [saveTextViewArray objectAtIndex:currentTextViewindex];
        if (!textView.isForSignature)
        {
            [textView becomeFirstResponder];
        }
        else
        {
            currentTextViewYlocation=textView.yLocation;
        }
        [self setScrollViewOffsetWithTextView:textView];
        
    }
    [self setToolBarItemEnable];
}

/**
 *  获取历史办理项
 */
-(void)getHistory
{
    SKColumnDetailController *dc=[[SKColumnDetailController alloc] init];
    [dc setFlowInstanceID:[GTaskDetailInfo objectForKey:@"FLOWINSTANCEID"]];
    dc.isHistory=YES;
    [dc setTfrm:[GTaskDetailInfo objectForKey:@"TFRM"]];
    [self.navigationController pushViewController:dc animated:YES];
}

/**
 *  进入常用语界面
 *
 *  @param sender
 */
-(void)getPhrase:(UIButton*)sender
{
    SKCommonLanguageController *lc = [[SKCommonLanguageController alloc] init];
    lc.textViewKey=[NSString stringWithFormat:@"%d",(int)(sender.tag)];
    HPGrowingTextView *textV=(HPGrowingTextView *)[self.view viewWithTag:((UIButton *)sender).tag];
    lc.textViewText=textV.text;
    currentTextViewindex = [saveTextViewArray indexOfObject:textV];
    [self.navigationController pushViewController:lc animated:YES];
}

/**
 *  获取文字签名
 *
 *  @param sender
 */
-(void)getSignatureWithTextView:(id)sender
{
    HPGrowingTextView *textV=(HPGrowingTextView *)[self.view viewWithTag:((UIButton *)sender).tag];
    textV.isTextSignature = YES;//这里其实可以去掉 改掉以后
    if (![textV.text isEqualToString:@""]&&![textV.text isEqualToString:[APPUtils userName]])
    {
        [textV setText:[APPUtils userName]];
    }
    else if([textV.text isEqualToString:[APPUtils userName]])
    {
        [textV setText:@""];
    }
    else
    {
        [textV setText:[APPUtils userName]];
    }
    [textV setSigText:[APPUtils userUid]];
}

/**
 *  获取图片签名
 *
 *  @param sender
 */
-(void)getSignature:(id)sender
{
    NSInteger index=(((UIButton *)sender).tag/100)*1001;
    SKImageView *signatureImageView=(SKImageView *)[self.view viewWithTag:index];
    if (signatureImageView.image)
    {
        [signatureImageView setImage:nil];
        [signatureImageView.tdView setHidden:NO];
        return;
    }
    NSURL* signatureUrl = [DataServiceURLs getSignature:[APPUtils userUid] TFRM:GTaskDetailInfo[@"TFRM"] Style:@"0"];
    
    SKHTTPRequest *request = [SKHTTPRequest requestWithURL:signatureUrl];
    __weak SKHTTPRequest *req = request;
    [request setCompletionBlock:^{
        if (req.responseStatusCode == 500) {
            [BWStatusBarOverlay showErrorWithMessage:@"服务器网络故障!" duration:1 animated:1];
            return;
        }
        GDataXMLDocument* tempdoc = [[GDataXMLDocument alloc] initWithData:req.responseData encoding:NSUTF8StringEncoding error:0] ;
        NSError* error=nil;
        GDataXMLElement* element1 = (GDataXMLElement*)[[tempdoc nodesForXPath:@"//returncode" error:&error] objectAtIndex:0];
        if (error) {
            [BWStatusBarOverlay showErrorWithMessage:[error localizedDescription] duration:1 animated:1];
            return;
        }
        if (![[element1 stringValue] isEqualToString:@"OK"]) {
            [BWStatusBarOverlay showErrorWithMessage:[[element1 stringValue] substringFromIndex:6] duration:1 animated:1];
            return;
        }
        
        GDataXMLElement* element = (GDataXMLElement*)[[tempdoc nodesForXPath:@"//column" error:0] objectAtIndex:0];
        NSData* imageData = [NSData dataFromBase64String:[element stringValue]];
        UIImage *image=[[UIImage alloc] initWithData:imageData];
        [signatureImageView setImage:image];
        [signatureImageView setBase64String:[element stringValue]];
        [signatureImageView.cs setIsWritenColumns:YES];
        CGRect imageRect=signatureImageView.frame;
        imageRect.size.width=image.size.width;
        signatureImageView.frame=imageRect;
        [signatureImageView.tdView setHidden:YES];
    }];
    [request setFailedBlock:^{
        [BWStatusBarOverlay showMessage:req.errorinfo duration:1.5 animated:YES];
    }];
    [request startAsynchronous];
    
}

/**
 *  获取column详细
 *
 *  @param sender
 */
-(void)getColumnDetail:(id)sender
{
    SKColumnDetailController *dc=[[SKColumnDetailController alloc] init];
    [dc setFlowInstanceID:[GTaskDetailInfo objectForKey:@"FLOWINSTANCEID"]];
    if ([sender class] == [UITapGestureRecognizer class]) {
        UITapGestureRecognizer* gesture = (UITapGestureRecognizer*)sender;
        [dc setUniqueID:[DetailIDArray objectAtIndex:gesture.view.tag]];
    }else{
        UIButton* button = (UIButton*)sender;
        [dc setUniqueID:[DetailIDArray objectAtIndex:button.tag]];
    }
    [dc setFrom:[GTaskDetailInfo objectForKey:@"TFRM"]];
    [self.navigationController pushViewController:dc animated:YES];
}

/**
 *  消除textView中包含的图片签名的textVIew  因为签名图片是绑定了一个textView 的
 *  isForSignature 专门指图片签名 没有指文字签名
 *  @return 返回一个不含图片签名的textview
 */
-(NSArray *)createFileterArray
{
    NSMutableArray *indexArray=[[NSMutableArray alloc] init];
    NSMutableArray *copysaveTextViewArray=[[NSMutableArray alloc] initWithArray:saveTextViewArray];
    for (int i=0;i<copysaveTextViewArray.count;i++)
    {
        HPGrowingTextView *textView =[copysaveTextViewArray objectAtIndex:i];
        if (textView.isForSignature) {
            [indexArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    for (NSNumber *index in indexArray)
    {
        [copysaveTextViewArray removeObjectAtIndex:index.integerValue];
    }
    NSArray *array=[NSArray arrayWithArray:copysaveTextViewArray];
    return array;
}

/**
 *  保存
 */
-(void)save
{
    NSArray *fileterArray=[self createFileterArray];
    for (int i=0;i<fileterArray.count;i++)
    {
        HPGrowingTextView *textView =[fileterArray objectAtIndex:i];
        //判断是否有没有填写的选项
        if (textView.isHadToBeFill&&[textView.text isEqualToString:@""])
        {
            [BWStatusBarOverlay showMessage:[NSString stringWithFormat:@"请填写%@",textView.nameLabelText] duration:2 animated:YES];
            if (!textView.isForSignature)//如果没有完成的选项 不是用来签名的
            {
                if (textView.isTextSignature) {
                    currentTextViewYlocation=textView.yLocation - 216;
                }else{
                    [textView becomeFirstResponder];
                }
            }else{
                currentTextViewYlocation=textView.yLocation;
            }
            [self setScrollViewOffsetWithTextView:textView];
            return;
        }
        
        if (textView.text.length || textView.isTextSignature) {
            if (textView.isTextSignature) {//文字签名
                [textView.node setStringValue:[APPUtils userUid]];
            }else{
                [textView.node setStringValue:textView.text];
            }
        }
        textView.cs.isWritenColumns = YES;
        
    }
    
    /**
     *  图片签名xml 的构造
     */
    if (signatureImageViewArray.count>0)
    {
        for (int i=0;i<signatureImageViewArray.count;i++)
        {
            SKImageView *signatureImageView=[signatureImageViewArray objectAtIndex:i];
            if (signatureImageView.textView.isHadToBeFill&&signatureImageView.image==nil)
            {
                [BWStatusBarOverlay showMessage:[NSString stringWithFormat:@"请填写%@",signatureImageView.nameLabelText] duration:2 animated:YES];
                
                currentTextViewYlocation=signatureImageView.textView.yLocation;
                if([UIScreen mainScreen].bounds.size.height>480)
                {
                    [mainScrollview setContentOffset:CGPointMake(0, currentTextViewYlocation-240-88) animated:YES];
                }
                else
                {
                    [mainScrollview setContentOffset:CGPointMake(0, currentTextViewYlocation-240) animated:YES];
                }
                
                [signatureImageView.tdView setHidden:NO];
                signatureImageView.tdView.noticeLabel.text=@"此项为必填项!";
                [signatureImageView.tdView.noticeLabel setTextColor:[UIColor redColor]];
                [signatureImageView.tdView.flagImage setImage:[UIImage imageNamed:@"error.png"]];
                return;
            }
            [signatureImageView.base64String stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [signatureImageView.xmlnode setStringValue:signatureImageView.base64String];
            [signatureImageView.cs setIsWritenColumns:YES];//这里还待测试
        }
    }
    
    NSString* xmlstring = @"<root>";
    for (columns* cs in _aBusiness.columnsArray) {
        if (cs.isWritenColumns) {
            xmlstring = [xmlstring stringByAppendingString:[cs.csnode XMLStringWithOptions:DDXMLNodePrettyPrint]];
        }
    }
    
    xmlstring = [xmlstring stringByAppendingString:@"</root>"];
    //NSLog(@"%@",xmlstring);
    [self saveWithSaveXml:xmlstring];
}


/**
 *  提交填写的数据
 *
 *  @param saveXML xmlstring
 */
-(void)saveWithSaveXml:(NSString *)saveXML
{
    NSURL*url = [DataServiceURLs saveData];
    SKFormDataRequest *saveDatarequest = [SKFormDataRequest requestWithURL:url];
    [saveDatarequest setTimeOutSeconds:15];
    [saveDatarequest setPostValue:[APPUtils userUid] forKey:@"userid"];
    [saveDatarequest setPostValue:[GTaskDetailInfo objectForKey:@"TFRM"]forKey:@"from"];
    [saveDatarequest setPostValue:[GTaskDetailInfo objectForKey:@"AID"] forKey:@"workitemid"];
    [saveDatarequest setPostValue:saveXML forKey:@"savexml"];
    [saveDatarequest setStartedBlock:^{
        [myToolBar.thirdButton setEnabled:NO];
    }];
    __weak  SKFormDataRequest * req = saveDatarequest;
    [saveDatarequest setCompletionBlock:^{
        NSLog(@"setCompletionBlock %@",req.responseString);
        if (req.responseStatusCode == 500) {
            [BWStatusBarOverlay showMessage:@"服务器网络故障!" duration:1.5 animated:YES];
            return;
        }
        if ([[req responseString] isEqualToString:@"OK"]) {
            [BWStatusBarOverlay showSuccessWithMessage:@"保存成功" duration:1 animated:1];
            if (isBack)
            {
                [self backtoItem];
            }
            else
            {
                SKNextBranchesController* nb = [[SKNextBranchesController alloc] initWithDictionary:GTaskDetailInfo];
                [self.navigationController pushViewController:nb animated:YES];
            }
        }else{
            [BWStatusBarOverlay showMessage:@"保存失败,请检查网络" duration:1.5 animated:YES];
            if (isBack)
            {
                [self backtoItem];
            }
        }
        
        
        [myToolBar.thirdButton setEnabled:YES];
    }];
    [saveDatarequest setFailedBlock:^{
        [myToolBar.thirdButton setEnabled:YES];
        [BWStatusBarOverlay showMessage:req.errorinfo duration:1.5 animated:YES];
    }];
    [saveDatarequest startAsynchronous];
}

/**
 *  获取下一个流程分支
 *
 *  @param sender
 */
-(void)getNextBranches:(id)sender
{
    [self save];
}
@end
