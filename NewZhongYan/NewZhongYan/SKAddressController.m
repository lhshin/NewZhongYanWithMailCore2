//
//  SKAddressController.m
//  NewZhongYan
//
//  Created by lilin on 13-10-30.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKAddressController.h"
#import "SKUnitCell.h"
#import "NSString+hnzy.h"
#import "SKViewController.h"
#import "SKEdetailInfoController.h"
#define USE_ACTIVITY    1	// use a xib file defining the cell
#define USE_REMENU      0

#define ROOTBUTTON 1
#define ROOTITEMS -1
#define VIEWCOUNT  1
#define ORGBARHEIGHT 46

#define OSKSHeight [UIScreen mainScreen].bounds.size.height-20 - 44 - 49- 200 + 4
#define OHKHHeight [UIScreen mainScreen].bounds.size.height-20 - 44 - 49
#define OSKHHeight [UIScreen mainScreen].bounds.size.height-20 - 44 - 49 - ORGBARHEIGHT
#define OHKSHeight [UIScreen mainScreen].bounds.size.height-20 - 44 - 200
@interface SKAddressController ()
{
    BOOL isHome;                //检测食补在主界面上                    以用来决定是不是要显示部门结构模块
    BOOL isDataRefersh;         //数据是不是已经刷新过了
    BOOL isInsearch;            //判断是不是在查询的界面
    
    NSInteger                   _currentItem;
    NSString                    *_currentPDPID;
    
    //创建的新的button的背景图片
    UIImage*  NImage;
    //以前的button要修改的颜色
    UIImage*  foldNImage;
    //back的button要修改的颜色
    UIImage*  foldBImage;
    __weak IBOutlet UIButton *titltButton;
    
    UIActionSheet* actionSheet;
}
@end

@implementation SKAddressController
@synthesize tmpCell;
@synthesize tmpMailCell;
@synthesize isMail = _isMail;
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


- (IBAction)help:(id)sender {
    UIImageView* helpImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [helpImage setImage:[UIImage imageNamed:IS_IPHONE_5? @"iphone5_help_addressbook" : @"iphone4_help_addressbook"]];
    [helpImage setUserInteractionEnabled:YES];
    [helpImage setTag:1111];
    [self.view.window addSubview:helpImage];
    
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapForHelpImage:)];
    [helpImage addGestureRecognizer:tapGes];
    [helpImage fallIn:.4 delegate:nil completeBlock:^{
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }];
}

-(void)initData
{
    //创建的新的button的背景图片
    NImage = [UIImage imageNamed:@"org_info_nodisplayed.png"];
    NImage = [NImage cropImageToRect:CGRectMake(2, 2, NImage.size.width -3, NImage.size.height -3)];
    NImage = [NImage stretchableImageWithLeftCapWidth:35 topCapHeight:0] ;
    
    //以前的button要修改的颜色
    foldNImage = [UIImage imageNamed:@"org_info_unfold.png"];
    foldNImage = [foldNImage cropImageToRect:CGRectMake(2, 2, foldNImage.size.width -3, foldNImage.size.height -3)];
    foldNImage = [foldNImage stretchableImageWithLeftCapWidth:35 topCapHeight:0];
    
    //back的button要修改的颜色
    foldBImage = [UIImage imageNamed:@"org_info_back.png"];
    foldBImage = [foldBImage cropImageToRect:CGRectMake(2, 2, foldBImage.size.width -3, foldBImage.size.height -3)];
    foldBImage = [foldBImage stretchableImageWithLeftCapWidth:35 topCapHeight:0];
    
    selectedEmployees = nil;
    _dataSITems = nil;
    _dataEItems    =  [[NSMutableArray alloc] init];
    _dataUItems    =  [[NSMutableArray alloc] init];
    _dataDPIDs     =  [[NSMutableArray alloc] init];
    _dataUShowed   =  [[NSMutableArray alloc] init];
    _dataEShowed   =  [[NSMutableArray alloc] init];
    _dataTitles    =  [[NSMutableArray alloc] init];
    isHome = YES;
    isInsearch = NO;
    _currentItem = ROOTITEMS;
    _currentPDPID = @"";
    
    cellNib = [UINib nibWithNibName:@"SKEmployeeCell" bundle:nil];
    mailCellNib = [UINib nibWithNibName:@"SKMailEmployeeCell" bundle:nil];
    [dataTable setHeaderOnly:YES];
}

