//
//  UIView+Transition.m
//  JiaodongOnlineNews
//
//  Created by zhang yi on 13-6-6.
//  Copyright (c) 2013年 胶东在线. All rights reserved.
//

#import "UIView+Transition.h"
#import <objc/runtime.h>

#define Transition_Time 0.3f
#define Min_Scale 0.98f
#define Max_Alpah 0.4f

@implementation UIView (Transition)

static const char* shadowViewKey = "shadowViewKey";
static const char* blackMaskKey = "blackMaskKey";

- (void) pushView:(UIView *) moveInView orientation:(JDOTransitionOrientation)orientation complete:(void (^)())complete{
    
    CGRect moveInStartFrame ;
    CGRect moveInEndFrame = CGRectMake(0, 0, 320, App_Height);
    if(orientation == JDOTransitionFromRight){
        moveInStartFrame = CGRectMake(320, 0, 320, App_Height);
    }else if(orientation == JDOTransitionFromBottom){
        moveInStartFrame = CGRectMake(0, App_Height, 320, App_Height);
    }
    
    [self pushView:moveInView startFrame:moveInStartFrame endFrame:moveInEndFrame complete:complete];
}

- (void) pushView:(UIView *) moveInView startFrame:(CGRect)startFrame endFrame:(CGRect)endFrame complete:(void (^)())complete{
    
    [self pushView:moveInView process:^(CGRect *_startFrame, CGRect *_endFrame, NSTimeInterval *_timeInterval) {
        *_startFrame = startFrame;
        *_endFrame = endFrame;
        *_timeInterval = Transition_Time;
    } complete:complete];
}

- (void) pushView:(UIView *) moveInView process:(void (^)(CGRect*,CGRect*,NSTimeInterval*))process complete:(void (^)())complete{
    
    [moveInView addSubview:self.shadowView];
    self.blackMask.alpha = 0;
    [self.superview insertSubview:self.blackMask aboveSubview:self];
    [self.superview insertSubview:moveInView aboveSubview:self.blackMask];
    
    CGRect startFrame,endFrame;
    NSTimeInterval timeInterval;
    process(&startFrame,&endFrame,&timeInterval);
    
    moveInView.frame = startFrame;
    [UIView animateWithDuration:timeInterval animations:^{
        moveInView.frame = endFrame;
        self.transform = CGAffineTransformMakeScale(Min_Scale, Min_Scale);
        self.blackMask.alpha = Max_Alpah;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        complete();
    }];
    
}

- (void) popView:(UIView *) presentView orientation:(JDOTransitionOrientation)orientation complete:(void (^)()) complete{
    
    CGRect moveOutStartFrame = CGRectMake(0, 0, 320, App_Height);
    CGRect moveOutEndFrame;
    if(orientation == JDOTransitionToRight){
        moveOutEndFrame = CGRectMake(320, 0, 320, App_Height);
    }else if(orientation == JDOTransitionToBottom){
        moveOutEndFrame = CGRectMake(0, App_Height, 320, App_Height);
    }
    [self popView:presentView startFrame:moveOutStartFrame endFrame:moveOutEndFrame complete:complete];
}

- (void) popView:(UIView *) presentView startFrame:(CGRect)startFrame endFrame:(CGRect)endFrame complete:(void (^)()) complete{
    
    [self popView:presentView process:^(CGRect *_startFrame, CGRect *_endFrame, NSTimeInterval *_timeInterval) {
        *_startFrame = startFrame;
        *_endFrame = endFrame;
        *_timeInterval = Transition_Time;
    } complete:complete];
    
}

- (void) popView:(UIView *) presentView process:(void (^)(CGRect*,CGRect*,NSTimeInterval*))process complete:(void (^)())complete{
    
    presentView.transform = CGAffineTransformMakeScale(Min_Scale, Min_Scale);
    [self addSubview:self.shadowView];
    self.blackMask.alpha = Max_Alpah;
    [self.superview insertSubview:self.blackMask belowSubview:self];
    [self.superview insertSubview:presentView belowSubview:self.blackMask];
    
    CGRect startFrame,endFrame;
    NSTimeInterval timeInterval;
    process(&startFrame,&endFrame,&timeInterval);
    
    self.frame = startFrame;
    [UIView animateWithDuration:timeInterval animations:^{
        self.frame = endFrame;
        presentView.transform = CGAffineTransformIdentity;
        self.blackMask.alpha = 0;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        complete();
    }];
}

- (UIView *) blackMask{
    UIView  *_blackMask = objc_getAssociatedObject(self, blackMaskKey);
    if( _blackMask == nil){
        _blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320 , App_Height)];
        _blackMask.backgroundColor = [UIColor blackColor];
        objc_setAssociatedObject(self, blackMaskKey, _blackMask, OBJC_ASSOCIATION_RETAIN);
    }
    return _blackMask;
}

- (UIImageView *) shadowView{
    UIImageView  *_shadowView = objc_getAssociatedObject(self, shadowViewKey);
    if( _shadowView == nil){
        _shadowView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
        _shadowView.frame = CGRectMake(-10, 0, 10, App_Height);
        objc_setAssociatedObject(self, shadowViewKey, _shadowView, OBJC_ASSOCIATION_RETAIN);
    }
    return _shadowView;
}


@end
