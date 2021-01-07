import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:headtrack/common_widgets/platform_exception_alert_dialog.dart';
import 'package:headtrack/common_widgets/platform_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';

class PlatformReportDialog extends PlatformWidget {
  PlatformReportDialog({@required this.filePath}) : assert(filePath != null);

  final String filePath;

  Future<bool> show(BuildContext context) async {
    return
        // Platform.isIOS
        //     ? await showCupertinoDialog<bool>(
        //         context: context,
        //         builder: (context) => this,
        //       )
        //     :
        await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => this,
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('title'),
      content: Text('content'),
      actions: [Text('')],
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text('save sucessfull'),
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('save sucessfull'),
          Text(filePath),
        ],
      ),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      FlatButton(
        child: const Text('cancel'),
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
      ),
      FlatButton(
          child: const Text('open file'),
          onPressed: () async {
            OpenResult b = await OpenFile.open(filePath);
            if (b.type == ResultType.noAppToOpen)
              PlatformExceptionAlertDialog(
                title: 'save failed',
                exception: PlatformException(
                  code: 'excel is required',
                  message: 'excel is required to open the file',
                ),
              ).show(context);
          }),
      FlatButton(
        child: const Text('share file'),
        onPressed: () => Share.shareFiles([filePath], text: 'report'),
      ),
    ];
  }
}