//修改OrganizationBar 上面的状态
-(void)rescaleOrganizationBar
{
    if (_dataUShowed.count > 2) {
        float distance = foldBImage.size.width  - self.controlButton.frame.size.width;
        [self.showButton    setFrame:CGRectMake(self.showButton.frame.origin.x + distance,
                                                self.showButton.frame.origin.y,
                                                self.showButton.frame.size.width - distance,
                                                self.showButton.frame.size.height)];
        [self.controlButton setBackgroundImage:foldBImage forState:UIControlStateNormal];
        [self.controlButton setBackgroundImage:foldBImage forState:UIControlStateHighlighted];
        [self.controlButton setFrame:CGRectMake(50, 0, foldBImage.size.width, 47)];
        [self.controlButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
    }else{
        NSString* title = self.showButton.titleLabel.text;
        CGFloat width = [title sizeWithFont:[UIFont systemFontOfSize:14]].width;
        [self.controlButton setBackgroundImage:foldNImage forState:UIControlStateNormal];
        [self.controlButton setBackgroundImage:foldNImage forState:UIControlStateHighlighted];
        [self.controlButton setTitle:title forState:UIControlStateNormal];
        [self.controlButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.controlButton setFrame:CGRectMake(50, 0,width + 35, 47)];
        [self.controlButton setHidden:NO];
        [self.showButton    setFrame:CGRectMake(width + 85, 0, 320 - width - 85, 47)];
    }
}

-(void)rootButtonPressed:(UIButton*)btn
{
    _currentPDPID = @"";
    isHome = YES;
    [_dataUItems setArray:[_dataUShowed objectAtIndex:0]];
    [_dataEItems setArray:[_dataEShowed objectAtIndex:0]];
    [_dataUShowed removeAllObjects];
    [_dataEShowed removeAllObjects];
    [_dataTitles  removeAllObjects];
    [_dataDPIDs   removeAllObjects];
    [dataTable reloadData];
    
    //界面
    [self.controlButton setHidden:YES];
    [dataTable    setFrame:CGRectMake(0,TopY, 320, keyboard.showed ? OHKSHeight : OHKHHeight)];
    [self.showButton    setFrame:CGRectMake(50, 0, 270, 47)];
}

-(void)controlButtonPressed:(UIButton*)btn
{
    [_dataUItems setArray:[_dataUShowed lastObject]];
    [_dataEItems setArray:[_dataEShowed lastObject]];
    [_dataTitles  removeLastObject];
    [_dataDPIDs   removeLastObject];
    [_dataUShowed removeLastObject];
    [_dataEShowed removeLastObject];
    
    _currentPDPID = [_dataDPIDs lastObject];
    [self.showButton setTitle:[_dataTitles lastObject] forState:UIControlStateNormal];
    
    if (_dataUShowed.count == 2) {          //此时要将back上面显示汉字了 而不是显示箭头了
        NSString* title = [_dataTitles objectAtIndex:0];
        CGFloat width = [title sizeWithFont:[UIFont systemFontOfSize:14]].width;
        [self.controlButton setBackgroundImage:foldNImage forState:UIControlStateNormal];
        [self.controlButton setBackgroundImage:foldNImage forState:UIControlStateHighlighted];
        [self.controlButton setTitle:title forState:UIControlStateNormal];
        [self.controlButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.controlButton setFrame:CGRectMake(50, 0,width + 35, 47)];
        [self.controlButton setHidden:NO];
        [self.showButton    setFrame:CGRectMake(width + 85, 0, 320 - width - 85, 47)];
    }
    if (_dataUShowed.count == 1) {          //此时要隐藏controlButton 且要修改frame了
        [self.controlButton setHidden:YES];
        [self.showButton setFrame:CGRectMake(50, 0, 270, 47)];
    }
    [dataTable reloadData];
}

-(void)createOrganizationBar
{
    //背景
    [orgazationBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"org_position_bg.png"]]];
    //根
    UIButton* rootButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* rootNImage = [UIImage imageNamed:@"org_position_info_root.png"];
    [rootButton setBackgroundImage:rootNImage forState:UIControlStateNormal];
    [rootButton setBackgroundImage:rootNImage forState:UIControlStateHighlighted];
    [rootButton setFrame:CGRectMake(0, 0,50,47)];
    [rootButton addTarget:self action:@selector(rootButtonPressed:)forControlEvents:UIControlEventTouchUpInside];
    [orgazationBar addSubview:rootButton];
    
    //控制
    self.controlButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.controlButton setTitleEdgeInsets:UIEdgeInsetsMake(0,35, 0, 0)];
    [self.controlButton.titleLabel setFont:[UIFont systemFontOfSize: 14.0]];
    [self.controlButton addTarget:self action:@selector(controlButtonPressed:)forControlEvents:UIControlEventTouchUpInside];
    [orgazationBar addSubview:self.controlButton];
    
    //展示
    self.showButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showButton setFrame:CGRectMake(50, 0, 320 - 50, 47)];
    [self.showButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.showButton setTitleEdgeInsets:UIEdgeInsetsMake(0,30, 0, 0)];
    [self.showButton.titleLabel setFont:[UIFont systemFontOfSize: 14.0]];
    [self.showButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.showButton setBackgroundImage:NImage forState:UIControlStateNormal];
    [self.showButton setBackgroundImage:NImage forState:UIControlStateHighlighted];
    [self.showButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [orgazationBar addSubview:self.showButton];
}

