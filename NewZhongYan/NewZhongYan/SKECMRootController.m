//
//  SKECMRootController.m
//  NewZhongYan
//
//  Created by lilin on 13-12-26.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKECMRootController.h"
#import "SKTableViewCell.h"
#import "SKToolBar.h"
#import "SKDaemonManager.h"
#import "SKECMBrowseController.h"
#import "SKECMSearchController.h"
#import "SKCMeetCell.h"
#define UP 1
#define DOWN 0
#define READ 1
#define UNREAD 0
#define BEFORETWODAY 1 //两天以前
#define INNERTWODAY  0 //两天以内
#define ActionsheetTag 101
@interface SKECMRootController ()
{
    NSMutableArray              *_dataItems;
    NSArray* subChannels;
    NSInteger                   currentIndex;
    UIButton *titleButton;
    UIActionSheet *actionSheet;
    UILabel* noneDataLabel;
    NSMutableArray  *openedInSectionArr;//记录展开的状态
}
@end

@implementation SKECMRootController
-(void)onSearchClick
{
    UINavigationController* nav = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"ecmsearchnavcontroller"];
    SKECMSearchController* searcher = (SKECMSearchController*)[nav topViewController];
    searcher.fidlist = self.channel.FIDLIST;
    searcher.channel = self.channel;
    searcher.isMeeting = isMeeting;
    [[APPUtils visibleViewController] presentViewController:nav animated:YES completion:^{
    }];
}

-(void)onRefrshClick
{
    [SKDaemonManager SynDocumentsWithChannel:self.channel complete:^{
        [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
            if (isMeeting) {
                [_sectionDictionary addEntriesFromDictionary:[self praseMeetingArray:array]];
            } else if (isNotice) {
                [_sectionDictionary addEntriesFromDictionary:[self praseNoticeArray:array]];
            } else {
                [_dataItems setArray:array];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView tableViewDidFinishedLoading];
                [self.tableView reloadData];
                [noneDataLabel setHidden:array.count > 0];
                [_tableView setHidden:array.count <= 0];
                [BWStatusBarOverlay showSuccessWithMessage:[NSString stringWithFormat:@"同步%@完成",self.channel.NAME] duration:1 animated:1];
            });
        }];
    } faliure:^(NSError* error){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == DataNoneCode) {
                [BWStatusBarOverlay showSuccessWithMessage:[NSString stringWithFormat:@"同步%@完成",self.channel.NAME] duration:1 animated:1];
            }
            //判断不是会议也不是消息通知
            [self showMsg];
            
            [self.tableView tableViewDidFinishedLoading];
        });
    } Type:UP];
}

/**
 *  用于从数据库中获取该频道下所有的数据
 *
 *  @param block
 */
-(void)dataFromDataBaseWithComleteBlock:(resultsetBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* sql = [NSString stringWithFormat:
                         @"select (case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',crtm)) then 1 else 0 end ) as bz,(case when(DATETIME(EDTM) > DATETIME('now','localtime')) then 1 else 0 end ) as az,AID,PAPERID,TITL,ATTRLABLE,PMS,URL,ADDITION,BGTM,EDTM,READED,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,strftime('%%s000',UPTM) UPTM from T_DOCUMENTS where CHANNELID in (%@) and ENABLED = 1  ORDER BY CRTM DESC;",self.channel.FIDLISTS];
        NSArray* dataArray = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
        for (NSMutableDictionary* d in dataArray)
        {
            if ([[d objectForKey:@"bz"] intValue] == INNERTWODAY && [[d objectForKey:@"READED"] intValue] == UNREAD) {
                [d setObject:@"0" forKey:@"READED"];
            }else{
                [d setObject:@"1" forKey:@"READED"];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(dataArray);
            }
        });
    });
}

/**
 *  用于从数据库中获取该频道下的指定的子频道的数据集合
 *
 *  @param currentFid 指定的子频道id
 *  @param block
 */
