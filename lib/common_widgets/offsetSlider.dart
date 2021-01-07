import 'package:flutter/material.dart';
import 'package:headtrack/constants/app_colors.dart';

class OffsetSlider extends StatefulWidget {
  const OffsetSlider({
    Key key,
    @required this.title,
    @required this.onValueChanged,
    @required this.initialValue,
  }) : super(key: key);
  final String title;
  final ValueChanged<double> onValueChanged;
  final double initialValue;

  @override
  _OffsetSliderState createState() => _OffsetSliderState();
}

class _OffsetSliderState extends State<OffsetSlider> {
  double _currentSliderValue;

  @override
  void initState() {
    _currentSliderValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.tileColor,
      height: 75,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          children: [
            Expanded(flex: 1, child: Text(widget.title)),
            Expanded(
              flex: 2,
              child: Slider(
                value: _currentSliderValue,
                min: -75,
                max: 75,
                divisions: 20,
                activeColor: AppColors.primaryColor,
                label: _currentSliderValue.toString(),
                onChanged: (double value) {
                  widget.onValueChanged(value);
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: FlatButton(
                onPressed: () => setState(() {
                  _currentSliderValue = widget.initialValue;
                  widget.onValueChanged(_currentSliderValue);
                }),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.restore),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