-(void)search:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        [dataTable setFrame:CGRectMake(0,
                                            isHome ? TopY + 0: TopY + 46,
                                            320,
                                            isHome ? OHKSHeight :OSKSHeight)];
        if (IS_IOS7) {
            [keyboard.view setFrame:CGRectMake(0,CGRectGetMaxY(toolView.frame) - 200, 320, 200)];
        }else{
            [keyboard.view setFrame:CGRectMake(0,CGRectGetMaxY(toolView.frame) - 200, 320, 200)];
        }
    } completion:^(BOOL completed){
        keyboard.showed = YES;
    }];
}
- (IBAction)selectType:(UIButton *)sender
{
#if USE_REMENU
    
#elif USE_ACTIVITY
    actionSheet = [[UIActionSheet alloc] initWithTitle:@"我的通讯录"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"组织",@"本部门",@"收藏",nil];
    actionSheet.tag = 10001;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
#endif
    
}

#pragma mark -Actionsheet delegate
-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:0];
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}


- (void)actionSheet:(UIActionSheet *)as clickedButtonAtIndex:(NSInteger)anIndex
{
    if (as.tag  == 10001) {
        if (anIndex == currentindex) {
            return;
        }
        
        if (anIndex) {
            [dataTable setFrame:CGRectMake(0, TopY, 320, OHKHHeight)];
        }
        switch (anIndex) {
            case 0:
            {
                [titltButton setTitle:@"组织" forState:UIControlStateNormal];
                [self dataFromDBForRootItems];
                break;
            }
            case 1:
            {
                [titltButton setTitle:@"本部门" forState:UIControlStateNormal];
                [self loadDataFromTable];
                break;
            }
            case 2:
            {
                [titltButton setTitle:@"收藏" forState:UIControlStateNormal];
                [self getStoredEmployeeFromTable];
                break;
            }
            default:
                break;
        }
        currentindex = anIndex;
        [as setDelegate:nil];
        
    }else{
        if (0 == anIndex) {
            NSString* index = [[_dataEItems objectAtIndex:actionSheet.tag] objectForKey:@"id"];
            [_dataEItems removeObjectAtIndex:as.tag];
            [dataTable reloadData];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString* updatesql = [NSString stringWithFormat:@"UPDATE T_EMPLOYEE SET STORED = 0 where id  = %@;",index];
                [[DBQueue sharedbQueue] updateDataTotableWithSQL:updatesql];
            });
        }
    }
}


-(void)createToolBar
{
    SKToolBar* myToolBar = [[SKToolBar alloc] initWithFrame:CGRectMake(0, 0, 320, 49)  FirstTarget:self FirstAction:@selector(search:)
                                               SecondTarget:dataTable SecondAction:@selector(launchRefreshing)];
    [toolView addSubview:myToolBar];
}

