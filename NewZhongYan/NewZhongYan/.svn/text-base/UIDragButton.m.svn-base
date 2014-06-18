 

#import "UIDragButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIDragButton
@synthesize location;
@synthesize lastCenter;
@synthesize delegate;
@synthesize controllerName;
@synthesize channel;
- (id)initWithFrame:(CGRect)frame inView:(UIView *)view
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lastCenter = CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2);
        superView = view;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
        [self addGestureRecognizer:longPress];
        
    }
    return self;
}


- (void)drag:(UILongPressGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:superView];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            lastPoint = point;
            [self.layer setShadowColor:[UIColor grayColor].CGColor];
            [self.layer setShadowOpacity:1.0f];
            [self.layer setShadowRadius:10.0f];
            [self setAlpha:0.7];
            [self startShake];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            float offX = point.x - lastPoint.x;
            float offY = point.y - lastPoint.y;
            [self setCenter:CGPointMake(self.center.x + offX, self.center.y + offY)];
            lastPoint = point;
            [delegate checkLocationOfOthersWithButton:self];
            if (CGRectGetMinX(self.frame) <= -(CGRectGetWidth(self.frame)/3)) {
                [delegate checkShakingButtonToLeftEdge:self];
            }
            if (CGRectGetMaxX(self.frame) >= (CGRectGetWidth(self.superview.frame) + CGRectGetWidth(self.frame)/3))
            {
                [delegate checkShakingButtonToRightEdge:self];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self stopShake];
            [self setAlpha:1];
            switch (self.location)
            {
                case up:
                {
                    self.location = up;
                    [UIView animateWithDuration:.5 animations:^{
                        if (self.lastCenter.x == 0) {
                            [delegate arrangeUpButtonsWithButton:self andAdd:YES];
                        }else{
                            [self setFrame:CGRectMake(lastCenter.x - 30, lastCenter.y - 30, 60, 60)];
                        }
                    } completion:^(BOOL finished) {
                        [self.layer setShadowOpacity:0];
                    }];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        {
            [self stopShake];
            [self setAlpha:1];
            break;
        }
        case UIGestureRecognizerStateFailed:
        {
            [self stopShake];
            [self setAlpha:1];
            break;
        }
        default:
            break;
    }
}


- (void)startShake
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, -0.1, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, 0.1, 0, 0, 1)];
    [self.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

- (void)stopShake
{
    [self.layer removeAnimationForKey:@"shakeAnimation"];
}

@end
