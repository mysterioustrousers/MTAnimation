//
//  UIView+MTAnimation.h
//  MTAnimation
//
//  Created by Adam Kirk on 4/25/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTTimingFunctions.h"
#import "MTAnimationTypes.h"


@interface UIView (MTAnimation)

/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MTTimingFunction)timingFunction
             animations:(void (^)(void))animations;

/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MTTimingFunction)timingFunction
             animations:(void (^)(void))animations
             completion:(MTAnimationCompletionBlock)completion;

/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MTTimingFunction)timingFunction
            perspective:(CGFloat)perspective
             animations:(void (^)(void))animations
             completion:(MTAnimationCompletionBlock)completion;

/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MTTimingFunction)timingFunction
            perspective:(CGFloat)perspective
           exaggeration:(CGFloat)exaggeration
             animations:(void (^)(void))animations
             completion:(MTAnimationCompletionBlock)completion;

/**
 Convenience method. See full method below for param explanations.
 */
+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MTTimingFunction)timingFunction
            perspective:(CGFloat)perspective
                  range:(MTAnimationRange)range
             animations:(void (^)(void))animations
             completion:(MTAnimationCompletionBlock)completion;

/**
 @param views           The list of views you will be modifying in the animation block. You must provide all views you'll be modifying.
 @param duration        The duration of the animation.
 @param timingFunction  The timing function to use for the easing.
 @param perspective     The perspective to apply to the 3D transform matrix. 0 is no perspective. (- 1 / 500) is a good value to experiment with.
 @param exaggeration    Some (but not all) of the easing functions can be exaggerated. (e.g. elastic out will be swing more dramatically with more exaggeration)
 @param options         Some of the UIView UIViewAnimationOptions options are implemented. Not all of them yet, but I'm working on it.
 @param animations      Make your changes to your views in this block and they will be animated to those final values.
 @param completion      Called when the animation completes.
 */
+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MTTimingFunction)timingFunction
            perspective:(CGFloat)perspective
                  range:(MTAnimationRange)range
           exaggeration:(CGFloat)exaggeration
                options:(UIViewAnimationOptions)options
             animations:(void (^)(void))animations
             completion:(MTAnimationCompletionBlock)completion;


@end
