//
//  SKSecretController.h
//  NewZhongYan
//
//  Created by lilin on 13-12-4.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKCTextField.h"
@interface SKSecretController : UIViewController<UITextFieldDelegate>
{
    IBOutlet SKCTextField* oldTextView;  //旧密码
    IBOutlet SKCTextField* newATextView; //新密码
    IBOutlet SKCTextField* newBTextView; //重复新密码
    
    IBOutlet UILabel *userPassWord; //用户密码
    IBOutlet UILabel *protPassWord; //保护密码
    IBOutlet UIView  *userdivisionline;
    IBOutlet  UIView  *protrdivisionline;
    IBOutlet UIScrollView *mainScrollView;
    __weak IBOutlet UIView *toolView;
    
    UIBarButtonItem *previousBtn;
    UIBarButtonItem *nextBtn;
    UIBarButtonItem *doneBtn;
    UIToolbar *textToolBar;
}

-(IBAction)modifySafePassWord:(id)sender;
@end
