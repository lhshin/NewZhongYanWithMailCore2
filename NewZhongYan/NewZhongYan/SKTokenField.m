//
//  SKTokenField.m
//  SKTokenField
//
//  Created by 李 林 on 11/22/12.
//  Copyright (c) 2012 surekam. All rights reserved.
//
#import "SKTokenField.h"
#import "SKTokenFieldInternalDelegate.h"
#import "SKToken.h"
#import "utils.h"
#import <QuartzCore/QuartzCore.h>
NSString * const kTextEmpty = @"\u200B"; // Zero-Width Space
NSString * const kTextHidden = @"\u200D"; // Zero-Width Joiner
@interface SKTokenField ()
@property (nonatomic, readonly) CGFloat leftViewWidth;
@property (nonatomic, readonly) CGFloat rightViewWidth;
@property (nonatomic, readonly) UIScrollView * scrollView;
@end

@implementation SKTokenField
@synthesize delegate;
@synthesize tokens;
@synthesize editable;
@synthesize resultsModeEnabled;
@synthesize removesTokensOnEndEditing;
@synthesize numberOfLines;
@synthesize selectedToken;
@synthesize tokenizingCharacters;
- (id)initWithFrame:(CGRect)frame {
	
    if ((self = [super initWithFrame:frame])){
        self.returnKeyType = UIReturnKeyNext;
		[self setup];
    }
	
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	
	if ((self = [super initWithCoder:aDecoder])){
		[self setup];
	}
	
	return self;
}

- (void)setup {
	for (id a in self.subviews) {
        NSLog(@"%@",[a class]);
    }
	[self setBorderStyle:UITextBorderStyleNone];
	[self setFont:[UIFont systemFontOfSize:14]];
	[self setBackgroundColor:[UIColor greenColor]];
	[self setAutocorrectionType:UITextAutocorrectionTypeNo];
	[self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self setKeyboardType:UIKeyboardTypeEmailAddress];
	self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[self addTarget:self action:@selector(didBeginEditing) forControlEvents:UIControlEventEditingDidBegin];
	[self addTarget:self action:@selector(didEndEditing) forControlEvents:UIControlEventEditingDidEnd];
	[self addTarget:self action:@selector(didChangeText) forControlEvents:UIControlEventEditingChanged];
	
	[self.layer setShadowColor:[[UIColor blackColor] CGColor]];
	[self.layer setShadowOpacity:0.6];
	[self.layer setShadowRadius:12];
	[self setBackgroundColor:[UIColor whiteColor]];
    
	[self setPromptText:@"To:"];
	[self setText:kTextEmpty];
	internalDelegate = [[SKTokenFieldInternalDelegate alloc] init];
	[internalDelegate setTokenField:self];
	[super setDelegate:internalDelegate];
	
	tokens = [[NSMutableArray alloc] init];
	editable = YES;
	removesTokensOnEndEditing = YES;
	tokenizingCharacters = [[NSCharacterSet characterSetWithCharactersInString:@","] retain];
}

#pragma mark Property Overrides
- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self.layer setShadowPath:[[UIBezierPath bezierPathWithRect:self.bounds] CGPath]];
	[self layoutTokensAnimated:NO];
}

- (void)setText:(NSString *)text {
    if ((text.length == 0 || [text isEqualToString:@""])) {
        [super setText:kTextEmpty];
    }else{
        [super setText:text];
    }
}

- (void)setFont:(UIFont *)font {
	[super setFont:font];
	
	if ([self.leftView isKindOfClass:[UILabel class]]){
		[self setPromptText:((UILabel *)self.leftView).text];
	}
}

- (void)setDelegate:(id<SKTokenFieldDelegate>)del {
	delegate = del;
	[internalDelegate setDelegate:delegate];
}

//获取所有的token
- (NSArray *)tokens {
	return [[tokens copy] autorelease];
}



//获取所有的token title
- (NSArray *)tokenTitles {
	NSMutableArray * titles = [[NSMutableArray alloc] init];
	for (SKToken * token in tokens) [titles addObject:token.title];
	return [titles autorelease];
}