-(void)createTableView
{
    CGRect rect = CGRectMake(0, TopY, 320, OHKHHeight);
    dataTable = [[PullingRefreshTableView alloc] initWithFrame:rect pullingDelegate:self];
    if (_isMail) {
         [dataTable setAllowsMultipleSelection:YES];
    }
    [dataTable setDelegate:self];
    [dataTable setDataSource:self];
    [dataTable setHeaderOnly:YES];
    [self.view addSubview:dataTable];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gestureRecognizer locationInView:dataTable];
        NSIndexPath *indexPath = [dataTable  indexPathForRowAtPoint:point];
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"编辑收藏列表"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"取消收藏"
                                                        otherButtonTitles:nil,nil];
        actionSheet.tag = indexPath.row;
        actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

-(void)getStoredEmployeeFromTable
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* sql =[NSString stringWithFormat:
                        @"SELECT E.*,U.CNAME UCNAME,U.PNAME,U.PDPID\
                        FROM T_EMPLOYEE E LEFT JOIN T_UNIT U\
                        ON E.DPID = U.DPID\
                        WHERE E.STORED = 1\
                        AND E.ENABLED = 1\
                        ORDER BY E.SORTNO;"];
        [_dataEItems setArray:[[DBQueue sharedbQueue] recordFromTableBySQL:sql]];
        [_dataUItems removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [dataTable reloadData];
        });
    });
}

-(void)loadDataFromTable
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* sql;
        if(1){
            sql =[NSString stringWithFormat:
                  @"SELECT E.*,U.CNAME UCNAME,U.PNAME,U.PDPID\
                  FROM T_EMPLOYEE E LEFT JOIN T_UNIT U\
                  ON E.DPID = U.DPID\
                  WHERE U.DPID = %@\
                  AND E.ENABLED = 1\
                  order by E.SORTNO;",[APPUtils userDepartmentID]];
        }else{
            sql =[NSString stringWithFormat:
                  @"SELECT E.*,U.CNAME UCNAME,U.PNAME,U.PDPID\
                  FROM S_EMPLOYEE E LEFT JOIN T_UNIT U\
                  ON E.DPID = U.DPID\
                  WHERE U.DPID = %@\
                  AND E.ENABLED = 1\
                  order by E.SORTNO;",[APPUtils userDepartmentID]];
        }
        if (!_dataSITems) {
            _dataSITems = [[NSMutableArray alloc] init];
        }
        [_dataEItems setArray:[[DBQueue sharedbQueue] recordFromTableBySQL:sql]];
        [_dataUItems removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [dataTable reloadData];
        });
    });
}

#pragma mark - 数据库的操作
//获取部门名称
-(void)getDNameFromDbWithPOID:(NSString*)poid
{
    //取本部门下的子部门
    NSString* querySql = [NSString stringWithFormat:
                          @"SELECT u.DPID,u.CNAME,u.PDPID\
                          FROM T_UNIT u LEFT JOIN T_ORGANIZATIONAL o\
                          ON u.DPID = o.OID\
                          WHERE o.POID = '%@'\
                          AND o.LTYPE = 0\
                          AND u.ENABLED = 1\
                          ORDER BY o.SORTNO;",poid];
    [_dataUItems setArray:[[DBQueue sharedbQueue] recordFromTableBySQL:querySql]];
    NSString*  sql =[NSString stringWithFormat:
                     @"SELECT distinct E.id,E.UID,E.CNAME,E.MOBILE,E.EMAIL,E.STORED,E.MOBILE,E.SHORTPHONE,E.TELEPHONE,E.TNAME,E.OFFICEADDRESS,U.CNAME UCNAME,U.PNAME,U.PDPID\
                     FROM T_UNIT U ,T_EMPLOYEE E ,T_ORGANIZATIONAL O\
                     WHERE  O.POID =  U.DPID\
                     AND E.UID = O.OID\
                     AND O.LTYPE = 1\
                     AND E.ENABLED = 1\
                     AND O.ENABLED = 1\
                     AND U.DPID = '%@'\
                     ORDER BY CASE WHEN E.sortno is null THEN 1 ELSE 0 END,E.SORTNO,E.FNAME",poid];
    [_dataEItems setArray:[[DBQueue sharedbQueue] recordFromTableBySQL:sql]];
}

