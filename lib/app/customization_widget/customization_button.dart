import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:headtrack/common_widgets/offsetSlider.dart';
import 'package:headtrack/common_widgets/sensitivity_slider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CustomizationButton extends StatefulWidget {
  const CustomizationButton({
    Key key,
    @required this.sensitivity,
    @required this.offset,
    @required this.onSensitivityChanged,
    @required this.onOffsetChanged,
    @required this.title,
  }) : super(key: key);

  final double sensitivity;
  final double offset;
  final ValueChanged<double> onSensitivityChanged;
  final ValueChanged<double> onOffsetChanged;
  final String title;

  @override
  _CustomizationButtonState createState() => _CustomizationButtonState();
}

class _CustomizationButtonState extends State<CustomizationButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      child: Text(
        widget.title,
        style: TextStyle(fontSize: 25),
      ),
      onPressed: () async {
        // print('rebuilt with ${widget.sensitivity} ${widget.offset}');

        await showMaterialModalBottomSheet(
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SentivitySlider(
                initialValue: widget.sensitivity,
                title: 'Sensitivity',
                onValueChanged: (value) {
                  print(value);
                  widget.onSensitivityChanged(value);
                },
              ),
              Divider(height: 0.5),
              OffsetSlider(
                initialValue: widget.offset,
                title: 'Offset',
                onValueChanged: (value) => widget.onOffsetChanged(value),
              ),
            ],
          ),
        );
      },
    );
  }
}
