//
//  SKViewController.m
//  NewZhongYan
//
//  Created by lilin on 13-9-28.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKViewController.h"
#import "SKLoginViewController.h"
#import "DDXMLDocument.h"
#import "DDXMLElementAdditions.h"
#import "DDXMLElement.h"
#import "SKPatternLockController.h"
#import "SKAgentLogonManager.h"
#import "LocalMetaDataManager.h"
#import "GetNewVersion.h"
#import "SKAPPUpdateController.h"
#import "MBProgressHUD.h"
#import "DataServiceURLs.h"
#import "SKGridController.h"
#import "UIView+screenshot.h"
#import "UIImage+BlurredFrame.h"
#import "SKDaemonManager.h"
#import "SKECMRootController.h"
#import "SKSettingController.h"
#import "SKHToolBar.h"
#define OriginY ((IS_IOS7) ? 64 : 0 )
#define DepartmentInfomationCheckDate @"DepartmentInfomationCheckDate"
#define ClientInfomationCheckDate @"ClientInfomationCheckDate"
@interface SKViewController ()<SKHToolBarProtocol>
{
    BWStatusBarOverlay* BWStatusBar;
    __weak IBOutlet UIView *tabbarView;
    __weak IBOutlet UIView *workItemView;
    __weak IBOutlet UIView *titleView;
    __weak IBOutlet UIImageView *titleImageView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UITabBar *tabbar;
    __weak IBOutlet UITabBarItem *remindTabItem;
    __weak IBOutlet UITabBarItem *emailTabItem;
    UILabel* navTitleLabel;
    UIView* topView;
    
    
    SKGridController* companyController;
    SKGridController* selfCompanyController;
    NSMutableArray* controllerArray;
    SKHToolBar *skhToolBar;
}
@end

@implementation SKViewController
@synthesize bgScrollView;
@synthesize pageController;
/**
 *  该函数主要用来设置导航条
 *  注意点：1 设置导航条上字体的颜色 为白色
 *  topView ：用来之定义导航条上的内容
 *  navTitleLabel ：显示你当前所在的位置 比如吴忠卷烟厂 长沙卷烟厂
 */
-(void)initNavBar
{
    UIImage* navbgImage;
    if (System_Version_Small_Than_(7)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        navbgImage = [UIImage imageNamed:@"navbar44"] ;
        self.navigationController.navigationBar.tintColor = COLOR(0, 97, 194);
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self setNeedsStatusBarAppearanceUpdate];
        navbgImage = [UIImage imageNamed:@"navbar64"] ;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    [self.navigationController.navigationBar setBackgroundImage:navbgImage  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
    
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    
    CGRect rect = self.navigationController.navigationBar.bounds;
    topView = [[UIView alloc] initWithFrame:rect];
    topView.backgroundColor =[UIColor clearColor];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, 220, 25)];
    [label setFont:[UIFont boldSystemFontOfSize:22]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setText:@"湖南中烟信息集成平台"];
    [topView addSubview:label];
    
    navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(228, 18, 90, 19)];
    [navTitleLabel setFont:[UIFont systemFontOfSize:14]];
    [navTitleLabel setTextColor:[UIColor whiteColor]];
    [navTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [navTitleLabel setBackgroundColor:[UIColor clearColor]];
    [topView addSubview:navTitleLabel];
    [self.navigationController.navigationBar addSubview:topView];
}

