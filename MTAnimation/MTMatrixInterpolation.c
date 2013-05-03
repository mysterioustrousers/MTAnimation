//
//  MTMatrixInterpolation.c
//  MTAnimation
//
//  Created by Adam Kirk on 5/3/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//
//  Extracts taken from http://svn.gna.org/svn/gnustep/libs/quartzcore/trunk/Source/CAAnimation.m



#include "MTMatrixInterpolation.h"


#define GSQC_POW2(x) ((x)*(x))


typedef struct _GSQuartzCoreQuaternion
{
    CGFloat x, y, z, w;
} GSQuartzCoreQuaternion;

static CGFloat linearInterpolation(CGFloat from, CGFloat to, CGFloat fraction)
{
    return from + (to-from)*fraction;
}

static CATransform3D transpose(CATransform3D m)
{
    CATransform3D r;
    CGFloat *mF = (CGFloat *)&m;
    CGFloat *rF = (CGFloat *)&r;
    for(int i = 0; i < 16; i++)
    {
        int col = i % 4;
        int row = i / 4;
        int j = col * 4 + row;
        rF[j] = mF[i];
    }

    return r;
}
/* Following two functions based on paper: */
/*   J.M.P. Warren: From Quaternion to Matrix and Back
 id Software, 2005 */
/* We use them to interpolate CATransform3Ds. Quaternions are
 easier to interpolate. */
static CATransform3D quaternionToMatrix(GSQuartzCoreQuaternion q)
{
    CATransform3D m;
    CGFloat x=q.x, y=q.y, z=q.z, w=q.w;

    m.m11 = 1 - 2*y*y - 2*z*z;
    m.m12 = 2*x*y + 2*w*z;
    m.m13 = 2*x*z - 2*w*y;
    m.m14 = 0;

    m.m21 = 2*x*y - 2*w*z;
    m.m22 = 1 - 2*x*x - 2*z*z;
    m.m23 = 2*y*z + 2*w*x;
    m.m24 = 0;

    m.m31 = 2*x*z + 2*w*y;
    m.m32 = 2*y*z - 2*w*x;
    m.m33 = 1 - 2*x*x - 2*y*y;
    m.m34 = 0;

    m.m41 = 0;
    m.m42 = 0;
    m.m43 = 0;
    m.m44 = 1;

    return m;
}

static GSQuartzCoreQuaternion matrixToQuaternion(CATransform3D m)
{
    /* note: how about we use reciprocal square root, too? */
    /* see:
     http://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Reciprocal_of_the_square_root
     http://en.wikipedia.org/wiki/Fast_inverse_square_root
     */

    GSQuartzCoreQuaternion q;

    m = m;
    if (m.m11 + m.m22 + m.m33 > 0)
    {
        CGFloat t = m.m11 + m.m22 + m.m33 + 1.;
        CGFloat s = 0.5/sqrt(t);

        q.w = s*t;
        q.z = (m.m12 - m.m21)*s;
        q.y = (m.m31 - m.m13)*s;
        q.x = (m.m23 - m.m32)*s;
    }
    else if (m.m11 > m.m22 && m.m11 > m.m33)
    {
        CGFloat t = m.m11 - m.m22 - m.m33 + 1;
        CGFloat s = 0.5/sqrt(t);

        q.x = s*t;
        q.y = (m.m12 + m.m21)*s;
        q.z = (m.m31 + m.m13)*s;
        q.w = (m.m23 - m.m32)*s;
    }
    else if (m.m22 > m.m33)
    {
        CGFloat t = -m.m11 + m.m22 - m.m33 + 1;
        CGFloat s = 0.5/sqrt(t);

        q.y = s*t;
        q.x = (m.m12 + m.m21)*s;
        q.w = (m.m31 - m.m13)*s;
        q.z = (m.m23 + m.m32)*s;
    }
    else
    {
        CGFloat t = -m.m11 - m.m22 + m.m33 + 1;
        CGFloat s = 0.5/sqrt(t);

        q.z = s*t;
        q.w = (m.m12 - m.m21)*s;
        q.x = (m.m31 + m.m13)*s;
        q.y = (m.m23 + m.m32)*s;
    }
    
    return q;
}

