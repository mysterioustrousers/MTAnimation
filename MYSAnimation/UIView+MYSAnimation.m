//
//  UIView+MTAnimation.m
//  MTAnimation
//
//  Created by Adam Kirk on 4/25/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "UIView+MYSAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>




static const NSInteger fps      = 60;
static const NSInteger second   = 1000;

static const char rotationXKey;
static const char rotationYKey;
static const char rotationZKey;
static const char startBoundsKey;
static const char startCenterKey;
static const char startTransformKey;
static const char startAlphaKey;
static const char start3DTransform;
static const char startRotationXKey;
static const char startRotationYKey;
static const char startRotationZKey;
static const char startBackgroundColorKey;
static const char completionBlockKey;




@interface UIView () 
@property (assign, nonatomic) CGRect                        startBounds;
@property (assign, nonatomic) CGPoint                       startCenter;
@property (assign, nonatomic) CGAffineTransform             startTransform;
@property (assign, nonatomic) CGFloat                       startAlpha;
@property (assign, nonatomic) CATransform3D                 start3DTransform;
@property (assign, nonatomic) CGFloat                       startRotationX;
@property (assign, nonatomic) CGFloat                       startRotationY;
@property (assign, nonatomic) CGFloat                       startRotationZ;
@property (strong, nonatomic) MYSAnimationCompletionBlock   completionBlock;
@end




@implementation UIView (MYSAnimation)

+ (void)mys_animateViews:(NSArray *)views
                duration:(NSTimeInterval)duration
          timingFunction:(MYSTimingFunction)timingFunction
              animations:(void (^)(void))animations
{
    [self mys_animateViews:views
                  duration:duration
            timingFunction:timingFunction
                animations:animations
                completion:nil];
}

+ (void)mys_animateViews:(NSArray *)views
                duration:(NSTimeInterval)duration
          timingFunction:(MYSTimingFunction)timingFunction
              animations:(void (^)(void))animations
              completion:(MYSAnimationCompletionBlock)completion
{
    [self mys_animateViews:views
                  duration:duration
                   options:0
            timingFunction:timingFunction
                animations:animations
                completion:completion];
}

+ (void)mys_animateViews:(NSArray *)views
                duration:(NSTimeInterval)duration
                 options:(UIViewAnimationOptions)options
          timingFunction:(MYSTimingFunction)timingFunction
              animations:(void (^)(void))animations
              completion:(MYSAnimationCompletionBlock)completion
{
    [self mys_animateViews:views
                  duration:duration
                   options:options
            timingFunction:timingFunction
              exaggeration:MYSAnimationExaggerationDefault
                animations:animations
                completion:completion];
}

