//
//  MTTimingFunctionsTests.m
//  MTAnimation
//
//  Created by Adam Kirk on 6/27/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


#import "MTTimingFunctionsTests.h"
#import "MTTimingFunctions.h"


@interface MTTimingFunctionsTests ()
@property (nonatomic, assign) double t;
@property (nonatomic, assign) double b;
@property (nonatomic, assign) double c;
@property (nonatomic, assign) double d;
@property (nonatomic, assign) double s;
@end


@implementation MTTimingFunctionsTests

- (void)setUp
{
    _t = 0.234423;
    _b = 0.235252;
    _c = 0.535233;
    _d = 0.443233;
    _s = 0.235231;
}

- (void)testInQuad
{
	double result = MTTimingFunctionEaseInQuad(_t, _b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.384971768277328, 0.0000001);
}

- (void)testOutQuad
{
	double result = MTTimingFunctionEaseOutQuad(_t, _b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.651694613851259, 0.0000001);
}

- (void)testInOutQuad
{
	double result = MTTimingFunctionEaseInOutQuad(_t, _b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.532904227702518, 0.0000001);
}

- (void)testInCubic
{
	double result = MTTimingFunctionEaseInCubic(_t, _b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.314437794466739, 0.0000001);
}

- (void)testOutCubic
{
	double result = MTTimingFunctionEaseOutCubic(_t, _b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.714522062827636, 0.0000001);
}

- (void)testInOutCubic
{
	double result = MTTimingFunctionEaseInOutCubic(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.546633251310542, 0.0000001);
}

- (void)testInQuart
{
	double result = MTTimingFunctionEaseInQuart(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.277132842573266, 0.0000001);
}

- (void)testOutQuart
{
	double result = MTTimingFunctionEaseOutQuart(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.744120489886896, 0.0000001);
}

- (void)testInOutQuart
{
	double result = MTTimingFunctionEaseInOutQuart(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.559568919095168, 0.0000001);
}

- (void)testInQuint
{
	double result = MTTimingFunctionEaseInQuint(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.2574025004333, 0.0000001);
}

- (void)testOutQuint
{
	double result = MTTimingFunctionEaseOutQuint(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.758064504782547, 0.0000001);
}

- (void)testInOutQuint
{
	double result = MTTimingFunctionEaseInOutQuint(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.571757076520756, 0.0000001);
}

- (void)testInSine
{
	double result = MTTimingFunctionEaseInSine(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.409578899207518, 0.0000001);
}

- (void)testOutSine
{
	double result = MTTimingFunctionEaseOutSine(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.630500214037416, 0.0000001);
}

- (void)testInOutSine
{
	double result = MTTimingFunctionEaseInOutSine(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.527127035171163, 0.0000001);
}

- (void)testInExpo
{
	double result = MTTimingFunctionEaseInExpo(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.255686812059887, 0.0000001);
}

- (void)testOutExpo
{
	double result = MTTimingFunctionEaseOutExpo(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.756794630812551, 0.0000001);
}

- (void)testInOutExpo
{
	double result = MTTimingFunctionEaseInOutExpo(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.591194450377345, 0.0000001);
}

- (void)testInCirc
{
	double result = MTTimingFunctionEaseInCirc(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.316239027475619, 0.0000001);
}

- (void)testOutCirc
{
	double result = MTTimingFunctionEaseOutCirc(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.707368330515532, 0.0000001);
}

- (void)testInOutCirc
{
	double result = MTTimingFunctionEaseInOutCirc(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.592523708006568, 0.0000001);
}

- (void)testInElastic
{
	double result = MTTimingFunctionEaseInElastic(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.216781504203076, 0.0000001);
}

- (void)testOutElastic
{
	double result = MTTimingFunctionEaseOutElastic(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.769369885918973, 0.0000001);
}

- (void)testInOutElastic
{
	double result = MTTimingFunctionEaseInOutElastic(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.646456709513847, 0.0000001);
}

- (void)testInBack
{
	double result = MTTimingFunctionEaseInBack(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.2978460172733, 0.0000001);
}

- (void)testOutBack
{
	double result = MTTimingFunctionEaseOutBack(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.729301026477798, 0.0000001);
}

- (void)testInOutBack
{
	double result = MTTimingFunctionEaseInOutBack(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.55155822653786, 0.0000001);
}

- (void)testInBounce
{
	double result = MTTimingFunctionEaseInBounce(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.346686128469726, 0.0000001);
}

- (void)testOutBounce
{
	double result = MTTimingFunctionEaseOutBounce(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.637786921316871, 0.0000001);
}

- (void)testInOutBounce
{
	double result = MTTimingFunctionEaseInOutBounce(_t,_b, _c, _d, _s);
    XCTAssertEqualWithAccuracy(result, 0.509626761597145, 0.0000001);
}


@end
