//
//  SKAddressController.h
//  NewZhongYan
//
//  Created by lilin on 13-10-30.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKToolBar.h"
#import "PullingRefreshTableView.h"
#import "SKCKeyBoards.h"
#import "SKEmployeeCell.h"
#import "SKMailEmployeeCell.h"
@interface SKAddressController : UIViewController
<SKCKeyBoardsDelegate,UITableViewDataSource,PullingRefreshTableViewDelegate,UITableViewDelegate,UIActionSheetDelegate,SKDataDaemonHelperDelegate>
{
    NSMutableArray              *_dataDPIDs;        //存储当前在oranazitionBar 上面的 DPID 号
    NSMutableArray              *_dataEShowed;
    NSMutableArray              *_dataUShowed;
    NSMutableArray              *_dataEItems;       //存储员工
    NSMutableArray              *_dataUItems;       //存储部门
    NSMutableArray              *_dataTitles;       //存储标题
    NSMutableArray              *_dataSITems;       //存储本部门的员工
    NSMutableArray              *selectedEmployees;//选择的员工
    __weak IBOutlet UIView *orgazationBar;
    __weak IBOutlet UIView *toolView;
    PullingRefreshTableView *dataTable;
    SKCKeyBoards                *keyboard;
    NSInteger currentindex;
    UINib *cellNib;
    UINib *mailCellNib;
}
@property (nonatomic,weak)IBOutlet SKEmployeeCell *tmpCell;
@property (nonatomic,weak)IBOutlet SKMailEmployeeCell *tmpMailCell;
@property (nonatomic,strong)UIButton *controlButton;
@property (nonatomic,strong)UIButton *showButton;
@property BOOL isMail;
@end
