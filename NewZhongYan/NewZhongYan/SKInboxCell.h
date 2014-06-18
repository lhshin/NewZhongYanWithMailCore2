//
//  SKInboxCell.h
//  NewZhongYan
//
//  Created by lilin on 13-11-1.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKEmailController.h"
@interface SKInboxCell : UITableViewCell<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UIImageView *stateView;
@property (weak, nonatomic) IBOutlet UILabel *mailSizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *attachView;
@property (weak, nonatomic) IBOutlet UILabel *recipientLabel;
@property (weak, nonatomic) IBOutlet UILabel *senddateLabel;
@property (weak, nonatomic) SKEmailController *parentController;
-(void)setMail:(NSDictionary*)mailInfo;

@end
