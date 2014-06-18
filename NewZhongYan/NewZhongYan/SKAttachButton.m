//
//  SKAttachButton.m
//  HNZYiPad
//
//  Created by lilin on 13-6-22.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import "SKAttachButton.h"
@implementation SKAttachButton
@synthesize DSImageView = _DSImageView;
@synthesize attachLabel = _attachLabel;
@synthesize indicator = _indicator;
@synthesize progresser;
@synthesize attachUrl;
@synthesize filePath;
@synthesize isAttachExisted;
@synthesize request = _request;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        previewController = [[SKQLPreviewController alloc] init];
        previewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        CGRect rect = CGRectInset(self.bounds, 1, 5);
        UIView* bgview = [[UIView alloc] initWithFrame:rect];
        [bgview setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bgview];
        bgview.layer.borderWidth = 1;
        bgview.layer.borderColor = [COLOR(51, 183, 229) CGColor];
        bgview.layer.cornerRadius = 4;
        
        _attachLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 235, 20)];
        [_attachLabel setUserInteractionEnabled:YES];
        [_attachLabel setTextColor:[UIColor blackColor]];
        [_attachLabel setBackgroundColor:[UIColor clearColor]];
        [_attachLabel setTextAlignment:NSTextAlignmentLeft];
        [_attachLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
        [_attachLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_attachLabel];
        
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLabelClicked:)];
        [_attachLabel addGestureRecognizer:gesture];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicator setFrame:CGRectMake(264, 5, 38, 38)];
        [self addSubview:_indicator];
        
        delelteAttachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delelteAttachBtn setBackgroundImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
        [delelteAttachBtn setBackgroundImage:[UIImage imageNamed:@"btn_delete_highlight"] forState:UIControlStateHighlighted];
        [delelteAttachBtn setFrame:CGRectMake(frame.size.width - 28, 10, 25, 25)];
        [delelteAttachBtn addTarget:self action:@selector(deleteAttachment:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:delelteAttachBtn];
        
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadButton setBackgroundImage:[UIImage imageNamed:@"btn_download"] forState:UIControlStateNormal];
        [_downloadButton setBackgroundImage:[UIImage imageNamed:@"btn_download_highlight"] forState:UIControlStateHighlighted];
        [_downloadButton setFrame:CGRectMake(frame.size.width - 28, 10, 24, 24)];
        [_downloadButton addTarget:self action:@selector(loadAttachment) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_downloadButton];
        
        progresser = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        if (System_Version_Small_Than_(7)) {
            [progresser setProgressImage:Image(@"progress")];
            [progresser setTrackImage:Image(@"track")];
        }
        //[progresser setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 15)];
        [progresser setCenter:CGPointMake(self.frame.size.width/2 - 60, self.frame.size.height/2 + 15)];
        rect = progresser.frame;
        rect.size.width += 90;
        progresser.frame = rect;
        [progresser setHidden:YES];
        [self addSubview:progresser];
        [self addTarget:self action:@selector(loadAttachment) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initNoBorderBtnWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        previewController = [[SKQLPreviewController alloc] init];
        previewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        CGRect rect = CGRectInset(self.bounds, 1, 5);
        UIView* bgview = [[UIView alloc] initWithFrame:rect];
        [bgview setBackgroundColor:[UIColor clearColor]];
        [self addSubview:bgview];
        bgview.layer.borderWidth = 1;
        bgview.layer.borderColor = [COLOR(51, 183, 229) CGColor];
        bgview.layer.cornerRadius = 4;
        
        _attachLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12, 235, 20)];
        [_attachLabel setTextColor:[UIColor blackColor]];
        [_attachLabel setBackgroundColor:[UIColor clearColor]];
        [_attachLabel setTextAlignment:NSTextAlignmentLeft];
        [_attachLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
        [_attachLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_attachLabel];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicator setFrame:CGRectMake(255, 5, 38, 38)];
        [self addSubview:_indicator];
        
        delelteAttachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delelteAttachBtn setBackgroundImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
        [delelteAttachBtn setBackgroundImage:[UIImage imageNamed:@"btn_delete_highlight"] forState:UIControlStateHighlighted];
        [delelteAttachBtn setFrame:CGRectMake(frame.size.width - 35, 10, 25, 25)];
        [delelteAttachBtn addTarget:self action:@selector(deleteAttachment:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:delelteAttachBtn];
        
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadButton setBackgroundImage:[UIImage imageNamed:@"btn_download"] forState:UIControlStateNormal];
        [_downloadButton setBackgroundImage:[UIImage imageNamed:@"btn_download_highlight"] forState:UIControlStateHighlighted];
        [_downloadButton setFrame:CGRectMake(frame.size.width - 34, 10, 24, 24)];
        [_downloadButton addTarget:self action:@selector(loadAttachment) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_downloadButton];
        
        progresser = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        [progresser setCenter:CGPointMake(self.frame.size.width/2 - 60, self.frame.size.height/2 + 13)];
        rect = progresser.frame;
        rect.size.width += 90;
        progresser.frame = rect;
        [progresser setHidden:YES];
        [self addSubview:progresser];
        [self addTarget:self action:@selector(loadAttachment) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    //[super setTitle:title forState:state];
    _attachLabel.text = title;
}

