//
//  SKTokenFieldInternalDelegate.m
//  SKTokenField
//
//  Created by 李 林 on 11/22/12.
//  Copyright (c) 2012 surekam. All rights reserved.
//

#import "SKTokenFieldInternalDelegate.h"
#import "SKTokenField.h"
NSString * const kITextEmpty = @"\u200B"; // Zero-Width Space
NSString * const kITextHidden = @"\u200D"; // Zero-Width Joiner
@interface SKTokenFieldInternalDelegate ()

@end

@implementation SKTokenFieldInternalDelegate
@synthesize delegate;
@synthesize tokenField;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	
	if ([delegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]){
		return [delegate textFieldShouldBeginEditing:textField];
	}
	
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	if ([delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]){
		[delegate textFieldDidBeginEditing:textField];
	}
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	
	if ([delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]){
		return [delegate textFieldShouldEndEditing:textField];
	}
	
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	if ([delegate respondsToSelector:@selector(textFieldDidEndEditing:)]){
		[delegate textFieldDidEndEditing:textField];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	if (tokenField.tokens.count && [string isEqualToString:@""] && [tokenField.text isEqualToString:kITextEmpty]){
		[tokenField selectToken:[tokenField.tokens lastObject]];
		return NO;
	}
	
	if ([textField.text isEqualToString:kITextHidden]){
		[tokenField removeToken:tokenField.selectedToken];
		return (![string isEqualToString:@""]);
	}
	
	if ([string rangeOfCharacterFromSet:tokenField.tokenizingCharacters].location != NSNotFound){
		[tokenField tokenizeText];
		return NO;
	}
	
	if ([delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]){
		return [delegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
	}
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[tokenField tokenizeText];
	
	if ([delegate respondsToSelector:@selector(textFieldShouldReturn:)]){
		[delegate textFieldShouldReturn:textField];
	}
	
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	
	if ([delegate respondsToSelector:@selector(textFieldShouldClear:)]){
		return [delegate textFieldShouldClear:textField];
	}
	
	return YES;
}

@end
