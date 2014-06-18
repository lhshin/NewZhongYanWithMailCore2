//
//  UIImageView+Addition.m
//  NewZhongYan
//
//  Created by lilin on 13-10-25.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "UIImageView+Addition.h"

@implementation UIImageView (Addition)
@dynamic caption;
- (void)imageTap
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.wantsFullScreenLayout = YES;
    [browser setCurrentPhotoIndex:2];//2 是什么意思
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[APPUtils visibleViewController] presentViewController:nc animated:YES completion:^{
    
    }];
    return;
}

- (void)addDetailShow
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return 1;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    MWPhoto* p = [MWPhoto photoWithImage:self.image];
    p.caption = self.caption;
    return p;
}
@end
