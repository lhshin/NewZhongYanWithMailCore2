//
//  SKPersonInfoController.h
//  NewZhongYan
//
//  Created by lilin on 13-11-14.
//  Copyright (c) 2013年 surekam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"

@interface SKPersonInfoController : UIViewController<HPGrowingTextViewDelegate>
{
      UILabel *nameLabel;
      UILabel *departmentLabel;
      UILabel *mailLabel;
      HPGrowingTextView *mobileTextField;

      HPGrowingTextView *shortPhoneTextField;
      HPGrowingTextView *telephoneTextField;
      HPGrowingTextView *officeAddressTextField;
      UIView *toolVIew;
      UIScrollView *mainScrollView;
}
@end
