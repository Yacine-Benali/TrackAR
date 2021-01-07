import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:headtrack/constants/app_colors.dart';

import 'customization_button.dart';

class CustomizationWidget extends StatefulWidget {
  const CustomizationWidget({
    Key key,
    @required this.onValueChanged,
  }) : super(key: key);

  final ValueChanged<List<double>> onValueChanged;

  @override
  _CustomizationWidgetState createState() => _CustomizationWidgetState();
}

class _CustomizationWidgetState extends State<CustomizationWidget> {
  double xOffset;
  double xSensitivity;
  //
  double yOffset;
  double ySensitivity;
  //
  double zOffset;
  double zSensitivity;
  //
  double pitchOffset;
  double pitchSensitivity;
  //
  double yawOffset;
  double yawSensitivity;
  //
  double rollOffset;
  double rollSensitivity;

  void save() {
    widget.onValueChanged([
      xSensitivity,
      xOffset,
      ySensitivity,
      yOffset,
      zSensitivity,
      zOffset,
      yawSensitivity,
      yawOffset,
      pitchSensitivity,
      pitchOffset,
      rollSensitivity,
      rollOffset,
    ]);
  }

  void reset() {
    xOffset = 0;
    xSensitivity = 1;
    //
    yOffset = 0;
    ySensitivity = 1;
    //
    zOffset = 0;
    zSensitivity = 1;
    //
    yawOffset = 0;
    yawSensitivity = 1;
    //
    pitchOffset = 0;
    pitchSensitivity = 1;
    //
    rollOffset = 0;
    rollSensitivity = 1;
  }

  @override
  void initState() {
    reset();
    save();
    super.initState();
  }

  void showBottomSheet() {}
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.tileColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sensitivity and offset',
                  style: TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: Icon(
                    Icons.restore,
                    size: 30,
                  ),
                  onPressed: () {
                    reset();
                    save();
                    setState(() {});
                  },
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
                  sensitivity: xSensitivity,
                  offset: xOffset,
                  onSensitivityChanged: (double value) {
                    xSensitivity = value;
                    save();
                  },
                  onOffsetChanged: (double value) {
                    xOffset = value;
                    save();
                  },
                ),
                CustomizationButton(
                  title: 'Y',
                  sensitivity: ySensitivity,
                  offset: yOffset,
                  onSensitivityChanged: (double value) {
                    ySensitivity = value;
                    save();
                  },
                  onOffsetChanged: (double value) {
                    yOffset = value;
                    save();
                  },
                ),
                CustomizationButton(
                  title: 'Z',
                  sensitivity: zSensitivity,
                  offset: zOffset,
                  onSensitivityChanged: (double value) {
                    zSensitivity = value;
                    save();
                  },
                  onOffsetChanged: (double value) {
                    zOffset = value;
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
                  sensitivity: pitchSensitivity,
                  offset: pitchOffset,
                  onSensitivityChanged: (double value) {
                    pitchSensitivity = value;
                    save();
                  },
                  onOffsetChanged: (double value) {
                    pitchOffset = value;
                    save();
                  },
                ),
                CustomizationButton(
                  title: 'Yaw',
                  sensitivity: yawSensitivity,
                  offset: yawOffset,
                  onSensitivityChanged: (double value) {
                    yawSensitivity = value;
                    save();
                  },
                  onOffsetChanged: (double value) {
                    yawOffset = value;
                    save();
                  },
                ),
                CustomizationButton(
                  title: 'Roll',
                  sensitivity: rollSensitivity,
                  offset: rollOffset,
                  onSensitivityChanged: (double value) {
                    rollSensitivity = value;
                    save();
                  },
                  onOffsetChanged: (double value) {
                    rollOffset = value;
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
