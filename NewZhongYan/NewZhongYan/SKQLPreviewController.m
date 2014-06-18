//
//  SKQLPreviewController.m
//  ZhongYan
//
//  Created by linlin on 8/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SKQLPreviewController.h"
#import "SKAppDelegate.h"
#import "utils.h"
@implementation SKQLPreviewController
- (void)setbackBtn
{
    [self viewWillLayoutSubviews];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //解决becomeActive 后返回按钮编程原来的颜色的bug
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setbackBtn) name:@"resume" object:0];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) 
	{
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:20.0];
        titleView.shadowColor = [UIColor colorWithRed:0.9373 green:0.9451 blue:0.9529 alpha:1.0000];
        titleView.shadowOffset = CGSizeMake(0.0, 1.0);
        titleView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
        titleView.textColor = [UIColor colorWithRed:0.3020 green:0.3294 blue:0.3608 alpha:1.0000]; // set this to whatever you like
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}
#pragma mark - View lifecycle
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"文档详情";
    self.navigationItem.titleView = label;
    if (System_Version_Small_Than_(7)) {
        UIButton* backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backbtn setFrame:CGRectMake(0, 0, 50, 30)];
        [backbtn setBackgroundImage:Image(@"back") forState:UIControlStateNormal];
        [backbtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
        self.navigationItem.leftBarButtonItem = backItem;

        //这里暂时没有办法解决
        UIButton* rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightbtn setFrame:CGRectMake(0, 0, 50, 30)];
        [rightbtn setBackgroundImage:Image(@"back") forState:UIControlStateNormal];
        [rightbtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
        self.navigationItem.rightBarButtonItem = rightItem;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationController.navigationItem.rightBarButtonItem = nil;
    }else{
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] init];
        backItem.title = @"返回";
        self.navigationItem.backBarButtonItem = backItem;
    }
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [[self navigationItem] setRightBarButtonItem:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ShowPreView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self navigationItem] setRightBarButtonItem:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShowPreView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
