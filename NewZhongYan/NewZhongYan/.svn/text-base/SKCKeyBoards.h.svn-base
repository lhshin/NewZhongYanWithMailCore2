//
//  SKCKeyBoards.h
//  NewZhongYan
//
//  Created by lilin on 13-10-30.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SKCKeyBoardsDelegate
-(void)textDidChanged:(NSString*)text;
-(void)textDidHided;
@end;
@interface SKCKeyBoards : UIViewController
{
    BOOL             dialKeyboardStatus;
    BOOL             isNumber;
    NSInteger        count;
    __weak IBOutlet UIButton *DelectButton;
    __weak IBOutlet UITextField *numeberLabel;
    __weak IBOutlet UIButton *oneButton;
    __weak IBOutlet UIButton *TwoButton;
    __weak IBOutlet UIButton *ThreeButton;
    __weak IBOutlet UIButton *FourButton;
    __weak IBOutlet UIButton *FiveButton;
    __weak IBOutlet UIButton *SixButton;
    __weak IBOutlet UIButton *SevenButton;
    __weak IBOutlet UIButton *EightButton;
    __weak IBOutlet UIButton *NineButton;
    __weak IBOutlet UIButton *ZeroButton;
    
}
@property (nonatomic,weak)id<SKCKeyBoardsDelegate> delegate;
@property BOOL showed;

@property CGFloat keyboardHeight;
-(IBAction)hideKeyBoard:(id)sender;
-(IBAction)deleteNumber:(id)sender;
-(IBAction)PrintNumber:(id)sender;
@end
