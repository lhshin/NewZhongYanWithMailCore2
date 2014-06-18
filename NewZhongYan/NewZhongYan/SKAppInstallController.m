//
//  SKAppInstallController.m
//  NewZhongYan
//
//  Created by lilin on 14-3-20.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKAppInstallController.h"

@implementation SKAppInstallController
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (System_Version_Small_Than_(7)) {
        UIButton* backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backbtn setFrame:CGRectMake(0, 0, 50, 30)];
        [backbtn setBackgroundImage:Image(@"back") forState:UIControlStateNormal];
        [backbtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
        self.navigationItem.leftBarButtonItem = backItem;
    }else{
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backItem;
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://tam.hngytobacco.com/d/"]];
    [_webview loadRequest:request];
}
@end
