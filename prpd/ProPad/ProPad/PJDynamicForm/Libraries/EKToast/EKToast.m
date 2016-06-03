//
//  EKToast.m
//  EKToast
//
//  Created by Bhumesh on 8/11/15.
//  Copyright (c) 2015 Zaptech Solutions Pvt Ltd. All rights reserved.
//

#import "EKToast.h"
@interface EKToast() {
    NSLayoutConstraint *centerVerticallyToSuperView;
    NSLayoutConstraint *centerHorizontallyToSuperView;
}
@property (nonatomic, copy) void (^completion)(void);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpace;
@end
@implementation EKToast

- (instancetype)initWithMessage:(NSString *)message
{
    self = [super init];
    if (self) {
        NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"EKToast" owner:nil options:nil];
        self = (EKToast *) views[0];
        self.lblMessage.text = message;
        self.position = ToastPositionCenter;
        self.horizontalOffset = 0;
        self.duration = 0.5f;
        self.delay = 1.6f;
        self.shouldAutoDestruct = YES;
        self.shouldCornerRadius = NO;
        self.closeImage.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        if (message == nil) {
            return nil;
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    return self;
}

- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            if (self) {
                [self reloadViewPosition];
            }
            
        }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            if (self) {
                [self reloadViewPosition];
            }
            
        }
            break;
        case UIInterfaceOrientationUnknown:break;
    }
}

- (void)reloadViewPosition {
    UIView *view = self;
    CGFloat halfHeight = view.superview.frame.size.height/2;
    if (self.position == ToastPositionBottom) {
        centerVerticallyToSuperView.constant = +halfHeight - view.bounds.size.height/2;
    } else if(self.position == ToastPositionTop) {
        centerVerticallyToSuperView.constant = -halfHeight + view.bounds.size.height/2;
    }
}

- (void)show:(void (^)(void))completion {
    self.completion = completion;
    UIWindow *window = [[UIApplication sharedApplication]windows][0];
    //If window already contains EKToast do not let add overlapping EKToast.
    for (id view in window.rootViewController.view.subviews) {
        if ([view isKindOfClass:[EKToast class]]) {
            return;
        }
    }
    [window.rootViewController.view addSubview:self];
    if (self.position == ToastPositionTop) {
        window.windowLevel = UIWindowLevelStatusBar + 1;
    }
    
    [self addConstraintWithRespectToSuperView:self];
    
    if (self.shouldCornerRadius) {
        [self setUpBackgroundView];
    }
    //[self setShadow:self];
    
    //Trigger auto removal of toast
    if (self.shouldAutoDestruct) {
        [UIView animateWithDuration:self.duration delay:self.delay options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {
            if (completion != nil) {
               completion();
            }

            [self removeFromSuperview];
            window.windowLevel = UIWindowLevelStatusBar - 1;
            
        }];
    } else {
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(removeOnTap:)];
        [self addGestureRecognizer:singleFingerTap];
        self.closeImage.hidden = NO;
        self.trailingSpace.constant = 36;
    }
}

- (void)removeOnTap:(UITapGestureRecognizer *)recognizer {
    [UIView animateWithDuration:self.duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if(self.completion != nil) {
                self.completion();
        }

    }];
    
}

- (void)setUpBackgroundView {
    self.backgroundView.layer.cornerRadius = 6.0f;
    self.clipsToBounds = YES;
}

-(void)setShadow:(UIView *)view
{
    if (self.position == ToastPositionBottom) {
        view.layer.shadowOffset = CGSizeMake(2, -2);
    } else {
        view.layer.shadowOffset = CGSizeMake(2, 2);
    }
    
    view.layer.shadowRadius = 5;
    view.layer.shadowOpacity = 0.8;
}

- (void)addConstraintWithRespectToSuperView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewsDictionary = @{@"View":view};
    NSString *widthFormat = [NSString stringWithFormat:@"H:|-%d-[View]-%d-|",(int)self.horizontalOffset,(int)self.horizontalOffset];
    
    NSArray *widthConstraint = [NSLayoutConstraint constraintsWithVisualFormat:widthFormat
                                                                       options:0
                                                                       metrics:nil
                                                                         views:viewsDictionary];
    
    centerVerticallyToSuperView = [NSLayoutConstraint constraintWithItem:view
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:view.superview
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0
                                   ];
    
    centerHorizontallyToSuperView = [NSLayoutConstraint constraintWithItem:view
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:view.superview
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1
                                                                  constant:0
                                     ];
    [view.superview addConstraint:centerVerticallyToSuperView];
    [view.superview addConstraint:centerHorizontallyToSuperView];
    [view.superview addConstraints:widthConstraint];
    [view.superview layoutIfNeeded];
    
    CGFloat halfHeight = view.superview.frame.size.height/2;
    
    //Animate according to position Top/Bottom/Center
    if (self.position == ToastPositionBottom) {
        centerVerticallyToSuperView.constant = +halfHeight + view.bounds.size.height/2;
        [view.superview layoutIfNeeded];
        centerVerticallyToSuperView.constant = +halfHeight - view.bounds.size.height/2;
        [UIView animateWithDuration:0.3f animations:^{
            [view.superview layoutIfNeeded];
        }];
    } else if(self.position == ToastPositionTop) {
        centerVerticallyToSuperView.constant = -halfHeight - view.bounds.size.height/2;
        [view.superview layoutIfNeeded];
        centerVerticallyToSuperView.constant = -halfHeight + view.bounds.size.height/2;
        [UIView animateWithDuration:0.3f animations:^{
            [view.superview layoutIfNeeded];
        }];
    } else {//Center
        self.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:0.2 animations:^(void){
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end