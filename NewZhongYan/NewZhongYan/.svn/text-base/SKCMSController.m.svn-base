//
//  SKCMSController.m
//  NewZhongYan
//
//  Created by lilin on 13-10-10.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKCMSController.h"
#import "SKPatternLockController.h"
@interface SKCMSController ()

@end

@implementation SKCMSController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)RefreshViewControlEventValueChanged
{
    NSLog(@"RefreshViewControlEventValueChanged");
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"刷新中"];
        [self performSelector:@selector(handleData) withObject:nil afterDelay:2];
    }
}

- (void) handleData
{
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.tableView reloadData];
}

-(void)back
{
}

-(void)loadMore
{
    NSLog(@"loadMore");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",self.view.class);
    self.tableView.backgroundColor = [UIColor whiteColor];
    if(System_Version_Small_Than_(6)){

    }else{
        //注意这里添加的是由顺序的
        UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
        [refresh addTarget:self
                    action:@selector(RefreshViewControlEventValueChanged)
          forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refresh;
    }
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    UIButton* footBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [footBtn setFrame:CGRectMake(15, 4.5, 290, 41)];
    [footBtn setTitle:@"正在加载..." forState:UIControlStateNormal];
    [footBtn setBackgroundImage:Image(@"contentview_graylongbutton") forState:UIControlStateNormal];
    [footBtn setBackgroundImage:Image(@"contentview_graylongbutton_highlighted") forState:UIControlStateHighlighted];
    [footBtn setBackgroundImage:Image(@"contentview_graylongbutton_highlighted") forState:UIControlStateSelected];
    [footBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [footBtn addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:footBtn];
    [self.tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"林哥";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
         cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    }else {
         cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"习近平参加apec峰会";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",@"10086"]]];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
