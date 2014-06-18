//
//  SKECMAttahController.h
//  NewZhongYan
//
//  Created by lilin on 13-11-21.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "UIImageView+WebCache.h"

@class SKECMDetail;
@interface SKECMAttahController : UIViewController<UIWebViewDelegate,EGOImageViewDelegate>
{
    
}

@property (strong,nonatomic)  UILabel *titleLabel;
@property (strong,nonatomic)  UILabel *authorLabel;
@property (strong,nonatomic)  UILabel *crtmLabel;
@property (weak,nonatomic) IBOutlet UIScrollView *bgscrollview;
@property (weak,nonatomic)SKChannel* channel;
@property (nonatomic,strong)NSDictionary *news;
@property (nonatomic,strong)SKECMDetail *detail;
@property int curHeight;
@property BOOL isSearch;

@end

/**
 *=================================================================================
 *T_DOCUMENTS 相关字段的介绍
 *=================================================================================
 *AID	主键ID
 *PAPERID	文章ID
 *CHANNELID	ECM栏目ID 值对应频道表的FIDLIST)
 *TITL	标题
 *TFRM	来源系统
 *URL	获取详情URL
 *CRTM	发布时间
 *AUTM	入库时间
 *BGTM	开始时间
 *EDTM	结束时间
 *ATTRLABLE	属性标识（bodyfile,attachment,bodyimage)
 *ADDITION	附加
 *PMS	权限
 *ENABLED	是否可用，1表示可用，0表示不可用（删除掉了）
 */

