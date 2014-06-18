//
//  SKToolBar.h
//  ZhongYan
//
//  Created by linlin on 8/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKToolBar : UIView
{
    UIButton* homeButton;
    UIButton* searchButton;
    UIButton* refreshButton;
    UIImageView *homeBgImageView;
}
-(id)initWithFrame:(CGRect)frame Target:(id)target FirstAction:(SEL)firstaction SecondAction:(SEL)secondaction;

-(id)initWithFrame:(CGRect)frame FirstTarget:(id)firsttarget FirstAction:(SEL)firstaction
      SecondTarget:(id)secondtarget SecondAction:(SEL)secondaction;

-(id)initMaintainWithFrame:(CGRect)frame Target:(id)target Action:(SEL)action;
-(void)addFirstTarget:(id)target action:(SEL)action;
-(void)addSecondTarget:(id)target action:(SEL)action;
-(void)setFirstTarget:(id)target action:(SEL)action;
@property(nonatomic,retain)UIButton* homeButton;
@property(nonatomic,retain)UIButton* searchButton;
@property(nonatomic,retain)UIButton* refreshButton;
@end
