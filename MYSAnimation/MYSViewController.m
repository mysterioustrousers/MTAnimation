//
//  MYSViewController.m
//  MYSAnimation
//
//  Created by Adam Kirk on 4/25/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSViewController.h"
#import "UIView+MYSAnimation.h"


@interface MYSViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak,   nonatomic) IBOutlet UITableView  *tableView;
@property (weak,   nonatomic) IBOutlet UIImageView  *logoImageView;
@property (assign, nonatomic) CGRect                startFrame;
@property (assign, nonatomic) MYSTimingFunction     timingFuction;
@property (assign, nonatomic) CGFloat               duration;
@property (assign, nonatomic) CGFloat               exaggeration;
@property (assign, nonatomic) CGFloat               endY;
@property (assign, nonatomic) CGFloat               endX;
@property (assign, nonatomic) CGFloat               endScale;
@property (assign, nonatomic) CGFloat               endRotation;
@property (assign, nonatomic) CGFloat               endAlpha;
@end



@implementation MYSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _startFrame     = _logoImageView.frame;
    _timingFuction  = kMYSEaseInQuad;
    _duration       = 1;
    _exaggeration   = 1.7;
    _endY           = 0;
    _endX           = 0;
    _endScale       = 1;
    _endRotation    = 0;
    _endAlpha       = 1;
}




#pragma mark - Actions

- (IBAction)durationChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    _duration = slider.value;
    [self animate];
}

- (IBAction)exaggerationChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    _exaggeration = slider.value;
    [self animate];
}

- (IBAction)endYChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    _endY = slider.value;
    [self animate];
}

- (IBAction)endXChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    _endX = slider.value;
    [self animate];
}

- (IBAction)endScaleChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    _endScale = slider.value;
    [self animate];
}

- (IBAction)endRotationChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    _endRotation = slider.value;
    [self animate];
}

- (IBAction)endAlphaDidChange:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    _endAlpha = slider.value;
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
    _logoImageView.transform    = CGAffineTransformIdentity;
    _logoImageView.frame        = _startFrame;
    _logoImageView.alpha        = 1;

    [UIView mys_animateViews:@[_logoImageView]
                    duration:_duration
                     options:0
              timingFunction:_timingFuction
                exaggeration:_exaggeration
                  animations:^{
//                     CGRect r                       = _logoImageView.frame;
//                     r.origin.x                     += _endX;
//                     r.origin.y                     += _endY;
//                     _logoImageView.frame           = [self scaledRect:r];
//                     _logoImageView.alpha           = _endAlpha;
                      _logoImageView.mys_rotationZ  = mys_degreesToRadians(_endRotation);
                  } completion:^{
                  }];
}

- (NSArray *)functionMap
{
    static NSArray *functions;
    functions = @[
                  @{  @"EaseInQuad"     	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInQuad       ] },
                  @{  @"EaseOutQuad"    	: [NSValue valueWithPointer:&MYSTimingFunctionEaseOutQuad      ] },
                  @{  @"EaseInOutQuad"  	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInOutQuad    ] },

                  @{  @"EaseInCubic"     	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInCubic      ] },
                  @{  @"EaseOutCubic"    	: [NSValue valueWithPointer:&MYSTimingFunctionEaseOutCubic     ] },
                  @{  @"EaseInOutCubic"  	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInOutCubic   ] },

                  @{  @"EaseInQuart"     	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInQuart      ] },
                  @{  @"EaseOutQuart"    	: [NSValue valueWithPointer:&MYSTimingFunctionEaseOutQuart     ] },
                  @{  @"EaseInOutQuart"  	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInOutQuart   ] },

                  @{  @"EaseInQuint"     	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInQuint      ] },
                  @{  @"EaseOutQuint"    	: [NSValue valueWithPointer:&MYSTimingFunctionEaseOutQuint     ] },
                  @{  @"EaseInOutQuint"  	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInOutQuint   ] },

                  @{  @"EaseInSine"     	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInSine       ] },
                  @{  @"EaseOutSine"    	: [NSValue valueWithPointer:&MYSTimingFunctionEaseOutSine      ] },
                  @{  @"EaseInOutSine"  	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInOutSine    ] },

                  @{  @"EaseInExpo"     	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInExpo       ] },
                  @{  @"EaseOutExpo"    	: [NSValue valueWithPointer:&MYSTimingFunctionEaseOutExpo      ] },
                  @{  @"EaseInOutExpo"  	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInOutExpo    ] },

                  @{  @"EaseInCirc"     	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInCirc       ] },
                  @{  @"EaseOutCirc"    	: [NSValue valueWithPointer:&MYSTimingFunctionEaseOutCirc      ] },
                  @{  @"EaseInOutCirc"  	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInOutCirc    ] },

                  @{  @"EaseInElastic"     	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInElastic    ] },
                  @{  @"EaseOutElastic"    	: [NSValue valueWithPointer:&MYSTimingFunctionEaseOutElastic   ] },
                  @{  @"EaseInOutElastic"  	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInOutElastic ] },

                  @{  @"EaseInBack"     	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInBack       ] },
                  @{  @"EaseOutBack"    	: [NSValue valueWithPointer:&MYSTimingFunctionEaseOutBack      ] },
                  @{  @"EaseInOutBack"  	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInOutBack    ] },

                  @{  @"EaseInBounce"     	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInBounce     ] },
                  @{  @"EaseOutBounce"    	: [NSValue valueWithPointer:&MYSTimingFunctionEaseOutBounce    ] },
                  @{  @"EaseInOutBounce"  	: [NSValue valueWithPointer:&MYSTimingFunctionEaseInOutBounce  ] }
                  
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
    [super viewDidUnload];
}

- (CGRect)scaledRect:(CGRect)r
{
    CGFloat h       = _startFrame.size.height;
    CGFloat w       = _startFrame.size.width;
    CGFloat hh      = h * _endScale;
    CGFloat ww      = w * _endScale;
    r.size.height   = hh;
    r.size.width    = ww;
    r.origin.y      -= (hh - h) / 2.0;
    r.origin.x      -= (ww - w) / 2.0;
    return r;
}


@end
