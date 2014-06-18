//
//  SKECMSearchController.h
//  NewZhongYan
//
//  Created by lilin on 14-1-8.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
	SKSearchTitle = 0,
	SKSearchContent
}SKSearchMode;
@interface SKECMSearchController : UITableViewController<UISearchBarDelegate>
{
    NSMutableArray      *_dataArray;
    BOOL                isRemote;//是否远程查询
    NSMutableArray      *_keyArray;//用来存储key的数组
    int           pageindex;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong,nonatomic)UIButton *moreBtn;
@property (strong,nonatomic)NSString* fidlist;
@property (weak,nonatomic)SKChannel* channel;
@property BOOL isMeeting;
@property BOOL isNotice;
@end