/**
 *  执行segue处理函数
 *
 *  @param segue
 *  @param sender
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"SKECMRootController"])
	{
        SKECMRootController *ecmRoot = segue.destinationViewController;
        ecmRoot.channel = sender;
	}
    
	if ([segue.identifier isEqualToString:@"setting"])
	{
        SKSettingController *setting = segue.destinationViewController;
        setting.rootController = self;
	}
}

/**
 *  tabbar 代理函数  该函数执行相关的segue  注意点 1 这个不是常见的tabbarcontroller 后面要求变高 建议之定义
 *  因为对字体图片的大小有要求
 *  @param tabBar
 *  @param item
 */
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 0:
        {
            //item.selectedImage = Image(@"remind_highnight");
            [self performSegueWithIdentifier:@"SKGTaskViewController"sender:self];
            break;
        }
        case 1:
        {
            //item.selectedImage = Image(@"email_highnight");
            [self performSegueWithIdentifier:@"SKEmailController"sender:self];
            break;
        }
        case 2:
        {
            //item.selectedImage = Image(@"address_highnight");
            [self performSegueWithIdentifier:@"SKAddressController"sender:self];
            break;
        }
        case 3:
        {
            //item.selectedImage = Image(@"setting_highnight");
            [self performSegueWithIdentifier:@"setting"sender:self];
            break;
        }
        default:
            break;
    }
    tabBar.selectedItem = nil;
}


/**
 *  tabbar 代理函数  该函数执行相关的segue
 *
 *
 *  @param viewTag
 */
-(void)onSingleOneDone:(long)viewTag
{
    switch (viewTag) {
        case 1:
        {
            //item.selectedImage = Image(@"remind_highnight");
            [self performSegueWithIdentifier:@"SKGTaskViewController"sender:self];
            break;
        }
        case 2:
        {
            //item.selectedImage = Image(@"email_highnight");
            [self performSegueWithIdentifier:@"SKEmailController"sender:self];
            break;
        }
        case 3:
        {
            //item.selectedImage = Image(@"address_highnight");
            [self performSegueWithIdentifier:@"SKAddressController"sender:self];
            break;
        }
        case 4:
        {
            //item.selectedImage = Image(@"setting_highnight");
            [self performSegueWithIdentifier:@"setting"sender:self];
            break;
        }
        default:
            break;
    }
}

/**
 *  该函数暂时没有用到 以前用到了
 *
 *  @param sender
 */
-(void)jumpToController:(id)sender
{
    UIDragButton *btn=(UIDragButton *)[(UIDragButton *)sender superview] ;
    [self performSegueWithIdentifier:btn.controllerName sender:self];
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        BWStatusBar = [[BWStatusBarOverlay alloc] init];
        isFirstLogin = ![APPUtils userUid];
    }
    return self;
}

/**
 *  pageController 相关处理函数
 *  pagecontroller 由于要兼容6以前的版本 所以用的开源 smpagecontroller
 *  @param animated
 */
- (void)gotoPage:(BOOL)animated
{
    NSInteger page = pageController.currentPage;
    CGRect bounds = bgScrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [bgScrollView scrollRectToVisible:bounds animated:animated];
}

- (void)scrollToPage:(int)page
{
    CGRect bounds = bgScrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [bgScrollView scrollRectToVisible:bounds animated:YES];
    pageController.currentPage = page;
}

- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];    // YES = animate
}

-(void)initPageController
{
    pageController = [[SMPageControl alloc] initWithFrame:CGRectMake((320 - 150)/2., BottomY - 49 - 35, 150, 40)];
    [pageController setIndicatorDiameter:8];
    [pageController setHidesForSinglePage:YES];
    [pageController setNumberOfPages:2];
    [pageController setCurrentPageIndicatorImage:Image(@"dot_selected")];
    [pageController setPageIndicatorImage:Image(@"dot_normal")];
    [pageController setCurrentPage:0];
    [pageController addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageController];
}

