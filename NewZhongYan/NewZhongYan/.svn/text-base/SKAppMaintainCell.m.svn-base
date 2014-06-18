//
//  SKAppMaintainCell.m
//  ZhongYan
//
//  Created by 袁树峰 on 13-3-13.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKAppMaintainCell.h"

@implementation SKAppMaintainCell
{
    __weak IBOutlet UIImageView *icon;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *sizeLabel;

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}
- (IBAction)clearData:(id)sender {
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.tag],@"tag", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cleanLocalDataNote" object:nil userInfo:dict];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataInfo:(NSDictionary*)dict
{
    sizeLabel.text=[dict objectForKey:@"size"];
    nameLabel.text=[dict objectForKey:@"title"];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
