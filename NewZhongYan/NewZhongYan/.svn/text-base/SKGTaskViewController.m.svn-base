//
//  SKGTaskViewController.m
//  NewZhongYan
//
//  Created by lilin on 13-11-6.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKGTaskViewController.h"
#import "SKTableViewCell.h"
#import "SKGtaskDetailController.h"
@implementation SKGTaskViewController
{
    NSArray                     *_filteredArray;       //存储查询结果
    SKRemindsState              remindState;
    UIButton                    *titleButton1;
    UIButton                    *titleButton2;
}

-(void)onSearchClick
{
    [self.searchBar becomeFirstResponder];
}

-(void)onRefrshClick
{
    [SKDataDaemonHelper synWithMetaData:[LocalDataMeta sharedRemind] delegate:self];
}

-(void)dataFromDataBaseWithComleteBlock:(SKRemindsState)remindstate ComleteBlock:(resultsetBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* sql;
        if (remindstate == SKReminding) {
            sql = @"select * from T_REMINDS where  ENABLED = 1 and STATUS = -1 group by FLOWINSTANCEID,TITL ORDER BY CRTM desc";
        }else{
            sql = @"select * from T_REMINDS where  ENABLED = 1 and STATUS != -1 group by FLOWINSTANCEID,TITL ORDER BY CRTM desc";
        }
        NSArray* dataArray = [[DBQueue sharedbQueue] recordFromTableBySQL:sql];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(dataArray);
            }
        });
    });
}

-(void)dataFromDataBaseWithComleteBlock:(resultsetBlock)block
{
    [self dataFromDataBaseWithComleteBlock:remindState ComleteBlock:block];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        datameta = [LocalDataMeta sharedRemind];
        remindState = SKReminding;
    }
    return self;
}
-(void)selectType:(UIButton*)button
{
    if ((button.tag==101 && remindState == SKReminding) || (button.tag==102 && remindState == SKreminded)) {
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
        remindState = SKReminding;
    }
    else
    {
        [titleButton1 setBackgroundImage:[UIImage imageNamed:@"segLeft.png"] forState:UIControlStateNormal];
        [titleButton1 setBackgroundImage:[UIImage imageNamed:@"segLeft.png"] forState:UIControlStateHighlighted];
        [titleButton2 setBackgroundImage:[UIImage imageNamed:@"segRight_press.png"] forState:UIControlStateNormal];
        [titleButton2 setBackgroundImage:[UIImage imageNamed:@"segRight_press.png"] forState:UIControlStateHighlighted];
        [titleButton2 setTitleColor:COLOR(5, 73, 165) forState:UIControlStateNormal];
        [titleButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        remindState = SKreminded;
    }
    
    [_dataItems removeAllObjects];
    [self.tableView reloadData];
    [self dataFromDataBaseWithComleteBlock:remindState ComleteBlock:^(NSArray* array){
        [_dataItems setArray:array];
        if (remindState == SKReminding)
        {
            if (_dataItems.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BWStatusBarOverlay showMessage:@"暂无待办" duration:1 animated:1];
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView tableViewDidFinishedLoading];
            [self.tableView reloadData];
        });
    }];
}

-(void)reload{
    [_dataItems removeAllObjects];[self.tableView reloadData];
    [self dataFromDataBaseWithComleteBlock:remindState ComleteBlock:^(NSArray* array){
        [_dataItems setArray:array];
        if (remindState == SKReminding)
        {
            if (_dataItems.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BWStatusBarOverlay showMessage:@"暂无待办" duration:1 animated:1];
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView tableViewDidFinishedLoading];
            [self.tableView reloadData];
        });
    }];
}