-(void)dataFromDBForRootItems
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* querySql = [NSString stringWithFormat:
                              @"SELECT u.DPID,u.CNAME,u.PDPID FROM T_UNIT u , T_ORGANIZATIONAL o\
                              WHERE u.DPID = o.OID\
                              AND o.POID = '%@'\
                              AND o.LTYPE = 0\
                              AND u.ENABLED = 1\
                              ORDER BY o.SORTNO,u.FNAME;",@"43"];
        [_dataUItems setArray:[[DBQueue sharedbQueue] recordFromTableBySQL:querySql]];
        [_dataUItems addObjectsFromArray:[[DBQueue sharedbQueue] recordFromTableBySQL:@"SELECT distinct DPID,CNAME FROM T_UNIT WHERE DPID = 99"]];
        [_dataEItems removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [dataTable reloadData];
        });
    });
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)chooseDone
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:selectedEmployees,@"employee", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EmailContact"
                                                        object:0
                                                      userInfo:dic];
    SKViewController* controller = [APPUtils AppRootViewController];
    [controller.navigationController popViewControllerAnimated:YES];
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
    [self createOrganizationBar];
    [self createTableView];
    [self createToolBar];
    [self dataFromDBForRootItems];
    
    if (_isMail)
    {
        if (System_Version_Small_Than_(7)) {
            UIButton * doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [doneBtn setFrame:CGRectMake(0, 0, 50, 30)];
            [doneBtn setImage:Image(@"btn_done") forState:UIControlStateNormal];
            [doneBtn addTarget:self action:@selector(chooseDone) forControlEvents:UIControlEventTouchUpInside];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
        }else{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(chooseDone)];
        }
        
        selectedEmployees=[[NSMutableArray alloc] init];
        self.navigationItem.titleView = nil;
        self.navigationItem.title = @"请选择联系人";
    }
    
    keyboard = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKCKeyBoards"];
    [keyboard.view setFrame:CGRectMake(0,BottomY, 320, 200)];
    [keyboard setDelegate:self];
    [self.view addSubview:keyboard.view];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"storeChanged" object:0 queue:0 usingBlock:^(NSNotification* note){
        [dataTable reloadData];
    }];
}

