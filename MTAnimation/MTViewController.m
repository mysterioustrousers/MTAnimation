//
//  MTViewController.m
//  MTAnimation
//
//  Created by Adam Kirk on 4/25/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MTViewController.h"
#import "UIView+MTAnimation.h"
#import <QuartzCore/QuartzCore.h>


@interface MTViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak,   nonatomic) IBOutlet UITableView  *tableView;
@property (weak,   nonatomic) IBOutlet UIImageView  *logoImageView;
@property (weak,   nonatomic) IBOutlet UIView       *animationAreaView;
@property (assign, nonatomic) CGRect                startFrame;
@property (assign, nonatomic) MTTimingFunction      timingFuction;
@property (assign, nonatomic) NSTimeInterval        duration;
@property (assign, nonatomic) NSTimeInterval        delay;
@property (assign, nonatomic) CGFloat               exaggeration;
@property (assign, nonatomic) CGFloat               endY;
@property (assign, nonatomic) CGFloat               endX;
@property (assign, nonatomic) CGFloat               endScale;
@property (assign, nonatomic) CGFloat               endRotation;
@property (assign, nonatomic) CGFloat               endAlpha;
@end



@implementation MTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.startFrame     = self.logoImageView.frame;
    self.timingFuction  = kMTEaseOutBack;
    self.duration       = 1;
    self.delay          = 0;
    self.exaggeration   = 1.7;
    self.endY           = 50;
    self.endX           = 50;
    self.endScale       = 1;
    self.endRotation    = 0;
    self.endAlpha       = 1;

    [self.animationAreaView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(animationAreaWasTapped:)]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:25 inSection:0]
                                animated:NO
                          scrollPosition:UITableViewScrollPositionTop];
}




#pragma mark - Actions

- (void)animationAreaWasTapped:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.animationAreaView];
    self.endX = point.x - (self.logoImageView.frame.size.width / 2.0);
    self.endY = point.y - (self.logoImageView.frame.size.height / 2.0);
    [self animate];
}

- (IBAction)durationChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    self.duration = slider.value;
    [self animate];
}

- (IBAction)delayChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    self.delay = slider.value;
}

- (IBAction)exaggerationChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    self.exaggeration = slider.value;
    [self animate];
}

- (IBAction)endScaleChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    self.endScale = slider.value;
    [self animate];
}

- (IBAction)endRotationChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    self.endRotation = slider.value;
    [self animate];
}

- (IBAction)endAlphaDidChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    self.endAlpha = slider.value;
    [self animate];
}







#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self functionMap] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSDictionary *functionDict = [self functionForRow:indexPath.row];
    NSString *functionName = [[functionDict allKeys] lastObject];

    cell.textLabel.text = functionName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *functionDict = [self functionForRow:indexPath.row];
    _timingFuction = [[[functionDict allValues] lastObject] pointerValue];
    [self animate];
}




#pragma mark - Private

- (void)animate
{
    CGRect r                           = self.logoImageView.frame;
    r.size                             = self.startFrame.size;
    self.logoImageView.frame           = r;

    self.logoImageView.layer.transform = CATransform3DIdentity;
    self.logoImageView.alpha           = 1;

    [UIView mt_animateWithViews:[self.view.window mt_allSubviews]
                       duration:self.duration
                          delay:self.delay
                 timingFunction:self.timingFuction
                        options:MTViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.logoImageView.mt_animationPerspective = -1.0 / 500.0;
                         CGRect r                                   = self.logoImageView.frame;
                         r.origin.x                                 = self.endX;
                         r.origin.y                                 = self.endY;
                         self.logoImageView.frame                   = [self scaledRect:r];
                         self.logoImageView.alpha                   = self.endAlpha;
                         CGFloat radians                            = mt_degreesToRadians(self.endRotation);
                         self.logoImageView.layer.transform         = CATransform3DMakeRotation(radians, 0, 1, 0);
                     } completion:^{
                         NSLog(@"completed");
                     }];


}

