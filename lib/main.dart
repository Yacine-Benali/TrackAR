import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:headtrack/app/home_screen.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('ARCORE IS AVAILABLE?');
  print(await ArCoreController.checkArCoreAvailability());
  print('\nAR SERVICES INSTALLED?');
  //TODO @high pop when when are core is not installed
  print(await ArCoreController.checkIsArCoreInstalled());
  Wakelock.enable();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIOverlays([]);
  if (kDebugMode) {
    // Future.delayed(Duration(seconds: 2), () {
    //   FirebaseCrashlytics.instance.crash();
    // });
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TrackAR',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        brightness: Brightness.dark,
      ),
      home: HomeSceen(),
    );
  }
}
