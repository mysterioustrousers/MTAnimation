//
//  UIView+MTAnimation.h
//  MTAnimation
//
//  Created by Adam Kirk on 4/25/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTTimingFunctions.h"
#import "MTAnimationTypes.h"


@interface MTView (MTAnimation)

/**
 Some (but not all) of the easing functions can be exaggerated. (e.g. elastic out will be swing
 more dramatically with more exaggeration).
 values: The default value is 1.70158, so any value from 0 to 10 is usually pretty reasonable.
 */
@property (assign, nonatomic) CGFloat mt_animationExaggeration;

/**
 The perspective to apply to the 3D transform matrix. 0 is no perspective.
 values: (- 1 / 500) is a good value to experiment with.
 */
@property (assign, nonatomic) CGFloat mt_animationPerspective;



/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateWithViews:(NSArray *)views
                   duration:(NSTimeInterval)duration
             timingFunction:(MTTimingFunction)timingFunction
                 animations:(MTAnimationsBlock)animations;

/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateWithViews:(NSArray *)views
                   duration:(NSTimeInterval)duration
             timingFunction:(MTTimingFunction)timingFunction
                 animations:(MTAnimationsBlock)animations
                 completion:(MTAnimationCompletionBlock)completion;
/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateWithViews:(NSArray *)views
                   duration:(NSTimeInterval)duration
                      delay:(NSTimeInterval)delay
             timingFunction:(MTTimingFunction)timingFunction
                 animations:(MTAnimationsBlock)animations
                 completion:(MTAnimationCompletionBlock)completion;

/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateWithViews:(NSArray *)views
                   duration:(NSTimeInterval)duration
             timingFunction:(MTTimingFunction)timingFunction
                    options:(MTViewAnimationOptions)options
                 animations:(MTAnimationsBlock)animations
                 completion:(MTAnimationCompletionBlock)completion;

/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateWithViews:(NSArray *)views
                   duration:(NSTimeInterval)duration
                      delay:(NSTimeInterval)delay
             timingFunction:(MTTimingFunction)timingFunction
                    options:(MTViewAnimationOptions)options
                 animations:(MTAnimationsBlock)animations
                 completion:(MTAnimationCompletionBlock)completion;

/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateWithViews:(NSArray *)views
                   duration:(NSTimeInterval)duration
             timingFunction:(MTTimingFunction)timingFunction
                      range:(MTAnimationRange)range
                 animations:(MTAnimationsBlock)animations
                 completion:(MTAnimationCompletionBlock)completion;

/**
 @param views           The views involved in the animation.
 @param duration        The duration of the animation.
 @param delay           A delay before the animation begins.
 @param timingFunction  The timing function to use for the easing.
 @param options         Some of the UIView MTViewAnimationOptions options are implemented. Not all of them yet, but I'm working on it.
 @param animations      Make your changes to your views in this block and they will be animated to those final values.
 @param completion      Called when the animation completes.
 */
+ (void)mt_animateWithViews:(NSArray *)views
                   duration:(NSTimeInterval)duration
                      delay:(NSTimeInterval)delay
             timingFunction:(MTTimingFunction)timingFunction
                      range:(MTAnimationRange)range
                    options:(MTViewAnimationOptions)options
                 animations:(MTAnimationsBlock)animations
                 completion:(MTAnimationCompletionBlock)completion;

/**
 Convenience method to add all the views in a view's subview heirarchy.
 */
- (NSArray *)mt_allSubviews;











/**********************************************************************************
 Automatically involving all views in the current window turned out to be a bad
 idea for a few reasons:
 1. If a UIKit Dynamics animation was running, and you call [UIView layoutIfNeeded]
 it would interfere with the dynamic animations because (if I'm not mistaken), it
 appears dynamics changes the view's model layer tree on each frame. Whereas, core
 animation changes the model layer tree to the final value.
 2. Using MTAnimation on OSX limited initiated an animation to the key window.
 *********************************************************************************/

/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateWithDuration:(NSTimeInterval)duration
                timingFunction:(MTTimingFunction)timingFunction
                    animations:(MTAnimationsBlock)animations __deprecated;

/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateWithDuration:(NSTimeInterval)duration
                timingFunction:(MTTimingFunction)timingFunction
                    animations:(MTAnimationsBlock)animations
                    completion:(MTAnimationCompletionBlock)completion __deprecated;
/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateWithDuration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
                timingFunction:(MTTimingFunction)timingFunction
                    animations:(MTAnimationsBlock)animations
                    completion:(MTAnimationCompletionBlock)completion __deprecated;

/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateWithDuration:(NSTimeInterval)duration
                timingFunction:(MTTimingFunction)timingFunction
                       options:(MTViewAnimationOptions)options
                    animations:(MTAnimationsBlock)animations
                    completion:(MTAnimationCompletionBlock)completion __deprecated;

/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateWithDuration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
                timingFunction:(MTTimingFunction)timingFunction
                       options:(MTViewAnimationOptions)options
                    animations:(MTAnimationsBlock)animations
                    completion:(MTAnimationCompletionBlock)completion __deprecated;

/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateWithDuration:(NSTimeInterval)duration
                timingFunction:(MTTimingFunction)timingFunction
                         range:(MTAnimationRange)range
                    animations:(MTAnimationsBlock)animations
                    completion:(MTAnimationCompletionBlock)completion __deprecated;

/**
 @param duration        The duration of the animation.
 @param delay           A delay before the animation begins.
 @param timingFunction  The timing function to use for the easing.
 @param options         Some of the UIView MTViewAnimationOptions options are implemented. Not all of them yet, but I'm working on it.
 @param animations      Make your changes to your views in this block and they will be animated to those final values.
 @param completion      Called when the animation completes.
 */
+ (void)mt_animateWithDuration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
                timingFunction:(MTTimingFunction)timingFunction
                         range:(MTAnimationRange)range
                       options:(MTViewAnimationOptions)options
                    animations:(MTAnimationsBlock)animations
                    completion:(MTAnimationCompletionBlock)completion __deprecated;

@end
