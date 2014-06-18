//
//  SKSearchCell.m
//  NewZhongYan
//
//  Created by lilin on 13-10-29.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKSearchCell.h"
@implementation SKSearchCell
{
    SKLabel *_titleLabel;
    UIImageView *_stateView;
    UIImageView *_attachView;
    UILabel *_crtmLabel;
    UILabel* _STIMELabel;//start
    UILabel* _ETIMELabel;//end
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[SKLabel alloc] init];
        //[_titleLabel setBackgroundColor:COLOR(17, 168, 171)];
        [_titleLabel setFrame:CGRectMake(25, 10, 280, 1)];
        [_titleLabel setFont: [UIFont fontWithName:@"Helvetica" size:16.]];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self addSubview:_titleLabel];
        
        _crtmLabel = [[UILabel alloc]init];
        //[_crtmLabel setBackgroundColor:COLOR(17, 168, 171)];
        [_crtmLabel setFont:[UIFont systemFontOfSize:12]];
        [_crtmLabel setTextAlignment:NSTextAlignmentRight];
        [_crtmLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_crtmLabel];
        
        //用于搜索
        _STIMELabel = [[UILabel alloc] init];
        [_STIMELabel setFont:[UIFont systemFontOfSize:12]];
        [_STIMELabel setTextAlignment:NSTextAlignmentRight];
        [_STIMELabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_STIMELabel];
        
        _ETIMELabel = [[UILabel alloc] init];
        [_ETIMELabel setFont:[UIFont systemFontOfSize:12]];
        [_ETIMELabel setTextAlignment:NSTextAlignmentRight];
        [_ETIMELabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_ETIMELabel];
        
        _attachView = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"cms_attachment.png"]];
        [self addSubview:_attachView];
        
        _stateView = [[UIImageView alloc]init];
        [self addSubview:_stateView];
    }
    return self;
}

-(void)resizeCellHeight
{
    CGFloat height = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(280, 220) lineBreakMode:NSLineBreakByCharWrapping].height;
    [_stateView   setFrame:CGRectMake(5,  height/2  - 7.5 + 12, 15, 15)];
    [_attachView  setFrame:CGRectMake(25, height + 14, 30, 15)];
    [_crtmLabel   setFrame:CGRectMake(205,height + 15, 100, 15)];
}

-(void)resizeMeetCellHeight
{
    CGFloat contentWidth = 280;
    CGFloat height = [_titleLabel.text sizeWithFont:_titleLabel.font constrainedToSize:CGSizeMake(contentWidth, 220) lineBreakMode:NSLineBreakByCharWrapping].height;
    [_titleLabel  setFrame:CGRectMake(25, 10, 280, height)];
    [_stateView setFrame:CGRectMake(5,CGRectGetMidY(_titleLabel.frame) - 7.5, 15, 15)];
    [_STIMELabel setFrame:CGRectMake(67, height + 12, 241, 20)];
    [_ETIMELabel setFrame:CGRectMake(67, height + 32, 241, 20)];
    [_attachView setFrame:CGRectMake(25, height + 32, 30, 15)];
}


//渲染该cell
-(void)setDataDictionary:(NSDictionary*)dictionary
{
    if ([dictionary.allKeys containsObject:@"TITL"]) {
        _titleLabel.text =  [dictionary objectForKey:@"TITL"];
    }
    if ([dictionary.allKeys containsObject:@"CRTM"]) {
        NSString* crtm = [dictionary objectForKey:@"CRTM"];
        if (crtm.length > 16 ) {
            [_crtmLabel setText: [[crtm stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16]];
        }else{
            [_crtmLabel setText:[dictionary objectForKey:@"CRTM"]];
        }
    }
    
    [_attachView setHidden:![self containAttachement:dictionary]];
    if (![[dictionary objectForKey:@"READED"] intValue]) {
        [_stateView  setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_unread" ofType:@"png"]]];
    }else{
        [_stateView setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_read" ofType:@"png"]]];
    }
}

-(void)setRemindInfo:(NSDictionary*)info
{
    if ([info.allKeys containsObject:@"TITL"]) {
        _titleLabel.text = [info objectForKey:@"TITL"];
    }
    
    if ([info.allKeys containsObject:@"CRTM"]) {
        NSString* crtm = [info objectForKey:@"CRTM"];
        if (crtm.length > 16) {//这种情况可能出现在远程查询
            NSDate   *notifyDate = [DateUtils stringToDate:crtm DateFormat:dateTimeFormat];
            NSString *notifyTime = [DateUtils dateToString:notifyDate DateFormat:displayDateTimeFormat];
            crtm = [notifyTime substringToIndex:16];
        }
        [_crtmLabel setText:crtm];
    }
    
    [_attachView setHidden:![self containAttachement:info]];
    if (![[info objectForKey:@"READED"] intValue]) {
        [_stateView  setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_unread" ofType:@"png"]]];
    }else{
        [_stateView setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_read" ofType:@"png"]]];
    }
}

-(void)setMeetInfo:(NSDictionary*)info
{
    if ([info.allKeys containsObject:@"TITL"]) {
        _titleLabel.text = [info objectForKey:@"TITL"];
    }
    
    _STIMELabel.text = [NSString stringWithFormat:@"开始: %@",[[[info objectForKey:@"BGTM"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16]];
    _ETIMELabel.text = [NSString stringWithFormat:@"结束: %@",[[[info objectForKey:@"EDTM"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16]];
    [_attachView setHidden:![self containAttachement:info]];
    if ([info[@"bz"] intValue]) {
        [_stateView  setImage:[UIImage imageNamed:@"icon_unread"]];
    }else{
        [_stateView  setImage:[UIImage imageNamed:@"icon_read"]];
    }
}

-(void)setCMSInfo:(NSDictionary*)info
{
    if ([info.allKeys containsObject:@"TITL"]) {
        _titleLabel.text =  [info objectForKey:@"TITL"];
    }
    
    if ([info.allKeys containsObject:@"CRTM"]) {
        NSString* crtm = [info objectForKey:@"CRTM"];
        if (crtm.length > 16) {//这种情况可能出现在远程查询
            NSDate   *notifyDate = [DateUtils stringToDate:crtm DateFormat:dateTimeFormat];
            NSString *notifyTime = [DateUtils dateToString:notifyDate DateFormat:displayDateTimeFormat];
            crtm = [notifyTime substringToIndex:16];
        }
        [_crtmLabel setText:crtm];
    }
    
    [_attachView setHidden:![self containAttachement:info]];
    if (![[info objectForKey:@"bz"] intValue] && ![[info objectForKey:@"READED"] intValue]) {
        [_stateView  setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_unread" ofType:@"png"]]];
    }else{
        [_stateView setImage:
         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_read" ofType:@"png"]]];
    }
}

-(void)setECMPaperInfo:(Paper*)paper
{
    _titleLabel.text =  paper.title;
    _crtmLabel.text =  paper.time;
    [_stateView  setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_unread" ofType:@"png"]]];
    [_attachView setHidden:YES];
}

-(BOOL)containAttachement:(NSDictionary*)dict
{
    if ([[dict allKeys] containsObject:@"ATTS"]) {
        return  [[[dict objectForKey:@"ATTS"] componentsSeparatedByString:@","] count] > 1;
    }else{
        return NO;
    }
}

-(void)setKeyWord:(NSString*)key
{
    [_titleLabel setKeyWord:key];
}

-(void)setKeyWordArray:(NSMutableArray*)keyArray
{
    [_titleLabel setKeyWordArray:keyArray];
}
@end
