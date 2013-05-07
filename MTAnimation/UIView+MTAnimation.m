//
//  UIView+MTAnimation.m
//  MTAnimation
//
//  Created by Adam Kirk on 4/25/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "UIView+MTAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "MTMatrixInterpolation.h"


// is b in the bitmask a
static inline BOOL inMask(NSUInteger a, NSUInteger b) { return (a & b) == b; }

static const NSInteger fps      = 60;
static const NSInteger second   = 1000;

static const char exaggerationKey;
static const char perspectiveKey;
static const char startBoundsKey;
static const char startCenterKey;
static const char startTransformKey;
static const char startTransform3DKey;
static const char startAlphaKey;
static const char startBackgroundColorKey;
static const char completionBlockKey;




@interface UIView ()
@property (assign, nonatomic) CGRect                        startBounds;
@property (assign, nonatomic) CGPoint                       startCenter;
@property (assign, nonatomic) CGAffineTransform             startTransform;
@property (assign, nonatomic) CATransform3D                 startTransform3D;
@property (assign, nonatomic) CGFloat                       startAlpha;
@property (strong, nonatomic) MTAnimationCompletionBlock    completionBlock;
@end




@implementation UIView (MTAnimation)

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MTTimingFunction)timingFunction
             animations:(void (^)(void))animations
{
    return [self mt_animateViews:views
                        duration:duration
                  timingFunction:timingFunction
                      animations:animations
                      completion:nil];
}

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MTTimingFunction)timingFunction
             animations:(void (^)(void))animations
             completion:(MTAnimationCompletionBlock)completion
{
    return [self mt_animateViews:views
                        duration:duration
                  timingFunction:timingFunction
                           range:MTAnimationRangeFull
                      animations:animations
                      completion:completion];
}

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MTTimingFunction)timingFunction
                  range:(MTAnimationRange)range
             animations:(void (^)(void))animations
             completion:(MTAnimationCompletionBlock)completion
{
    return [self mt_animateViews:views
                        duration:duration
                  timingFunction:timingFunction
                           range:range
                         options:0
                      animations:animations
                      completion:completion];
}

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MTTimingFunction)timingFunction
                  range:(MTAnimationRange)range
                options:(UIViewAnimationOptions)options
             animations:(void (^)(void))animations
             completion:(MTAnimationCompletionBlock)completion
{
    assert([views count] > 0);
    assert(duration > 0);
    assert(animations != nil);
    assert(range.start >= 0);
    assert(range.end <= 1);

    UIView *completionReceiver = [views lastObject];
    completionReceiver.completionBlock = completion;

    for (UIView *view in views) {
        [view.layer removeAllAnimations];
        [view takeStartSnapshot];
    }

    if (animations) animations();

    for (UIView *view in views) {

        if (!CGRectEqualToRect(view.startBounds, view.bounds)) {
            CAKeyframeAnimation *keyframeAnimation  = [CAKeyframeAnimation new];
            keyframeAnimation.keyPath               = @"bounds";
            keyframeAnimation.duration              = duration;
            keyframeAnimation.calculationMode       = kCAAnimationLinear;
            keyframeAnimation.delegate              = completionReceiver;
            keyframeAnimation.values                = [self rectValuesWithDuration:duration
                                                                          function:timingFunction
                                                                              from:view.startBounds
                                                                                to:view.bounds
                                                                      exaggeration:view.mt_animationExaggeration];
            [view addAnimation:keyframeAnimation
                        forKey:@"bounds"
                         range:range
                       options:options
                   perspective:view.mt_animationPerspective];
        }


        if (!CGPointEqualToPoint(view.startCenter, view.center)) {
            CAKeyframeAnimation *keyframeAnimation  = [CAKeyframeAnimation new];
            keyframeAnimation.keyPath               = @"position";
            keyframeAnimation.duration              = duration;
            keyframeAnimation.calculationMode       = kCAAnimationLinear;
            keyframeAnimation.delegate              = completionReceiver;
            keyframeAnimation.values                = [self pointValuesWithDuration:duration
                                                                           function:timingFunction
                                                                               from:view.startCenter
                                                                                 to:view.center
                                                                       exaggeration:view.mt_animationExaggeration];
            [view addAnimation:keyframeAnimation
                        forKey:@"position"
                         range:range
                       options:options
                   perspective:view.mt_animationPerspective];
        }

        // TODO: does not interpolate rotation around the z-axis correctly
        if (!CATransform3DEqualToTransform(view.startTransform3D, view.layer.transform)) {
            CAKeyframeAnimation *keyframeAnimation  = [CAKeyframeAnimation new];
            keyframeAnimation.keyPath               = @"transform";
            keyframeAnimation.duration              = duration;
            keyframeAnimation.calculationMode       = kCAAnimationLinear;
            keyframeAnimation.delegate              = completionReceiver;
            keyframeAnimation.values                = [self transformValuesWithDuration:duration
                                                                               function:timingFunction
                                                                                   from:view.startTransform3D
                                                                                     to:view.layer.transform
                                                                           exaggeration:view.mt_animationExaggeration];
            [view addAnimation:keyframeAnimation
                        forKey:@"transform"
                         range:range
                       options:options
                   perspective:view.mt_animationPerspective];
        }

        if (view.startAlpha != view.alpha) {
            CAKeyframeAnimation *keyframeAnimation  = [CAKeyframeAnimation new];
            keyframeAnimation.keyPath               = @"opacity";
            keyframeAnimation.duration              = duration;
            keyframeAnimation.calculationMode       = kCAAnimationLinear;
            keyframeAnimation.delegate              = completionReceiver;
            keyframeAnimation.values                = [self floatValuesWithDuration:duration
                                                                           function:timingFunction
                                                                               from:view.startAlpha
                                                                                 to:view.alpha
                                                                       exaggeration:view.mt_animationExaggeration];
            [view addAnimation:keyframeAnimation
                        forKey:@"opacity"
                         range:range
                       options:options
                   perspective:view.mt_animationPerspective];
        }
    }
}




