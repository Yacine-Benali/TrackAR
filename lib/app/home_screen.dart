import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:headtrack/app/face_detection/face_detection_screen.dart';
import 'package:headtrack/app/home_bloc.dart';
import 'package:headtrack/app/home_provider.dart';
import 'package:headtrack/app/instructions/instructions_screen.dart';
import 'package:headtrack/app/models/user_settings.dart';
import 'package:headtrack/common_widgets/empty_content.dart';
import 'package:headtrack/common_widgets/tex_field2.dart';
import 'package:headtrack/common_widgets/validator.dart';
import 'package:headtrack/constants/app_colors.dart';
import 'package:headtrack/constants/size_config.dart';
import 'package:headtrack/services/local_storage_service.dart';
import 'package:overlay_screen/overlay_screen.dart';

import 'customization_widget/customization_widget.dart';

class HomeSceen extends StatefulWidget {
  @override
  _HomeSceenState createState() => _HomeSceenState();
}

class _HomeSceenState extends State<HomeSceen> with IpAddressAndPortValidator {
  HomeBloc bloc;
  HomeProvider provider;
  String ipAddress;
  int port;
  bool isEnabled;
  List<double> offsetsAndSensitivity;

  LocalStorageService storage = LocalStorageService();
  UserSettings userSettings;
  Future<RawDatagramSocket> socketFuture;
  @override
  void initState() {
    socketFuture =
        RawDatagramSocket.bind(InternetAddress.anyIPv4, 0, reuseAddress: true);
    provider = HomeProvider(socket: null);
    bloc = HomeBloc(provider: provider);
    isEnabled = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    OverlayScreen().saveScreens({
      'custom2': CustomOverlayScreen(
          backgroundColor: Colors.yellow[400],
          content: Scaffold(
            backgroundColor: Colors.black,
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.lightbulb,
                color: Colors.black,
              ),
              onPressed: () async {
                OverlayScreen().pop();
              },
            ),
          )),
    });
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        title: Text('TrackAR'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        child: Icon(
          Icons.lightbulb,
          color: Colors.black,
          size: 30,
        ),
        onPressed: () async {
          OverlayScreen().show(
            context,
            identifier: 'custom2',
          );
        },
      ),
      body: SizedBox.expand(
        child: FutureBuilder(
          future: Future.wait([bloc.getUserSettings(), socketFuture]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              userSettings = snapshot.data[0];
              provider.socket = snapshot.data[1];
              ipAddress = userSettings.ipAddress;
              port = userSettings.port;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SizedBox(
                        width: SizeConfig.blockSizeVertical * 30,
                        height: SizeConfig.blockSizeVertical * 30,
                        child: FaceDetectionScreen(
                          onFaceDetected: (List<double> values) {
                            if (isEnabled) bloc.sendFace(userSettings, values);
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          TextField2(
                            validator: (value) =>
                                ipAdressValidator.validate(value),
                            onValueChanged: (value) {
                              ipAddress = value;
                              bloc.setValue('ipAddress', value);
                            },
                            title: 'IP Address',
                            initialValue: ipAddress,
                          ),
                          Divider(height: 0.5),
                          TextField2(
                            validator: (value) => portValidator.validate(value),
                            onValueChanged: (value) {
                              port = int.parse(value);
                              bloc.setValue('port', port);
                            },
                            title: 'Port',
                            initialValue: port.toString(),
                          ),
                          Divider(height: 0.5),
                          CustomizationWidget(
                            userSettings: userSettings,
                            onValueChanged: (newuserSettings) =>
                                userSettings = newuserSettings,
                            bloc: bloc,
                          ),
                          Divider(height: 0.5),
                          Container(
                            color: AppColors.tileColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SwitchListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: const Text('enabled'),
                                value: isEnabled,
                                activeColor: AppColors.primaryColor,
                                onChanged: (bool value) async {
                                  setState(() {
                                    isEnabled = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              color: AppColors.primaryColor,
                              onPressed: () async => await Navigator.of(context,
                                      rootNavigator: false)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) => InstructionScreen(),
                                  fullscreenDialog: true,
                                ),
                              ),
                              child: const Text(
                                'Instructions',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return EmptyContent(
                title: 'Something went wrong',
                message: 'Can\'t load items right now',
              );
            }
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: AppColors.primaryColor,
            ));
          },
        ),
      ),
    );
  }
}
