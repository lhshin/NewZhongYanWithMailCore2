//
//  SKGridController.m
//  NewZhongYan
//
//  Created by lilin on 13-12-13.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKGridController.h"
#import "DDXMLDocument.h"
#import "DDXMLElementAdditions.h"
#import "DDXMLElement.h"
#import "SKViewController.h"
#import "SKDaemonManager.h"
#import "SKECMRootController.h"
#import "LocalMetaDataManager.h"

#define InitIconX 30
#define InitIconY 40
#define InitIconHeight 80
//(320 - 180 ) - 2x/2 = (140 - 2x)/2 = 70 - x
#define InitIconintervalX 70 - InitIconX
#define InitIconintervalWidth 130 - InitIconX
#define InitIconintervalY 16.6
@interface SKGridController ()
{
    NSMutableArray *upButtons;
    BOOL isLoadImage;
}
@end

@implementation SKGridController
-(void)jumpToController:(id)sender
{
    UIDragButton *btn=(UIDragButton *)[(UIDragButton *)sender superview];
    [_rootController performSegueWithIdentifier:@"SKECMRootController" sender:btn.channel];
}

/**
 *  构建grid view 的界面
 *
 *  @param completeBlock <#completeBlock description#>
 */
-(void)initChannelView:(basicBlock)completeBlock
{
    isLoadImage = YES;
    for (UIView* v in self.view.subviews) {
        if (v.class == [UIDragButton class]) {
            [v removeFromSuperview];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        upButtons = [[NSMutableArray alloc] init];
        NSString* sql = [NSString stringWithFormat:@"select * from T_CHANNEL WHERE OWNERAPP = '%@' and LEVL = 1 and ENABLED = 1;",self.clientApp.CODE];
        NSArray* array = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
        for (int i=0;i<array.count;i++)
        {
            NSDictionary *dict=[array objectAtIndex:i];
            SKChannel* channel = [[SKChannel alloc] initWithDictionary:dict];
            if (![channel.FIDLIST isEqual:[NSNull null]]) {
                [channel restoreVersionInfo];
            }
            
            UIDragButton *dragbtn=[[UIDragButton alloc] initWithFrame:CGRectZero inView:self.view];
            [dragbtn setChannel:channel];
            [dragbtn setTitle:dict[@"NAME"]];
            [dragbtn.tapButton setPlaceholderImage:Image(@"icon_default")];
            [dragbtn.tapButton setDelegate:self];
            if (dict[@"LOGO"] == [NSNull null]) {
                [dragbtn.tapButton setImageURL:[NSURL URLWithString:@"http://tam.hngytobacco.com/ZZZobtc/public/icon/wzfactory/wzgeneralinfo.png"]];
            }else{
                [dragbtn.tapButton setImageURL:[NSURL URLWithString:dict[@"LOGO"]]];
            }
            [dragbtn setControllerName:dict[@"CODE"]];
            [dragbtn setDelegate:self];
            [dragbtn setTag:i];
            [dragbtn.tapButton addTarget:self action:@selector(jumpToController:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:dragbtn];
            [upButtons addObject:dragbtn];
        }
        [self setUpButtonsFrameWithAnimate:NO withoutShakingButton:nil];
        if (completeBlock) {
            completeBlock();
        }
    });
}

#pragma mark - EGOButton代理函数
- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton{
    
}

- (void)imageButtonFailedToLoadImage:(EGOImageButton*)imageButton error:(NSError*)error
{
    [[SKAppDelegate sharedCurrentUser] addObserver:self
                                        forKeyPath:@"logged"
                                           options:NSKeyValueObservingOptionNew
                                           context:(void*)imageButton];
}

/**
 *  这里还需要测试
 *
 *  @param keyPath <#keyPath description#>
 *  @param object  <#object description#>
 *  @param change  <#change description#>
 *  @param context <#context description#>
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (!isLoadImage) {
        [self initChannelView:^{
            isLoadImage = NO;
        }];
    }
    [[SKAppDelegate sharedCurrentUser] removeObserver:self forKeyPath:@"logged"];
}

/**
 *  设置每一个按钮的位置
 *  注意在我这里 每一个按钮都对应一个平道
 *  @param _bool         是否使用动画
 *  @param shakingButton 被点中的按钮  如果是初始化界面的话 被点中的按钮可能会为空
 */
- (void)setUpButtonsFrameWithAnimate:(BOOL)_bool withoutShakingButton:(UIDragButton *)shakingButton
{
    NSUInteger count = [upButtons count];
    if (shakingButton != nil) {
        [UIView animateWithDuration:_bool ? 0.4 : 0 animations:^{
            for (int y = 0; y <= count / 3; y++) {
                for (int x = 0; x < 3; x++) {
                    int i = 3 * y + x;
                    if (i < count) {
                        UIDragButton *button = (UIDragButton *)[upButtons objectAtIndex:i];
                        if (button.tag != shakingButton.tag){
                            [button setFrame:CGRectMake(InitIconX + x * (InitIconintervalWidth),  InitIconY + y * (InitIconHeight + InitIconintervalY), 60, 60)];
                        }
                        [button setLastCenter:CGPointMake( InitIconX + x * (InitIconintervalWidth) + 60/2.0,  InitIconY + y * (InitIconHeight + InitIconintervalY)  + 60/2.0)];
                    }
                }
            }
        }];
    }else{
        [UIView animateWithDuration:_bool ? 0.4 : 0 animations:^{
            for (int y = 0; y <= count / 3; y++) {
                for (int x = 0; x < 3; x++) {
                    int i = 3 * y + x;
                    if (i < count) {
                        UIDragButton *button = (UIDragButton *)[upButtons objectAtIndex:i];
                        [button setFrame:CGRectMake(InitIconX + x *  (InitIconintervalWidth), InitIconY + y * (InitIconHeight + InitIconintervalY), 60, 60)];
                        [button setLastCenter:CGPointMake( InitIconX + x * (InitIconintervalWidth) + 60/2.0,  InitIconY + y * (InitIconHeight + InitIconintervalY)  + 60/2.0 )];
                    }
                }
            }
        }];
    }
}

/**
 *  检查图标的位置 看是不是需要交换位置
 *
 *  @param shakingButton 被点中的button
 */
- (void)checkLocationOfOthersWithButton:(UIDragButton *)shakingButton
{
    for (int i = 0; i < [upButtons count]; i++)
    {
        UIDragButton *button = (UIDragButton *)[upButtons objectAtIndex:i];
        if (button.tag != shakingButton.tag)
        {
            CGRect intersectionRect=CGRectIntersection(shakingButton.frame, button.frame);//两个按钮接触的大小
            if (intersectionRect.size.width>15&&intersectionRect.size.height>25)
            {
                [upButtons exchangeObjectAtIndex:i withObjectAtIndex:[upButtons indexOfObject:shakingButton]];
                [self setUpButtonsFrameWithAnimate:YES withoutShakingButton:shakingButton];
                //[self writeDataToXml];
                break;
            }
        }
    }
}


-(void)checkShakingButtonToLeftEdge:(UIDragButton *)shakingButton
{
    if (_rootController.pageController.currentPage == 1) {
        [_rootController scrollToPage:0];
    }
}

-(void)checkShakingButtonToRightEdge:(UIDragButton *)shakingButton
{
    if (_rootController.pageController.currentPage == 0) {
        [_rootController scrollToPage:1];
    }
}

/**
 *  当该界面出现时  应检测该应用下对应的频道是不是有更新
 *
 *  @param animated <#animated description#>
 */
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SKDaemonManager SynChannelWithClientApp:self.clientApp complete:^{
        [self initChannelView:^{
            [SKDaemonManager SynMaxUpdateDateWithClient:self.clientApp
                                               complete:^(NSMutableArray* array){
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [self reloadBageNumberWithServerInfo:array];
                                                   });
                                               } faliure:^(NSError* error){
                                                   
                                               }];
        }];
    } faliure:^(NSError* error){
        [SKDaemonManager SynMaxUpdateDateWithClient:self.clientApp
                                           complete:^(NSMutableArray* array){
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [self reloadBageNumberWithServerInfo:array];
                                               });
                                           } faliure:^(NSError* error){
                                               
                                           }];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initChannelView:^{
        [self setECMBadgeNumber];
    }];
}

