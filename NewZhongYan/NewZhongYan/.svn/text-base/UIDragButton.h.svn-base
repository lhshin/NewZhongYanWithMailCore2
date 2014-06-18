 
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SKLauncherItem.h"
#import "SKChannel.h"
typedef enum{
    up = 0,
    down = 1,
}Location;

@class UIDragButton;

@protocol UIDragButtonDelegate <NSObject>
@optional
- (void)arrangeUpButtonsWithButton:(UIDragButton *)button andAdd:(BOOL)_bool;
- (void)arrangeDownButtonsWithButton:(UIDragButton *)button andAdd:(BOOL)_bool;
- (void)setDownButtonsFrameWithAnimate:(BOOL)_bool withoutShakingButton:(UIDragButton *)shakingButton;
- (void)checkLocationOfOthersWithButton:(UIDragButton *)shakingButton;
- (void)checkShakingButtonToLeftEdge:(UIDragButton *)shakingButton;
- (void)checkShakingButtonToRightEdge:(UIDragButton *)shakingButton;
- (void)removeShakingButton:(UIDragButton *)button fromUpButtons:(BOOL)_bool;
@end

@interface UIDragButton : SKLauncherItem
{
    UIView *superView;
    CGPoint lastPoint;
    NSTimer *timer;
}

@property (nonatomic, strong) SKChannel* channel;
@property (nonatomic, assign) Location location;
@property (nonatomic, assign) CGPoint lastCenter;
@property (nonatomic, assign) id<UIDragButtonDelegate> delegate;
@property (nonatomic, strong) NSString *controllerName;
- (id)initWithFrame:(CGRect)frame inView:(UIView *)view;
- (void)startShake;
- (void)stopShake;

@end
