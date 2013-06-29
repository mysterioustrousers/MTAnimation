//
//  MTTimingFunctions.c
//  NSBKeyframeAnimation
//
//  Created by Nacho Soto on 8/6/12.
//  Copyright (c) 2012 Nacho Soto. All rights reserved.
//

#include <math.h>
#include <stdlib.h>

#import "MTTimingFunctions.h"

// source: http://gsgd.co.uk/sandbox/jquery/easing/jquery.easing.1.3.js

// TODO: Apply exaggeration to everything. (currently only applied to some).

double MTTimingFunctionEaseInQuad(double t, double b, double c, double d, double s)
{
    t/=d;
    return c*t*t + b;
}

double MTTimingFunctionEaseOutQuad(double t, double b, double c, double d, double s)
{
    t/=d;
    return -c *t*(t-2) + b;
}

double MTTimingFunctionEaseInOutQuad(double t, double b, double c, double d, double s)
{
    t/=(d/2);
    if (t < 1) return c/2*t*t + b;
    --t;
    return -c/2 * (t*(t-2) - 1) + b;
}

double MTTimingFunctionEaseInCubic(double t, double b, double c, double d, double s)
{
    t/=d;
    return c*t*t*t + b;
}

double MTTimingFunctionEaseOutCubic(double t, double b, double c, double d, double s)
{
    t=t/d-1;
    return c*(t*t*t + 1) + b;
}

double MTTimingFunctionEaseInOutCubic(double t, double b, double c, double d, double s)
{
    t/=(d/2);
    if (t < 1) return c/2*t*t*t + b;
    t-=2;
    return c/2*(t*t*t + 2) + b;
}

double MTTimingFunctionEaseInQuart(double t, double b, double c, double d, double s)
{
    t/=d;
    return c*t*t*t*t + b;
}

double MTTimingFunctionEaseOutQuart(double t, double b, double c, double d, double s)
{
    t=t/d-1;
    return -c * (t*t*t*t - 1) + b;
}

double MTTimingFunctionEaseInOutQuart(double t, double b, double c, double d, double s)
{
    t/=(d/2);
    if (t < 1) return c/2*t*t*t*t + b;
    t-=2;
    return -c/2 * (t*t*t*t - 2) + b;
}

double MTTimingFunctionEaseInQuint(double t, double b, double c, double d, double s)
{
    t/=d;
    return c*t*t*t*t*t + b;
}

double MTTimingFunctionEaseOutQuint(double t, double b, double c, double d, double s)
{
    t=t/d-1;
    return c*(t*t*t*t*t + 1) + b;
}

double MTTimingFunctionEaseInOutQuint(double t, double b, double c, double d, double s)
{
    t/=(d/2);
    if (t < 1) return c/2*t*t*t*t*t + b;
    t-=2;
    return c/2*(t*t*t*t*t + 2) + b;
}

double MTTimingFunctionEaseInSine(double t, double b, double c, double d, double s)
{
    return -c * cos(t/d * (M_PI_2)) + c + b;
}

double MTTimingFunctionEaseOutSine(double t, double b, double c, double d, double s)
{
    return c * sin(t/d * (M_PI_2)) + b;
}

double MTTimingFunctionEaseInOutSine(double t, double b, double c, double d, double s)
{
    return -c/2 * (cos(M_PI*t/d) - 1) + b;
}

double MTTimingFunctionEaseInExpo(double t, double b, double c, double d, double s)
{
    return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b;
}

double MTTimingFunctionEaseOutExpo(double t, double b, double c, double d, double s)
{
    return (t==d) ? b+c : c * (-pow(2, -10 * t/d) + 1) + b;
}

double MTTimingFunctionEaseInOutExpo(double t, double b, double c, double d, double s)
{
    if (t==0) return b;
    if (t==d) return b+c;
    t/=(d/2);
    if (t < 1) return c/2 * pow(2, 10 * (t - 1)) + b;
    --t;
    return c/2 * (-pow(2, -10 * t) + 2) + b;
}

