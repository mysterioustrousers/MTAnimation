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

static const char startFrameKey;
static const char startBoundsKey;
static const char startCenterKey;
static const char startTransformKey;
static const char startAlphaKey;
static const char startBackgroundColorKey;
static const char completionBlockKey;




@interface UIView () 
@property (assign, nonatomic) CGRect                        startFrame;
@property (assign, nonatomic) CGRect                        startBounds;
@property (assign, nonatomic) CGPoint                       startCenter;
@property (assign, nonatomic) CGAffineTransform             startTransform;
@property (assign, nonatomic) CGFloat                       startAlpha;
@property (strong, nonatomic) UIColor                       *startBackgroundColor;
@property (strong, nonatomic) MYSAnimationCompletionBlock   completionBlock;
@end




@implementation UIView (MYSAnimation)


+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MYSTimingFunction)timingFunction
             animations:(void (^)(void))animations
{
    [self mt_animateViews:views
                 duration:duration
           timingFunction:timingFunction
               animations:animations
               completion:nil];
}

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
         timingFunction:(MYSTimingFunction)timingFunction
             animations:(void (^)(void))animations
             completion:(MYSAnimationCompletionBlock)completion
{
    [self mt_animateViews:views
                 duration:duration
                  options:0
           timingFunction:timingFunction
               animations:animations
               completion:completion];
}

+ (void)mt_animateViews:(NSArray *)views
               duration:(NSTimeInterval)duration
                options:(UIViewAnimationOptions)options
         timingFunction:(MYSTimingFunction)timingFunction
             animations:(void (^)(void))animations
             completion:(MYSAnimationCompletionBlock)completion
{
    [self mt_animateViews:views
                 duration:duration
                  options:options
           timingFunction:timingFunction
             exaggeration:MYSAnimationExaggerationDefault
               animations:animations
               completion:completion];
}

+ (void)mt_animateViews:(NSArray *)views
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


        if (!CGAffineTransformEqualToTransform(view.startTransform, view.transform)) {
            CAKeyframeAnimation *keyframeAnimation  = [CAKeyframeAnimation new];
            keyframeAnimation.keyPath               = @"transform";
            keyframeAnimation.duration              = duration;
            keyframeAnimation.calculationMode       = kCAAnimationLinear;
            keyframeAnimation.delegate              = completionReceiver;
            keyframeAnimation.values                = [self transformValuesWithDuration:duration
                                                                               function:timingFunction
                                                                                   from:view.startTransform
                                                                                     to:view.transform
                                                                           exaggeration:exaggeration];
            [view addAnimation:keyframeAnimation forKey:@"transform"];
        }


        if (view.startAlpha != view.alpha) {
            CAKeyframeAnimation *keyframeAnimation  = [CAKeyframeAnimation new];
            keyframeAnimation.keyPath               = @"alpha";
            keyframeAnimation.duration              = duration;
            keyframeAnimation.calculationMode       = kCAAnimationLinear;
            keyframeAnimation.delegate              = completionReceiver;
            keyframeAnimation.values                = [self floatValuesWithDuration:duration
                                                                           function:timingFunction
                                                                               from:view.startAlpha
                                                                                 to:view.alpha
                                                                       exaggeration:exaggeration];
            [view addAnimation:keyframeAnimation forKey:@"alpha"];
        }

        
//        if (![view.startBackgroundColor isEqual:view.backgroundColor]) {
//            CAKeyframeAnimation *keyframeAnimation  = [CAKeyframeAnimation new];
//            keyframeAnimation.duration              = duration;
//            keyframeAnimation.calculationMode       = kCAAnimationLinear;
//            keyframeAnimation.delegate              = completionReceiver;
//            keyframeAnimation.values                = [self colorValuesWithDuration:duration
//                                                                           function:timingFunction
//                                                                               from:view.startBackgroundColor
//                                                                                 to:view.backgroundColor];
//            [view addAnimation:keyframeAnimation forKey:@"backgroundColor"];
//        }
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
    self.startFrame             = self.frame;
    self.startBounds            = self.bounds;
    self.startCenter            = self.center;
    self.startTransform         = self.transform;
    self.startAlpha             = self.alpha;
    self.startBackgroundColor   = self.backgroundColor;
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
                                    from:(CGAffineTransform)fromTransform
                                      to:(CGAffineTransform)toTransform
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

        CGAffineTransform transform = CGAffineTransformIdentity;
        transform.a         = fromTransform.a     + (v * (toTransform.a      - fromTransform.a));
        transform.b         = fromTransform.b     + (v * (toTransform.b      - fromTransform.b));
        transform.c         = fromTransform.c     + (v * (toTransform.c      - fromTransform.c));
        transform.d         = fromTransform.d     + (v * (toTransform.d      - fromTransform.d));
        transform.tx        = fromTransform.tx    + (v * (toTransform.tx     - fromTransform.tx));
        transform.ty        = fromTransform.ty    + (v * (toTransform.ty     - fromTransform.ty));

        [values addObject:[NSValue valueWithCGAffineTransform:transform]];

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

