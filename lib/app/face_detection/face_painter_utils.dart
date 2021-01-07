import 'dart:ui';

import 'package:camera/camera.dart';

double flipXBasedOnCam(
  double x,
  CameraLensDirection direction,
  double width,
) {
  if (direction == CameraLensDirection.back) {
    return x;
  } else {
    return width - x;
  }
}

Offset flipOffsetBasedOnCam(
  Offset point,
  CameraLensDirection direction,
  double width,
) {
  double dx = flipXBasedOnCam(point.dx, direction, width);
  return Offset(dx, point.dy);
}

Rect flipRectBasedOnCam(
  Rect rect,
  CameraLensDirection direction,
  double width,
) {
  if (direction == CameraLensDirection.back) {
    return rect;
  } else {
    double left = width - rect.right;
    double right = width - rect.left;
    return Rect.fromLTRB(left, rect.top, right, rect.bottom);
  }
}