//获取所有token的representObject
- (NSArray *)tokenObjects {
	NSMutableArray * objects = [[NSMutableArray alloc] init];
	for (SKToken * token in tokens) [objects addObject:(token.representedObject ? token.representedObject : token.title)];
	return [objects autorelease];
}

-(NSString*)tokenFieldText
{
    NSString* result = @"";
    if (self.tokenObjects.count < 1 || !self.tokenObjects) return  result;
    for (NSString* tokenText in self.tokenObjects) {
        result = [result stringByAppendingFormat:@"%@,",tokenText];
    }
    return result;
}
#pragma mark Event Handling
- (BOOL)becomeFirstResponder {
	return (editable ? [super becomeFirstResponder] : NO);
}

//编辑开始:
- (void)didBeginEditing {
    for (SKToken * token in tokens) [self addToken:token];
}

- (void)didEndEditing {
	
	[selectedToken setSelected:NO];
	selectedToken = nil;
	
	[self tokenizeText];
	
	if (removesTokensOnEndEditing)
    {
		
		for (SKToken * token in tokens) [token removeFromSuperview];
		
		NSString * untokenized = kTextEmpty;
		
		if (tokens.count)
        {
			
			NSMutableArray * titles = [[NSMutableArray alloc] init];
			for (SKToken * token in tokens) [titles addObject:token.title];
			
			untokenized = [self.tokenTitles componentsJoinedByString:@", "];
			CGSize untokSize = [untokenized sizeWithFont:[UIFont systemFontOfSize:14]];
			CGFloat availableWidth = self.bounds.size.width - self.leftView.bounds.size.width - self.rightView.bounds.size.width;
			
			if (tokens.count > 1 && untokSize.width > availableWidth)
            {
				untokenized = [NSString stringWithFormat:@"%ld 位联系人", (long)titles.count];
			}
			
			[titles release];
		}
		[self setText:untokenized];
	}
	
	[self setResultsModeEnabled:NO];
}

- (void)didChangeText {
	if (self.text.length == 0) [self setText:kTextEmpty];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
	
	// Stop the cut, copy, select and selectAll appearing when the field is 'empty'.
	if (action == @selector(cut:) || action == @selector(copy:) || action == @selector(select:) || action == @selector(selectAll:))
		return ![self.text isEqualToString:kTextEmpty];
    
	return [super canPerformAction:action withSender:sender];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	
	if (selectedToken && touch.view == self) [self deselectSelectedToken];
	return [super beginTrackingWithTouch:touch withEvent:event];
}

- (UIScrollView *)scrollView {
	return ([self.superview isKindOfClass:[UIScrollView class]] ? (UIScrollView *)self.superview : nil);
}

#pragma mark Token Handling
- (SKToken *)addTokenWithTitle:(NSString *)title
{
     return [self addTokenWithTitle:title representedObject:nil];
}

- (SKToken *)addTokenWithTitle:(NSString *)title representedObject:(id)object
{
    if (title.length){
        SKToken * token = [[SKToken alloc] initWithTitle:title representedObject:object font:self.font];
        [self addToken:token];
        return [token autorelease];
    }
    return nil;
}