double MTTimingFunctionEaseInCirc(double t, double b, double c, double d, double s)
{
    t/=d;
    return -c * (sqrt(1 - t*t) - 1) + b;
}

double MTTimingFunctionEaseOutCirc(double t, double b, double c, double d, double s)
{
    t=t/d-1;
    return c * sqrt(1 - t*t) + b;
}

double MTTimingFunctionEaseInOutCirc(double t, double b, double c, double d, double s)
{
    t/=(d/2);
    if (t < 1) return -c/2 * (sqrt(1 - t*t) - 1) + b;
    t-=2;
    return c/2 * (sqrt(1 - t*t) + 1) + b;
}

double MTTimingFunctionEaseInElastic(double t, double b, double c, double d, double s)
{
    double p=0; double a=c;

    t/=d;
    if (t==0) return b;  if (t==1) return b+c;  if (!p) p=d*.3;
    if (a < abs(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    t-=1;
    return -(a*pow(2,10*t) * sin( (t*d-s)*(2*M_PI)/p )) + b;
}

double MTTimingFunctionEaseOutElastic(double t, double b, double c, double d, double s)
{
    double p=0, a=c;
    t/=d;
    if (t==0) return b;  if (t==1) return b+c;  if (!p) p=d*.3;
    if (a < abs(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    return a*pow(2,-10*t) * sin( (t*d-s)*(2*M_PI)/p ) + c + b;
}

double MTTimingFunctionEaseInOutElastic(double t, double b, double c, double d, double s)
{
    double p=0, a=c;
    t/=(d/2);
    if (t==0) return b;  if (t==2) return b+c;  if (!p) p=d*(.3*1.5);
    if (a < abs(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin(c/a);
    if (t < 1) {
        t-=1;
        return -.5*(a*pow(2,10*t) * sin( (t*d-s)*(2*M_PI)/p )) + b;
    }
    t-=1;
    return a*pow(2,-10*t) * sin( (t*d-s)*(2*M_PI)/p )*.5 + c + b;
}

double MTTimingFunctionEaseInBack(double t, double b, double c, double d, double s)
{
    t/=d;
    return c*t*t*((s+1)*t - s) + b;
}

double MTTimingFunctionEaseOutBack(double t, double b, double c, double d, double s)
{
    t=t/d-1;
    return c*(t*t*((s+1)*t + s) + 1) + b;
}

double MTTimingFunctionEaseInOutBack(double t, double b, double c, double d, double s)
{
    t/=(d/2);
    s*=(1.525);
    if (t < 1) return c/2*(t*t*((s+1)*t - s)) + b;
    t-=2;
    return c/2*(t*t*((s+1)*t + s) + 2) + b;
}

double MTTimingFunctionEaseInBounce(double t, double b, double c, double d, double s)
{
    return c - MTTimingFunctionEaseOutBounce(d-t, 0, c, d, s) + b;
}

double MTTimingFunctionEaseOutBounce(double t, double b, double c, double d, double s)
{
    t/=d;
    if (t < (1/2.75)) {
        return c*(7.5625*t*t) + b;
    } else if (t < (2/2.75)) {
        t-=(1.5/2.75);
        return c*(7.5625*t*t + .75) + b;
    } else if (t < (2.5/2.75)) {
        t-=(2.25/2.75);
        return c*(7.5625*t*t + .9375) + b;
    } else {
        t-=(2.625/2.75);
        return c*(7.5625*t*t + .984375) + b;
    }
}

double MTTimingFunctionEaseInOutBounce(double t, double b, double c, double d, double s)
{
    if (t < d/2)
        return MTTimingFunctionEaseInBounce (t*2, 0, c, d, s) * .5 + b;
    else
        return MTTimingFunctionEaseOutBounce(t*2-d, 0, c, d, s) * .5 + c*.5 + b;
}
