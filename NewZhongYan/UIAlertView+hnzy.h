//
//  UIAlertView+hnzy.h
//  HNZYiPad
//
//  Created by lilin on 13-6-24.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (hnzy)
+(UIAlertView*) showAlertError:(NSError*) networkError;
+(UIAlertView*) showAlertString:(NSString*) networkError;
+(UIAlertView*) showOAAlert:(NSString*)oaCode;
@end
