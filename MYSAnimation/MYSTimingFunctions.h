//
//  MYSTimingFunctions.h
//  NSBKeyframeAnimation
//
//  Created by Nacho Soto on 8/6/12.
//  Copyright (c) 2012 Nacho Soto. All rights reserved.
//


typedef double (*MYSTimingFunction)(double, double, double, double, double);

double MYSTimingFunctionEaseInQuad(double t, double b, double c, double d, double s);
double MYSTimingFunctionEaseOutQuad(double t, double b, double c, double d, double s);
double MYSTimingFunctionEaseInOutQuad(double t, double b, double c, double d, double s);

double MYSTimingFunctionEaseInCubic(double t, double b, double c, double d, double s);
double MYSTimingFunctionEaseOutCubic(double t, double b, double c, double d, double s);
double MYSTimingFunctionEaseInOutCubic(double t,double b, double c, double d, double s);

double MYSTimingFunctionEaseInQuart(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseOutQuart(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseInOutQuart(double t,double b, double c, double d, double s);

double MYSTimingFunctionEaseInQuint(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseOutQuint(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseInOutQuint(double t,double b, double c, double d, double s);

double MYSTimingFunctionEaseInSine(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseOutSine(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseInOutSine(double t,double b, double c, double d, double s);

double MYSTimingFunctionEaseInExpo(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseOutExpo(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseInOutExpo(double t,double b, double c, double d, double s);

double MYSTimingFunctionEaseInCirc(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseOutCirc(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseInOutCirc(double t,double b, double c, double d, double s);

double MYSTimingFunctionEaseInElastic(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseOutElastic(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseInOutElastic(double t,double b, double c, double d, double s);

double MYSTimingFunctionEaseInBack(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseOutBack(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseInOutBack(double t,double b, double c, double d, double s);

double MYSTimingFunctionEaseInBounce(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseOutBounce(double t,double b, double c, double d, double s);
double MYSTimingFunctionEaseInOutBounce(double t,double b, double c, double d, double s);







#define kMYSEaseInQuad      	&MYSTimingFunctionEaseInQuad
#define kMYSEaseOutQuad     	&MYSTimingFunctionEaseOutQuad
#define kMYSEaseInOutQuad   	&MYSTimingFunctionEaseInOutQuad
#define kMYSEaseInCubic     	&MYSTimingFunctionEaseInCubic
#define kMYSEaseOutCubic    	&MYSTimingFunctionEaseOutCubic
#define kMYSEaseInOutCubic  	&MYSTimingFunctionEaseInOutCubic
#define kMYSEaseInQuart     	&MYSTimingFunctionEaseInQuart
#define kMYSEaseOutQuart    	&MYSTimingFunctionEaseOutQuart
#define kMYSEaseInOutQuart  	&MYSTimingFunctionEaseInOutQuart
#define kMYSEaseInQuint     	&MYSTimingFunctionEaseInQuint
#define kMYSEaseOutQuint    	&MYSTimingFunctionEaseOutQuint
#define kMYSEaseInOutQuint  	&MYSTimingFunctionEaseInOutQuint
#define kMYSEaseInSine      	&MYSTimingFunctionEaseInSine
#define kMYSEaseOutSine     	&MYSTimingFunctionEaseOutSine
#define kMYSEaseInOutSine   	&MYSTimingFunctionEaseInOutSine
#define kMYSEaseInExpo      	&MYSTimingFunctionEaseInExpo
#define kMYSEaseOutExpo     	&MYSTimingFunctionEaseOutExpo
#define kMYSEaseInOutExpo   	&MYSTimingFunctionEaseInOutExpo
#define kMYSEaseInCirc      	&MYSTimingFunctionEaseInCirc
#define kMYSEaseOutCirc     	&MYSTimingFunctionEaseOutCirc
#define kMYSEaseInOutCirc   	&MYSTimingFunctionEaseInOutCirc
#define kMYSEaseInElastic   	&MYSTimingFunctionEaseInElastic
#define kMYSEaseOutElastic  	&MYSTimingFunctionEaseOutElastic
#define kMYSEaseInOutElastic	&MYSTimingFunctionEaseInOutElastic
#define kMYSEaseInBack      	&MYSTimingFunctionEaseInBack
#define kMYSEaseOutBack     	&MYSTimingFunctionEaseOutBack
#define kMYSEaseInOutBack   	&MYSTimingFunctionEaseInOutBack
#define kMYSEaseInBounce    	&MYSTimingFunctionEaseInBounce
#define kMYSEaseOutBounce   	&MYSTimingFunctionEaseOutBounce
#define kMYSEaseInOutBounce 	&MYSTimingFunctionEaseInOutBounce
