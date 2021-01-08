import 'package:flutter/foundation.dart';

class UserSettings {
  UserSettings({
    @required this.ipAddress,
    @required this.port,
    @required this.xSensitivity,
    @required this.xOffset,
    @required this.ySensitivity,
    @required this.yOffset,
    @required this.zSensitivity,
    @required this.zOffset,
    @required this.yawSensitivity,
    @required this.yawOffset,
    @required this.pitchSensitivity,
    @required this.pitchOffset,
    @required this.rollSensitivity,
    @required this.rollOffset,
  });

  String ipAddress;
  int port;
  double xSensitivity;
  double xOffset;
  double ySensitivity;
  double yOffset;
  double zSensitivity;
  double zOffset;
  double yawSensitivity;
  double yawOffset;
  double pitchSensitivity;
  double pitchOffset;
  double rollSensitivity;
  double rollOffset;

  @override
  String toString() {
    print("""
     --------------------------------------------------------
    $ipAddress $port
    $xSensitivity $xOffset 
    $ySensitivity $yOffset 
    $zSensitivity $zOffset 
    $pitchSensitivity $pitchOffset 
    $yawSensitivity $yawOffset 
    $rollSensitivity $rollOffset 
    
        """);
    return super.toString();
  }
}
