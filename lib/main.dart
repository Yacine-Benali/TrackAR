// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:headtrack/app/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('ARCORE IS AVAILABLE?');
  print(await ArCoreController.checkArCoreAvailability());
  print('\nAR SERVICES INSTALLED?');
  print(await ArCoreController.checkIsArCoreInstalled());
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'title go brrr',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        brightness: Brightness.dark,
      ),
      home: HomeSceen(),
    );
  }
}
