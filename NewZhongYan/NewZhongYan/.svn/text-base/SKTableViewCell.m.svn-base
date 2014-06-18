//
//  SKRootCell.m
//  ZhongYan
//
//  Created by 李 林 on 4/12/13.
//  Copyright (c) 2013 surekam. All rights reserved.
//

#import "SKTableViewCell.h"
#import "utils.h"
@implementation SKTableViewCell
{
    UILabel *_titleLabel;
    UILabel *_crtmLabel;
    UIImageView *_stateView;
    UIImageView *_attachView;
    UIView*      _attachBgView;
    UIImageView* pictureImageView;
    UIImageView* contentImageView;
    UIImageView* attachImageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFrame:CGRectMake(25, 10, 280, 40)];
        [_titleLabel setFont: [UIFont fontWithName:@"Helvetica" size:16.]];
        [_titleLabel setNumberOfLines:0];
        [_titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [self addSubview:_titleLabel];
        
        _crtmLabel = [[UILabel alloc]init];
        [_crtmLabel setBackgroundColor:[UIColor clearColor]];
        [_crtmLabel setFont:[UIFont systemFontOfSize:10]];
        [_crtmLabel setTextAlignment:NSTextAlignmentRight];
        [_crtmLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_crtmLabel];
        
        _attachView = [[UIImageView alloc]initWithImage: [UIImage imageNamed:@"cms_attachment.png"]];
        [self addSubview:_attachView];
        
        
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

        _stateView = [[UIImageView alloc]init];
        [self addSubview:_stateView];
    }
    return self;
}

-(void)setAttachViewImage:(NSString*)attachName
{
    CGFloat X = 0;
    //判断图片字段是否为null
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

-(void)setECMInfo:(NSDictionary*)info
{
    [_attachView setHidden:YES];
    if ([info.allKeys containsObject:@"TITL"]) {
        _titleLabel.text =  [info objectForKey:@"TITL"];
    }
    
    if ([info.allKeys containsObject:@"CRTM"]) {
        [_crtmLabel setText:[info objectForKey:@"CRTM"]];
    }
    [self setAttachViewImage:info[@"ATTRLABLE"]];
    if (![[info objectForKey:@"READED"] intValue]) {
        [_stateView  setImage:Image(@"icon_unread")];
    }else{
        [_stateView setImage:Image(@"icon_read")];
    }
}

-(void)setECMInfo:(NSDictionary*)info Section:(NSInteger)section
{
    [_attachView setHidden:YES];
    if ([info.allKeys containsObject:@"TITL"]) {
        _titleLabel.text = [info objectForKey:@"TITL"];
    }
    
    if ([info.allKeys containsObject:@"CRTM"]) {
        [_crtmLabel setText:[info objectForKey:@"CRTM"]];
    }
    [self setAttachViewImage:info[@"ATTRLABLE"]];
    if (![[info objectForKey:@"READED"] intValue]) {
        [_stateView  setImage:Image(@"icon_unread")];
    }else{
        [_stateView setImage:Image(@"icon_read")];
    }
    
    if (!section) {
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
        [_crtmLabel setText:[info objectForKey:@"CRTM"]];
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

-(void)setECMPaperInfo:(Paper*)paper
{
    _titleLabel.text =  paper.title;
    _crtmLabel.text =  paper.time;
    [_attachView setHidden:NO];
}

-(void)dealloc
{

}

-(BOOL)containAttachement:(NSDictionary*)dict
{
    if ([[dict allKeys] containsObject:@"ATTS"]) {
        return  [[[dict objectForKey:@"ATTS"] componentsSeparatedByString:@","] count] > 1;
    }else{
        return NO;
    }
}

-(void)setRemindInfo:(NSDictionary*)remind
{
    [_attachBgView setHidden:YES];
    NSString* flowInstanceId = [remind objectForKey:@"FLOWINSTANCEID"];
    if ([[remind objectForKey:@"HANDLE"] intValue] == 0
        || [flowInstanceId isEqual:[NSNull null]]//不可处理
        || [flowInstanceId isEqualToString:@"0"]
        || [flowInstanceId isEqualToString:@""]) {
        [_attachView setImage:[UIImage imageNamed:@"undispose"]];
    }else if ([[remind objectForKey:@"HANDLE"] intValue] == 1){//仅阅读
        [_attachView setImage:[UIImage imageNamed:@"list_onlyread"]];
    }else if ([[remind objectForKey:@"HANDLE"] intValue] == 2){//可处理
        [_attachView setImage:[UIImage imageNamed:@"dispose"]];
    }else{
        [_attachView setImage:[UIImage imageNamed:@"undispose"]];
    }
    _titleLabel.text = [remind objectForKey:@"TITL"];
    _crtmLabel.text =  [[[remind objectForKey:@"CRTM"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] substringToIndex:16];
    if ([remind[@"STATUS"] intValue] == -1) {
        [_stateView  setImage:Image(@"icon_unread")];
    }else{
        [_stateView  setImage:Image(@"icon_read")];
    }
}

-(void)resizeCellHeight
{
    CGFloat contentWidth = 280;
    CGFloat height = [_titleLabel.text sizeWithFont:_titleLabel.font
                                  constrainedToSize:CGSizeMake(contentWidth, 220)
                                      lineBreakMode:NSLineBreakByCharWrapping].height;
    
    [_titleLabel  setFrame:CGRectMake(25, 8, 280, height)];
    [_stateView   setFrame:CGRectMake(5, CGRectGetMidY(_titleLabel.frame) - 7.5, 15, 15)];
    [_attachView  setFrame:CGRectMake(25,CGRectGetMaxY(_titleLabel.frame)+5, 30, 15)];
    [_attachBgView  setFrame:CGRectMake(25,CGRectGetMaxY(_titleLabel.frame)+5, 85, 15)];
    [_crtmLabel   setFrame:CGRectMake(205,CGRectGetMaxY(_titleLabel.frame)+5, 100, 21)];
}

//渲染该cell
-(void)setDataDictionary:(NSDictionary*)dictionary
{
    if ([dictionary.allKeys containsObject:@"TITL"]) {
        _titleLabel.text =  [dictionary objectForKey:@"TITL"];
    }
    
    if ([dictionary.allKeys containsObject:@"CRTM"]) {
        [_crtmLabel setText:[dictionary objectForKey:@"CRTM"]];
    }
    
    [_attachView setHidden:![self containAttachement:dictionary]];
    if (![[dictionary objectForKey:@"READED"] intValue]) {
        [_stateView  setImage:Image(@"icon_unread")];
    }else{
        [_stateView setImage:Image(@"icon_read")];
    }
}
@end