#pragma mark - CAAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished
{
    if (self.completionBlock != nil)
    {
        self.completionBlock();
        self.completionBlock = nil;
    }
}




#pragma mark - Private

- (void)takeStartSnapshot
{
    self.startBounds            = self.bounds;
    self.startCenter            = self.center;
    self.startTransform         = self.transform;
    self.startTransform3D       = self.layer.transform;
    self.startAlpha             = self.alpha;
}

+ (NSArray *)rectValuesWithDuration:(NSTimeInterval)duration
                           function:(MTTimingFunction)timingFuction
                               from:(CGRect)fromRect
                                 to:(CGRect)toRect
                       exaggeration:(CGFloat)exaggeration
{
    NSInteger steps         = (NSInteger)ceil(fps * duration) + 2;
	NSMutableArray *values  = [NSMutableArray arrayWithCapacity:steps];
    CGFloat increment       = 1.0 / (steps - 1);
    CGFloat progress        = 0.0;
    duration                *= second;

    for (NSInteger i = 0; i < steps; i++) {
        CGFloat v           = timingFuction(duration * progress, 0, 1, duration, exaggeration);

        CGRect rect         = CGRectZero;
        rect.origin.x       = fromRect.origin.x     + (v * (toRect.origin.x      - fromRect.origin.x));
        rect.origin.y       = fromRect.origin.y     + (v * (toRect.origin.y      - fromRect.origin.y));
        rect.size.width     = fromRect.size.width   + (v * (toRect.size.width    - fromRect.size.width));
        rect.size.height    = fromRect.size.height  + (v * (toRect.size.height   - fromRect.size.height));

        [values addObject:[NSValue valueWithCGRect:rect]];

        progress += increment;
    }

    return values;
}

+ (NSArray *)pointValuesWithDuration:(NSTimeInterval)duration
                            function:(MTTimingFunction)timingFuction
                                from:(CGPoint)fromPoint
                                  to:(CGPoint)toPoint
                        exaggeration:(CGFloat)exaggeration
{
    NSInteger steps         = (NSInteger)ceil(fps * duration) + 2;
	NSMutableArray *values  = [NSMutableArray arrayWithCapacity:steps];
    CGFloat increment       = 1.0 / (steps - 1);
    CGFloat progress        = 0.0;
    duration                *= second;

    for (NSInteger i = 0; i < steps; i++) {
        CGFloat v           = timingFuction(duration * progress, 0, 1, duration, exaggeration);

        CGPoint point       = CGPointZero;
        point.x             = fromPoint.x     + (v * (toPoint.x      - fromPoint.x));
        point.y             = fromPoint.y     + (v * (toPoint.y      - fromPoint.y));

        [values addObject:[NSValue valueWithCGPoint:point]];

        progress += increment;
    }

    return values;
}

