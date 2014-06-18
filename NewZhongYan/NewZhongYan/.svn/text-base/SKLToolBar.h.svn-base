//
//  SKLToolBar.h
//  ZhongYan
//
//  Created by linlin on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SKLToolBarProtocal <NSObject>

-(void)onClickFirstbtn;
-(void)onClickSecondbtn;
-(void)onClickThirdbtn;
@end

@interface SKLToolBar : UIView
{
    UIButton* homeButton;
    UIButton* firstButton;
    UIButton* secondButton;
    UIButton* thirdButton;
    UILabel*  firstLabel;
    UILabel*  secondLabel;
    UILabel*  thirdLabel;
    UIImageView *homeBgImageView;
}

@property(nonatomic,strong)UIButton* homeButton;
@property(nonatomic,strong)UIButton* firstButton;
@property(nonatomic,strong)UIButton* secondButton;
@property(nonatomic,retain)UIButton* thirdButton;

@property(nonatomic,strong)UILabel*  firstLabel;
@property(nonatomic,strong)UILabel*  secondLabel;
@property(nonatomic,strong)UILabel*  thirdLabel;

//@property(nonatomic,retain)id<SKLToolBarProtocal> delegate;

-(void)setFirstItem:(NSString*)imageName Title:(NSString*)title;
-(void)setSecondItem:(NSString*)imageName Title:(NSString*)title;
-(void)setThirdItem:(NSString*)imageName Title:(NSString*)title;
@end