+ (NSArray *)colorValuesWithDuration:(NSTimeInterval)duration
                            function:(MYSTimingFunction)timingFuction
                                from:(UIColor *)fromColor
                                  to:(UIColor *)toColor
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

        CGFloat fromRed     = 0;
        CGFloat fromGreen   = 0;
        CGFloat fromBlue    = 0;
        CGFloat fromAlpha   = 0;
        [toColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];

        CGFloat toRed       = 0;
        CGFloat toGreen     = 0;
        CGFloat toBlue      = 0;
        CGFloat toAlpha     = 0;
        [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];


        CGFloat red         = fromRed   + (v * (toRed   - fromRed));
        CGFloat green       = fromGreen + (v * (toGreen - fromGreen));
        CGFloat blue        = fromBlue  + (v * (toBlue  - fromBlue));
        CGFloat alpha       = fromAlpha + (v * (toAlpha - fromAlpha));
        UIColor *color      = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];

        [values addObject:color];

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
        self.transform                  = newTransform;
    }
    else if ([key isEqualToString:@"alpha"]) {
        CGFloat newAlpha                = self.alpha;
        self.alpha                      = self.startAlpha;
        [self.layer addAnimation:animation forKey:key];
        self.layer.opacity              = newAlpha;
    }
    else if ([key isEqualToString:@"backgroundColor"]) {
        UIColor *newBackgroundColor     = self.backgroundColor;
        self.backgroundColor            = self.startBackgroundColor;
        [self.layer addAnimation:animation forKey:key];
        self.backgroundColor            = newBackgroundColor;
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

- (void)setStartFrame:(CGRect)startFrame
{
    objc_setAssociatedObject(self, &startFrameKey, [NSValue valueWithCGRect:startFrame], OBJC_ASSOCIATION_ASSIGN);
}

- (CGRect)startFrame
{
    NSValue *value = objc_getAssociatedObject(self, &startFrameKey);
    return value ? [value CGRectValue] : CGRectZero;
}

- (void)setStartBounds:(CGRect)startBounds
{
    objc_setAssociatedObject(self, &startBoundsKey, [NSValue valueWithCGRect:startBounds], OBJC_ASSOCIATION_ASSIGN);
}

- (CGRect)startBounds
{
    NSValue *value = objc_getAssociatedObject(self, &startBoundsKey);
    return value ? [value CGRectValue] : CGRectZero;
}

- (void)setStartCenter:(CGPoint)startCenter
{
    objc_setAssociatedObject(self, &startCenterKey, [NSValue valueWithCGPoint:startCenter], OBJC_ASSOCIATION_ASSIGN);
}

- (CGPoint)startCenter
{
    NSValue *value = objc_getAssociatedObject(self, &startCenterKey);
    return value ? [value CGPointValue] : CGPointZero;
}

- (void)setStartTransform:(CGAffineTransform)startTransform
{
    objc_setAssociatedObject(self, &startTransformKey, [NSValue valueWithCGAffineTransform:startTransform], OBJC_ASSOCIATION_ASSIGN);
}

- (CGAffineTransform)startTransform
{
    NSValue *value = objc_getAssociatedObject(self, &startTransformKey);
    return value ? [value CGAffineTransformValue] : CGAffineTransformIdentity;
}

- (void)setStartAlpha:(CGFloat)startAlpha
{
    objc_setAssociatedObject(self, &startAlphaKey, @(startAlpha), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)startAlpha
{
    NSNumber *value = objc_getAssociatedObject(self, &startAlphaKey);
    return value ? [value floatValue] : 1;
}

- (void)setStartBackgroundColor:(UIColor *)startBackgroundColor
{
    objc_setAssociatedObject(self, &startBackgroundColorKey, startBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)startBackgroundColor
{
    return objc_getAssociatedObject(self, &startBackgroundColorKey);
}

- (void)setCompletionBlock:(MYSAnimationCompletionBlock)completionBlock
{
    objc_setAssociatedObject(self, &completionBlockKey, completionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MYSAnimationCompletionBlock)completionBlock
{
    return objc_getAssociatedObject(self, &completionBlockKey);
}




@end