/**
 *  刷新界面
 */
-(void)reloadData
{
    [SKDaemonManager SynChannelWithClientApp:self.clientApp complete:^{
        [self initChannelView:^{
            [SKDaemonManager SynMaxUpdateDateWithClient:self.clientApp
                                               complete:^(NSMutableArray* array){
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       [self reloadBageNumberWithServerInfo:array];
                                                   });
                                               } faliure:^(NSError* error){
                                                   
                                               }];
        }];
    } faliure:^(NSError* error){
        [SKDaemonManager SynMaxUpdateDateWithClient:self.clientApp
                                           complete:^(NSMutableArray* array){
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [self reloadBageNumberWithServerInfo:array];
                                               });
                                           } faliure:^(NSError* error){
                                               
                                           }];
    }];
}

/**
 *  获取某个频道下服务器上最大数据的时间
 *
 *  @param array 存储服务器上某应用下所有频道的最新数据时间
 *  @param code  频道code
 *
 *  @return 13位的时间戳
 */
-(long long)maxuptmFromServer:(NSArray*)array ChannelCode:(NSString*)code{
    for (NSDictionary* dict in array) {
        NSDictionary* vinfo = dict[@"v"];
        if ([vinfo[@"CHANNELCODE"] isEqualToString:code]) {
            NSString* timestr = vinfo[@"LATESTTIME"];
            NSTimeInterval time = [[DateUtils stringToDate:timestr DateFormat:dateTimeFormat] timeIntervalSince1970];
            return time*1000;
        }
    }
    return 0;
}

