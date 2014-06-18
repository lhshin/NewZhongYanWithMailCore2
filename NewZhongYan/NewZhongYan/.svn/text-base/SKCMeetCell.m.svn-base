//
//  SKCMeetCell.m
//  NewZhongYan
//
//  Created by lilin on 13-11-7.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKCMeetCell.h"

@implementation SKCMeetCell
{
    UILabel* _TITLLabel;
    UILabel* _STIMELabel;//start
    UILabel* _ETIMELabel;//end
    UILabel* _MeetAddrLabel;//addition
    UIImageView *_RStateView;
    UIImageView *_ATTACHView;
    
    UIView*      _attachBgView;
    UIImageView* pictureImageView;
    UIImageView* contentImageView;
    UIImageView* attachImageView;
    UIImageView* meetPlaceImageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _RStateView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_read.png"]];
        [self addSubview:_RStateView];
        
        _TITLLabel = [[UILabel alloc] init];
        //[_TITLLabel setBackgroundColor:COLOR(17, 168, 171)];
        [_TITLLabel setFont: [UIFont fontWithName:@"Helvetica" size:16.]];
        [_TITLLabel setNumberOfLines:0];
        [_TITLLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self addSubview:_TITLLabel];
        
        _STIMELabel = [[UILabel alloc] init];
        //[_STIMELabel setBackgroundColor:COLOR(17, 168, 171)];
        [_STIMELabel setFont:[UIFont systemFontOfSize:12]];
        [_STIMELabel setTextAlignment:NSTextAlignmentRight];
        [_STIMELabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_STIMELabel];
        
        _ETIMELabel = [[UILabel alloc] init];
        //[_ETIMELabel setBackgroundColor:COLOR(17, 168, 171)];
        [_ETIMELabel setFont:[UIFont systemFontOfSize:12]];
        [_ETIMELabel setTextAlignment:NSTextAlignmentRight];
        [_ETIMELabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_ETIMELabel];
        
        _MeetAddrLabel = [[UILabel alloc] init];
        //[_MeetAddrLabel setBackgroundColor:COLOR(17, 168, 171)];
        [_MeetAddrLabel setFont:[UIFont systemFontOfSize:12]];
        [_MeetAddrLabel setTextAlignment:NSTextAlignmentLeft];
        [_MeetAddrLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_MeetAddrLabel];
        
        meetPlaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,1,15,15)];
        meetPlaceImageView.image = Image(@"meeting_place");
        [self addSubview:meetPlaceImageView];
        
        _attachBgView = [[UIView alloc] initWithFrame:CGRectMake(25,25, 85, 15)];
        //[_attachBgView setBackgroundColor:COLOR(17, 168, 171)];
        [self addSubview:_attachBgView];
        
        contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,1, 28, 14)];
        contentImageView.image = Image(@"content_unread");
        [_attachBgView addSubview:contentImageView];
        
        pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contentImageView.frame) + 1,1, 28, 14)];
        pictureImageView.image = Image(@"picture_unread");
        [_attachBgView addSubview:pictureImageView];
        
        attachImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pictureImageView.frame) + 1, 1, 28, 14)];
        attachImageView.image = Image(@"attach_unread");
        [_attachBgView addSubview:attachImageView];
        
        _ATTACHView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cms_attachment.png"]];
        //[self addSubview:_ATTACHView];
    }
    return self;
}

-(void)resizeCellHeight
{
    CGFloat contentWidth = 280;
    CGFloat height = [_TITLLabel.text sizeWithFont:_TITLLabel.font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:NSLineBreakByCharWrapping].height;
    [_TITLLabel  setFrame:CGRectMake(25, 10, 280, height)];
    [_RStateView setFrame:CGRectMake(5,CGRectGetMidY(_TITLLabel.frame) - 7.5, 15, 15)];
    [_STIMELabel setFrame:CGRectMake(165, height + 12, 140, 20)];
    [_ETIMELabel setFrame:CGRectMake(165, height + 32, 140, 20)];
    [_MeetAddrLabel setFrame:CGRectMake(35, height + 12, 128, 20)];
    [meetPlaceImageView setFrame:CGRectMake(20, height + 15, 15, 15)];
    [_attachBgView  setFrame:CGRectMake(25, height + 32, 85, 15)];
    //[_ATTACHView setFrame:CGRectMake(25, height + 32, 30, 15)];
}

-(void)setAttachViewImage:(NSString*)attachName
{
    CGFloat X = 0;
    if (![attachName isEqual:[NSNull null]] && [attachName rangeOfString:@"bodyfile"].location != NSNotFound) {
        [contentImageView setHidden:NO];
        X = CGRectGetMaxX(contentImageView.frame) + 1;
    }else{
        [contentImageView setHidden:YES];
    }
    
    if (![attachName isEqual:[NSNull null]] && [attachName rangeOfString:@"bodyimage"].location != NSNotFound) {
        [pictureImageView setHidden:NO];
        [pictureImageView setFrame:CGRectMake(X, 1, 28, 14)];
        X = CGRectGetMaxX(pictureImageView.frame) + 1;
    }else{
        [pictureImageView setHidden:YES];
    }
    
    if (![attachName isEqual:[NSNull null]] && [attachName rangeOfString:@"attachment"].location != NSNotFound) {
        [attachImageView setHidden:NO];
        [attachImageView setFrame:CGRectMake(X, 1, 28, 14)];
    }else{
        [attachImageView setHidden:YES];
    }
}

-(void)setCMSInfo:(NSDictionary*)info Section:(NSInteger)section
{
    if ([info.allKeys containsObject:@"TITL"]) {
        _TITLLabel.text = [info objectForKey:@"TITL"];
    }
    _STIMELabel.text = [NSString stringWithFormat:@"开始: %@",[[[info objectForKey:@"BGTM"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16]];
    _ETIMELabel.text = [NSString stringWithFormat:@"结束: %@",[[[info objectForKey:@"EDTM"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16]];
    
    if (![info[@"ADDITION"] isEqual:[NSNull null]]) {
        NSArray* array = [info[@"ADDITION"] componentsSeparatedByString:@"&"];
        _MeetAddrLabel.text = [array[0] substringFromIndex:13];
        [meetPlaceImageView setHidden:[_MeetAddrLabel.text isEqualToString:@""]];
    }else{
        [meetPlaceImageView setHidden:YES];
    }
    
    [self setAttachViewImage:info[@"ATTRLABLE"]];

    if (!section) {
        [_RStateView  setImage:[UIImage imageNamed:@"icon_unread"]];
    }else{
        [_RStateView  setImage:[UIImage imageNamed:@"icon_read"]];
    }
}

//重新布局
-(void)resizeTheHeight
{
    CGFloat height = [_TITLLabel.text sizeWithFont:_TITLLabel.font constrainedToSize:CGSizeMake(280, 220) lineBreakMode:NSLineBreakByCharWrapping].height;
    [_TITLLabel  setFrame:CGRectMake(25, 10, 280, height)];
    [_RStateView setFrame:CGRectMake(5,CGRectGetMidY(_TITLLabel.frame) - 7.5, 15, 15)];
    [_STIMELabel setFrame:CGRectMake(67, height + 12, 241, 20)];
    [_ETIMELabel setFrame:CGRectMake(67, height + 32, 241, 20)];
    [_ATTACHView setFrame:CGRectMake(25, height + 32, 30, 15)];
}

-(BOOL)containAttachement:(NSDictionary*)dict
{
    return [[[dict objectForKey:@"ATTS"] componentsSeparatedByString:@","] count] > 1;
}
@end
