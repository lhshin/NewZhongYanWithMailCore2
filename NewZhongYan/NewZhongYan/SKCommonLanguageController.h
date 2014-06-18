//
//  SKCommonLanguageController.h
//  ZhongYan
//
//  Created by linlin on 10/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "SKCommonLanguageCell.h"
@interface SKCommonLanguageController : UIViewController<UITableViewDataSource,UITableViewDelegate,HPGrowingTextViewDelegate,UIActionSheetDelegate>
{
    NSMutableArray  *PhraseArray;//用来存储常用语数组
    UITableView     *_tableView;
    NSString        *_textViewKey;
    UIView          *downView;//下方输入框
    HPGrowingTextView     *phraseTextField;
}

@property(nonatomic,strong)NSMutableArray  *PhraseArray;
@property(nonatomic,strong)UITableView     *tableView;
@property(nonatomic,strong)NSString        *textViewKey;
@property(nonatomic,strong)NSString        *textViewText;
@end
