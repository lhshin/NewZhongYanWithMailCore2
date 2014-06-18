//
//  SKNextBranchesController.h
//  ZhongYan
//
//  Created by linlin on 9/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKHTTPRequest.h"
#import "aNextBranches.h"
#import "branches.h"
@interface SKNextBranchesController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    SKHTTPRequest *NBRequest;
    NSString        *uid;
    NSString        *tfrm;
    NSString        *aid;
    NSString        *bid;
    NSDictionary    *GTaskInfo;
    aNextBranches   *nextBranches;
    UITableView     *_tableView;
    CGFloat         currentHeight;
    NSIndexPath*     selectedRow;
    NSUInteger      branchCount;
}

-(id)initWithDictionary:(NSDictionary*)dictionary;
@property(nonatomic,retain)NSString        *uid;
@property(nonatomic,retain)NSDictionary    *GTaskInfo;
@property(nonatomic,retain)aNextBranches   *nextBranches;
@property(nonatomic,retain)UITableView     *tableView;
@property(nonatomic,retain)NSString        *bid;
@end
