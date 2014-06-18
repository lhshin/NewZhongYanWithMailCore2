//
//  SKDraftboxCell.h
//  NewZhongYan
//
//  Created by lilin on 13-11-5.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKEmailController.h"
@interface SKDraftboxCell : UITableViewCell
<UIActionSheetDelegate>
@property(nonatomic,weak)IBOutlet UILabel* subjectLabel;
@property(nonatomic,weak)IBOutlet UILabel* recipientLabel;
@property(nonatomic,weak)IBOutlet UILabel* senddateLabel;
@property(nonatomic,weak)IBOutlet UIImageView *stateView;
@property (weak, nonatomic) SKEmailController *parentController;
-(void)setMail:(NSDictionary*)mailInfo;
@end