- (void)addToken:(SKToken *)token {
	
	BOOL shouldAdd = YES;
	if ([delegate respondsToSelector:@selector(tokenField:willAddToken:)]){
		shouldAdd = [delegate tokenField:self willAddToken:token];
	}
	
	if (shouldAdd){
        
		//[self becomeFirstResponder];
        
		[token addTarget:self action:@selector(tokenTouchDown:) forControlEvents:UIControlEventTouchDown];
		[token addTarget:self action:@selector(tokenTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:token];
        
		if (![tokens containsObject:token]) [tokens addObject:token];
		
		if ([delegate respondsToSelector:@selector(tokenField:didAddToken:)]){
			[delegate tokenField:self didAddToken:token];
		}
		
		[self setResultsModeEnabled:NO];
		[self deselectSelectedToken];
	}
}

- (void)removeToken:(SKToken *)token {
	
	if (token == selectedToken) [self deselectSelectedToken];
	
	BOOL shouldRemove = YES;
	if ([delegate respondsToSelector:@selector(tokenField:willRemoveToken:)]){
		shouldRemove = [delegate tokenField:self willRemoveToken:token];
	}
	
	if (shouldRemove){
        
		[token removeFromSuperview];
		[tokens removeObject:token];
		
		if ([delegate respondsToSelector:@selector(tokenField:didRemoveToken:)]){
			[delegate tokenField:self didRemoveToken:token];
		}
		
		[self setResultsModeEnabled:NO];
	}
}

-(void)removeAllToken
{
     for (SKToken * token in tokens)
     {
         [token removeFromSuperview];
     }
    [tokens removeAllObjects];
    [self layoutTokensAnimated:YES];
    //[self setResultsModeEnabled:NO];
}

- (void)selectToken:(SKToken *)token {
	
	[self deselectSelectedToken];
	
	selectedToken = token;
	[selectedToken setSelected:YES];
	
	[self becomeFirstResponder];
	
	[self setText:kTextHidden];
}

- (void)deselectSelectedToken {
	
	[selectedToken setSelected:NO];
	selectedToken = nil;
	
	[self setText:kTextEmpty];
}

- (void)tokenizeText {
	if (![self.text isEqualToString:kTextEmpty] && ![self.text isEqualToString:kTextHidden]){
		for (NSString * component in [self.text componentsSeparatedByCharactersInSet:tokenizingCharacters]){
            //add by lilin for lilin 
            component = [component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (![self.tokenObjects containsObject:component]) {
                [self addTokenWithTitle:component];
            }else{
                self.text = @"";
            }
            
		}
	}
}

- (void)tokenTouchDown:(SKToken *)token {
	
	if (selectedToken != token){
		[selectedToken setSelected:NO];
		selectedToken = nil;
	}
}

- (void)tokenTouchUpInside:(SKToken *)token {
	if (editable) [self selectToken:token];
}

- (CGFloat)layoutTokensInternal {
	CGFloat topMargin = floor(self.font.lineHeight * 4 / 7);
	CGFloat leftMargin = self.leftViewWidth + 12;
	CGFloat hPadding = 8;
	CGFloat rightMargin = self.rightViewWidth + hPadding;
	CGFloat lineHeight = self.font.lineHeight + topMargin + 5;
	
	numberOfLines = 1;
	tokenCaret = (CGPoint){leftMargin, (topMargin - 1)};
	
	for (SKToken * token in tokens)
    {
		[token setFont:self.font];
		[token setMaxWidth:(self.bounds.size.width - rightMargin - (numberOfLines > 1 ? hPadding : leftMargin))];
		
		if (token.superview){
			
			if (tokenCaret.x + token.bounds.size.width + rightMargin > self.bounds.size.width){
				numberOfLines++;
				tokenCaret.x = (numberOfLines > 1 ? hPadding : leftMargin);
				tokenCaret.y += lineHeight;
			}
			
			[token setFrame:(CGRect){tokenCaret, token.bounds.size}];
			tokenCaret.x += token.bounds.size.width + 4;
			
			if (self.bounds.size.width - tokenCaret.x - rightMargin < 50){
				numberOfLines++;
				tokenCaret.x = (numberOfLines > 1 ? hPadding : leftMargin);
				tokenCaret.y += lineHeight;
			}
		}
	}
	
	return tokenCaret.y + lineHeight;
}

#pragma mark View Handlers
//功能
- (void)layoutTokensAnimated:(BOOL)animated {
	
	CGFloat newHeight = [self layoutTokensInternal];
	if (self.bounds.size.height != newHeight){
		[UIView animateWithDuration:(animated ? 0.3 : 0) animations:^{
			[self setFrame:((CGRect){self.frame.origin, {self.bounds.size.width, newHeight}})];
			[self sendActionsForControlEvents:(UIControlEvents)SKTokenFieldControlEventFrameWillChange];
			
		} completion:^(BOOL complete){
			[self sendActionsForControlEvents:(UIControlEvents)SKTokenFieldControlEventFrameDidChange];
		}];
	}
}

//功能:
- (void)setResultsModeEnabled:(BOOL)flag animated:(BOOL)animated {
	
	[self layoutTokensAnimated:animated];
	
	if (resultsModeEnabled != flag){
		
		//Hide / show the shadow
		[self.layer setMasksToBounds:!flag];
		
		UIScrollView * scrollView = self.scrollView;
		[scrollView setScrollsToTop:!flag];
		[scrollView setScrollEnabled:!flag];
		
		CGFloat offset = ((numberOfLines == 1 || !flag) ? 0 : tokenCaret.y - floor(self.font.lineHeight * 4 / 7) + 1);
		[scrollView setContentOffset:CGPointMake(0, self.frame.origin.y + offset) animated:animated];
	}
	
	resultsModeEnabled = flag;
}

- (void)setResultsModeEnabled:(BOOL)flag {
	[self setResultsModeEnabled:flag animated:YES];
}

#pragma mark Left / Right view stuff
- (void)setPromptText:(NSString *)text {
	
	if (text){
		
		UILabel * label = (UILabel *)self.leftView;
		if (!label || ![label isKindOfClass:[UILabel class]]){
			label = [[UILabel alloc] initWithFrame:CGRectZero];
            [label setBackgroundColor:[UIColor clearColor]];
			[label setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
			[self setLeftView:label];
			[label release];
			
			[self setLeftViewMode:UITextFieldViewModeAlways];
		}
		
		[label setText:text];
		[label setFont:[UIFont systemFontOfSize:(self.font.pointSize + 1)]];
		[label sizeToFit];
	}
	else
	{
		[self setLeftView:nil];
	}
	
	[self layoutTokensAnimated:YES];
}

#pragma mark Layout
- (CGRect)textRectForBounds:(CGRect)bounds {
	if ([self.text isEqualToString:kTextHidden]) return CGRectMake(0, -20, 0, 0);
	
	CGRect frame = CGRectOffset(bounds, tokenCaret.x + 2, tokenCaret.y + 3);
	frame.size.width -= (tokenCaret.x + self.rightViewWidth + 10);
	//if (IS_IOS7) {
        frame.origin.y = (16.5 * (self.numberOfLines- 1));//这里写死的 还需要找个不写死的办法
    //}
	return frame;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
	return [self textRectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
	return [self textRectForBounds:bounds];
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
	return ((CGRect){{8, ceilf(self.font.lineHeight * 4 / 7)}, self.leftView.bounds.size});
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
	return ((CGRect){{bounds.size.width - self.rightView.bounds.size.width - 6,
		bounds.size.height - self.rightView.bounds.size.height - 6}, self.rightView.bounds.size});
}

- (CGFloat)leftViewWidth {
	
	if (self.leftViewMode == UITextFieldViewModeNever ||
		(self.leftViewMode == UITextFieldViewModeUnlessEditing && self.editing) ||
		(self.leftViewMode == UITextFieldViewModeWhileEditing && !self.editing)) return 0;
	
	return self.leftView.bounds.size.width;
}

- (CGFloat)rightViewWidth {
	
	if (self.rightViewMode == UITextFieldViewModeNever ||
		(self.rightViewMode == UITextFieldViewModeUnlessEditing && self.editing) ||
		(self.rightViewMode == UITextFieldViewModeWhileEditing && !self.editing)) return 0;
	
	return self.rightView.bounds.size.width;
}

#pragma mark Other
- (NSString *)description {
	return [NSString stringWithFormat:@"<TITokenField %p; prompt = \"%@\">", self, ((UILabel *)self.leftView).text];
}

- (void)dealloc {
	[self setDelegate:nil];
	[internalDelegate release];
	[tokens release];
	[tokenizingCharacters release];
    [super dealloc];
}

@end

@implementation SKTextField

#pragma mark Layout
- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = bounds;
    if (IS_IOS7) {
        rect.origin.x += 48;
        rect.origin.y += 2;
        return rect;
    }
    return CGRectMake(45, 13, 320 - 40, 22);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
	return [self textRectForBounds:bounds];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
	return [self textRectForBounds:bounds];
}

@end