#pragma mark - SKCKeyBoards delegate
-(void)textDidChanged:(NSString *)text
{
    if (currentindex == 0) {
        if (text != nil && [text length] != 0){
            NSString* sql;
            NSString* PDPIDCondition;
            if (_currentPDPID && _currentPDPID.length > 0)
                PDPIDCondition = [NSString stringWithFormat:@"and U.PDPID LIKE '%%/%@/%%'",_currentPDPID];
            else
                PDPIDCondition = @"";
            if ([text characterAtIndex:0] == '0' || [text characterAtIndex:0] == '1') {
                sql = [NSString stringWithFormat:
                       @"SELECT E.id,E.UID,E.CNAME,E.MOBILE,E.EMAIL,E.STORED,E.MOBILE,E.SHORTPHONE,E.TELEPHONE,E.TNAME,E.OFFICEADDRESS,U.CNAME UCNAME,U.PNAME,U.PDPID\
                       FROM T_EMPLOYEE E left join T_UNIT U \
                       on E.DPID = U.DPID \
                       where E.ENABLED = 1\
                       and (E.MOBILE like '%@%%' or E.SHORTPHONE like '%@%%') %@\
                       order by E.SORTNO limit 30;",text,text,PDPIDCondition];
            }else{
                sql = [NSString stringWithFormat:
                       @"SELECT  E.id,E.UID,E.CNAME,E.MOBILE,E.EMAIL,E.STORED,E.MOBILE,E.SHORTPHONE,E.TELEPHONE,E.TNAME,E.OFFICEADDRESS,U.CNAME UCNAME,U.PNAME,U.PDPID\
                       FROM T_EMPLOYEE E,T_UNIT U ,T_ORGANIZATIONAL O\
                       where E.UID = O.OID\
                       AND U.DPID = O.POID \
                       AND E.dpid = U.DPID\
                       and E.ENABLED = 1\
                       and U.ENABLED = 1\
                       and (E.SNUM like '%@%%' or E.FNUM like '%@%%') %@\
                       order by E.SORTNO limit 30;",text,text,PDPIDCondition];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [_dataUItems removeAllObjects];
                [_dataEItems setArray:[[DBQueue sharedbQueue] recordFromTableBySQL:sql]];
                if ([text characterAtIndex:0] == '6') {
                    NSString* snumsql = [NSString stringWithFormat:
                                         @"SELECT E.id,E.UID,E.CNAME,E.MOBILE,E.EMAIL,E.STORED,E.MOBILE,E.SHORTPHONE,E.TELEPHONE,E.TNAME,E.OFFICEADDRESS,U.CNAME UCNAME,U.PNAME,U.PDPID\
                                         FROM T_EMPLOYEE E left join T_UNIT U \
                                         on E.DPID = U.DPID \
                                         where E.ENABLED = 1\
                                         and E.SHORTPHONE like '%@%%' %@\
                                         order by E.SORTNO limit 30;",text,PDPIDCondition];
                    [_dataEItems addObjectsFromArray:[[DBQueue sharedbQueue] recordFromTableBySQL:snumsql]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [dataTable reloadData];
                });
            });
        }else{
            if (isHome) {
                [self dataFromDBForRootItems];
            }else{
                [self getDNameFromDbWithPOID:_currentPDPID];
                [dataTable reloadData];
            }
        }
    }else if(currentindex == 1){
        if (text != nil && [text length] != 0) {
            NSString* sql;
            if ([text characterAtIndex:0] == '0' || [text characterAtIndex:0] == '1') {
                sql =[NSString stringWithFormat:
                      @"SELECT E.*,U.CNAME UCNAME,U.PNAME,U.PDPID\
                      FROM T_EMPLOYEE E LEFT JOIN T_UNIT U\
                      ON E.DPID = U.DPID\
                      WHERE (U.DPID = %@\
                      AND E.ENABLED = 1\
                      and E.MOBILE like '%%%@%%');",[APPUtils userDepartmentID],text];
            }else{
                sql =[NSString stringWithFormat:
                      @"SELECT E.*,U.CNAME UCNAME,U.PNAME,U.PDPID\
                      FROM T_EMPLOYEE E,T_UNIT U ,T_ORGANIZATIONAL O\
                      where E.UID = O.OID AND U.DPID = O.POID \
                      AND U.DPID = %@\
                      AND E.ENABLED = 1\
                      and (E.SNUM like '%@%%' or E.FNUM like '%@%%');",[APPUtils userDepartmentID],text,text];
            }
            [_dataUItems removeAllObjects];
            [_dataEItems setArray:[[DBQueue sharedbQueue] recordFromTableBySQL:sql]];
            [dataTable reloadData];
        }else{
            [self loadDataFromTable];
        }
    } else{
        
    }
    
}

-(void)textDidHided
{
    [dataTable setFrame:CGRectMake(0,
                                        isHome ? TopY + 0: TopY + 46,
                                        320,
                                        isHome ? OHKHHeight:OSKHHeight)];
    [UIView animateWithDuration:0.3 animations:^{
        [keyboard.view setFrame:CGRectMake(0, CGRectGetMaxY(toolView.frame), 320, 200)];
    } completion:^(BOOL finished){
    }];
}


