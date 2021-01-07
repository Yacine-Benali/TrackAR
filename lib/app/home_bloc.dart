import 'dart:ffi';
import 'dart:math' as math;

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:headtrack/app/home_provider.dart';

class HomeBloc {
  HomeBloc({
    @required this.provider,
    @required this.offsetAndSensitivity,
  });
  final HomeProvider provider;
  List<double> offsetAndSensitivity;

  Future<String> getIpAddress() async => provider.getString('ipAddress');

  Future<int> getPort() async => await provider.getInt('port');

  void setIpAddress(String value) async =>
      provider.setString('ipAddress', value);

  void setPort(int value) async => provider.setInt('port', value);

  Pointer<Float> intListToArray(List<double> list) {
    final ptr = allocate<Float>(count: list.length);
    for (var i = 0; i < list.length; i++) {
      ptr.elementAt(i).value = list[i];
    }
    return ptr;
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
    String ipAddress,
    int port,
    List<double> l,
  ) async {
    List<double> q = [l[6], l[3], l[4], l[5]]; // {qw, qx, qy, qz}.

    final listPtr = intListToArray(q);

    final arr = q2c(q);

    List<double> rawPoses = [
      l[0] * 100, // -arr[6],
      l[1] * 100, //  arr[7],
      -l[2] * 100, //   arr[8],
      -arr[1], // -arr[6],
      -arr[0], //  arr[7],
      -arr[2], //   arr[8],
    ];
    rawPoses[0] =
        (rawPoses[0] * offsetAndSensitivity[0]) + offsetAndSensitivity[1];
    rawPoses[1] =
        (rawPoses[1] * offsetAndSensitivity[2]) + offsetAndSensitivity[3];
    rawPoses[2] =
        (rawPoses[2] * offsetAndSensitivity[4]) + offsetAndSensitivity[5];

    rawPoses[3] =
        (rawPoses[3] * offsetAndSensitivity[6]) + offsetAndSensitivity[7];
    rawPoses[4] =
        (rawPoses[4] * offsetAndSensitivity[8]) + offsetAndSensitivity[9];
    rawPoses[5] =
        (rawPoses[5] * offsetAndSensitivity[10]) + offsetAndSensitivity[11];

    await provider.sendPoses(ipAddress, port, rawPoses);

    free(listPtr);
  }
}
