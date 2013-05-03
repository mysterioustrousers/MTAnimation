//
//  MTTimingFunctions.h
//  NSBKeyframeAnimation
//
//  Created by Nacho Soto on 8/6/12.
//  Copyright (c) 2012 Nacho Soto. All rights reserved.
//


typedef double (*MTTimingFunction)(double, double, double, double, double);

double MTTimingFunctionEaseInQuad(double t, double b, double c, double d, double s);
double MTTimingFunctionEaseOutQuad(double t, double b, double c, double d, double s);
double MTTimingFunctionEaseInOutQuad(double t, double b, double c, double d, double s);

double MTTimingFunctionEaseInCubic(double t, double b, double c, double d, double s);
double MTTimingFunctionEaseOutCubic(double t, double b, double c, double d, double s);
double MTTimingFunctionEaseInOutCubic(double t,double b, double c, double d, double s);

double MTTimingFunctionEaseInQuart(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseOutQuart(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseInOutQuart(double t,double b, double c, double d, double s);

double MTTimingFunctionEaseInQuint(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseOutQuint(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseInOutQuint(double t,double b, double c, double d, double s);

double MTTimingFunctionEaseInSine(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseOutSine(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseInOutSine(double t,double b, double c, double d, double s);

double MTTimingFunctionEaseInExpo(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseOutExpo(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseInOutExpo(double t,double b, double c, double d, double s);

double MTTimingFunctionEaseInCirc(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseOutCirc(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseInOutCirc(double t,double b, double c, double d, double s);

double MTTimingFunctionEaseInElastic(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseOutElastic(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseInOutElastic(double t,double b, double c, double d, double s);

double MTTimingFunctionEaseInBack(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseOutBack(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseInOutBack(double t,double b, double c, double d, double s);

double MTTimingFunctionEaseInBounce(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseOutBounce(double t,double b, double c, double d, double s);
double MTTimingFunctionEaseInOutBounce(double t,double b, double c, double d, double s);







#define kMTEaseInQuad      	&MTTimingFunctionEaseInQuad
#define kMTEaseOutQuad     	&MTTimingFunctionEaseOutQuad
#define kMTEaseInOutQuad   	&MTTimingFunctionEaseInOutQuad
#define kMTEaseInCubic     	&MTTimingFunctionEaseInCubic
#define kMTEaseOutCubic    	&MTTimingFunctionEaseOutCubic
#define kMTEaseInOutCubic  	&MTTimingFunctionEaseInOutCubic
#define kMTEaseInQuart     	&MTTimingFunctionEaseInQuart
#define kMTEaseOutQuart    	&MTTimingFunctionEaseOutQuart
#define kMTEaseInOutQuart  	&MTTimingFunctionEaseInOutQuart
#define kMTEaseInQuint     	&MTTimingFunctionEaseInQuint
#define kMTEaseOutQuint    	&MTTimingFunctionEaseOutQuint
#define kMTEaseInOutQuint  	&MTTimingFunctionEaseInOutQuint
#define kMTEaseInSine      	&MTTimingFunctionEaseInSine
#define kMTEaseOutSine     	&MTTimingFunctionEaseOutSine
#define kMTEaseInOutSine   	&MTTimingFunctionEaseInOutSine
#define kMTEaseInExpo      	&MTTimingFunctionEaseInExpo
#define kMTEaseOutExpo     	&MTTimingFunctionEaseOutExpo
#define kMTEaseInOutExpo   	&MTTimingFunctionEaseInOutExpo
#define kMTEaseInCirc      	&MTTimingFunctionEaseInCirc
#define kMTEaseOutCirc     	&MTTimingFunctionEaseOutCirc
#define kMTEaseInOutCirc   	&MTTimingFunctionEaseInOutCirc
#define kMTEaseInElastic   	&MTTimingFunctionEaseInElastic
#define kMTEaseOutElastic  	&MTTimingFunctionEaseOutElastic
#define kMTEaseInOutElastic	&MTTimingFunctionEaseInOutElastic
#define kMTEaseInBack      	&MTTimingFunctionEaseInBack
#define kMTEaseOutBack     	&MTTimingFunctionEaseOutBack
#define kMTEaseInOutBack   	&MTTimingFunctionEaseInOutBack
#define kMTEaseInBounce    	&MTTimingFunctionEaseInBounce
#define kMTEaseOutBounce   	&MTTimingFunctionEaseOutBounce
#define kMTEaseInOutBounce 	&MTTimingFunctionEaseInOutBounce
