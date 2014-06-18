//
//  SKTokenField.h
//  SKTokenField
//
//  Created by 李 林 on 11/22/12.
//  Copyright (c) 2012 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKTokenField,SKToken,SKTokenFieldInternalDelegate;
@protocol SKTokenFieldDelegate <UITextFieldDelegate>
@optional
- (BOOL)tokenField:(SKTokenField *)tokenField willAddToken:(SKToken *)token;
- (void)tokenField:(SKTokenField *)tokenField didAddToken:(SKToken *)token;
- (BOOL)tokenField:(SKTokenField *)tokenField willRemoveToken:(SKToken *)token;
- (void)tokenField:(SKTokenField *)tokenField didRemoveToken:(SKToken *)token;
@end

typedef enum {
	SKTokenFieldControlEventFrameWillChange = 1 << 24,
	SKTokenFieldControlEventFrameDidChange = 1 << 25,
} SKTokenFieldControlEvents;

@interface SKTextField : UITextField
{
    
}

@end


@interface SKTokenField : UITextField
{
    id <SKTokenFieldDelegate> delegate;
	SKTokenFieldInternalDelegate * internalDelegate;
	
	NSMutableArray * tokens;
	SKToken * selectedToken;
	
	BOOL editable;                      //能否编辑
	BOOL resultsModeEnabled;            //
	BOOL removesTokensOnEndEditing;
	CGPoint tokenCaret;                 //插字号
	int numberOfLines;
	
	NSCharacterSet * tokenizingCharacters;
}

@property (nonatomic, assign) id <SKTokenFieldDelegate> delegate;
@property (atomic, readonly) NSArray * tokens;           //所有的Token??1111111111
@property (nonatomic, readonly) NSArray * tokenTitles;      //所有Token上的标题
@property (nonatomic, readonly) NSArray * tokenObjects;     //所有的Token??
@property (nonatomic, readonly) SKToken * selectedToken;    //被选中的Token

@property (nonatomic, assign) BOOL editable;                //能否编辑
@property (nonatomic, assign) BOOL resultsModeEnabled;      //??
@property (nonatomic, assign) BOOL removesTokensOnEndEditing;   //编辑结束侯是否去掉token
@property (nonatomic, readonly) int numberOfLines;              //函数
@property (nonatomic, retain) NSCharacterSet * tokenizingCharacters;

//添加删除
- (void)addToken:(SKToken *)title;
- (SKToken *)addTokenWithTitle:(NSString *)title;
- (SKToken *)addTokenWithTitle:(NSString *)title representedObject:(id)object;
- (void)removeToken:(SKToken *)token;
-(void)removeAllToken;
//选择
- (void)selectToken:(SKToken *)token;
- (void)deselectSelectedToken;

//使文字 变成 token模式
- (void)tokenizeText;

//?
- (CGFloat)layoutTokensInternal;
- (void)layoutTokensAnimated:(BOOL)animated;
- (void)setResultsModeEnabled:(BOOL)enabled animated:(BOOL)animated;

// Pass nil to hide label
- (void)setPromptText:(NSString *)aText;

-(NSString*)tokenFieldText;
@end
