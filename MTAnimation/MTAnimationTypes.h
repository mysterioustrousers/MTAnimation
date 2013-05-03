//
//  MTAnimation.h
//  MTAnimation
//
//  Created by Adam Kirk on 5/3/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


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
 Completion blocks take no arguments and return void.
 */
typedef void(^MTAnimationCompletionBlock)();


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