- (NSArray *)functionMap
{
    static NSArray *functions;
    functions = @[
                  @{  @"EaseInQuad"         : [NSValue valueWithPointer:&MTTimingFunctionEaseInQuad       ] },
                  @{  @"EaseOutQuad"    	: [NSValue valueWithPointer:&MTTimingFunctionEaseOutQuad      ] },
                  @{  @"EaseInOutQuad"  	: [NSValue valueWithPointer:&MTTimingFunctionEaseInOutQuad    ] },

                  @{  @"EaseInCubic"     	: [NSValue valueWithPointer:&MTTimingFunctionEaseInCubic      ] },
                  @{  @"EaseOutCubic"    	: [NSValue valueWithPointer:&MTTimingFunctionEaseOutCubic     ] },
                  @{  @"EaseInOutCubic"  	: [NSValue valueWithPointer:&MTTimingFunctionEaseInOutCubic   ] },

                  @{  @"EaseInQuart"     	: [NSValue valueWithPointer:&MTTimingFunctionEaseInQuart      ] },
                  @{  @"EaseOutQuart"    	: [NSValue valueWithPointer:&MTTimingFunctionEaseOutQuart     ] },
                  @{  @"EaseInOutQuart"  	: [NSValue valueWithPointer:&MTTimingFunctionEaseInOutQuart   ] },

                  @{  @"EaseInQuint"     	: [NSValue valueWithPointer:&MTTimingFunctionEaseInQuint      ] },
                  @{  @"EaseOutQuint"    	: [NSValue valueWithPointer:&MTTimingFunctionEaseOutQuint     ] },
                  @{  @"EaseInOutQuint"  	: [NSValue valueWithPointer:&MTTimingFunctionEaseInOutQuint   ] },

                  @{  @"EaseInSine"     	: [NSValue valueWithPointer:&MTTimingFunctionEaseInSine       ] },
                  @{  @"EaseOutSine"    	: [NSValue valueWithPointer:&MTTimingFunctionEaseOutSine      ] },
                  @{  @"EaseInOutSine"  	: [NSValue valueWithPointer:&MTTimingFunctionEaseInOutSine    ] },

                  @{  @"EaseInExpo"     	: [NSValue valueWithPointer:&MTTimingFunctionEaseInExpo       ] },
                  @{  @"EaseOutExpo"    	: [NSValue valueWithPointer:&MTTimingFunctionEaseOutExpo      ] },
                  @{  @"EaseInOutExpo"  	: [NSValue valueWithPointer:&MTTimingFunctionEaseInOutExpo    ] },

                  @{  @"EaseInCirc"     	: [NSValue valueWithPointer:&MTTimingFunctionEaseInCirc       ] },
                  @{  @"EaseOutCirc"    	: [NSValue valueWithPointer:&MTTimingFunctionEaseOutCirc      ] },
                  @{  @"EaseInOutCirc"  	: [NSValue valueWithPointer:&MTTimingFunctionEaseInOutCirc    ] },

                  @{  @"EaseInElastic"     	: [NSValue valueWithPointer:&MTTimingFunctionEaseInElastic    ] },
                  @{  @"EaseOutElastic"    	: [NSValue valueWithPointer:&MTTimingFunctionEaseOutElastic   ] },
                  @{  @"EaseInOutElastic"  	: [NSValue valueWithPointer:&MTTimingFunctionEaseInOutElastic ] },

                  @{  @"EaseInBack"     	: [NSValue valueWithPointer:&MTTimingFunctionEaseInBack       ] },
                  @{  @"EaseOutBack"    	: [NSValue valueWithPointer:&MTTimingFunctionEaseOutBack      ] },
                  @{  @"EaseInOutBack"  	: [NSValue valueWithPointer:&MTTimingFunctionEaseInOutBack    ] },

                  @{  @"EaseInBounce"     	: [NSValue valueWithPointer:&MTTimingFunctionEaseInBounce     ] },
                  @{  @"EaseOutBounce"    	: [NSValue valueWithPointer:&MTTimingFunctionEaseOutBounce    ] },
                  @{  @"EaseInOutBounce"  	: [NSValue valueWithPointer:&MTTimingFunctionEaseInOutBounce  ] }

                  ];
    return functions;
}

- (NSDictionary *)functionForRow:(NSInteger)row
{
    NSArray *functions = [self functionMap];
    return functions[row];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setAnimationAreaView:nil];
    [super viewDidUnload];
}

- (CGRect)scaledRect:(CGRect)r
{
    CGFloat h       = self.startFrame.size.height;
    CGFloat w       = self.startFrame.size.width;
    CGFloat hh      = h * self.endScale;
    CGFloat ww      = w * self.endScale;
    r.size.height   = hh;
    r.size.width    = ww;
    r.origin.y      -= (hh - h) / 2.0;
    r.origin.x      -= (ww - w) / 2.0;
    return r;
}


@end
