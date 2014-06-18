//
//  SKUnitCell.m
//  NewZhongYan
//
//  Created by lilin on 13-10-31.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKUnitCell.h"

@implementation SKUnitCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17, 8, 12)];
        [iv setImage:Image(@"icon_organize.png")];
        [self.contentView addSubview:iv];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 13, 257, 21)];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
@end
