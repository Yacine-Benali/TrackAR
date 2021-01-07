import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:headtrack/app/home_provider.dart';
import 'package:headtrack/constants/constants.dart';
import 'package:headtrack/constants/size_config.dart';
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:tuple/tuple.dart';

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

    await provider.sendPoses(ipAddress, port, rawPoses);

    free(listPtr);
  }

  int getScreenOrientation(NativeDeviceOrientation screenOrientation) {
    switch (screenOrientation) {
      case NativeDeviceOrientation.portraitDown:
        return 0;
        break;
      case NativeDeviceOrientation.landscapeRight:
        return 3;
        break;
      case NativeDeviceOrientation.landscapeLeft:
        return 1;
        break;
      default:
        return 0;
    }
  }

  Tuple2<double, double> getDimensions(
      NativeDeviceOrientation screenOrientation) {
    double width, height = 0;
    switch (screenOrientation) {
      case NativeDeviceOrientation.portraitUp:
        width = height = double.infinity;
        break;
      case NativeDeviceOrientation.landscapeRight:
        height = SizeConfig.screenHeight;
        width = SizeConfig.screenWidth;
        break;
      case NativeDeviceOrientation.landscapeLeft:
        height = SizeConfig.screenHeight;
        width = SizeConfig.screenWidth;
        break;
      default:
        width = height = double.infinity;
    }
    return Tuple2<double, double>(height, width);
  }
}