/*
 循环滚动
 每次滚动后都将scrollview的offset设置为中间的一页
 若本次滚动是向前一页滚动，则把三页都向后放置，最后一页放到开头
 若本次滚动是向后一页滚动，则把三页都向前放置，第一页放到末尾
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(bgScrollView.frame);
    NSUInteger page = floor((bgScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageController.currentPage = page;
    SKGridController *controller = controllerArray[page];
    navTitleLabel.text = controller.clientApp.NAME;
}

- (SKGridController*)loadScrollViewWithClientApp:(SKClientApp*)app PageNo:(NSUInteger)page
{
    if (page == 0) {
        navTitleLabel.text = app.NAME;
    }
    [bgScrollView setContentSize:CGSizeMake((page + 1) * 320, bgScrollView.frame.size.height)];
    SKGridController *controller = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKGridController"];
    controller.rootController = self;
    controller.clientApp = app;
    [controllerArray addObject:controller];
    if (controller.view.superview == nil)
    {
        CGRect frame = bgScrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self addChildViewController:controller];
        [bgScrollView addSubview:controller.view];
    }
    return controller;
}

-(void)initData
{
    titleLabel.text = @"吴忠主页";
    controllerArray = [NSMutableArray array];
    if (System_Version_Small_Than_(7)) {
        tabbar.backgroundImage = Image(@"landbar_noshadow");
        [[UITabBarItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    }
    skhToolBar=[[SKHToolBar alloc] initWithFrame:CGRectMake(0, 0, 320, 49)];
    [skhToolBar setOwner:self];
    [tabbarView addSubview:skhToolBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initNavBar];
    [self initPageController];
    if (isFirstLogin) {
        SKLoginViewController* loginController = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"loginController"];
        [FileUtils setvalueToPlistWithKey:@"EPSIZE" Value:@"5"];
        [self presentViewController:loginController animated:NO completion:^{
            NSString* username = [FileUtils valueFromPlistWithKey:@"gpusername"];
            if ([username length] > 0) {
                loginController.userField.text = username;
                loginController.userField.enabled = NO;
            }
        }];
    }else{
        [self initClientApp];
        UINavigationController* nav = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"patternlocknav"];
        SKPatternLockController* locker = (SKPatternLockController*)[nav topViewController];
        [locker setDelegate:self];
        [[APPUtils visibleViewController] presentViewController:nav animated:NO completion:^{
            [LocalMetaDataManager restoreAllMetaData];
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [topView setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [topView setHidden:NO];
}

-(void)viewWillLayoutSubviews
{
    tabbar.selectedItem = nil;
}

/**
 *  设置未读邮件和待办的条数 在每次进入界面的时候
 *
 *  @param animated <#animated description#>
 */
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [emailTabItem setBadgeValue:[LocalMetaDataManager newDataItemCount:[LocalDataMeta sharedMail]]];
    skhToolBar.emailBadge.badgeText = [LocalMetaDataManager newDataItemCount:[LocalDataMeta sharedMail]];
    [remindTabItem setBadgeValue:[LocalMetaDataManager newDataItemCount:[LocalDataMeta sharedRemind]]];
    skhToolBar.remindBadge.badgeText =[LocalMetaDataManager newDataItemCount:[LocalDataMeta sharedRemind]];
}

#pragma mark - 屏保代理函数
-(void)onGetNewVersionDoneWithDic:(NSDictionary *)dic
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    if ([[dic objectForKey:@"NVER"] floatValue] > [appVersion floatValue])
    {
        UINavigationController* nav = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"versionupdatenav"];
        [self presentViewController:nav animated:NO completion:^{
            SKAPPUpdateController* updater = (SKAPPUpdateController*)[nav topViewController];
            [updater setVersionDic:dic];
        }];
    }
}

