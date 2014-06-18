//
//  UIAlertView+hnzy.m
//  HNZYiPad
//
//  Created by lilin on 13-6-24.
//  Copyright (c) 2013年 袁树峰. All rights reserved.
//

#import "UIAlertView+hnzy.h"

@implementation UIAlertView (hnzy)
+(UIAlertView*) showAlertError:(NSError*) networkError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[networkError localizedDescription]
                                                    message:[networkError localizedRecoverySuggestion]
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"确定", @"")
                                          otherButtonTitles:nil];
    [alert show];
    return alert;
}
+(UIAlertView*) showAlertString:(NSString*) networkError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:networkError                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"确定", @"")
                                          otherButtonTitles:nil];
    [alert show];
    return alert;
}

+(UIAlertView*) showOAAlert:(NSString*) oaReturnCode
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:oaReturnCode                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"确定", @"")
                                          otherButtonTitles:nil];
    [alert show];
    return alert;
}
@end
