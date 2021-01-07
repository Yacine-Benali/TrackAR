import 'dart:ffi';

typedef nativeAddC = Pointer<Double> Function(
  Pointer p,
  Pointer<Double> list,
  Int32 size,
  Int32 imCols,
  Int32 imRows,
  Int32 position,
);

typedef nativeAddD = Pointer<Double> Function(
  Pointer p,
  Pointer<Double> list,
  int size,
  int imCols,
  int imRows,
  int position,
);

typedef quaternion2EulerC = Pointer<Float> Function(
  Pointer<Float> list,
);

typedef getKalmanFilterInstance = Pointer<Void> Function();

//typedef getKalmanFilterInstanceD = Pointer<Void> Function();

typedef initKalmanFilter = Pointer<Void> Function(Pointer<Void> p);

const double refDistanceToCamera = 296; // in mm
const double refEyeDistancePx = 110;
const double refEyesDistance = 6.5;
const double focalLength =
    (refEyeDistancePx * refDistanceToCamera) / refEyesDistance;
