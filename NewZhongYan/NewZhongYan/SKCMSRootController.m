//
//  SKCMSRootController.m
//  NewZhongYan
//
//  Created by lilin on 13-10-15.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKCMSRootController.h"
#import "SKToolBar.h"
@interface SKCMSRootController ()

@end

@implementation SKCMSRootController
-(void)onRefrshClick
{

}

-(void)onSearchClick
{

}

-(void)dataFromDataBaseWithComleteBlock:(resultsetBlock)block
{

}

-(NSDictionary*)praseWorkNewsArray:(NSArray*)workNews{
    NSDictionary *sectionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSMutableArray array],@"信息安全",
                                       [NSMutableArray array],@"战略信息择要",
                                       [NSMutableArray array],@"工作要情",
                                       [NSMutableArray array],@"法律法规",
                                       [NSMutableArray array],@"其它工作动态",
                                       [NSMutableArray array],@"经济运行通报",
                                       [NSMutableArray array],@"领导讲话", nil];
    for (NSDictionary *dict  in workNews){
        if ([dict objectForKey:@"TPID"] != [NSNull null]) {
            NSInteger tpid = [[dict objectForKey:@"TPID"] intValue];
            switch (tpid) {
                case 11:
                    [(NSMutableArray*)[sectionDictionary objectForKey:@"信息安全"]  addObject:dict];
                    break;
                case 12:
                    [(NSMutableArray*)[sectionDictionary objectForKey:@"战略信息择要"]  addObject:dict];
                    break;
                case 29:
                    [(NSMutableArray*)[sectionDictionary objectForKey:@"工作要情"]  addObject:dict];
                    break;
                case 3:
                    [(NSMutableArray*)[sectionDictionary objectForKey:@"法律法规"]  addObject:dict];
                    break;
                case 30:
                    [(NSMutableArray*)[sectionDictionary objectForKey:@"其它工作动态"]  addObject:dict];
                    break;
                case 32:
                    [(NSMutableArray*)[sectionDictionary objectForKey:@"经济运行通报"]  addObject:dict];
                    break;
                case 33:
                    [(NSMutableArray*)[sectionDictionary objectForKey:@"领导讲话"]  addObject:dict];
                    break;
                default:
                    continue;
                    break;
            }
        }else{
            return nil;
        }
    }
    return sectionDictionary;
}


-(NSDictionary*)praseMeetingArray:(NSArray*)meetings{
    NSDictionary *sectionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSMutableArray array],@"即将召开&正在召开",
                                       [NSMutableArray array],@"已召开", nil];
    
    for (NSDictionary *dict in [NSArray arrayWithArray:meetings]){
        NSString* bz = [dict objectForKey:@"bz"];
        if (bz.intValue) {
            [(NSMutableArray*)[sectionDictionary objectForKey:@"即将召开&正在召开"] addObject:dict];
        }else{
            [(NSMutableArray*)[sectionDictionary objectForKey:@"已召开"]  addObject:dict];
        }
    }
    return sectionDictionary;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dataItems = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)back:(id)sender
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SKToolBar* myToolBar = [[SKToolBar alloc] initWithFrame:CGRectMake(0, 0, 320, 49)
                                                FirstTarget:self FirstAction:@selector(onSearchClick)
                                               SecondTarget:self.tableView SecondAction:@selector(launchRefreshing)];
    [toolView addSubview:myToolBar];
    [self onRefrshClick];
}

#pragma mark - 数据代理函数
-(void)didBeginSynData:(LocalDataMeta *)metaData
{
}

-(void)didCompleteSynData:(LocalDataMeta *)metaData
{
    if ([[metaData dataCode] isEqualToString:@"news"]) {
        from = 0;
        [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
            [_dataItems setArray:array];
            [BWStatusBarOverlay showMessage:@"更新新闻完成" duration:1 animated:YES];
            [self.tableView tableViewDidFinishedLoading];
            [self.tableView setReachedTheEnd:array.count < 20];
            [self.tableView reloadData];
            from += 20;
        }];
    }else if ([[metaData dataCode] isEqualToString:@"notify/9"]){
        from = 0;
        [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
            [_dataItems setArray:array];
            [BWStatusBarOverlay showMessage:@"更新通知完成" duration:1 animated:YES];
            [self.tableView tableViewDidFinishedLoading];
            [self.tableView setReachedTheEnd:array.count < 20];
            [self.tableView reloadData];
            from += 20;
        }];
    }else if ([[metaData dataCode] isEqualToString:@"notify/4"]){
        from = 0;
        [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
            [_dataItems setArray:array];
            [BWStatusBarOverlay showMessage:@"更新公告完成" duration:1 animated:YES];
            [self.tableView tableViewDidFinishedLoading];
            [self.tableView setReachedTheEnd:array.count < 20];
            [self.tableView reloadData];
            from += 20;
        }];
    } else if ([[metaData dataCode] isEqualToString:@"notify/31"]){
        from = 0;
        [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
            [_sectionDictionary addEntriesFromDictionary:[self praseMeetingArray:array]];
            [BWStatusBarOverlay showMessage:@"更新会议完成" duration:1 animated:YES];
            [self.tableView tableViewDidFinishedLoading];
            [self.tableView setReachedTheEnd:array.count < 20];
            [self.tableView reloadData];
            from += 20;
        }];
    }else if ([[metaData dataCode] isEqualToString:@"codocs"]){
        from = 0;
        [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
            [_dataItems setArray:array];
            [BWStatusBarOverlay showMessage:@"更新公司公文完成" duration:1 animated:YES];
            [self.tableView tableViewDidFinishedLoading];
            [self.tableView setReachedTheEnd:array.count < 20];
            [self.tableView reloadData];
            from += 20;
        }];
    }else if ([[metaData dataCode] isEqualToString:@"worknews"]){
        from = 0;
        [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
            [_sectionDictionary addEntriesFromDictionary:[self praseWorkNewsArray:array]];
            [BWStatusBarOverlay showMessage:@"更新工作动态完成" duration:1 animated:YES];
            [self.tableView tableViewDidFinishedLoading];
            [self.tableView setReachedTheEnd:array.count < 20];
            [self.tableView reloadData];
            from += 20;
        }];
    }else if ([[metaData dataCode] isEqualToString:@"remind"]){
        [self dataFromDataBaseWithComleteBlock:^(NSArray* array){
            [_dataItems setArray:array];
            [BWStatusBarOverlay showMessage:@"更新待办完成" duration:1 animated:YES];
            [self.tableView tableViewDidFinishedLoading];
            [self.tableView reloadData];
        }];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView tableViewDidFinishedLoading];
    });
}

-(void)didCompleteSynData:(NSString *)datacode SV:(int)sv SC:(int)sc LV:(int)lv
{
}

-(void)didEndSynData:(LocalDataMeta *)metaData
{
    
}

-(void)didCancelSynData:(LocalDataMeta *)metaData
{
    
}

-(void)didErrorSynData:(LocalDataMeta *)metaData Reason:(NSString *)errorinfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [BWStatusBarOverlay showMessage:errorinfo duration:1 animated:YES];
        [self.tableView tableViewDidFinishedLoading];
    });
}

@end
