//
//  SKCMSRootController.h
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface SKCMSRootController : UIViewController<SKDataDaemonHelperDelegate>
{
    
    __weak IBOutlet UIView *toolView;
    NSString                    *_keyWord;
    NSMutableArray              *_dataItems;
    LocalDataMeta               *datameta;
    int                   from;
    NSMutableDictionary         *_sectionDictionary;   //存储section的数据
    NSArray                     *_sectionArray;        //存储section的标题
}
@property (nonatomic,weak)IBOutlet PullingRefreshTableView *tableView;

-(NSDictionary*)praseMeetingArray:(NSArray*)meetings;

-(NSDictionary*)praseWorkNewsArray:(NSArray*)workNews;
/**
 *  刷新执行代码
 */
-(void)onRefrshClick;

/**
 *  搜索执行代码
 */
-(void)onSearchClick;

/**
 *  从数据库获取数据
 *
 *  @param resultset 获取完成数据后，执行的block
 */
-(void)dataFromDataBaseWithComleteBlock:(resultsetBlock)resultset;

/**
 *  返回到主界面
 *
 *  @param sender 点击的按钮
 */
-(void)back:(id)sender;
@end
