import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:headtrack/app/home_bloc.dart';
import 'package:headtrack/app/models/user_settings.dart';
import 'package:headtrack/constants/app_colors.dart';

import 'customization_button.dart';

class CustomizationWidget extends StatefulWidget {
  const CustomizationWidget({
    Key key,
    @required this.onValueChanged,
    @required this.bloc,
    @required this.userSettings,
  }) : super(key: key);

  final ValueChanged<UserSettings> onValueChanged;
  final HomeBloc bloc;
  final UserSettings userSettings;

  @override
  _CustomizationWidgetState createState() => _CustomizationWidgetState();
}

class _CustomizationWidgetState extends State<CustomizationWidget> {
  UserSettings get userSettings => widget.userSettings;
  HomeBloc get bloc => widget.bloc;

  void save() {
    widget.onValueChanged(userSettings);
    setState(() {});
  }

  void reset() {
    userSettings.xOffset = 0;
    userSettings.xSensitivity = 1;
    //
    userSettings.yOffset = 0;
    userSettings.ySensitivity = 1;
    //
    userSettings.zOffset = 0;
    userSettings.zSensitivity = 1;
    //
    userSettings.yawOffset = 0;
    userSettings.yawSensitivity = 1;
    //
    userSettings.pitchOffset = 0;
    userSettings.pitchSensitivity = 1;
    //
    userSettings.rollOffset = 0;
    userSettings.rollSensitivity = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.tileColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Sensitivity and offset',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      reset();
                      save();
                      setState(() {});
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.restore,
                        size: 30,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomizationButton(
                  title: 'X',
                  sensitivity: userSettings.xSensitivity,
                  offset: userSettings.xOffset,
                  onSensitivityChanged: (double value) {
                    userSettings.xSensitivity = value;
                    bloc.setValue('xSensitivity', userSettings.xSensitivity);
                    save();
                  },
                  onOffsetChanged: (double value) {
                    userSettings.xOffset = value;
                    bloc.setValue('xOffset', userSettings.xOffset);
                    save();
                  },
                ),
                CustomizationButton(
                  title: 'Y',
                  sensitivity: userSettings.ySensitivity,
                  offset: userSettings.yOffset,
                  onSensitivityChanged: (double value) {
                    userSettings.ySensitivity = value;
                    bloc.setValue('ySensitivity', userSettings.ySensitivity);

                    save();
                  },
                  onOffsetChanged: (double value) {
                    userSettings.yOffset = value;
                    bloc.setValue('yOffset', userSettings.yOffset);
                    save();
                  },
                ),
                CustomizationButton(
                  title: 'Z',
                  sensitivity: userSettings.zSensitivity,
                  offset: userSettings.zOffset,
                  onSensitivityChanged: (double value) {
                    userSettings.zSensitivity = value;
                    bloc.setValue('zSensitivity', userSettings.zSensitivity);
                    save();
                  },
                  onOffsetChanged: (double value) {
                    userSettings.zOffset = value;
                    bloc.setValue('zOffset', userSettings.zOffset);
                    save();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomizationButton(
                  title: 'Pitch',
                  sensitivity: userSettings.pitchSensitivity,
                  offset: userSettings.pitchOffset,
                  onSensitivityChanged: (double value) {
                    userSettings.pitchSensitivity = value;
                    bloc.setValue(
                        'pitchSensitivity', userSettings.pitchSensitivity);
                    save();
                  },
                  onOffsetChanged: (double value) {
                    userSettings.pitchOffset = value;
                    bloc.setValue('pitchOffset', userSettings.pitchOffset);
                    save();
                  },
                ),
                CustomizationButton(
                  title: 'Yaw',
                  sensitivity: userSettings.yawSensitivity,
                  offset: userSettings.yawOffset,
                  onSensitivityChanged: (double value) {
                    userSettings.yawSensitivity = value;
                    bloc.setValue(
                        'yawSensitivity', userSettings.yawSensitivity);
                    save();
                  },
                  onOffsetChanged: (double value) {
                    userSettings.yawOffset = value;
                    bloc.setValue('yawOffset', userSettings.yawOffset);
                    save();
                  },
                ),
                CustomizationButton(
                  title: 'Roll',
                  sensitivity: userSettings.rollSensitivity,
                  offset: userSettings.rollOffset,
                  onSensitivityChanged: (double value) {
                    userSettings.rollSensitivity = value;
                    bloc.setValue(
                        'rollSensitivity', userSettings.rollSensitivity);
                    save();
                  },
                  onOffsetChanged: (double value) {
                    userSettings.rollOffset = value;
                    bloc.setValue('rollOffset', userSettings.rollOffset);
                    save();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