+ (void)mys_animateViews:(NSArray *)views
                duration:(NSTimeInterval)duration
                 options:(UIViewAnimationOptions)options
          timingFunction:(MYSTimingFunction)timingFunction
            exaggeration:(CGFloat)exaggeration
              animations:(void (^)(void))animations
              completion:(MYSAnimationCompletionBlock)completion
{
    assert([views count] > 0);
    assert(duration > 0);
    assert(animations != nil);

    UIView *completionReceiver = [views lastObject];
    completionReceiver.completionBlock = completion;

    for (UIView *view in views) {
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
                                                                      exaggeration:exaggeration];
            [view addAnimation:keyframeAnimation forKey:@"bounds"];
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
                                                                       exaggeration:exaggeration];
            [view addAnimation:keyframeAnimation forKey:@"position"];
        }

        // TODO: does not interpolate rotation correctly
        if (!CGAffineTransformEqualToTransform(view.startTransform, view.transform)) {
            CAKeyframeAnimation *keyframeAnimation  = [CAKeyframeAnimation new];
            keyframeAnimation.keyPath               = @"transform";
            keyframeAnimation.duration              = duration;
            keyframeAnimation.calculationMode       = kCAAnimationLinear;
            keyframeAnimation.delegate              = completionReceiver;
            keyframeAnimation.values                = [self transformValuesWithDuration:duration
                                                                               function:timingFunction
                                                                                   from:CATransform3DMakeAffineTransform(view.startTransform)
                                                                                     to:CATransform3DMakeAffineTransform(view.transform)
                                                                           exaggeration:exaggeration];
            [view addAnimation:keyframeAnimation forKey:@"transform"];
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
                                                                       exaggeration:exaggeration];
            [view addAnimation:keyframeAnimation forKey:@"opacity"];
        }

        if (view.startRotationX != view.mys_rotationX) {
            CAKeyframeAnimation *keyframeAnimation  = [CAKeyframeAnimation new];
            keyframeAnimation.keyPath               = @"transform.rotation.x";
            keyframeAnimation.duration              = duration;
            keyframeAnimation.calculationMode       = kCAAnimationLinear;
            keyframeAnimation.delegate              = completionReceiver;
            keyframeAnimation.values                = [self floatValuesWithDuration:duration
                                                                           function:timingFunction
                                                                               from:view.startRotationX
                                                                                 to:view.mys_rotationX
                                                                       exaggeration:exaggeration];
            [view addAnimation:keyframeAnimation forKey:@"transform.rotation.x"];
        }

        if (view.startRotationY != view.mys_rotationY) {
            CAKeyframeAnimation *keyframeAnimation  = [CAKeyframeAnimation new];
            keyframeAnimation.keyPath               = @"transform.rotation.y";
            keyframeAnimation.duration              = duration;
            keyframeAnimation.calculationMode       = kCAAnimationLinear;
            keyframeAnimation.delegate              = completionReceiver;
            keyframeAnimation.values                = [self floatValuesWithDuration:duration
                                                                           function:timingFunction
                                                                               from:view.startRotationY
                                                                                 to:view.mys_rotationY
                                                                       exaggeration:exaggeration];
            [view addAnimation:keyframeAnimation forKey:@"transform.rotation.y"];
        }

        if (view.startRotationZ != view.mys_rotationZ) {
            CAKeyframeAnimation *keyframeAnimation  = [CAKeyframeAnimation new];
            keyframeAnimation.keyPath               = @"transform.rotation.z";
            keyframeAnimation.duration              = duration;
            keyframeAnimation.rotationMode          = kCAAnimationRotateAuto;
            keyframeAnimation.calculationMode       = kCAAnimationLinear;
            keyframeAnimation.delegate              = completionReceiver;
            keyframeAnimation.values                = [self floatValuesWithDuration:duration
                                                                           function:timingFunction
                                                                               from:view.startRotationZ
                                                                                 to:view.mys_rotationZ
                                                                       exaggeration:exaggeration];
            [view addAnimation:keyframeAnimation forKey:@"transform.rotation.z"];
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
    self.startAlpha             = self.alpha;
    self.start3DTransform       = self.layer.transform;
    self.startRotationX         = self.mys_rotationX;
    self.startRotationY         = self.mys_rotationY;
    self.startRotationZ         = self.mys_rotationZ;
}