-(void)dataFromDataBaseWithFid:(NSString*)currentFid  ComleteBlock:(resultsetBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* sql = [NSString stringWithFormat:
                         @"select (case when(strftime('%%s','now','start of day','-8 hour','-1 day') >= strftime('%%s',crtm)) then 1 else 0 end ) as bz,(case when(DATETIME(EDTM) > DATETIME('now','localtime')) then 1 else 0 end ) as az,AID,PAPERID,TITL,ATTRLABLE,PMS,URL,ADDITION,BGTM,EDTM,READED,strftime('%%Y-%%m-%%d %%H:%%M',CRTM) CRTM,strftime('%%s000',UPTM) UPTM from T_DOCUMENTS where CHANNELID in (%@) and ENABLED = 1  ORDER BY CRTM DESC;",currentFid];
        NSArray* dataArray = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
        if (isMeeting) {
            NSDictionary *sectionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                               [NSMutableArray array],@"即将召开&正在召开",
                                               [NSMutableArray array],@"已结束", nil];
            
            for (NSDictionary *dict in [NSArray arrayWithArray:dataArray]){
                NSString* bz = [dict objectForKey:@"az"];
                if (bz.intValue) {
                    [(NSMutableArray*)[sectionDictionary objectForKey:@"即将召开&正在召开"] addObject:dict];
                }else{
                    [(NSMutableArray*)[sectionDictionary objectForKey:@"已结束"]  addObject:dict];
                }
            }
            _sectionDictionary = [NSMutableDictionary dictionaryWithDictionary:sectionDictionary];
        } else if (isNotice) {
            NSDictionary *sectionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                               [NSMutableArray array],@"最新",
                                               [NSMutableArray array],@"过期", nil];
            
            for (NSDictionary *dict in [NSArray arrayWithArray:dataArray]){
                NSString* az = [dict objectForKey:@"az"];
                if (az.intValue) {
                    [(NSMutableArray*)[sectionDictionary objectForKey:@"最新"] addObject:dict];
                }else{
                    [(NSMutableArray*)[sectionDictionary objectForKey:@"过期"]  addObject:dict];
                }
            }
            _sectionDictionary = [NSMutableDictionary dictionaryWithDictionary:sectionDictionary];

        } else{
            for (NSMutableDictionary* d in dataArray)
            {
                if ([[d objectForKey:@"bz"] intValue] == INNERTWODAY && [[d objectForKey:@"READED"] intValue] == UNREAD) {
                    [d setObject:@"0" forKey:@"READED"];
                }else{
                    [d setObject:@"1" forKey:@"READED"];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(dataArray);
            }
        });
    });
}

#pragma mark -Actionsheet delegate
- (void)actionSheet:(UIActionSheet*)as clickedButtonAtIndex:(NSInteger)anIndex
{
    if (noneDataLabel)//YANGZ ADD
    {
        [noneDataLabel setHidden:YES];
    }
    
    if (currentIndex == anIndex || anIndex == subChannels.count + 1)
    {
        
        if (!_dataItems.count>0)//YANGZ ADD
        {
            if (!noneDataLabel)
            {
                noneDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
                noneDataLabel.textAlignment = NSTextAlignmentCenter;
                noneDataLabel.textColor = [UIColor lightGrayColor];
                noneDataLabel.text = @"没有数据或正在加载数据...";
                noneDataLabel.center = self.view.center;
                [self.view addSubview:noneDataLabel];
            }
            else
            {
                [noneDataLabel setHidden:NO];
            }
        }
        

        return;
    }
    [_dataItems removeAllObjects];
    if (anIndex == 0) {
        [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
            if (isMeeting) {
                [_sectionDictionary addEntriesFromDictionary:[self praseMeetingArray:array]];
            } else if (isNotice) {
                [_sectionDictionary addEntriesFromDictionary:[self praseNoticeArray:array]];
            } else {
                [_dataItems setArray:array];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        [titleButton setTitle:@"全部" forState:UIControlStateNormal];
    }else{
        [titleButton setTitle:subChannels[anIndex - 1][@"NAME"] forState:UIControlStateNormal];
        [self dataFromDataBaseWithFid:subChannels[anIndex - 1][@"FIDLIST"] ComleteBlock:^(NSArray* array){
            if (isMeeting) {
                [_sectionDictionary addEntriesFromDictionary:[self praseMeetingArray:array]];
            } else if (isNotice) {
                [_sectionDictionary addEntriesFromDictionary:[self praseNoticeArray:array]];
            } else
            {
                [_dataItems setArray:array];
            }
            [self showMsg];
            [self.tableView reloadData];
        }];
    }
    //判断不是会议也不是消息通知
    [self showMsg];
    currentIndex = anIndex;
    [as setDelegate:nil];
}

- (IBAction)selectType:(id)sender {
   actionSheet = [[UIActionSheet alloc] initWithTitle:self.channel.NAME
                                                             delegate:self
                                                    cancelButtonTitle:0
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:0,nil];
    [actionSheet addButtonWithTitle:@"全部"];
    for (NSDictionary* dict in subChannels) {
        [actionSheet addButtonWithTitle:dict[@"NAME"]];
    }
    [actionSheet addButtonWithTitle:@"取消"];
    actionSheet.tag = ActionsheetTag;
    [actionSheet setCancelButtonIndex:subChannels.count + 1];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;
    [actionSheet showInView:self.view];
}

-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:0];
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

-(void)initToolView
{
    SKToolBar* myToolBar = [[SKToolBar alloc] initWithFrame:CGRectMake(0, 0, 320, 49)  FirstTarget:self FirstAction:@selector(onSearchClick)
                                               SecondTarget:self.tableView SecondAction:@selector(launchRefreshing)];
    [toolView addSubview:myToolBar];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dataItems = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSDictionary*)praseMeetingArray:(NSArray*)meetings{
    NSDictionary *sectionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSMutableArray array],@"即将召开&正在召开",
                                       [NSMutableArray array],@"已结束", nil];
    
    for (NSDictionary *dict in [NSArray arrayWithArray:meetings]){
        NSString* bz = [dict objectForKey:@"az"];
        if (bz.intValue) {
            [(NSMutableArray*)[sectionDictionary objectForKey:@"即将召开&正在召开"] addObject:dict];
        }else{
            [(NSMutableArray*)[sectionDictionary objectForKey:@"已结束"] addObject:dict];
        }
    }
    return sectionDictionary;
}

