//
//  SKMailDetailController.h
//  NewZhongYan
//
//  Created by lilin on 13-11-2.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKMailDetailController : UIViewController<UIWebViewDelegate>
{
    __weak IBOutlet UIScrollView *scrollview;
    __weak IBOutlet UIView *toolView;
    UILabel      *toLabel;
    
    UIWebView   *mailWebView;
    
    CGFloat      subjectHeight;
    CGFloat      contentHeight;
    
    
    int     statusCode;
    BOOL    isOpen;//表示收件人cell是否显示
    BOOL    isSend;
    
    UIView* subjectBGView;
    UIView* senderBGView;
    UIView* recieveBGView;
    UIView* contentBGView;
}
@property(nonatomic,weak)NSDictionary* emailDetailDictionary;
@property BOOL isSend;
@end
