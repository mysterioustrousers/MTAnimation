//
//  MTAnimation.h
//  MTAnimation
//
//  Created by Adam Kirk on 5/3/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#define IS_IOS (TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE)


#if IS_IOS
#import <CoreGraphics/CoreGraphics.h>
#else
#import <ApplicationServices/ApplicationServices.h>
#endif


/**
 Helper function for converting degrees into radians.
 */
static inline double mt_degreesToRadians(double degrees) { return degrees * M_PI / 180; }


/**
 This type allows you to clip an animation. For example, if you wanted to split an animation into
 two parts, you could create two animations with the same easing and specify the first half with
 a range of (0.0, 0.5) and the second half with a range of (0.5, 1.0). 0 being the beginning of
 the animation and 1 being the completed animation.
 */
typedef struct {
    CGFloat start;
    CGFloat end;
} MTAnimationRange;


/**
 Convenience for creating an MTAnimationRange struct.
 */
NS_INLINE MTAnimationRange MTMakeAnimationRange(CGFloat start, CGFloat end) {
    MTAnimationRange r;
    r.start = MAX(0, start);
    r.end   = MIN(1, end);
    return r;
}


/**
 Convenience for creating a default full range MTAnimationRange struct.
 */
#define MTAnimationRangeFull MTMakeAnimationRange(0,1)


/**
 Animation blocks take no arguments and return void.
 */
typedef void(^MTAnimationsBlock)();


/**
 Completion blocks take no arguments and return void.
 */
typedef void(^MTAnimationCompletionBlock)();


/**
 Animation options
 */
typedef NS_ENUM(NSUInteger, MTAnimationOptions) {
    MTAnimationOptionLayoutSubviews            = 1 << 0, // TODO: Not implemented yet
    MTAnimationOptionAllowUserInteraction      = 1 << 1, // TODO: Not implemented yet
    MTAnimationOptionBeginFromCurrentState     = 1 << 2,
    MTAnimationOptionRepeat                    = 1 << 3,
    MTAnimationOptionAutoreverse               = 1 << 4,
    MTAnimationOptionOverrideInheritedDuration = 1 << 5, // TODO: Not implemented yet
    MTAnimationOptionOverrideInheritedCurve    = 1 << 6, // TODO: Not implemented yet
    MTAnimationOptionAllowAnimatedContent      = 1 << 7, // TODO: Not implemented yet
    MTAnimationOptionShowHideTransitionViews   = 1 << 8, // TODO: Not implemented yet
};


#if !IS_IOS
typedef MTAnimationOptions UIViewAnimationOptions;
#endif


/**
 The `exaggeration` param can be any float value, but these are helpful.
 */
typedef NS_ENUM(NSInteger, MTAnimationExaggeration) {
    MTAnimationExaggerationDefault,        // 1.70158;
    MTAnimationExaggerationLow,            // 0.70158;
    MTAnimationExaggerationMedium,         // 2.70158;
    MTAnimationExaggerationHigh,           // 3.70158;
    MTAnimationExaggerationLudicrous       // 4.70158;
};