-(BOOL)isLoggedCookieValidity
{
    ASIHTTPRequest* validateLogonrequest =
    [ASIHTTPRequest requestWithURL:validloginurl];
    [validateLogonrequest setTimeOutSeconds:15];
    [validateLogonrequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    [validateLogonrequest startSynchronous];
    return [[validateLogonrequest responseData] length] == 1;
}

/**
 *  当应用列表发生更新完成后 需要更新界面
 */
-(void)updateClientAppinfo
{
    for (SKGridController* controller in controllerArray) {
        [controller reloadData];
    }
}

/**
 *  构造界面尽在viewdidload中使用
 */
-(void)initClientApp
{
    clientAppArray = [NSMutableArray array];
    NSArray* array = [[DBQueue sharedbQueue] recordFromTableBySQL:@"select * from T_CLIENTAPP where HASPMS = 1 and ENABLED = 1 ORDER BY DEFAULTED;"];
    [pageController setNumberOfPages:array.count];
    for (NSDictionary* dict in array) {
        SKClientApp* clientApp = [[SKClientApp alloc] initWithDictionary:dict];
        [clientAppArray addObject:clientApp];
    }
    for (SKClientApp* app in clientAppArray) {
        [self loadScrollViewWithClientApp:app PageNo:[clientAppArray indexOfObject:app]];
    }
}

/**
 *  启动程序构造界面
 */
-(void)firstInitClientApp
{
    for (UIView* view in [bgScrollView subviews]) {
        [view removeFromSuperview];
    }
    clientAppArray = [NSMutableArray array];
    NSArray* array = [[DBQueue sharedbQueue] recordFromTableBySQL:@"select * from T_CLIENTAPP where HASPMS = 1 and ENABLED = 1 ORDER BY DEFAULTED;"];
    [pageController setNumberOfPages:array.count];
    for (NSDictionary* dict in array) {
        SKClientApp* clientApp = [[SKClientApp alloc] initWithDictionary:dict];
        [clientAppArray addObject:clientApp];
    }
    for (SKClientApp* app in clientAppArray) {
        SKGridController* controller =  [self loadScrollViewWithClientApp:app PageNo:[clientAppArray indexOfObject:app]];
        [controller reloadData];
    }
}

/**
 *  登录完成后进行的操作
 */
-(void)afterOnLogon
{
    [SKClientApp getClientAppWithCompleteBlock:^{
        [self firstInitClientApp];
    } faliureBlock:^(NSError* error){
        [self updateClientAppinfo];
    }];
    [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedVersionInfo] delegate:self];
    [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedRemind] delegate:self];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ECONTACTSYNED"]) {
        if ([APPUtils currentReachabilityStatus] == ReachableViaWiFi) {
            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedEmployee] delegate:self];
            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedOranizational] delegate:self];
            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedUnit] delegate:self];
        }
    }
    [GetNewVersion getNewsVersionComplteBlock:^(NSDictionary* dict){
        [self onGetNewVersionDoneWithDic:dict];
    } FaliureBlock:^(NSDictionary* error){
        NSLog(@"获取app版本信息失败 %@",error);
    }];
}

/**
 *  解锁完成后相关的处理函数
 */
