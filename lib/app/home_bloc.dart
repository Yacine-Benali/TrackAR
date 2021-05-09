import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:headtrack/app/home_provider.dart';
import 'package:headtrack/app/models/user_settings.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:vector_math/vector_math.dart' as vector_math;
import 'package:vector_math/vector_math.dart';

class HomeBloc {
  HomeBloc({
    @required this.provider,
  });
  final HomeProvider provider;

  Future<void> setValue(String key, dynamic value) async =>
      provider.setValue(key, value);

  Future<UserSettings> getUserSettings() async {
    return UserSettings(
      ipAddress: await provider.getString('ipAddress') ?? '192.168.1.3',
      port: await provider.getInt('port') ?? 4242,
      //
      xOffset: await provider.getDouble('xOffset') ?? 0,
      xSensitivity: await provider.getDouble('xSensitivity') ?? 1,
      //
      yOffset: await provider.getDouble('yOffset') ?? 0,
      ySensitivity: await provider.getDouble('ySensitivity') ?? 1,
      //
      zOffset: await provider.getDouble('zOffset') ?? 0,
      zSensitivity: await provider.getDouble('zSensitivity') ?? 1,
      //
      yawOffset: await provider.getDouble('yawOffset') ?? 0,
      yawSensitivity: await provider.getDouble('yawSensitivity') ?? 1,
      //
      pitchOffset: await provider.getDouble('pitchOffset') ?? 0,
      pitchSensitivity: await provider.getDouble('pitchSensitivity') ?? 1,
      //
      rollOffset: await provider.getDouble('rollOffset') ?? 0,
      rollSensitivity: await provider.getDouble('rollSensitivity') ?? 1,
    );
  }

  List<double> q2c(List<double> q) {
    var w = q[0];
    var x = q[1];
    var y = q[2];
    var z = q[3];

    var ret = List<double>.filled(3, 0);

    var test = x * y + z * w;
    if (test > 0.4999) {
      ret[2] = 2.0 * math.atan2(x, w);
      ret[1] = math.pi / 2;
      ret[0] = 0.0;
      q[0] = ret[0];
      q[2] = ret[1];
      q[1] = ret[2];
      return q;
    }
    if (test < -0.4999) {
      ret[2] = 2.0 * math.atan2(x, w);
      ret[1] = -math.pi / 2;
      ret[0] = 0.0;
      q[0] = ret[0];
      q[2] = ret[1];
      q[1] = ret[2];
      return q;
    }
    var sqx = x * x;
    var sqy = y * y;
    var sqz = z * z;
    ret[2] = math.atan2(2.0 * y * w - 2.0 * x * z, 1.0 - 2.0 * sqy - 2.0 * sqz);
    ret[1] = math.asin(2.0 * test);
    ret[0] = math.atan2(2.0 * x * w - 2.0 * z * y, 1.0 - 2.0 * sqx - 2.0 * sqz);

    ret[0] *= 180 / math.pi;
    ret[1] *= 180 / math.pi;
    ret[2] *= 180 / math.pi;

    q[0] = ret[0];
    q[2] = ret[1];
    q[1] = ret[2];
    return q;
  }

  List<double> correctForOrientation(
    List<double> rawPoses,
    NativeDeviceOrientation orientation,
  ) {
    // according to the paper I sent to you, this is landscape left.  make if statements to choose theta according to mobile orientation.
    double theta;
    switch (orientation) {
      case NativeDeviceOrientation.landscapeRight:
        theta = math.pi / 2;
        break;
      case NativeDeviceOrientation.landscapeLeft:
        theta = -(math.pi / 2);
        break;
      case NativeDeviceOrientation.portraitDown:
        theta = math.pi;
        break;
      default:
        // default is portrait up
        theta = 0;
    }
    // Rotation matrix for any point in 3d space we will be using for the translation
    Matrix3 T = Matrix3.rotationZ(theta);
    // rotation matrix for quaternion
    Quaternion Q = Quaternion.fromRotation(T);

    // put the point you want to transform here
    Vector3 measuredPosition =
        vector_math.Vector3(rawPoses[0], rawPoses[1], rawPoses[2]);

    // input quaternion.
    Quaternion measuredQuat = Quaternion(rawPoses[3], rawPoses[4], rawPoses[5],
        rawPoses[6]); // Please note the order: x,y,z,w
    // Transform position by T.
    Vector3 actualPosition = T.transform(measuredPosition);
    // Transform quaternion by Q.
    Quaternion actualQuat = Q * measuredQuat;

    return [
      actualPosition.x,
      actualPosition.y,
      actualPosition.z,
      actualQuat.x,
      actualQuat.y,
      actualQuat.z,
      actualQuat.w
    ];
  }

  Future<void> sendFace(
    UserSettings userSettings,
    List<double> l,
    NativeDeviceOrientation orientation,
  ) async {
    List<double> posesCorrected = correctForOrientation(l, orientation);
    // transform the quanternion to degrees
    // {qw, qx, qy, qz}.
    List<double> quanternionsList = [
      posesCorrected[6],
      posesCorrected[3],
      posesCorrected[4],
      posesCorrected[5]
    ];
    List<double> euluerDegrees = q2c(quanternionsList);
    List<double> finalPosition = [
      posesCorrected[0] * 100, // x
      posesCorrected[1] * 100, //  y
      -posesCorrected[2] * 100, //   z
      -euluerDegrees[1], // yaw
      -euluerDegrees[0], // pitch
      -euluerDegrees[2], //   roll
    ];

    finalPosition = applyUserSettings(finalPosition, userSettings);

    await provider.sendPoses(
      userSettings.ipAddress,
      userSettings.port,
      finalPosition,
    );
  }

  List<double> applyUserSettings(
      List<double> rawPoses, UserSettings userSettings) {
    rawPoses[0] =
        (rawPoses[0] * userSettings.xSensitivity) + userSettings.xOffset;
    rawPoses[1] =
        (rawPoses[1] * userSettings.ySensitivity) + userSettings.yOffset;
    rawPoses[2] =
        (rawPoses[2] * userSettings.zSensitivity) + userSettings.zOffset;

    rawPoses[3] =
        (rawPoses[3] * userSettings.yawSensitivity) + userSettings.yawOffset;

    rawPoses[4] = (rawPoses[4] * userSettings.pitchSensitivity) +
        userSettings.pitchOffset;

    rawPoses[5] =
        (rawPoses[5] * userSettings.rollSensitivity) + userSettings.rollOffset;

    return rawPoses;
  }
}
