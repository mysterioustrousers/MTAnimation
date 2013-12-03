//
//  MTAnimation.h
//  MTAnimation
//
//  Created by Adam Kirk on 5/3/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#define IS_IOS (TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE)


#if IS_IOS

#define MTView UIView
#import <CoreGraphics/CoreGraphics.h>
#define MTRectValue         CGRectValue
#define MTPointValue        CGPointValue
#define mt_valueWithCGRect  valueWithCGRect
#define mt_valueWithCGPoint valueWithCGPoint
#define mt_alpha            alpha

#else

#define MTView NSView
#import <ApplicationServices/ApplicationServices.h>
#define MTRectValue         rectValue
#define MTPointValue        pointValue
#define mt_valueWithCGRect  valueWithRect
#define mt_valueWithCGPoint valueWithPoint
#define mt_alpha            alphaValue

#endif


/**
 Helper function for converting degrees into radians.
 */
static inline double mt_degreesToRadians(double degrees) { return degrees * M_PI / 180; }

/**
 Helper function to determine if an enum is in a mask
 */
static inline BOOL mt_isInMask(NSUInteger bitmask, NSUInteger value) { return (bitmask & value) == value; }


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
 The `exaggeration` param can be any float value, but these are helpful.
 */
typedef NS_ENUM(NSInteger, MTAnimationExaggeration) {
    MTAnimationExaggerationDefault,        // 1.70158;
    MTAnimationExaggerationLow,            // 0.70158;
    MTAnimationExaggerationMedium,         // 2.70158;
    MTAnimationExaggerationHigh,           // 3.70158;
    MTAnimationExaggerationLudicrous       // 4.70158;
};


/**
 * MTAnimation variants of the animation options for UIKit (to support OS X). The options commented out still need
 * to be implemented by either me or contributors.
 */
typedef NS_OPTIONS(NSUInteger, MTViewAnimationOptions) {
    MTViewAnimationOptionLayoutSubviews            = 1 <<  0,
//    MTViewAnimationOptionAllowUserInteraction      = 1 <<  1, // turn on user interaction while animating
    MTViewAnimationOptionBeginFromCurrentState     = 1 <<  2, // start all views from current value, not initial value
    MTViewAnimationOptionRepeat                    = 1 <<  3, // repeat animation indefinitely
    MTViewAnimationOptionAutoreverse               = 1 <<  4, // if repeat, run animation back and forth
//    MTViewAnimationOptionOverrideInheritedDuration = 1 <<  5, // ignore nested duration
//    MTViewAnimationOptionOverrideInheritedCurve    = 1 <<  6, // ignore nested curve
//    MTViewAnimationOptionAllowAnimatedContent      = 1 <<  7, // animate contents (applies to transitions only)
//    MTViewAnimationOptionShowHideTransitionViews   = 1 <<  8, // flip to/from hidden state instead of adding/removing
//    MTViewAnimationOptionOverrideInheritedOptions  = 1 <<  9, // do not inherit any options or animation type
};