-(void)back:(id)sender
{
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"refresh" object:nil];
    [self.tableView setHeaderOnly:YES];
    
    titleButton1=[UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton1 setFrame:CGRectMake(0, 0, 74, 32)];
    [titleButton1 setTitleColor:COLOR(5, 73, 165) forState:UIControlStateNormal];
    [titleButton1 setBackgroundImage:[UIImage imageNamed:@"segLeft_press.png"] forState:UIControlStateNormal];
    [titleButton1 setBackgroundImage:[UIImage imageNamed:@"segLeft_press.png"] forState:UIControlStateHighlighted];
    [titleButton1 setTitle:@"待办" forState:UIControlStateNormal];
    [titleButton1.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [titleButton1 setTag:101];
    [titleButton1 addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
    
    titleButton2=[UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton2 setFrame:CGRectMake(74, 0, 74, 32)];
    [titleButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton2 setBackgroundImage:[UIImage imageNamed:@"segRight.png"] forState:UIControlStateNormal];
    [titleButton2 setBackgroundImage:[UIImage imageNamed:@"segRight.png"] forState:UIControlStateHighlighted];
    [titleButton2 setTitle:@"已办" forState:UIControlStateNormal];
    [titleButton2.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [titleButton2 setTag:102];
    [titleButton2 addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
    UIView *tView=[[UIView alloc] initWithFrame:CGRectMake(86, 6, 148, 32)];
    [tView addSubview:titleButton1];
    [tView addSubview:titleButton2];
    self.navigationItem.titleView = tView;
    
    // Create a search bar
	self.searchBar = [[UISearchBar alloc] init] ;
    if (IS_IOS7) {
        [self.searchBar setBackgroundImage:Image(@"navbar64") forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self.searchBar setSearchBarStyle:UISearchBarStyleDefault];
        [self.searchBar setFrame:CGRectMake(0.0f, 20, 320.0f, 44)];
        self.searchBar.tintColor = [UIColor whiteColor];
    }else{
        [self.searchBar setFrame:CGRectMake(0.0f, 0, 320.0f, 44)];
        self.searchBar.tintColor = [UIColor grayColor];
    }
	
	self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar.keyboardType = UIKeyboardTypeDefault;
    self.searchBar.placeholder  = @"请输入你搜索的内容";
    self.searchBar.delegate = self;
    self.searchBar.hidden = YES;
    [self.view addSubview:self.searchBar];
    
    self.searchDC = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
	self.searchDC.searchResultsDataSource = self;
	self.searchDC.searchResultsDelegate = self;
    self.searchDC.delegate = self;
    
    [self dataFromDataBaseWithComleteBlock:remindState ComleteBlock:^(NSArray* array){
        [_dataItems setArray:array];
        if (remindState == SKReminding)
        {
            if (_dataItems.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BWStatusBarOverlay showMessage:@"暂无待办" duration:1 animated:1];
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView tableViewDidFinishedLoading];
            [self.tableView setReachedTheEnd:array.count < 10];
            [self.tableView reloadData];
        });
    }];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView != (UIScrollView*)self.tableView) return;
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView != (UIScrollView*)self.tableView)   return;
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(onRefrshClick) withObject:nil afterDelay:0.0];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataItems.count;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"待办";
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
    label.backgroundColor = COLOR(245, 245, 245);
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"  待办";
    return label;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identify = @"codocscell";
    SKTableViewCell*  cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell)
    {
        cell = [[SKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    [cell setRemindInfo:[_dataItems objectAtIndex:indexPath.row]];
    [cell resizeCellHeight];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataDictionary = [_dataItems objectAtIndex:indexPath.row];
    NSString* flowInstanceId = [dataDictionary objectForKey:@"FLOWINSTANCEID"];
    if ([[dataDictionary objectForKey:@"HANDLE"] intValue] == 0
        || [flowInstanceId isEqual:[NSNull null]]//不可处理
        || [flowInstanceId isEqualToString:@"0"]
        || [flowInstanceId isEqualToString:@""]) {
        [UIAlertView showAlertString:@"不可处理表示该待办不适宜在手机上办理，或者该待办的接口还在开发中，敬请期待..."];
        return;
    }
    [self performSegueWithIdentifier:@"remindDeatil" sender:self];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:16.];
    CGSize size = [_dataItems[indexPath.row][@"TITL"] sizeWithFont:font constrainedToSize:CGSizeMake(280, 220) lineBreakMode:NSLineBreakByTruncatingTail];
    return size.height + 30;
}

#pragma mark- UISearchBarDelegate methods
-(void)searchGtaskWithKey:(NSString*)key
{
    NSString* sql = [NSString stringWithFormat:
                     @"select * from T_REMINDS where ENABLED = 1 and TITL like '%%%@%%' group by FLOWINSTANCEID,TITL ORDER BY CRTM DESC limit 30;",key];
    _filteredArray = [[NSMutableArray alloc]  initWithArray:[[DBQueue sharedbQueue] recordFromTableBySQL:sql]];
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.searchBar setHidden:YES];
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.searchDisplayController.searchBar.showsCancelButton = YES;
    UISearchBar *searchBar = self.searchDisplayController.searchBar;
    UIView *viewTop = IS_IOS7 ? searchBar.subviews[0] : searchBar;
    NSString *classString = IS_IOS7 ? @"UINavigationButton" : @"UIButton";
    for (UIView *subView in viewTop.subviews) {
        if ([subView isKindOfClass:NSClassFromString(classString)]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton.titleLabel setTextColor:[UIColor whiteColor]];
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    [self.searchBar setHidden:NO];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.searchBar.text.length) {
        _keyWord = [NSString stringWithFormat:@"%@",self.searchBar.text];
        [self searchGtaskWithKey:self.searchBar.text];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"remindDeatil"]) {
        SKGtaskDetailController *gtaskDetail = (SKGtaskDetailController *)[segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        gtaskDetail.GTaskDetailInfo = _dataItems[selectedIndexPath.row];
        [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    }
}


@end
