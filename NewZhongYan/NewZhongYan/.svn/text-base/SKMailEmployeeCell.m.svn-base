//
//  SKMailEmployeeCell.m
//  NewZhongYan
//
//  Created by lilin on 13-11-4.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKMailEmployeeCell.h"

@implementation SKMailEmployeeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.statusImageView setImage:[UIImage imageNamed:@"check.png"]];

    }else{
        [self.statusImageView setImage:[UIImage imageNamed:@"uncheck.png"]];
    }
}
-(void)setEmployee:(NSMutableDictionary*)dict
{
    self.name.text = [dict objectForKey:@"CNAME"];
    self.email.text = [dict objectForKey:@"EMAIL"];
    self.position.text = [dict objectForKey:@"TNAME"];
    if ([dict objectForKey:@"UCNAME"] == [NSNull null])
    {
        self.department.text = @"";
    }else{
        self.department.text = [dict objectForKey:@"PNAME"];
    }
}
@end
