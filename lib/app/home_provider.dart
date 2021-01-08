import 'dart:io';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider {
  HomeProvider();

  Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<int> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  Future<double> getDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  void setValue(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }

  Future<void> sendPoses(
    String ipAddress,
    int port,
    List<double> posesList,
  ) async {
    var bytes = Float64List.fromList(posesList).buffer.asUint8List();
    await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0, reuseAddress: true)
        .then((RawDatagramSocket socket) {
      socket.send(bytes, InternetAddress(ipAddress), port);
    });
  }
}
