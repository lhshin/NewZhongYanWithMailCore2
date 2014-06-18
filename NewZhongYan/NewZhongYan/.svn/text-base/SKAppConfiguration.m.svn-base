//
//  SKAppConfiguration.m
//  ZhongYan
//
//  Created by 袁树峰 on 13-4-9.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKAppConfiguration.h"
#import "SKConfigureCell.h"
#import "SKEmailConfigurationView.h"
#import "utils.h"
@interface SKAppConfiguration ()
{
    UITableView *leftTableView;
    UIView *rightView;
    NSArray *dataArray;
}
@end

@implementation SKAppConfiguration
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"应用设置";
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
    
    
    //初始化数据
    [self initData];
    
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(66, TopY, 320-66,ScreenHeight)];
    [imageView setImage:[UIImage imageNamed:@"bg.png"]];
    [imageView setUserInteractionEnabled:YES];
    [self.view addSubview:imageView];
    
    leftTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, TopY, 66, ScreenHeight) style:UITableViewStylePlain];
    [leftTableView setBackgroundColor:[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1]];
    [leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:leftTableView];
    [leftTableView setDelegate:self];
    [leftTableView setDataSource:self];
    [leftTableView reloadData];
    
    rightView=[[UIView alloc] initWithFrame:CGRectMake(66,TopY, 320-66,ScreenHeight)];
    [rightView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:rightView];
    
    if (dataArray.count>0)
    {
        NSDictionary *dic=[dataArray objectAtIndex:0];
        NSString *viewName=[dic objectForKey:@"view"];
        Class cls = NSClassFromString(viewName);
        if (cls)
        {
            NSObject *obj = [cls alloc];// 代码问题
            obj=[[[NSBundle mainBundle] loadNibNamed:viewName owner:self options:nil] objectAtIndex:0];
            SEL initSEL = NSSelectorFromString(@"initSelf");
            if ([obj respondsToSelector:initSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [obj performSelector:initSEL];
#pragma clang diagnostic pop
                
            }
            [rightView addSubview:(UIView *)obj];
        }
    }
    
}

-(void)initData
{
    //暂时采用固定模式 以后采用读取xml的方式
    NSDictionary *emailDic=[NSDictionary dictionaryWithObjectsAndKeys:
        [UIImage imageNamed:@"icon_email.png"],@"image",@"邮件",@"title",@"SKEmailConfigurationView",@"view",nil];
    
    dataArray=[[NSArray alloc] initWithObjects:emailDic, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -tableViewDataScource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tIdentify = @"maintainCell";
    SKConfigureCell* cell = [tableView dequeueReusableCellWithIdentifier:tIdentify];
    if (!cell) {
        cell = [[SKConfigureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:76 green:160 blue:220 alpha:0.7]];
    
    NSDictionary *dic=[dataArray objectAtIndex:indexPath.row];
    [cell.iconImageView setImage:[dic objectForKey:@"image"]];
    [cell.titleL setText:[dic objectForKey:@"title"]];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88.;
}

#pragma mark -tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIView *vi in rightView.subviews)
    {
        [vi removeFromSuperview];
    }
    NSDictionary *dic=[dataArray objectAtIndex:indexPath.row];
    NSString *viewName=[dic objectForKey:@"view"];
    Class cls = NSClassFromString(viewName);
    if (cls)
    {
        NSObject *obj = [cls alloc];
        obj=[[[NSBundle mainBundle] loadNibNamed:viewName owner:self options:nil] objectAtIndex:0];
        SEL initSEL = NSSelectorFromString(@"initSelf");
        if ([obj respondsToSelector:initSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [obj performSelector:initSEL];
#pragma clang diagnostic pop
        }
        [rightView addSubview:(UIView *)obj];
    }
}
@end
