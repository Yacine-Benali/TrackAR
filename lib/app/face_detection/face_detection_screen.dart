import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FaceDetectionScreen extends StatefulWidget {
  FaceDetectionScreen({Key key, @required this.onFaceDetected})
      : super(key: key);
  final ValueChanged<List<double>> onFaceDetected;
  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  ArCoreFaceController arCoreFaceController;
  var _channel = EventChannel('events');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ArCoreFaceView(
      enableAugmentedFaces: true,
      onArCoreViewCreated: _onArCoreViewCreated,
    );
  }

  void _onArCoreViewCreated(ArCoreFaceController controller) {
    arCoreFaceController = controller;
    _channel.receiveBroadcastStream().listen(
      (value) {
        List<double> l = [
          value[0],
          value[1],
          value[2],
          value[3],
          value[4],
          value[5],
          value[6],
        ];

        widget.onFaceDetected(l);
      },
      cancelOnError: true,
    );
    loadMesh();
  }

  loadMesh() async {
    final ByteData textureBytes = await rootBundle.load('assets/empty.png');
    arCoreFaceController.loadMesh(
      textureBytes: textureBytes.buffer.asUint8List(),
    );
  }

  @override
  void dispose() {
    arCoreFaceController.dispose();
    super.dispose();
  }
}