-(NSDictionary*)praseNoticeArray:(NSArray*)notices{
    NSDictionary *sectionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSMutableArray array],@"最新",
                                       [NSMutableArray array],@"过期", nil];
    
    for (NSDictionary *dict in [NSArray arrayWithArray:notices]){
        NSString* bz = [dict objectForKey:@"az"];
        if (bz.intValue) {
            [(NSMutableArray*)[sectionDictionary objectForKey:@"最新"] addObject:dict];
        }else{
            [(NSMutableArray*)[sectionDictionary objectForKey:@"过期"] addObject:dict];
        }
    }
    return sectionDictionary;
}


-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initData
{
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
    [_tableView setHidden:YES];
    self.title = self.channel.NAME;
    isMeeting = [self.channel.TYPELABLE rangeOfString:@"meeting"].location != NSNotFound;
    isNotice = [self.channel.TYPELABLE rangeOfString:@"notice"].location != NSNotFound;
    [titleButton setHidden:!self.channel.HASSUBTYPE];
    
    if (self.channel.HASSUBTYPE) {
        NSString* sql = [NSString stringWithFormat:@"select * from T_CHANNEL WHERE PARENTID  = %@",self.channel.CURRENTID];
        subChannels = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
    }else{
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 21)];
        label.text = self.channel.NAME;
        label.font = [UIFont boldSystemFontOfSize:18];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [label sizeToFit];
        self.navigationItem.titleView = label;
    }

    if (isMeeting) {
        _sectionArray = [[NSArray alloc] initWithObjects:@"即将召开&正在召开",@"已结束", nil];
        _sectionDictionary = [[NSMutableDictionary alloc] init];
    } else if (isNotice) {
        _sectionArray = [[NSArray alloc] initWithObjects:@"最新",@"过期", nil];
        _sectionDictionary = [[NSMutableDictionary alloc] init];
    }
    
    [self dataFromDataBaseWithFid:self.channel.FIDLISTS ComleteBlock:^(NSArray* array){
        if (array.count) {
            [_tableView setHidden:NO];
            [noneDataLabel setHidden:YES];
            if (isMeeting) {
                [_sectionDictionary addEntriesFromDictionary:[self praseMeetingArray:array]];
            } else if (isNotice) {
                [_sectionDictionary addEntriesFromDictionary:[self praseNoticeArray:array]];
            } else {
                [_dataItems setArray:array];
            }
            [self.tableView tableViewDidFinishedLoading];
            [self.tableView reloadData];
        }else{
            [_tableView setHidden:YES];
            noneDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
            noneDataLabel.textAlignment = NSTextAlignmentCenter;
            noneDataLabel.textColor = [UIColor lightGrayColor];
            noneDataLabel.text = @"没有数据或正在加载数据...";
            noneDataLabel.center = self.view.center;
            [self.view addSubview:noneDataLabel];
        }

        [self onRefrshClick];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initToolView];
    //每个section展开收起状态标识符 1是展开 0是关闭
    openedInSectionArr = [[NSMutableArray alloc] initWithObjects:@"1", @"0",nil];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView != (UIScrollView*)self.tableView) return;
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView != (UIScrollView*)self.tableView)   return;
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(onRefrshClick) withObject:nil afterDelay:0.0];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [SKDaemonManager SynDocumentsWithChannel:self.channel complete:^{
        [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
            if (array.count) {
                if (isMeeting) {
                    [_sectionDictionary addEntriesFromDictionary:[self praseMeetingArray:array]];
                } else if (isNotice) {
                    [_sectionDictionary addEntriesFromDictionary:[self praseNoticeArray:array]];
                } else {
                    [_dataItems setArray:array];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView tableViewDidFinishedLoading];
                    [self.tableView reloadData];
                });
            }else{
                [self.tableView setReachedTheEnd:YES];
            }
        }];
    } faliure:^(NSError* error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView tableViewDidFinishedLoading];
            if (error.code == DataNoneCode) {
                [self.tableView setReachedTheEnd:YES];
            }
        });
    } Type:DOWN];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isMeeting){
        return [_sectionDictionary count];
    } else if (isNotice) {
        return [_sectionDictionary count];
    } else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (isMeeting) {
//        return [[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count];
//    } else if (isNotice) {
//        return [[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count];
//    } else {
//        return _dataItems.count;
//    }
    if (isMeeting)
    {
        if ([[openedInSectionArr objectAtIndex:section] intValue] == 1)
        {
            return [[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count];
        }
        return 0;
    }
    else if (isNotice)
    {
        
        if ([[openedInSectionArr objectAtIndex:section] intValue] == 1)
        {
            return [[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count];
        }
        return 0;
        //return [[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count];
    }
    else
    {
        return _dataItems.count;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    if (isMeeting) {
//        if ([[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count] > 0) {
//            return [_sectionArray objectAtIndex:section];
//        }else{
//            return 0;
//        }
//    } else if (isNotice) {
//        if ([[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count] > 0) {
//            return [_sectionArray objectAtIndex:section];
//        }else{
//            return 0;
//        }
//    }
    
    
    if (isMeeting) {
        return [_sectionArray objectAtIndex:section];
    } else if (isNotice) {
        return [_sectionArray objectAtIndex:section];
    }
    return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
//    label.backgroundColor = COLOR(245, 245, 245);
//    label.textColor = [UIColor grayColor];
//    label.font = [UIFont systemFontOfSize:15];
//    if (isMeeting) {
//        if ([[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count] > 0) {
//            label.text = [NSString stringWithFormat:@"  %@",[_sectionArray objectAtIndex:section]];
//            return label;
//        }else{
//            return 0;
//        }
//    } else if (isNotice) {
//        if ([[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count] > 0) {
//            label.text = [NSString stringWithFormat:@"  %@",[_sectionArray objectAtIndex:section]];
//            return label;
//        }else{
//            return 0;
//        }
//    }
    
    UIView * mySectionView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    mySectionView.backgroundColor = [UIColor clearColor];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    label.backgroundColor = COLOR(245, 245, 245);
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15];
    [mySectionView addSubview:label];
    if (isMeeting) {
        if ([[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count] > 0) {
            label.text = [NSString stringWithFormat:@"  %@",[_sectionArray objectAtIndex:section]];
            UIButton * myButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //myButton.imageView.image = [UIImage imageNamed:@"淡蓝头.png"];
            myButton.frame = CGRectMake(0, 0, 320, 30);
            myButton.tag = 100 + section;
            [myButton addTarget:self action:@selector(tapHeader:) forControlEvents:UIControlEventTouchUpInside];
            if ([[openedInSectionArr objectAtIndex:section] intValue] == 1)
            {
                //myButton.imageView.image = [UIImage imageNamed:@"table_section_down.png"];
                [myButton setImage:[UIImage imageNamed:@"table_section_down.png"] forState:UIControlStateNormal];
            }
            else
            {
                [myButton setImage:[UIImage imageNamed:@"table_section_left.png"] forState:UIControlStateNormal];
            }
            [mySectionView addSubview:myButton];
            return mySectionView;
        }else{
            return 0;
        }
    } else if (isNotice) {
        if ([[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count] > 0) {
            label.text = [NSString stringWithFormat:@"  %@",[_sectionArray objectAtIndex:section]];
            UIButton * myButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //myButton.imageView.image = [UIImage imageNamed:@"淡蓝头.png"];
            myButton.frame = CGRectMake(0, 0, 320, 30);
            myButton.tag = 100 + section;
            [myButton addTarget:self action:@selector(tapHeader:) forControlEvents:UIControlEventTouchUpInside];
            if ([[openedInSectionArr objectAtIndex:section] intValue] == 1)
            {
                //myButton.imageView.image = [UIImage imageNamed:@"table_section_down.png"];
                [myButton setImage:[UIImage imageNamed:@"table_section_down.png"] forState:UIControlStateNormal];
            }
            else
            {
                [myButton setImage:[UIImage imageNamed:@"table_section_left.png"] forState:UIControlStateNormal];
            }
//            myButton.imageView.image = [UIImage imageNamed:@"table_section_left.png"];
            [mySectionView addSubview:myButton];
            return mySectionView;
        }else{
            return 0;
        }
    }
//    if (isMeeting) {
//        label.text = [NSString stringWithFormat:@"  %@",[_sectionArray objectAtIndex:section]];
//        return label;
//    } else if (isNotice) {
//        label.text = [NSString stringWithFormat:@"  %@",[_sectionArray objectAtIndex:section]];
//        return label;
//    }
    return 0;
}


//点击header的方法
-(void)tapHeader:(UIButton *)sender
{
    if ([[openedInSectionArr objectAtIndex:sender.tag - 100] intValue] == 0) {
        [openedInSectionArr replaceObjectAtIndex:sender.tag - 100 withObject:@"1"];
        NSLog(@"%d打开",sender.tag);
        [sender setImage:[UIImage imageNamed:@"table_section_down"] forState:UIControlStateNormal];
    }
    else
    {
        [openedInSectionArr replaceObjectAtIndex:sender.tag - 100 withObject:@"0"];
        NSLog(@"%d关闭",sender.tag);
        [sender setImage:[UIImage imageNamed:@"table_section_left"] forState:UIControlStateNormal];
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (isMeeting){
        if ([[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count] > 0){
            return 30;
        }else{
            return 0;
        }
    } else if (isNotice) {
        if ([[_sectionDictionary objectForKey:[_sectionArray objectAtIndex:section]] count] > 0){
            return 30;
        }else{
            return 0;
        }
    }
//    if (isMeeting){
//        return 20;
//    } else if (isNotice) {
//        return 20;
//    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //yangz ADD 有数据不显示提示信息
    [noneDataLabel setHidden:YES];
    if (isMeeting) {
        static NSString* identify = @"meetcell";
        SKCMeetCell*  cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[SKCMeetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        NSString* sectionName  = [_sectionArray objectAtIndex:indexPath.section];//获取section 的名字
        NSArray * sectionArray = [_sectionDictionary objectForKey:sectionName];  //获取本section 的数据
        NSDictionary*dataDictionary = [sectionArray objectAtIndex:indexPath.row];
        
        [cell setCMSInfo:dataDictionary Section:indexPath.section];
        [cell resizeCellHeight];
        return cell;

    } else if (isNotice) {
        NSString* sectionName  = [_sectionArray objectAtIndex:indexPath.section];//获取section 的名字
        NSArray * sectionArray = [_sectionDictionary objectForKey:sectionName];  //获取本section 的数据
        NSDictionary*dataDictionary = [sectionArray objectAtIndex:indexPath.row];
        
        if ([[dataDictionary allKeys] count] == 1) {
            UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:0];
            cell.textLabel.text = @"暂无数据";
            return cell;
        }
        static NSString* identify = @"noticecell";
        SKTableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[SKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        [cell setECMInfo:dataDictionary Section:indexPath.section];
        [cell resizeCellHeight];
        return cell;
        
    } else {
        static NSString* identify = @"newscell";
        SKTableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell)
        {
            cell = [[SKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        [cell setECMInfo:_dataItems[indexPath.row]];
        [cell resizeCellHeight];
        return cell;
    }
}

-(void)deselect{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"browse" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"browse"]) {
        if (isMeeting) {
            NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
            NSString* sectionName  = [_sectionArray objectAtIndex:selectedIndexPath.section];//获取section 的名字
            NSArray * sectionArray = [_sectionDictionary objectForKey:sectionName];  //获取本section 的数据
            SKECMBrowseController *browser = (SKECMBrowseController *)[segue destinationViewController];
            browser.channel = self.channel;
            browser.currentDictionary = sectionArray[selectedIndexPath.row];;
        } else if (isNotice){
            NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
            NSString* sectionName  = [_sectionArray objectAtIndex:selectedIndexPath.section];//获取section 的名字
            NSArray * sectionArray = [_sectionDictionary objectForKey:sectionName];  //获取本section 的数据
            SKECMBrowseController *browser = (SKECMBrowseController *)[segue destinationViewController];
            browser.channel = self.channel;
            browser.currentDictionary = sectionArray[selectedIndexPath.row];;
        } else {
            NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
            NSMutableDictionary* dict = _dataItems[selectedIndexPath.row];
            SKECMBrowseController *browser = (SKECMBrowseController *)[segue destinationViewController];
            browser.channel = self.channel;
            browser.currentDictionary = dict;
            if (![[dict objectForKey:@"READED"] intValue])
            {
                NSString* sql =[NSString stringWithFormat:@"update T_DOCUMENTS set READED = 1 where AID  = '%@'",[_dataItems[selectedIndexPath.row] objectForKey:@"AID"]];
                [dict setObject:@"1" forKey:@"READED"];
                [self.tableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[DBQueue sharedbQueue] updateDataTotableWithSQL:sql];
                });
            }
        }
    }
    [self deselect];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isMeeting) {
        NSString* sectionName  = [_sectionArray objectAtIndex:indexPath.section];//获取section 的名字
        NSArray * sectionArray = [_sectionDictionary objectForKey:sectionName];  //获取本section 的数据
        NSDictionary*  dataDictionary = [sectionArray objectAtIndex:indexPath.row];
        return [dataDictionary[@"TITL"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16.]
                                          constrainedToSize:CGSizeMake(280, 220)
                                              lineBreakMode:NSLineBreakByCharWrapping].height+55;
    } else if (isNotice) {
        NSString* sectionName  = [_sectionArray objectAtIndex:indexPath.section];//获取section 的名字
        NSArray * sectionArray = [_sectionDictionary objectForKey:sectionName];  //获取本section 的数据
        NSDictionary*  dataDictionary = [sectionArray objectAtIndex:indexPath.row];
        return [dataDictionary[@"TITL"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16.]
                                   constrainedToSize:CGSizeMake(280, 220)
                                       lineBreakMode:NSLineBreakByCharWrapping].height+30;
    } else {
        return [_dataItems[indexPath.row][@"TITL"]  sizeWithFont:[UIFont fontWithName:@"Helvetica" size:16.]
                                                      constrainedToSize:CGSizeMake(280, 220)
                                                          lineBreakMode:NSLineBreakByTruncatingTail].height + 30;
    }
}

#pragma mark - table show MSG yangzhi add
-(void)showMsg
{
    //判断不是会议也不是消息通知
    if (!isNotice && !isMeeting)
    {
        if (_dataItems.count>0)
        {
            [noneDataLabel setHidden:YES];
        }
        else
        {
            if (!noneDataLabel)
            {
                noneDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
                noneDataLabel.textAlignment = NSTextAlignmentCenter;
                noneDataLabel.textColor = [UIColor lightGrayColor];
                noneDataLabel.text = @"没有数据或正在加载数据...";
                noneDataLabel.center = self.view.center;
                [self.view addSubview:noneDataLabel];
            }
            else
            {
                [noneDataLabel setHidden:NO];
            }
        }
    }
}
@end
