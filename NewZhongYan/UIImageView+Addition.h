//
//  UIImageView+Addition.h
//  NewZhongYan
//
//  Created by lilin on 13-10-25.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
@interface UIImageView (Addition)<MWPhotoBrowserDelegate>
{
    
}

@property(nonatomic,strong)NSString* caption;
- (void)addDetailShow;
@end
