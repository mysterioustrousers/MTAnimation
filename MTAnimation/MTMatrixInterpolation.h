#ifndef MT_MATRIXINTERPOLAITON_H
#define MT_MATRIXINTERPOLAITON_H

#import <QuartzCore/QuartzCore.h>

#ifdef __cplusplus
extern "C" {
#endif

CATransform3D interpolatedMatrixFromMatrix(CATransform3D fromTf, CATransform3D toTf, CGFloat fraction);

#ifdef __cplusplus
}
#endif

#endif