+ (NSArray *)rectValuesWithDuration:(NSTimeInterval)duration
                           function:(MYSTimingFunction)timingFuction
                               from:(CGRect)fromRect
                                 to:(CGRect)toRect
                       exaggeration:(CGFloat)exaggeration
{
    duration                *= second;
    NSInteger steps         = (NSInteger)ceil(fps * duration) + 2;
	NSMutableArray *values  = [NSMutableArray arrayWithCapacity:steps];
    CGFloat increment       = 1.0 / (steps - 1);
    CGFloat progress        = 0.0;

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
                            function:(MYSTimingFunction)timingFuction
                                from:(CGPoint)fromPoint
                                  to:(CGPoint)toPoint
                        exaggeration:(CGFloat)exaggeration
{
    duration                *= second;
    exaggeration            = [self exaggerationEnumToFloat:exaggeration];
    NSInteger steps         = (NSInteger)ceil(fps * duration) + 2;
	NSMutableArray *values  = [NSMutableArray arrayWithCapacity:steps];
    CGFloat increment       = 1.0 / (steps - 1);
    CGFloat progress        = 0.0;

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
                                function:(MYSTimingFunction)timingFuction
                                    from:(CATransform3D)fromTransform
                                      to:(CATransform3D)toTransform
                            exaggeration:(CGFloat)exaggeration
{
    duration                *= second;
    exaggeration            = [self exaggerationEnumToFloat:exaggeration];
    NSInteger steps         = (NSInteger)ceil(fps * duration) + 2;
	NSMutableArray *values  = [NSMutableArray arrayWithCapacity:steps];
    CGFloat increment       = 1.0 / (steps - 1);
    CGFloat progress        = 0.0;

    for (NSInteger i = 0; i < steps; i++) {
        CGFloat v           = timingFuction(duration * progress, 0, 1, duration, exaggeration);



        CATransform3D transform = CATransform3DIdentity;
        transform.m11           = fromTransform.m11 + (v * (toTransform.m11 - fromTransform.m11 ));
        transform.m12           = fromTransform.m12 + (v * (toTransform.m12 - fromTransform.m12 ));
        transform.m13           = fromTransform.m13 + (v * (toTransform.m13 - fromTransform.m13 ));
        transform.m14           = fromTransform.m14 + (v * (toTransform.m14 - fromTransform.m14 ));
        transform.m21           = fromTransform.m21 + (v * (toTransform.m21 - fromTransform.m21 ));
        transform.m22           = fromTransform.m22 + (v * (toTransform.m22 - fromTransform.m22 ));
        transform.m23           = fromTransform.m23 + (v * (toTransform.m23 - fromTransform.m23 ));
        transform.m24           = fromTransform.m24 + (v * (toTransform.m24 - fromTransform.m24 ));
        transform.m31           = fromTransform.m31 + (v * (toTransform.m31 - fromTransform.m31 ));
        transform.m32           = fromTransform.m32 + (v * (toTransform.m32 - fromTransform.m32 ));
        transform.m33           = fromTransform.m33 + (v * (toTransform.m33 - fromTransform.m33 ));
        transform.m34           = fromTransform.m34 + (v * (toTransform.m34 - fromTransform.m34 ));
        transform.m41           = fromTransform.m41 + (v * (toTransform.m41 - fromTransform.m41 ));
        transform.m42           = fromTransform.m42 + (v * (toTransform.m42 - fromTransform.m42 ));
        transform.m43           = fromTransform.m43 + (v * (toTransform.m43 - fromTransform.m43 ));
        transform.m44           = fromTransform.m44 + (v * (toTransform.m44 - fromTransform.m44 ));

        [values addObject:[NSValue valueWithCATransform3D:transform]];

        progress += increment;
    }
    
    return values;
}

+ (NSArray *)floatValuesWithDuration:(NSTimeInterval)duration
                            function:(MYSTimingFunction)timingFuction
                                from:(CGFloat)fromFloat
                                  to:(CGFloat)toFloat
                        exaggeration:(CGFloat)exaggeration
{
    duration                *= second;
    exaggeration            = [self exaggerationEnumToFloat:exaggeration];
    NSInteger steps         = (NSInteger)ceil(fps * duration) + 2;
	NSMutableArray *values  = [NSMutableArray arrayWithCapacity:steps];
    CGFloat increment       = 1.0 / (steps - 1);
    CGFloat progress        = 0.0;

    for (NSInteger i = 0; i < steps; i++) {
        CGFloat v           = timingFuction(duration * progress, 0, 1, duration, exaggeration);

        CGFloat flowt       = 0;
        flowt               = fromFloat + (v * (toFloat - fromFloat));

        [values addObject:@(flowt)];

        progress += increment;
    }
    
    return values;
}

- (void)addAnimation:(CAKeyframeAnimation *)animation forKey:(NSString *)key
{
    if ([key isEqualToString:@"bounds"]) {
        CGRect newBounds                = self.bounds;
        self.bounds                     = self.startBounds;
        [self.layer addAnimation:animation forKey:key];
        self.layer.bounds               = newBounds;
    }
    else if ([key isEqualToString:@"position"]) {
        CGPoint newCenter               = self.center;
        self.center                     = self.startCenter;
        [self.layer addAnimation:animation forKey:key];
        self.layer.position             = newCenter;
    }
    else if ([key isEqualToString:@"transform"]) {
        CGAffineTransform newTransform  = self.transform;
        self.transform                  = self.startTransform;
        [self.layer addAnimation:animation forKey:key];
        self.layer.transform            = CATransform3DMakeAffineTransform(newTransform);
    }
    else if ([key isEqualToString:@"opacity"]) {
        CGFloat newAlpha                = self.alpha;
        self.alpha                      = self.startAlpha;
        [self.layer addAnimation:animation forKey:key];
        self.layer.opacity              = newAlpha;
    }
    else if ([key isEqualToString:@"transform.rotation.x"]) {
        CGFloat newRotation             = self.mys_rotationX;
        self.mys_rotationX              = self.startRotationX;
        [self.layer addAnimation:animation forKey:key];
        self.layer.transform            = CATransform3DMakeRotation(newRotation, 1, 0, 0);
    }
    else if ([key isEqualToString:@"transform.rotation.y"]) {
        CGFloat newRotation             = self.mys_rotationY;
        self.mys_rotationY              = self.startRotationY;
        [self.layer addAnimation:animation forKey:key];
        self.layer.transform            = CATransform3DMakeRotation(newRotation, 0, 1, 0);
    }
    else if ([key isEqualToString:@"transform.rotation.z"]) {
        CGFloat newRotation             = self.mys_rotationZ;
        self.mys_rotationZ              = self.startRotationZ;
        [self.layer addAnimation:animation forKey:key];
        self.layer.transform            = CATransform3DMakeRotation(newRotation, 0, 0, 1);
    }
}

+ (CGFloat)exaggerationEnumToFloat:(CGFloat)exaggeration
{
    if (exaggeration == MYSAnimationExaggerationDefault) {
        return 1.70158;
    }
    else if (exaggeration == MYSAnimationExaggerationLow) {
        return 0.70158;
    }
    else if (exaggeration == MYSAnimationExaggerationMedium) {
        return 2.70158;
    }
    else if (exaggeration == MYSAnimationExaggerationHigh) {
        return 3.70158;
    }
    else if (exaggeration == MYSAnimationExaggerationLudicrous) {
        return 4.70158;
    }
    else {
        return exaggeration;
    }
}





#pragma mark - Added Properties

- (void)setMys_rotationX:(CGFloat)rotationX
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.layer.transform = CATransform3DMakeRotation(rotationX, 1, 0, 0);
    [CATransaction commit];

    objc_setAssociatedObject(self, &rotationXKey, @(rotationX), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)mys_rotationX
{
    NSNumber *value = objc_getAssociatedObject(self, &rotationXKey);
    return value ? [value floatValue] : 0;
}

- (void)setMys_rotationY:(CGFloat)rotationY
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.layer.transform = CATransform3DMakeRotation(rotationY, 0, 1, 0);
    [CATransaction commit];

    objc_setAssociatedObject(self, &rotationYKey, @(rotationY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)mys_rotationY
{
    NSNumber *value = objc_getAssociatedObject(self, &rotationYKey);
    return value ? [value floatValue] : 0;
}

- (void)setMys_rotationZ:(CGFloat)rotationZ
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.layer.transform = CATransform3DMakeRotation(rotationZ, 0, 0, 1);
    [CATransaction commit];

    objc_setAssociatedObject(self, &rotationZKey, @(rotationZ), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)mys_rotationZ
{
    NSNumber *value = objc_getAssociatedObject(self, &rotationYKey);
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

- (void)setStartAlpha:(CGFloat)startAlpha
{
    objc_setAssociatedObject(self, &startAlphaKey, @(startAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)startAlpha
{
    NSNumber *value = objc_getAssociatedObject(self, &startAlphaKey);
    return value ? [value floatValue] : 1;
}

- (void)setCompletionBlock:(MYSAnimationCompletionBlock)completionBlock
{
    objc_setAssociatedObject(self, &completionBlockKey, completionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MYSAnimationCompletionBlock)completionBlock
{
    return objc_getAssociatedObject(self, &completionBlockKey);
}

- (void)setStart3DTransform:(CATransform3D)start3DTransform
{
    objc_setAssociatedObject(self, &start3DTransform, [NSValue valueWithCATransform3D:start3DTransform], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CATransform3D)start3DTransform
{
    NSValue *value = objc_getAssociatedObject(self, &startTransformKey);
    return value ? [value CATransform3DValue] : CATransform3DIdentity;
}

- (void)setStartRotationX:(CGFloat)startRotationX
{
    objc_setAssociatedObject(self, &startRotationXKey, @(startRotationX), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)startRotationX
{
    NSNumber *value = objc_getAssociatedObject(self, &startRotationXKey);
    return value ? [value floatValue] : 0;
}

- (void)setStartRotationY:(CGFloat)startRotationY
{
    objc_setAssociatedObject(self, &startRotationYKey, @(startRotationY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)startRotationY
{
    NSNumber *value = objc_getAssociatedObject(self, &startRotationYKey);
    return value ? [value floatValue] : 0;
}

- (void)setStartRotationZ:(CGFloat)startRotationZ
{
    objc_setAssociatedObject(self, &startRotationZKey, @(startRotationZ), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)startRotationZ
{
    NSNumber *value = objc_getAssociatedObject(self, &startRotationYKey);
    return value ? [value floatValue] : 0;
}



@end
