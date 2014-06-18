//
//  SKImageView.h
//  ZhongYan
//
//  Created by 李 林 on 5/18/13.
//  Copyright (c) 2013 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDXMLNode.h"
#import "HPGrowingTextView.h"
#import "columns.h"
@interface SKImageView : UIImageView
@property(nonatomic,retain)NSString* base64String;
@property(nonatomic,retain)DDXMLNode* xmlnode;
@property(nonatomic,retain)TextDownView* tdView;
@property(nonatomic,assign)HPGrowingTextView *textView;
@property(nonatomic,assign)columns* cs;
@property(nonatomic,retain)NSString* nameLabelText;
@end
