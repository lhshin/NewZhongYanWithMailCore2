//
//  SKSToolBar.h
//  ZhongYan
//
//  Created by linlin on 10/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKSToolBar : UIView{
    UIButton* homeButton;
    UIButton* firstButton;
    UIButton* secondButton;
    UILabel*  firstLabel;
    UILabel*  secondLabel;
    UIImageView *homeBgImageView;
}

@property(nonatomic,retain)UIButton* homeButton;
@property(nonatomic,retain)UIButton* firstButton;
@property(nonatomic,retain)UIButton* secondButton;

@property(nonatomic,retain)UILabel*  firstLabel;
@property(nonatomic,retain)UILabel*  secondLabel;

-(void)setFirstItem:(NSString*)imageName Title:(NSString*)title ;
-(void)setSecondItem:(NSString*)imageName Title:(NSString*)title ;

-(void)setFirstItem:(NSString*)imageName Title:(NSString*)title Target:(id)target action:(SEL)action;
-(void)setSecondItem:(NSString*)imageName Title:(NSString*)title Target:(id)target action:(SEL)action;

-(void)addFirstTarget:(id)target action:(SEL)action;
-(void)addSecondTarget:(id)target action:(SEL)action;
@end
