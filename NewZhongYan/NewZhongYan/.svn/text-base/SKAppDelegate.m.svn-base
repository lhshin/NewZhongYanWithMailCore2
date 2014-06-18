//
//  SKAppDelegate.m
//  NewZhongYan
//
//  Created by lilin on 13-9-28.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKAppDelegate.h"
#import "SKPatternLockController.h"
#import "SKLoginViewController.h"
#import "SKAgentLogonManager.h"
#import "Sqlite.h"
#import "FileUtils.h"
#import "APPUtils.h"
#import "DateUtils.h"
#import "User.h"
#import "UIDevice-Hardware.h"
#import "UIDevice+IdentifierAddition.h"
#import "SKViewController.h"
#import "AESCrypt.h"
#import "EGOCache.h"
#import "UncaughtExceptionHandler.h"
#define MAXTIME 1
static User* currentUser = nil;
@implementation SKAppDelegate
{
    UIView *rView;//图片的UIView
    UIImageView *zView;//Z图片ImageView
    UIImageView *fView;//F图片ImageView
    NSString *theDeviceToken;//推送令牌
}

+(User*)sharedCurrentUser
{
    if (currentUser == nil) {
        currentUser = [SKAgentLogonManager historyLoggedUsers];
        if (!currentUser) {
            currentUser = [[User alloc] init];
        }else{
            
        }
            
    }
    return currentUser;
}

NSUInteger DeviceSystemMajorVersion() {
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    return _deviceSystemMajorVersion;
}

- (void)installUncaughtExceptionHandler
{
    InstallUncaughtExceptionHandler();
}

/**
 *  创建和更新数据库
 */
-(void)creeateDatabase
{
    //判断以前是不是安装过这个应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"CreetDB"])      //如果没有安装过则创建最新的数据库代码
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CreetDB"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DBVERSION"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [Sqlite  createAllTable];
    }
    else                                                                    //如果安装过则执行补丁代码
    {
        [Sqlite setDBVersion];
    }
}

/**
 *  创建网络监听
 */
-(void)createDataManager
{
    InstallUncaughtExceptionHandler();
    _queue = [[NSOperationQueue alloc] init];
    [FileUtils setvalueToPlistWithKey:@"sleepTime" Value:[NSDate distantFuture]];
    //推送
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeSound];
    [self creeateDatabase];
    if (!self.logonManager) {
        self.logonManager = [APPUtils AppLogonManager];
    }
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    _networkstatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    switch (_networkstatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            break;
        }
            
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            break;
        }
    }
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
}

- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}

-(void)createNetObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.internetReachability = [Reachability reachabilityWithHostname:@"tam.hngytobacco.com"];
	[self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (System_Version_Small_Than_(7)) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
            _mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_ios6" bundle:nil];
        }else {
            _mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_ios5" bundle:nil];
        }
    }else{
        _mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    }
    [self createNetObserver];
    [self createDataManager];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [_mainStoryboard instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    zView=[[UIImageView alloc]initWithFrame:self.window.frame];
    if (IS_IPHONE_5){
        zView.image=[UIImage imageNamed:@"Default-568h_logo"];
    }else{
        zView.image=[UIImage imageNamed:@"Default_logo"];
    }
    rView=[[UIView alloc]initWithFrame:self.window.frame];
    [rView addSubview:zView];
    [self.window addSubview:rView];
    
    [self performSelector:@selector(TheAnimation) withObject:nil afterDelay:1];
    return YES;
}

- (void)TheAnimation{
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.7 ;  // 动画持续时间(秒)
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;//淡入淡出效果
    [[rView layer] addAnimation:animation forKey:@"animation"];
    [UIView animateWithDuration:0.7  //速度0.7秒
                     animations:^{   //修改rView坐标
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [rView setAlpha:0];
                     }
                     completion:^(BOOL finished){
                         [rView removeFromSuperview];
                     }];
}

//当程序即将从active状态到inactive状态 或者用户quit了这个程序即将进入后台时的状态
//比如来电话了等等
//在该方法中暂停正在进行的任务，禁用定时器 throttle down OpenGL ES frame rates. 在这个方法中也要暂停游戏 如果是游戏类型的app的话
- (void)applicationWillResignActive:(UIApplication *)application
{
    [FileUtils setvalueToPlistWithKey:@"sleepTime" Value:[NSDate date]];
}

//程序已经进入后台
//该方法用来释放共享资源，保存用户数据，关掉定时器，保存足够的app状态信息用来恢复你的app到当前状态以防app终止
//如果你的app支持后台执行 this method is called instead of applicationWillTerminate: when the user quits.
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground");
}

//程序即将进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//程序已经激活
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([FileUtils valueFromPlistWithKey:@"sleepTime"])
    {
        NSDate *date=[FileUtils valueFromPlistWithKey:@"sleepTime"];
        NSInteger sleepSecond = [[NSDate date] secondsAfterDate:date];
        if (sleepSecond > 3) {
            UIViewController* controller = [APPUtils visibleViewController];
            if ([controller isKindOfClass:[SKPatternLockController class]]
                || [controller isKindOfClass:[SKLoginViewController class]]) {
                return;
            }
            UINavigationController* nav = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"patternlocknav"];
            SKPatternLockController* locker = (SKPatternLockController*)[nav topViewController];
            [locker setDelegate:[APPUtils AppRootViewController]];
            [controller presentViewController:nav animated:NO completion:^{
            }];
        }
    }
}

//注册成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSRange subStr;
    NSMutableString *deviceTokenString = [NSMutableString stringWithFormat:@"%@", deviceToken];
    
    subStr = [deviceTokenString rangeOfString:@">"];
    if (subStr.location != NSNotFound) {
        [deviceTokenString deleteCharactersInRange:subStr];
    }
    subStr = [deviceTokenString rangeOfString:@"<"];
    if (subStr.location != NSNotFound) {
        [deviceTokenString deleteCharactersInRange:subStr];
    }
    subStr = [deviceTokenString rangeOfString:@" "];
    while (subStr.location != NSNotFound) {
        [deviceTokenString deleteCharactersInRange:subStr];
        subStr = [deviceTokenString rangeOfString:@" "];
    }
    theDeviceToken = deviceTokenString;
	NSLog(@"deviceToken: %@\n%@", deviceToken, theDeviceToken);
}

//注册失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error in registration. Error: %@", error);
}

//当应用接收到远程推送的响应函数
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *status = [NSString stringWithFormat:@"Notification received:\n%@",[userInfo description]];
    NSLog(@"status:%@",status);
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"applicationDidReceiveMemoryWarning");
}
@end
