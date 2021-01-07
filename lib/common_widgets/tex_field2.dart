import 'package:flutter/material.dart';
import 'package:headtrack/common_widgets/input_dialog.dart';
import 'package:headtrack/constants/app_colors.dart';

class TextField2 extends StatefulWidget {
  TextField2({
    Key key,
    @required this.onValueChanged,
    @required this.title,
    @required this.initialValue,
    @required this.validator,
  }) : super(key: key);
  final ValueChanged<String> onValueChanged;
  final String title;
  final String initialValue;
  final String Function(String) validator;
  @override
  _TextField2State createState() => _TextField2State();
}

class _TextField2State extends State<TextField2> {
  String value;
  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () => InputDialog(
          validator: widget.validator,
          onValueChanged: (String newValue) {
            value = newValue;
            widget.onValueChanged(newValue);
            setState(() {});
          },
          title: widget.title,
          initialValue: value,
        ).show(context),
        child: Container(
          color: AppColors.tileColor,
          child: Row(
            children: [
              Expanded(flex: 1, child: Text(widget.title)),
              Expanded(
                flex: 2,
                child: Center(child: Text(value)),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.edit),
                  ),
                  onPressed: () => InputDialog(
                    validator: widget.validator,
                    onValueChanged: (String newValue) {
                      value = newValue;
                      widget.onValueChanged(newValue);
                      setState(() {});
                    },
                    title: widget.title,
                    initialValue: value,
                  ).show(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