+ (NSArray *)transformValuesWithDuration:(NSTimeInterval)duration
                                function:(MTTimingFunction)timingFuction
                                    from:(CATransform3D)fromTransform
                                      to:(CATransform3D)toTransform
                            exaggeration:(CGFloat)exaggeration
{
    NSInteger steps         = (NSInteger)ceil(fps * duration) + 2;
	NSMutableArray *values  = [NSMutableArray arrayWithCapacity:steps];
    CGFloat increment       = 1.0 / (steps - 1);
    CGFloat progress        = 0.0;
    duration                *= second;

    for (NSInteger i = 0; i < steps; i++) {
        CGFloat v           = timingFuction(duration * progress, 0, 1, duration, exaggeration);

        CATransform3D transform = interpolatedMatrixFromMatrix(fromTransform, toTransform, v);

        // TODO: add perspective. isn't working at the moment. I set it and it's ignored.

        [values addObject:[NSValue valueWithCATransform3D:transform]];

        progress += increment;
    }

    return values;
}

+ (NSArray *)floatValuesWithDuration:(NSTimeInterval)duration
                            function:(MTTimingFunction)timingFuction
                                from:(CGFloat)fromFloat
                                  to:(CGFloat)toFloat
                        exaggeration:(CGFloat)exaggeration
{
    NSInteger steps         = (NSInteger)ceil(fps * duration) + 2;
	NSMutableArray *values  = [NSMutableArray arrayWithCapacity:steps];
    CGFloat increment       = 1.0 / (steps - 1);
    CGFloat progress        = 0.0;
    duration                *= second;

    for (NSInteger i = 0; i < steps; i++) {
        CGFloat v           = timingFuction(duration * progress, 0, 1, duration, exaggeration);

        CGFloat flowt       = 0;
        flowt               = fromFloat + (v * (toFloat - fromFloat));

        [values addObject:@(flowt)];

        progress += increment;
    }

    return values;
}

- (void)addAnimation:(CAKeyframeAnimation *)animation
              forKey:(NSString *)key
               range:(MTAnimationRange)range
             options:(UIViewAnimationOptions)options
         perspective:(CGFloat)perspective
{
    // slice the animation to the range
    CGFloat rangeDelta  = range.end - range.start;
    animation.duration  = animation.duration * rangeDelta;
    NSInteger steps     = [animation.values count];
    NSUInteger loc      = lroundf(steps * range.start);
    NSUInteger len      = lroundf(steps * range.end) - loc;
    NSRange valueRange  = NSMakeRange(MAX(loc, 0), MIN(len, steps));
    animation.values    = [animation.values subarrayWithRange:valueRange];



    // apply options
    /**
     TODO: Options to implement:
     - UIViewAnimationOptionLayoutSubviews
     - UIViewAnimationOptionAllowUserInteraction
     + UIViewAnimationOptionBeginFromCurrentState
     + UIViewAnimationOptionRepeat
     + UIViewAnimationOptionAutoreverse
     - UIViewAnimationOptionOverrideInheritedDuration
     - UIViewAnimationOptionOverrideInheritedCurve
     - UIViewAnimationOptionAllowAnimatedContent
     - UIViewAnimationOptionShowHideTransitionViews
     (- needs, + done)
     */

    // TODO: this seems to be enabled by default when animating with UIView, so I'm not sure what the difference
    // is with the UIViewAnimationOptionLayoutSubviews option. I think it has something to do with telling it to
    // layout in the beginning so that the beginning of the animation looks sort of blurry/pixelated but the end
    // looks sharp.
    self.layer.needsDisplayOnBoundsChange = YES;
//    if (inMask(options, UIViewAnimationOptionLayoutSubviews)) {
//        self.layer.needsDisplayOnBoundsChange = YES;
//    }

    if (inMask(options, UIViewAnimationOptionBeginFromCurrentState)) {
        animation.additive = YES;
    }

    if (inMask(options, UIViewAnimationOptionAutoreverse)) {
        animation.autoreverses = YES;
    }

    if (inMask(options, UIViewAnimationOptionRepeat)) {
        animation.repeatCount = HUGE_VALF;
    }


    // add perspective
    CATransform3D perspectiveTransform = CATransform3DIdentity;
    perspectiveTransform.m34 = perspective;
    self.layer.superlayer.sublayerTransform = perspectiveTransform;

    // add the animation
    if ([key isEqualToString:@"bounds"]) {
        self.bounds                     = self.startBounds;
        [self.layer addAnimation:animation forKey:key];
        self.layer.bounds               = [[animation.values lastObject] CGRectValue];
    }
    else if ([key isEqualToString:@"position"]) {
        self.center                     = self.startCenter;
        [self.layer addAnimation:animation forKey:key];
        self.layer.position             = [[animation.values lastObject] CGPointValue];
    }
    else if ([key isEqualToString:@"opacity"]) {
        self.alpha                      = self.startAlpha;
        [self.layer addAnimation:animation forKey:key];
        self.layer.opacity              = [[animation.values lastObject] floatValue];
    }
    else if ([key isEqualToString:@"transform"]) {
        self.layer.transform            = self.startTransform3D;
        [self.layer addAnimation:animation forKey:key];
        self.layer.transform            = [[animation.values lastObject] CATransform3DValue];
    }
}