static GSQuartzCoreQuaternion linearInterpolationQuaternion(GSQuartzCoreQuaternion a, GSQuartzCoreQuaternion b, CGFloat fraction)
{
    // slerp
	GSQuartzCoreQuaternion qr;

    /* reduction of calculations */
    if (!memcmp(&a, &b, sizeof(a)))
    {
        /* aside from making less calculations, this will also
         fix NaNs that would be returned if quaternions are equal */
        return a;
    }
    if (fraction == 0.)
    {
        return a;
    }
    if (fraction == 1.)
    {
        return b;
    }

    CGFloat dotproduct = a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
	CGFloat theta, st, sut, sout, coeff1, coeff2;

	theta = acos(dotproduct);
    if (theta == 0.0)
    {
        /* shouldn't happen, since we already checked for equality of
         inbound quaternions */
        /* if we didn't make this check, we'd get a lot of NaNs. */
        return a;
    }

	if (theta<0.0)
        theta=-theta;

	st = sin(theta);
	sut = sin(fraction*theta);
	sout = sin((1-fraction)*theta);
	coeff1 = sout/st;
	coeff2 = sut/st;

	qr.x = coeff1*a.x + coeff2*b.x;
	qr.y = coeff1*a.y + coeff2*b.y;
	qr.z = coeff1*a.z + coeff2*b.z;
	qr.w = coeff1*a.w + coeff2*b.w;

    // normalize
    CGFloat qrLen = sqrt(qr.x*qr.x + qr.y*qr.y + qr.z*qr.z + qr.w*qr.w);
    qr.x /= qrLen;
    qr.y /= qrLen;
    qr.z /= qrLen;
    qr.w /= qrLen;
    
    return qr;
}

