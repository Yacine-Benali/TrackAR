import 'dart:io';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider {
  HomeProvider();

  Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  void setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<int> getInt(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  void setInt(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
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
