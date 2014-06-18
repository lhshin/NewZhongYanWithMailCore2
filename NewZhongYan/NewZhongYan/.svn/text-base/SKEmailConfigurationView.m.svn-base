//
//  SKEmailConfigurationView.m
//  ZhongYan
//
//  Created by 袁树峰 on 13-4-9.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKEmailConfigurationView.h"
#import "utils.h"
@implementation SKEmailConfigurationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
}

-(void)initSelf
{
    UILabel *titltL=[[UILabel alloc] initWithFrame:CGRectMake(20, 20, 193, 31)];
    [titltL setText:@"邮件每次收取数量设置："];
    [titltL setFont:[UIFont systemFontOfSize:16]];
    [titltL setBackgroundColor:[UIColor clearColor]];
    [self addSubview:titltL];
    
    dataArray=[[NSArray alloc] initWithObjects:@"1",@"5",@"10",@"15",@"20",nil];
    popView=[[UIView alloc] init];
    [popView setFrame:CGRectMake(0, 0, 320-66, [UIScreen mainScreen].bounds.size.height-20-44)];
    [popView setBackgroundColor:[UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:0.7]];
    [popView setHidden:YES];
    selectTable=[[UITableView alloc] initWithFrame:CGRectMake(0, 120, 255, 220)];
    [selectTable setDelegate:self];
    [selectTable setDataSource:self];
    [selectTable reloadData];
    [popView addSubview:selectTable];
    NSString *eSize=[FileUtils valueFromPlistWithKey:@"EPSIZE"];
    
    btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(15, 60, 225, 39)];
    [btn setTitle:eSize forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [btn setTitleColor:[UIColor colorWithRed:0/255.0 green:89.0/255.0 blue:179.0/255.0 alpha:1] forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 180)];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn.layer setBorderWidth:1];
    [btn.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [btn.layer setCornerRadius:3];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(205, 66, 29, 27)];
    [imageView setImage:[UIImage imageNamed:@"downArrow.jpg"]];
   
    [self addSubview:btn];
    [self addSubview:imageView];
    [self addSubview:popView];
}

-(void)btnClick:(id)sender
{
    [popView setAlpha:1];
    [popView setHidden:NO];
}

#pragma mark -tableViewDataScource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tIdentify = @"configureCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:tIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tIdentify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    [cell.textLabel setText:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark -tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [FileUtils setvalueToPlistWithKey:@"EPSIZE" Value:[dataArray objectAtIndex:indexPath.row]];
    [btn setTitle:[dataArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        [popView setAlpha:0.2];
    }];
    
    [self performSelector:@selector(setpopViewHidden) withObject:nil afterDelay:0.3];
}


-(void)setpopViewHidden
{
    [popView setHidden:YES];
}

@end
