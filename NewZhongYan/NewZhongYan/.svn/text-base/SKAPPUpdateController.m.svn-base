//
//  SKAPPUpdateController.m
//  NewZhongYan
//
//  Created by lilin on 13-10-21.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKAPPUpdateController.h"

@interface SKAPPUpdateController ()

@end

@implementation SKAPPUpdateController
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    if (actualSize.height>=webView.frame.size.height)
    {
        [(UIScrollView *)[webView.subviews objectAtIndex:0] setScrollEnabled:YES];
    }
    else
    {
        [(UIScrollView *)[webView.subviews objectAtIndex:0] setScrollEnabled:NO];
    }
}

-(void)initNavBar
{
    UIImage* navbgImage;
    if (System_Version_Small_Than_(7)) {
        navbgImage = [UIImage imageNamed:@"navbar44"] ;
        self.navigationController.navigationBar.tintColor = COLOR(0, 97, 194);
    }else{
        [self setNeedsStatusBarAppearanceUpdate];
        self.navigationController.navigationBar.translucent = YES;
        navbgImage = [UIImage imageNamed:@"navbar64"] ;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    [self.navigationController.navigationBar setBackgroundImage:navbgImage  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor]};
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initNavBar];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [(UIScrollView *)[infoWebView.subviews objectAtIndex:0] setBounces:NO];
    [infoWebView setDelegate:self];
    [infoWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_versionDic objectForKey:@"PAGEURL"]]]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    currentVersionLabel.text=[infoDictionary objectForKey:@"CFBundleShortVersionString"];
    latestVersionLabel.text=[_versionDic objectForKey:@"SVER"];
    if ([[_versionDic objectForKey:@"FORCEDUP"] boolValue]) {
        [warningLabel setText:@"本次更新为必须更新，否则某些功能将无法正常使用！"];
    }else{
        [warningLabel setText:@"请及时更新软件"];
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches.anyObject view]==downloadBtn)
    {
        [downloadBtn setBackgroundColor:[UIColor colorWithRed:0 green:154.0/255.0 blue:199.0/255.0 alpha:1]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_versionDic objectForKey:@"ALOC"]]];
    }
    if ([touches.anyObject view]==cancelBtn)
    {
        [cancelBtn setBackgroundColor:[UIColor colorWithRed:0 green:154.0/255.0 blue:199.0/255.0 alpha:1]];
        [self dismissViewControllerAnimated:YES completion:^{
        
        }];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches.anyObject view]==downloadBtn)
    {
        [downloadBtn setBackgroundColor:[UIColor colorWithRed:0 green:94.0/255.0 blue:179.0/255.0 alpha:1]];
    }
    if ([touches.anyObject view]==cancelBtn)
    {
        [cancelBtn setBackgroundColor:[UIColor colorWithRed:0 green:94.0/255.0 blue:179.0/255.0 alpha:1]];
    }
}
@end
