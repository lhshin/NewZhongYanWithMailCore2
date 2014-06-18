//
//  SKDraftboxCell.m
//  NewZhongYan
//
//  Created by lilin on 13-11-5.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKDraftboxCell.h"

@implementation SKDraftboxCell
{
    __weak NSDictionary* mailinfo;
}
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

    // Configure the view for the selected state
}

-(void)setMail:(NSDictionary*)mailInfo
{
    mailinfo = mailInfo;
    self.recipientLabel.text = [mailinfo objectForKey:@"TO_TEXT"];
    self.subjectLabel.text = [mailinfo objectForKey:@"SUBJECT"];
    if (self.subjectLabel.text == (NSString *)[NSNull null] || self.subjectLabel.text.length == 0)
    {
        self.subjectLabel.text = @"无主题";
    }
    NSDate* date = [DateUtils stringToDate:[mailinfo objectForKey:@"SENTDATE"] DateFormat:displayDateTimeFormat];
    self.senddateLabel.text =  [date dateToDetail];
}
@end
