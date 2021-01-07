import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:headtrack/app/home_provider.dart';
import 'package:headtrack/constants/constants.dart';

class HomeBloc {
  HomeBloc({
    @required this.quaternion2eulerC,
    @required this.provider,
    @required this.offsetAndSensitivity,
  });
  final quaternion2EulerC quaternion2eulerC;
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

  void sendFace(
    String ipAddress,
    int port,
    List<double> l,
  ) async {
    List<double> q = [l[6], l[3], l[4], l[5]]; // {qw, qx, qy, qz}.

    final listPtr = intListToArray(q);

    final arrayPointer = quaternion2eulerC(listPtr);
    final arr = arrayPointer.asTypedList(3);

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
