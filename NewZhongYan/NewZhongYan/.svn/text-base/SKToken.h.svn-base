//
//  SKToken.h
//  SKTokenField
//
//  Created by 李 林 on 11/23/12.
//  Copyright (c) 2012 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
	SKTokenAccessoryTypeNone = 0, // Default
	SKTokenAccessoryTypeDisclosureIndicator = 1,
} SKTokenAccessoryType;

@interface SKToken : UIControl
{
    NSString * title;
	id representedObject;   //??
	
	UIFont  *font;
	UIColor *tintColor;
	
	SKTokenAccessoryType accessoryType;
	CGFloat maxWidth;
}

@property (nonatomic, copy) NSString * title;
@property (nonatomic, retain) id representedObject;
@property (nonatomic, retain) UIFont * font;
@property (nonatomic, retain) UIColor * tintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) SKTokenAccessoryType accessoryType;
@property (nonatomic, assign) CGFloat maxWidth;

- (id)initWithTitle:(NSString *)aTitle;
- (id)initWithTitle:(NSString *)aTitle representedObject:(id)object;
- (id)initWithTitle:(NSString *)aTitle representedObject:(id)object font:(UIFont *)aFont;

+ (UIColor *)blueTintColor;
+ (UIColor *)redTintColor;
+ (UIColor *)greenTintColor;
@end
