import 'package:flutter/material.dart';

class InputDialog extends StatelessWidget {
  InputDialog({
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
  final _formKey = GlobalKey<FormState>();
  Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Form(
        key: _formKey,
        child: TextFormField(
          // keyboardType: TextInputType.number,
          validator: validator,
          initialValue: initialValue,
          onSaved: (value) => onValueChanged(value),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