#pragma mark - Added Properties

- (void)setMt_animationExaggeration:(CGFloat)mt_animationExaggeration
{
    objc_setAssociatedObject(self, &exaggerationKey, @(mt_animationExaggeration), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)mt_animationExaggeration
{
    NSNumber *value = objc_getAssociatedObject(self, &exaggerationKey);
    return value ? [value floatValue] : 1.70158;
}

- (void)setMt_animationPerspective:(CGFloat)mt_animationPerspective
{
    objc_setAssociatedObject(self, &perspectiveKey, @(mt_animationPerspective), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)mt_animationPerspective
{
    NSNumber *value = objc_getAssociatedObject(self, &perspectiveKey);
    return value ? [value floatValue] : 0;
}




#pragma mark (private)

- (void)setStartBounds:(CGRect)startBounds
{
    objc_setAssociatedObject(self, &startBoundsKey, [NSValue valueWithCGRect:startBounds], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)startBounds
{
    NSValue *value = objc_getAssociatedObject(self, &startBoundsKey);
    return value ? [value CGRectValue] : CGRectZero;
}

- (void)setStartCenter:(CGPoint)startCenter
{
    objc_setAssociatedObject(self, &startCenterKey, [NSValue valueWithCGPoint:startCenter], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGPoint)startCenter
{
    NSValue *value = objc_getAssociatedObject(self, &startCenterKey);
    return value ? [value CGPointValue] : CGPointZero;
}

- (void)setStartTransform:(CGAffineTransform)startTransform
{
    objc_setAssociatedObject(self, &startTransformKey, [NSValue valueWithCGAffineTransform:startTransform], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGAffineTransform)startTransform
{
    NSValue *value = objc_getAssociatedObject(self, &startTransformKey);
    return value ? [value CGAffineTransformValue] : CGAffineTransformIdentity;
}

- (void)setStartTransform3D:(CATransform3D)startTransform3D
{
    objc_setAssociatedObject(self, &startTransform3DKey, [NSValue valueWithCATransform3D:startTransform3D], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CATransform3D)startTransform3D
{
    NSValue *value = objc_getAssociatedObject(self, &startTransform3DKey);
    return value ? [value CATransform3DValue] : CATransform3DIdentity;
}

- (void)setStartAlpha:(CGFloat)startAlpha
{
    objc_setAssociatedObject(self, &startAlphaKey, @(startAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)startAlpha
{
    NSNumber *value = objc_getAssociatedObject(self, &startAlphaKey);
    return value ? [value floatValue] : 1;
}

- (void)setCompletionBlock:(MTAnimationCompletionBlock)completionBlock
{
    objc_setAssociatedObject(self, &completionBlockKey, completionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MTAnimationCompletionBlock)completionBlock
{
    return objc_getAssociatedObject(self, &completionBlockKey);
}

@end









// TODO: use this for color interpolation
// Core Graphics uses Core Foundation types internally
//if ([fromValue isKindOfClass: NSClassFromString(@"__NSCFType")] &&
//    [toValue isKindOfClass: NSClassFromString(@"__NSCFType")] &&
//    CFGetTypeID(fromValue) == CGColorGetTypeID() &&
//    CFGetTypeID(toValue) == CGColorGetTypeID())
//{
//    CGColorRef from = (CGColorRef)fromValue;
//    CGColorRef to = (CGColorRef)toValue;
//
//    if (CGColorGetNumberOfComponents(from) == CGColorGetNumberOfComponents(to) &&
//        CGColorGetColorSpace(from) == CGColorGetColorSpace(to))
//    {
//        const CGFloat * fromComponents = CGColorGetComponents(from);
//        const CGFloat * toComponents = CGColorGetComponents(to);
//
//        size_t numberOfComponents = CGColorGetNumberOfComponents(from);
//
//        CGFloat valueComponents[4] = { 0, 0, 0, 1 }; //numberOfComponents];
//        for (int i = 0; i < numberOfComponents; i++)
//        {
//            valueComponents[i] = linearInterpolation(fromComponents[i], toComponents[i], fraction);
//        }
//
//        return [(id)CGColorCreate(CGColorGetColorSpace(from), valueComponents) autorelease];
//    }
//}

