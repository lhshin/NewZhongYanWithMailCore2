//
//  SKECMSearchController.m
//  NewZhongYan
//
//  Created by lilin on 14-1-8.
//  Copyright (c) 2014年 surekam. All rights reserved.
//

#import "SKECMSearchController.h"
#import "DDXMLNode.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "Paper.h"
#import "SKTableViewCell.h"
#import "SKCMeetCell.h"
#import "SKSearchCell.h"
#import "SKECMAttahController.h"
@interface UIButton(network)
- (void)startLoadData:(BOOL)show;
@end

@implementation UIButton(network)
- (void)startLoadData:(BOOL)show {
	if(show) {
		UIActivityIndicatorView *progress = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		UIView *progressView = [[UIView alloc] initWithFrame: self.bounds];
        [self addSubview:progressView];
        [self setTitle:@"正在加载..." forState:UIControlStateNormal];
        [progressView setTag:1001];
        [self setEnabled:NO];
        [progressView addSubview: progress];
        CGPoint p =  progressView.center;
        p.x -= 90;
		progress.center = p;
		[progress startAnimating];
	} else {
		[self setEnabled:YES];
        [[self viewWithTag:1001] removeFromSuperview];
	}
}
@end

@implementation SKECMSearchController
{
    UIButton                    *titleButton1;
    UIButton                    *titleButton2;
    SKSearchMode                 searchmode;
}
@synthesize moreBtn = _moreBtn;
-(void)initNavBar
{
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
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

-(void)selectType:(UIButton*)button
{
    if ((button.tag==101 && searchmode == SKSearchTitle) || (button.tag==102 && searchmode == SKSearchContent)) {
        return;
    }
    if (button.tag==101)
    {
        [titleButton1 setBackgroundImage:[UIImage imageNamed:@"segLeft_press.png"] forState:UIControlStateNormal];
        [titleButton1 setBackgroundImage:[UIImage imageNamed:@"segLeft_press.png"] forState:UIControlStateHighlighted];
        [titleButton2 setBackgroundImage:[UIImage imageNamed:@"segRight.png"] forState:UIControlStateNormal];
        [titleButton2 setBackgroundImage:[UIImage imageNamed:@"segRight.png"] forState:UIControlStateHighlighted];
        [titleButton1 setTitleColor:COLOR(5, 73, 165) forState:UIControlStateNormal];
        [titleButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        searchmode = SKSearchTitle;
    }
    else
    {
        [titleButton1 setBackgroundImage:[UIImage imageNamed:@"segLeft.png"] forState:UIControlStateNormal];
        [titleButton1 setBackgroundImage:[UIImage imageNamed:@"segLeft.png"] forState:UIControlStateHighlighted];
        [titleButton2 setBackgroundImage:[UIImage imageNamed:@"segRight_press.png"] forState:UIControlStateNormal];
        [titleButton2 setBackgroundImage:[UIImage imageNamed:@"segRight_press.png"] forState:UIControlStateHighlighted];
        [titleButton2 setTitleColor:COLOR(5, 73, 165) forState:UIControlStateNormal];
        [titleButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        searchmode = SKSearchContent;
    }
}

-(void)initData
{
    _dataArray = [[NSMutableArray alloc] init];
    pageindex = 1;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setFrame:CGRectMake(15, 4.5, 290, 41)];
    [_moreBtn setTitle:@"远程查询" forState:UIControlStateNormal];
    [_moreBtn setHidden:YES];
    [_moreBtn setBackgroundImage:Image(@"contentview_graylongbutton") forState:UIControlStateNormal];
    [_moreBtn setBackgroundImage:Image(@"contentview_graylongbutton_highlighted") forState:UIControlStateHighlighted];
    [_moreBtn setBackgroundImage:Image(@"contentview_graylongbutton_highlighted") forState:UIControlStateSelected];
    [_moreBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_moreBtn];
    [self.tableView setTableFooterView:view];
    
    titleButton1=[UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton1 setFrame:CGRectMake(0, 0, 74, 32)];
    [titleButton1 setTitleColor:COLOR(5, 73, 165) forState:UIControlStateNormal];
    [titleButton1 setBackgroundImage:[UIImage imageNamed:@"segLeft_press.png"] forState:UIControlStateNormal];
    [titleButton1 setBackgroundImage:[UIImage imageNamed:@"segLeft_press.png"] forState:UIControlStateHighlighted];
    [titleButton1 setTitle:@"标题" forState:UIControlStateNormal];
    [titleButton1.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [titleButton1 setTag:101];
    [titleButton1 addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
    
    titleButton2=[UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton2 setFrame:CGRectMake(74, 0, 74, 32)];
    [titleButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton2 setBackgroundImage:[UIImage imageNamed:@"segRight.png"] forState:UIControlStateNormal];
    [titleButton2 setBackgroundImage:[UIImage imageNamed:@"segRight.png"] forState:UIControlStateHighlighted];
    [titleButton2 setTitle:@"全文" forState:UIControlStateNormal];
    [titleButton2.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [titleButton2 setTag:102];
    [titleButton2 addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
    UIView *tView=[[UIView alloc] initWithFrame:CGRectMake(86, 6, 148, 32)];
    [tView addSubview:titleButton1];
    [tView addSubview:titleButton2];
    self.navigationItem.titleView = tView;
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
 
    NSURL* queryurl;
    if (searchmode) {
        queryurl = [SKECMURLManager queryContentWith:pageindex ECMContent:searchBar.text ChannelID:self.fidlist];
    } else {
        queryurl = [SKECMURLManager queryTitleWith:pageindex ECMContent:searchBar.text ChannelID:self.fidlist];
    }
    //NSLog(@"%@",queryurl);
    SKHTTPRequest* request = [SKHTTPRequest requestWithURL:queryurl];
    __weak SKHTTPRequest* req = request;
    [request setCompletionBlock:^{
        [_dataArray removeAllObjects];
        DDXMLDocument* mainDoc = [[DDXMLDocument alloc] initWithData:req.responseData options:0 error:0];
        NSArray* array = [mainDoc nodesForXPath:@"//paper" error:nil];
        for (DDXMLElement* e in array) {
            Paper* p = [Paper new];
            p.paperid = [[e nodesForXPath:@"paperid" error:0][0] stringValue];
            p.channelid = [[e nodesForXPath:@"channelid" error:0][0] stringValue];
            p.title = [[e nodesForXPath:@"title" error:0][0] stringValue];
            p.content = [[e nodesForXPath:@"content" error:0][0] stringValue];
            p.time = [[e nodesForXPath:@"time" error:0][0] stringValue];
            p.author = [[e nodesForXPath:@"author" error:0][0] stringValue];
            p.url = [[e nodesForXPath:@"url" error:0][0] stringValue];
            [_dataArray addObject:p];
        }
        [self.tableView reloadData];
        if (_dataArray.count < 20 ) {
            [_moreBtn setHidden:YES];
        }else{
            [_moreBtn setHidden:NO];
            [_moreBtn setTitle:array.count < 20 ? @"没有更多了" :@"下一页" forState:UIControlStateNormal];
            pageindex ++;
        }
        
    }];
    
    [request setFailedBlock:^{
        [_moreBtn setHidden:YES];
    }];
    [request startAsynchronous];
    [searchBar resignFirstResponder];
}

-(void)nextPage
{
    NSURL* queryurl;
    if (searchmode) {
        queryurl= [SKECMURLManager queryContentWith:pageindex ECMContent:_searchBar.text ChannelID:self.fidlist];
    }else{
        queryurl= [SKECMURLManager queryTitleWith:pageindex ECMContent:_searchBar.text ChannelID:self.fidlist];
    }
    SKHTTPRequest* request = [SKHTTPRequest requestWithURL:queryurl];
    __weak SKHTTPRequest* req = request;
    [request setCompletionBlock:^{
        DDXMLDocument* mainDoc = [[DDXMLDocument alloc] initWithData:req.responseData options:0 error:0];
        NSArray* array = [mainDoc nodesForXPath:@"//paper" error:nil];
        for (DDXMLElement* e in array) {
            Paper* p = [Paper new];
            p.paperid = [[e nodesForXPath:@"paperid" error:0][0] stringValue];
            p.channelid = [[e nodesForXPath:@"channelid" error:0][0] stringValue];
            p.title = [[e nodesForXPath:@"title" error:0][0] stringValue];
            p.content = [[e nodesForXPath:@"content" error:0][0] stringValue];
            p.time = [[e nodesForXPath:@"time" error:0][0] stringValue];
            p.author = [[e nodesForXPath:@"author" error:0][0] stringValue];
            p.url = [[e nodesForXPath:@"url" error:0][0] stringValue];
            [_dataArray addObject:p];
        }
        [self.tableView reloadData];
        if (_dataArray.count < 20 ) {
            [_moreBtn setHidden:YES];
        }else{
            [_moreBtn setHidden:NO];
            [_moreBtn setTitle:array.count < 20 ? @"没有更多了" :@"下一页" forState:UIControlStateNormal];
            [_moreBtn startLoadData:NO];
            pageindex ++;
        }
        
    }];
    
    [request setFailedBlock:^{
        [_moreBtn setHidden:YES];
        [_moreBtn startLoadData:NO];
    }];
    [request startAsynchronous];
    [_moreBtn startLoadData:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initData];
    [self initNavBar];
    if (System_Version_Small_Than_(7)) {
        _searchBar.tintColor = [UIColor lightGrayColor];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SKSearchCell*  cell;
    if (self.isMeeting) {
        static NSString* identify = @"meetscell";
        cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[SKSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        [cell setECMPaperInfo:_dataArray[indexPath.row]];
        [cell resizeCellHeight];
    } else if (self.isNotice) {
        static NSString* identify = @"noticecell";
        cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[SKSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        [cell setECMPaperInfo:_dataArray[indexPath.row]];
        [cell resizeCellHeight];
    } else {
        static NSString* identify = @"newscell";
        cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[SKSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        [cell setECMPaperInfo:_dataArray[indexPath.row]];
        [cell resizeCellHeight];
    }
    [cell setKeyWord:_searchBar.text];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Paper* paper = _dataArray[indexPath.row];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:16.];
    CGSize size = [paper.title sizeWithFont:font constrainedToSize:CGSizeMake(280, 220) lineBreakMode:NSLineBreakByTruncatingTail];
    return size.height + 32;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Paper* paper = _dataArray[indexPath.row];
    SKECMAttahController *controller = [[APPUtils AppStoryBoard] instantiateViewControllerWithIdentifier:@"SKECMAttahController"];
    controller.news = @{@"PAPERID":paper.paperid,@"URL":paper.url};
    controller.channel = self.channel;
    controller.isSearch = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
@end
