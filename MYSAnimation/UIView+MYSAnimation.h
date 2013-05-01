//
//  UIView+MTAnimation.h
//  MTAnimation
//
//  Created by Adam Kirk on 4/25/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSTimingFunctions.h"

/**
 Completion blocks take no arguments and return void.
 */
typedef void(^MYSAnimationCompletionBlock)();

/**
 The `exaggeration` param can be any float value, but these are helpful.
 */
typedef NS_ENUM(NSInteger, MYSAnimationExaggeration) {
    MYSAnimationExaggerationDefault,        // 1.70158;
    MYSAnimationExaggerationLow,            // 0.70158;
    MYSAnimationExaggerationMedium,         // 2.70158;
    MYSAnimationExaggerationHigh,           // 3.70158;
    MYSAnimationExaggerationLudicrous       // 4.70158;
};


@interface UIView (MYSAnimation)

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MYSTimingFunction)timingFunction
             animations:(void (^)(void))animations;

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MYSTimingFunction)timingFunction
             animations:(void (^)(void))animations
             completion:(MYSAnimationCompletionBlock)completion;

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
                options:(UIViewAnimationOptions)options
         timingFunction:(MYSTimingFunction)timingFunction
             animations:(void (^)(void))animations
             completion:(MYSAnimationCompletionBlock)completion;

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
                options:(UIViewAnimationOptions)options
         timingFunction:(MYSTimingFunction)timingFunction
           exaggeration:(CGFloat)exaggeration
             animations:(void (^)(void))animations
             completion:(MYSAnimationCompletionBlock)completion;

@end
