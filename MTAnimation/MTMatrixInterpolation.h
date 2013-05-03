//
//  MTMatrixInterpolation.h
//  MTAnimation
//
//  Created by Adam Kirk on 5/3/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//
//  Extracts taken from http://svn.gna.org/svn/gnustep/libs/quartzcore/trunk/Source/CAAnimation.m

#include <QuartzCore/QuartzCore.h>

CATransform3D interpolatedMatrixFromMatrix(CATransform3D fromTf, CATransform3D toTf, CGFloat fraction);