-(void)onPatternLockSuccess
{
    if (isFirstLogin){//这里还有bug//测试 登陆后会不会到这里
        isFirstLogin = NO;
        NSString* username = [FileUtils valueFromPlistWithKey:@"gpusername"];
        if ([username length] > 0 ) {
            [FileUtils setvalueToPlistWithKey:@"gpusername" Value:@""];//这里一般不是第一次登陆 比如屏幕保护密码输错
        }else{
            if ([APPUtils currentReachabilityStatus] != NotReachable) {
                [[EGOCache currentCache] clearCache];
                [self firstInitClientApp];
                [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedEmployee] delegate:self];
                [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedOranizational] delegate:self];
                [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedUnit] delegate:self];
                [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedSelfEmployee] delegate:0];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SKAppDelegate sharedCurrentUser].logging = NO;
                    [BWStatusBarOverlay showSuccessWithMessage:@"当前网络不可用，请检查网络设置" duration:1 animated:1];
                });
            }
        }
    }else{
        if ([APPUtils currentReachabilityStatus] != NotReachable) {
            NSInteger sleepSecond = [[NSDate date] secondsAfterDate:[FileUtils valueFromPlistWithKey:@"sleepTime"]];
            if (sleepSecond > 1500 || sleepSecond < 0)
            {
                if (sleepSecond > 1500 && [self isLoggedCookieValidity]) {
                    [self afterOnLogon];
                }else{
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [[APPUtils AppLogonManager] loginWithUser:[SKAppDelegate sharedCurrentUser]
                                                    CompleteBlock:^{
                                                        [self afterOnLogon];
                                                    }failureBlock:^(NSDictionary* dict){
                                                    }];
                    });
                }
                
            }else{
                if (clientAppArray) {//一般恢复界面后且时间小于1500秒函数会直接执行到这里，然后直接检车应用是否有更新
                    [SKClientApp getClientAppWithCompleteBlock:^{
                        [self firstInitClientApp];
                    } faliureBlock:^(NSError* error){
                        NSLog(@"%@",error);
                    }];
                }else{//有时候需要检查是否需要重新构建grid界面 比如 bug10（bugtree中）： 首次登陆进入help界面退出再进来的情况
                    [self firstInitClientApp];
                    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ECONTACTSYNED"]) {
                        if ([APPUtils currentReachabilityStatus] == ReachableViaWiFi) {
                            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedEmployee] delegate:self];
                            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedOranizational] delegate:self];
                            [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedUnit] delegate:self];
                        }
                    }
                }
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [SKAppDelegate sharedCurrentUser].logging = NO;
                [BWStatusBarOverlay showSuccessWithMessage:@"当前网络不可用，请检查网络设置" duration:1 animated:1];
            });
        }
    }
}

/**
 *  当在后台登陆账号密码被修改时 这个代理函数会执行详见:
 *  -(void)loginWithUser:(User*)user CompleteBlock:(basicBlock)block failureBlock:(errorBlock)errorblock
 *  @param alertView
 *  @param buttonIndex
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        [FileUtils setvalueToPlistWithKey:@"gpsw" Value:@""];
        [FileUtils setvalueToPlistWithKey:@"gpusername" Value:[APPUtils userUid]];
        [[DBQueue sharedbQueue] updateDataTotableWithSQL:@"delete from USER_REMS"];
        SKLoginViewController* loginController = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"loginController"];
        [[APPUtils visibleViewController] presentViewController:loginController animated:NO completion:^{
            [loginController.userField setText:[FileUtils valueFromPlistWithKey:@"gpusername"]];
            [loginController.userField setEnabled:NO];
        }];
    }
}

#pragma mark - cms时同步数据代理函数
-(void)didBeginSynData:(LocalDataMeta *)metaData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([metaData.dataCode isEqualToString:@"employee"]  && ![metaData isUserOwner])  {
            BWStatusBar =  [[BWStatusBarOverlay alloc] init];
            [BWStatusBar showLoadingWithMessage:@"正在同步通讯录..." animated:YES];
            if (IS_IOS7) {
                [BWStatusBar setProgressBackgroundColor:COLOR(17, 168, 171)];
            }
        }
    });
}

-(void)didCompleteSynData:(LocalDataMeta *)metaData
{
    if ([metaData.dataCode isEqualToString:@"employee"] && ![metaData isUserOwner])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ECONTACTSYNED"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
            [BWStatusBar showSuccessWithMessage:@"通讯录同步完成" duration:2 animated:YES];
        });
    }
}

-(void)didCompleteSynData:(NSString *)datacode SV:(int)sv SC:(int)sc LV:(int)lv
{
    
}

-(void)didEndSynData:(LocalDataMeta *)metaData
{
    float p = (float)metaData.lastfrom/metaData.lastcount;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([metaData.dataCode isEqualToString:@"employee"] && ![metaData isUserOwner])  {
            [BWStatusBar setProgress:p animated:YES];
            [BWStatusBar setMessage:@"正在同步通讯录..." animated:NO];
        }
    });
}

-(void)didCancelSynData:(LocalDataMeta *)metaData
{
    
}

-(void)didErrorSynData:(LocalDataMeta *)metaData Reason:(NSString *)errorinfo
{
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