CATransform3D interpolatedMatrixFromMatrix(CATransform3D fromTf, CATransform3D toTf, CGFloat fraction)
{
    CATransform3D valueTf;
    memcpy(&valueTf, &CATransform3DIdentity, sizeof(valueTf));

    /* A simple implementation of matrix decomposition based on:
     http://www.gamedev.net/topic/441695-transform-matrix-decomposition/
     Also incorrect; on the other hand, it's simple, and can later be
     replaced by something "smarter" and more complex

     Decomposition will be useful in implementing valueForKeypath: for
     transform "subproperties" such as .translation, .translation.x,
     .rotation, etc.
     */




    /* FIXME! Adjust the code below as well as quaternion<->matrix conversion
     to avoid calls to transpose(). */
    fromTf = transpose(fromTf);
    toTf = transpose(toTf);
    /* FIXME! */




    /* translation */
    CGFloat fromTX = fromTf.m14, fromTY = fromTf.m24, fromTZ = fromTf.m34;
    CGFloat   toTX =   toTf.m14,   toTY =   toTf.m24,   toTZ =   toTf.m34;

    CGFloat valueTX = linearInterpolation(fromTX, toTX, fraction);
    CGFloat valueTY = linearInterpolation(fromTY, toTY, fraction);
    CGFloat valueTZ = linearInterpolation(fromTZ, toTZ, fraction);




    /* scale */
    CGFloat fromSX = sqrt(GSQC_POW2(fromTf.m11) + GSQC_POW2(fromTf.m12) + GSQC_POW2(fromTf.m13));
    CGFloat fromSY = sqrt(GSQC_POW2(fromTf.m21) + GSQC_POW2(fromTf.m22) + GSQC_POW2(fromTf.m23));
    CGFloat fromSZ = sqrt(GSQC_POW2(fromTf.m31) + GSQC_POW2(fromTf.m32) + GSQC_POW2(fromTf.m33));

    CGFloat toSX = sqrt(GSQC_POW2(toTf.m11) + GSQC_POW2(toTf.m12) + GSQC_POW2(toTf.m13));
    CGFloat toSY = sqrt(GSQC_POW2(toTf.m21) + GSQC_POW2(toTf.m22) + GSQC_POW2(toTf.m23));
    CGFloat toSZ = sqrt(GSQC_POW2(toTf.m31) + GSQC_POW2(toTf.m32) + GSQC_POW2(toTf.m33));

    CGFloat valueSX = linearInterpolation(fromSX, toSX, fraction);
    CGFloat valueSY = linearInterpolation(fromSY, toSY, fraction);
    CGFloat valueSZ = linearInterpolation(fromSZ, toSZ, fraction);



    

    /* rotation */
    CATransform3D fromRotation;
    fromRotation.m11 = fromTf.m11 / fromSX;
    fromRotation.m12 = fromTf.m12 / fromSX;
    fromRotation.m13 = fromTf.m13 / fromSX;
    fromRotation.m14 = 0;

    fromRotation.m21 = fromTf.m21 / fromSY;
    fromRotation.m22 = fromTf.m22 / fromSY;
    fromRotation.m23 = fromTf.m23 / fromSY;
    fromRotation.m24 = 0;

    fromRotation.m31 = fromTf.m31 / fromSZ;
    fromRotation.m32 = fromTf.m32 / fromSZ;
    fromRotation.m33 = fromTf.m33 / fromSZ;
    fromRotation.m34 = 0;

    fromRotation.m41 = 0;
    fromRotation.m42 = 0;
    fromRotation.m43 = 0;
    fromRotation.m44 = 1;

    CATransform3D toRotation;
    toRotation.m11 = toTf.m11 / toSX;
    toRotation.m12 = toTf.m12 / toSX;
    toRotation.m13 = toTf.m13 / toSX;
    toRotation.m14 = 0;

    toRotation.m21 = toTf.m21 / toSY;
    toRotation.m22 = toTf.m22 / toSY;
    toRotation.m23 = toTf.m23 / toSY;
    toRotation.m24 = 0;

    toRotation.m31 = toTf.m31 / toSZ;
    toRotation.m32 = toTf.m32 / toSZ;
    toRotation.m33 = toTf.m33 / toSZ;
    toRotation.m34 = 0;

    toRotation.m41 = 0;
    toRotation.m42 = 0;
    toRotation.m43 = 0;
    toRotation.m44 = 1;




    /* apply rotation */
    GSQuartzCoreQuaternion fromQuat = matrixToQuaternion(fromRotation);
    GSQuartzCoreQuaternion toQuat = matrixToQuaternion(toRotation);

    CGFloat fromQuatLen = sqrt(fromQuat.x*fromQuat.x + fromQuat.y*fromQuat.y + fromQuat.z*fromQuat.z + fromQuat.w*fromQuat.w);
    fromQuat.x /= fromQuatLen;
    fromQuat.y /= fromQuatLen;
    fromQuat.z /= fromQuatLen;
    fromQuat.w /= fromQuatLen;
    CGFloat toQuatLen = sqrt(toQuat.x*toQuat.x + toQuat.y*toQuat.y + toQuat.z*toQuat.z + toQuat.w*toQuat.w);
    toQuat.x /= toQuatLen;
    toQuat.y /= toQuatLen;
    toQuat.z /= toQuatLen;
    toQuat.w /= toQuatLen;

    GSQuartzCoreQuaternion valueQuat;
    valueQuat = linearInterpolationQuaternion(fromQuat, toQuat, fraction);

    valueTf = quaternionToMatrix(valueQuat);




    /* apply scale */
    valueTf.m11 *= valueSX;
    valueTf.m12 *= valueSX;
    valueTf.m13 *= valueSX;

    valueTf.m21 *= valueSY;
    valueTf.m22 *= valueSY;
    valueTf.m23 *= valueSY;

    valueTf.m31 *= valueSZ;
    valueTf.m32 *= valueSZ;
    valueTf.m33 *= valueSZ;



    /* apply translation */
    valueTf.m14 = valueTX;
    valueTf.m24 = valueTY;
    valueTf.m34 = valueTZ;

    
    
    valueTf = transpose(valueTf);
    
    return valueTf;
}