#pragma mark - PullingRefreshTableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [dataTable tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [dataTable tableViewDidEndDragging:scrollView];
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedEmployee] delegate:self];
    [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedOranizational] delegate:self];
    [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedUnit] delegate:self];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0){
        if ([_dataUItems count] == 0 ) return .0f;
        else return 20;
    }else{
        if ([_dataEItems count] == 0 ) return .0f;
        else return 20;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
    label.backgroundColor = COLOR(245, 245, 245);
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15];
    if (section == 0){
        //if ([_dataUItems count] > 0 ) label.text =  @"  下属部门";
        if ([_dataUItems count] > 0 ) label.text =  @"  所属部门";
        else return nil;
    }else{
        //if ([_dataEItems count] > 0 ) label.text =  @"  下属员工";
        if ([_dataEItems count] > 0 ) label.text =  @"  所属人员";
        else  return nil;
    }
    return label;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return _dataUItems.count;
    }else{
        return _dataEItems.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"UnitCell";
        SKUnitCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[SKUnitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.titleLabel.text = [[_dataUItems objectAtIndex:indexPath.row] objectForKey:@"CNAME"];
        return cell;
    }else{
        if (_isMail)
        {
            static NSString *EIdentifier = @"mailEmployeeCell";
            SKMailEmployeeCell *cell = (SKMailEmployeeCell *)[tableView dequeueReusableCellWithIdentifier:EIdentifier];
            if (!cell) {
                [mailCellNib instantiateWithOwner:self options:nil];
                cell = tmpMailCell;tmpMailCell = nil;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            [cell setEmployee:_dataEItems[indexPath.row]];

            return cell;
        }
        else
        {
            static NSString *EIdentifier = @"employeeCell";
            SKEmployeeCell *cell = (SKEmployeeCell *)[tableView dequeueReusableCellWithIdentifier:EIdentifier];
            if (!cell) {
                [cellNib instantiateWithOwner:self options:nil];
                cell = tmpCell;tmpCell = nil;
            }
            [cell setEmployee:_dataEItems[indexPath.row]];
            if (currentindex == 2) {
                UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
                longPressReger.minimumPressDuration = 0.3;
                [cell addGestureRecognizer:longPressReger];
            }
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44.;
    }else{
        return 75.;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//部门
        isHome = NO;
        
        [dataTable setFrame:CGRectMake(0,(46 + TopY), 320,keyboard.showed ? OSKSHeight : OSKHHeight)];
        [_dataUShowed addObject:[NSArray arrayWithArray:_dataUItems]];
        [_dataEShowed addObject:[NSArray arrayWithArray:_dataEItems]];
        if (_dataUShowed.count >= 2)
        {
            [self rescaleOrganizationBar];
        }
        [_dataDPIDs  addObject:[[_dataUItems objectAtIndex:indexPath.row] objectForKey:@"DPID"]];
        [_dataTitles addObject:[[_dataUItems objectAtIndex:indexPath.row] objectForKey:@"CNAME"]];
        
        [self.showButton setTitle:[[_dataUItems objectAtIndex:indexPath.row] objectForKey:@"CNAME"] forState:UIControlStateNormal];
        _currentPDPID = [[_dataUItems objectAtIndex:indexPath.row] objectForKey:@"DPID"];
        [self getDNameFromDbWithPOID:_currentPDPID];
        [dataTable reloadData];
    }else{
        if (_isMail){
            [selectedEmployees addObject:[_dataEItems objectAtIndex:indexPath.row]];
        }else{
            [self performSegueWithIdentifier:@"EDetail" sender:self];
        }
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        if (_isMail) {
            [selectedEmployees removeObject:[_dataEItems objectAtIndex:indexPath.row]];
        }
    }
}
#pragma mark - 数据代理函数
-(void)didBeginSynData:(LocalDataMeta *)metaData
{
}

-(void)didCompleteSynData:(LocalDataMeta *)metaData
{
    if ([metaData.dataCode isEqualToString:@"employee"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [BWStatusBarOverlay showSuccessWithMessage:@"通讯录同步完成" duration:2 animated:YES];
            [dataTable tableViewDidFinishedLoading];
        });
    }
}

-(void)didCompleteSynData:(NSString *)datacode SV:(int)sv SC:(int)sc LV:(int)lv
{
}

-(void)didEndSynData:(LocalDataMeta *)metaData
{
}

-(void)didCancelSynData:(LocalDataMeta *)metaData
{
    
}

-(void)didErrorSynData:(LocalDataMeta *)metaData Reason:(NSString *)errorinfo
{
    if ([metaData.dataCode isEqualToString:@"employee"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [BWStatusBarOverlay showSuccessWithMessage:errorinfo duration:2 animated:YES];
            [dataTable tableViewDidFinishedLoading];
        });
    }
}

#pragma mark - UIStoryboardSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EDetail"]){
        SKEdetailInfoController *EDetail = segue.destinationViewController;
        EDetail.employeeInfo = _dataEItems[[dataTable indexPathForSelectedRow].row];
        [dataTable deselectRowAtIndexPath:[dataTable indexPathForSelectedRow] animated:YES];
	}
}
@end
