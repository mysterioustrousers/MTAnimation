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

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MTTimingFunction)timingFunction
             animations:(void (^)(void))animations;

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MTTimingFunction)timingFunction
             animations:(void (^)(void))animations
             completion:(MTAnimationCompletionBlock)completion;

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
                options:(UIViewAnimationOptions)options
         timingFunction:(MTTimingFunction)timingFunction
             animations:(void (^)(void))animations
             completion:(MTAnimationCompletionBlock)completion;

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
                options:(UIViewAnimationOptions)options
         timingFunction:(MTTimingFunction)timingFunction
           exaggeration:(CGFloat)exaggeration
             animations:(void (^)(void))animations
             completion:(MTAnimationCompletionBlock)completion;

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
                options:(UIViewAnimationOptions)options
         timingFunction:(MTTimingFunction)timingFunction
           exaggeration:(CGFloat)exaggeration
                  range:(MTAnimationRange)range
             animations:(void (^)(void))animations
             completion:(MTAnimationCompletionBlock)completion;


@end
