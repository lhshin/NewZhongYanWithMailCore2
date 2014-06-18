//
//  SKMailEmployeeCell.h
//  NewZhongYan
//
//  Created by lilin on 13-11-4.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKMailEmployeeCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel* name;
@property(nonatomic,weak)IBOutlet UILabel* position;
@property(nonatomic,weak)IBOutlet UILabel* department;
@property(nonatomic,weak)IBOutlet UILabel* email;
@property(nonatomic,weak)IBOutlet UIImageView *statusImageView;
@property(nonatomic,assign)BOOL hasBeenSelected;

-(void)setEmployee:(NSMutableDictionary*)dict;
@end