-(void)dealloc{
    [_request clearDelegatesAndCancel];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController{return 1;}

- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx{
    if (self.filePath) {
        return [NSURL fileURLWithPath:self.filePath];
    }
    return 0;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            NSError* error = nil;
            [SKHTTPRequest removeFileAtPath:self.filePath error:&error];
            if (error) {
                NSLog(@"删除失败");
            }else{
                [self setIsAttachExisted:NO];
            }
        }
    }
    
    if (alertView.tag == 1002) {
        if (buttonIndex == 1) {
            if ([_request isExecuting])
            {
                [_request clearDelegatesAndCancel];
                [ASIHTTPRequest removeFileAtPath:self.filePath error:0];
                [self.progresser setHidden:YES];
                [self.indicator stopAnimating];
                return;
            }
            _request = [[SKHTTPRequest alloc] initWithURL:self.attachUrl];
            [_request setDownloadDestinationPath:self.filePath];
            [_request setDownloadProgressDelegate:self.progresser];
            [_request setDelegate:self];
            [_request startAsynchronous];
        }
    }
}

-(void)onLabelClicked:(UITapGestureRecognizer*)gesture
{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

-(void)loadAttachment{
    if (self.attachUrl && self.filePath)
    {
        previewController.dataSource = self;
        previewController.delegate = self;
        previewController.currentPreviewItemIndex = 0;
        if (self.isAttachExisted)
        {
            id<QLPreviewItem> a = [NSURL fileURLWithPath:self.filePath];
            if ([QLPreviewController canPreviewItem:a])
            {
                [[[APPUtils visibleViewController] navigationController] pushViewController:previewController animated:YES];
            }
            return;
        }
        
        if ([_request isExecuting])
        {
            [_request clearDelegatesAndCancel];
            [ASIHTTPRequest removeFileAtPath:self.filePath error:0];
            [_downloadButton setHidden:NO];
            [self.progresser setHidden:YES];
            [self.indicator stopAnimating];
            return;
        }
        
        
        if ([APPUtils currentReachabilityStatus] == ReachableViaWWAN) {
            UIAlertView* alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络为3G状态，继续下载会使用大量的流量..." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
            [alter setTag:1002];
            [alter show];
            return;
        }
        _request = [[SKHTTPRequest alloc] initWithURL:self.attachUrl];
        [_request setShowAccurateProgress:YES];
        [_request setDownloadDestinationPath:self.filePath];
        [_request setDownloadProgressDelegate:self.progresser];
        [_request setDelegate:self];
        [_request startAsynchronous];
    }
}

- (void)requestFinished:(SKHTTPRequest *)req{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([req responseStatusCode] != 200)
        {
            [ASIHTTPRequest removeFileAtPath:self.filePath error:0];
            [UIAlertView showAlertString:@"服务器内部异常..."];
            return ;
        }
        [self setIsAttachExisted:YES];
        [self.indicator stopAnimating];
        [self.progresser setHidden:YES];
        
        id<QLPreviewItem> a = [NSURL fileURLWithPath:self.filePath];
        if ([QLPreviewController canPreviewItem:a])
        {
            UIViewController* controller = [APPUtils visibleViewController];
            if ([controller isKindOfClass:[SKQLPreviewController class]]) {
                return;
            }
            [[controller navigationController] pushViewController:previewController animated:YES];
        }
    });
}

- (void)requestFailed:(SKHTTPRequest *)req{
    [self.indicator stopAnimating];
    [self.progresser setHidden:YES];
    [_downloadButton setHidden:NO];

    [ASIHTTPRequest removeFileAtPath:self.filePath error:0];
    if (req.errorcode) {
        [UIAlertView showAlertString:@"服务器不存在该资源"];
    }else{
        [UIAlertView showAlertString:@"获取数据失败"];
    }
}

- (void)request:(SKHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary*)responseHeaders{
    //NSLog(@"%@",responseHeaders);
}

- (void)requestStarted:(SKHTTPRequest *)request{
    [self.indicator startAnimating];
    [self.progresser setHidden:NO];
    [_downloadButton setHidden:YES];
}


-(void)deleteAttachment:(id)sender{
    UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该文件吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [av setTag:1001];
    [av show];
}

-(void)setIsAttachExisted:(BOOL)attachExisted{
    isAttachExisted = attachExisted;
    [delelteAttachBtn setHidden:!attachExisted];
    [_downloadButton setHidden:attachExisted];
    if (attachExisted) {
        [self setImage:[UIImage imageNamed:@"doc_downloaded.png"] forState:UIControlStateNormal];
    }else{
        [self setImage:[UIImage imageNamed:@"doc_downloading.png"] forState:UIControlStateNormal];
    }
}
@end
