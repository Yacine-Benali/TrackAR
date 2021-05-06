import 'dart:ffi';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:headtrack/app/home_provider.dart';
import 'package:headtrack/app/models/user_settings.dart';

class HomeBloc {
  HomeBloc({
    @required this.provider,
  });
  final HomeProvider provider;

  void setValue(String key, dynamic value) async =>
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

  Pointer<Float> intListToArray(List<double> list) {
    // final ptr = allocate<Float>(count: list.length);
    // for (var i = 0; i < list.length; i++) {
    //   ptr.elementAt(i).value = list[i];
    // }
    // return ptr;
  }

  List<double> q2c(List<double> q) {
    var w = q[0];
    var x = q[1];
    var y = q[2];
    var z = q[3];

    var ret = List<double>(3);

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

  void sendFace(
    UserSettings userSettings,
    List<double> l,
  ) async {
    List<double> q = [l[6], l[3], l[4], l[5]]; // {qw, qx, qy, qz}.

    //final listPtr = intListToArray(q);
    //print(userSettings);
    final arr = q2c(q);
    //userSettings.toString();
    List<double> rawPoses = [
      l[0] * 100, // x
      l[1] * 100, //  y
      -l[2] * 100, //   z
      -arr[1], // yaw
      -arr[0], // pitch
      -arr[2], //   roll
    ];
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

    await provider.sendPoses(
      userSettings.ipAddress,
      userSettings.port,
      rawPoses,
    );

    //free(listPtr);
  }
}
