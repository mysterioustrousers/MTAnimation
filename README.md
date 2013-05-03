MTAnimation
===========

The animation library everyone's been waiting for.

Allows you to animate views in your app in the way you're familiar with (e.g. `[UIKit animateWithDuration:animations:]`) but adds 25+ [easing functions](http://easings.net/) (from jQuery) to make your animations more [visceral](http://mysterioustrousers.com/news/2013/3/25/visceral-apps-and-you).


## Installation

In your Podfile, add this line:

    pod "MTAnimation"

Then add the import:

    #import <UIView+MTAnimation.h>

## Example App

Clone the repo (or download [the zip](https://github.com/mysterioustrousers/MTAnimation/archive/master.zip)) and run the iPad demo app to play around.

## Example Usage

Similar to the UIKits animation methods but you must supply an array of all the views you will be animating and an easing function.

    [UIView mt_animateViews:@[_logoImageView]
               duration:0.25
         timingFunction:kMTEaseOutBack
             animations:^{
                 CGRect r               = _logoImageView.frame;
                 r.origin.x             = 50;
                 _logoImageView.frame   = r;
             }];

You can animate:

1. UIView - frame
2. UIView - alpha
3. UIView - transform
4. CALayer - transform

You can cut an animation into parts (using the `range` param). You might use this to swap the view half way through a flip animation:

        _logoImageView.image    = [UIImage imageNamed:@"logo"];
        [UIView mt_animateViews:@[_logoImageView]
                       duration:0.25
                        options:0
                 timingFunction:kMTEaseOutBack
                   exaggeration:MTAnimationExaggerationDefault
                          range:MTMakeAnimationRange(0, 0.135)
                     animations:^{
                        CGFloat radians                 = mt_degreesToRadians(_endRotation);
                        _logoImageView.layer.transform  = CATransform3DMakeRotation(radians, 0, 1, 0);
                     } completion:^{
                         _logoImageView.image = [UIImage imageNamed:@"logo-flip"];
                         [UIView mt_animateViews:@[_logoImageView]
                                        duration:0.25
                                         options:0
                                  timingFunction:kMTEaseOutBack
                                    exaggeration:MTAnimationExaggerationDefault
                                           range:MTMakeAnimationRange(0.135, 1)
                                      animations:^{
                                          CGFloat radians                 = mt_degreesToRadians(_endRotation);
                                          _logoImageView.layer.transform  = CATransform3DMakeRotation(radians, 0, 1, 0);
                                      } completion:^{
                                      }];
                     }];

This code will animate until the image is sideways, then swap out the image view's image and continue the animation so it looks like it has a backside.

## Author

[Adam Kirk](https://github.com/atomkirk) ([@atomkirk](https://twitter.com/atomkirk))

## Contributing

I have `TODO:` comments on stuff I need some help with, so feel free.

## Credits

Inspired by [Nocho Soto's NSBKeyframeAnimation Library](https://github.com/NachoSoto/NSBKeyframeAnimation)

Code extracts from [Ivan VuÄica & Amr Aboelela work on CAAnimation](http://svn.gna.org/svn/gnustep/libs/quartzcore/trunk/Source/CAAnimation.m)

[Easing functions](http://easings.net/) from [jQuery](http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js)

## License

Copyright (c) 2010 Mysterious Trousers, LLC (http://www.mysterioustrousers.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