/**
 *  用服务器最新的数据信息 更新badge数据
 *
 *  @param array 服务器上该应用下的最新数据
 */
-(void)reloadBageNumberWithServerInfo:(NSArray*)array{
        if(array){
            for (UIDragButton*btn in upButtons) {
                long long lmaxuptm = [btn.channel.MAXUPTM longLongValue];
                long long smaxuptm = [self maxuptmFromServer:array ChannelCode:btn.channel.CODE];
                if (smaxuptm > lmaxuptm) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [btn setBadgeNumber:@"new"];
                    });
                }else{
                    BOOL isMeeting = [btn.channel.TYPELABLE rangeOfString:@"meeting"].location != NSNotFound;
                    BOOL isNotice = [btn.channel.TYPELABLE rangeOfString:@"notice"].location != NSNotFound;
                    if (isMeeting || isNotice) {
                        [btn setBadgeNumber:[LocalMetaDataManager newECMMeettingItemCount:btn.channel.FIDLISTS]];
                    }else{
                        [btn setBadgeNumber:[LocalMetaDataManager newECMDataItemCount:btn.channel.FIDLISTS]];
                    }
                }
            }
        }
}

/**
 *  设置ecm上badge的数值
 */
-(void)setECMBadgeNumber{
    for (UIDragButton *btn in upButtons)
    {
        BOOL isMeeting = [btn.channel.TYPELABLE rangeOfString:@"meeting"].location != NSNotFound;
        BOOL isNotice = [btn.channel.TYPELABLE rangeOfString:@"notice"].location != NSNotFound;
        if (isMeeting || isNotice) {
            [btn setBadgeNumber:[LocalMetaDataManager newECMMeettingItemCount:btn.channel.FIDLISTS]];
        }else{
            [btn setBadgeNumber:[LocalMetaDataManager newECMDataItemCount:btn.channel.FIDLISTS]];
        }
    }
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
@end
