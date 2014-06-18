//
//  SKCKeyBoards.m
//  NewZhongYan
//
//  Created by lilin on 13-10-30.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import "SKCKeyBoards.h"

@interface SKCKeyBoards ()

@end

@implementation SKCKeyBoards
-(IBAction)hideKeyBoard:(id)sender
{
    if (_delegate)
    {
        [_delegate textDidHided];
        self.showed = NO;
    }
}

-(IBAction)deleteNumber:(id)sender
{
    if (numeberLabel.text.length == 0) {
        return;
    }
    numeberLabel.text = [numeberLabel.text substringToIndex:numeberLabel.text.length-1];
    if (_delegate) {
        [_delegate textDidChanged:numeberLabel.text];
    }
}

- (IBAction)PrintNumber:(id)sender         //键盘输入处理
{
    if ([numeberLabel.text length] >= 15) {
        return;
    }
    if (sender == oneButton) {
        numeberLabel.text = [NSString stringWithFormat:@"%@1",numeberLabel.text];
    }
    if (sender == TwoButton) {
        numeberLabel.text = [NSString stringWithFormat:@"%@2",numeberLabel.text];
    }
    if (sender == ThreeButton) {
        numeberLabel.text = [NSString stringWithFormat:@"%@3",numeberLabel.text];
    }
    if (sender == FourButton) {
        numeberLabel.text = [NSString stringWithFormat:@"%@4",numeberLabel.text];
    }
    if (sender == FiveButton) {
        numeberLabel.text = [NSString stringWithFormat:@"%@5",numeberLabel.text];
    }
    if (sender == SixButton) {
        numeberLabel.text = [NSString stringWithFormat:@"%@6",numeberLabel.text];
    }
    if (sender == SevenButton) {
        numeberLabel.text = [NSString stringWithFormat:@"%@7",numeberLabel.text];
    }
    if (sender == EightButton) {
        numeberLabel.text = [NSString stringWithFormat:@"%@8",numeberLabel.text];
    }
    if (sender == NineButton) {
        numeberLabel.text = [NSString stringWithFormat:@"%@9",numeberLabel.text];     }
    if (sender == ZeroButton) {
        numeberLabel.text = [NSString stringWithFormat:@"%@0",numeberLabel.text];
    }
    if (_delegate) {
        [_delegate textDidChanged:numeberLabel.text];
    }
    
}
-(void)longPressed:(id)sender
{
    if (numeberLabel.text.length == 0) {
        return;
    }
    numeberLabel.text = @"";
    if (_delegate) {
        [_delegate textDidChanged:numeberLabel.text];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:41.0/255 green:41.0/255 blue:41.0/255 alpha:1]];
    [self setKeyboardHeight:200];
    [numeberLabel setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    numeberLabel.text = @"";
    UILongPressGestureRecognizer* longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [DelectButton addGestureRecognizer:longpress];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
