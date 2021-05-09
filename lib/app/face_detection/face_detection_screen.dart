import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({Key key, @required this.onFaceDetected})
      : super(key: key);
  final ValueChanged<List<double>> onFaceDetected;
  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  ArCoreFaceController arCoreFaceController;
  final EventChannel _channel = EventChannel('events');
  List<double> newStrealValue = [0, 0, 0, 0, 0, 0];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: ArCoreFaceView(
        enableAugmentedFaces: true,
        onArCoreViewCreated: _onArCoreViewCreated,
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreFaceController controller) {
    arCoreFaceController = controller;
    _channel.receiveBroadcastStream().listen(
      (value) {
        newStrealValue = [
          value[0] as double,
          value[1] as double,
          value[2] as double,
          value[3] as double,
          value[4] as double,
          value[5] as double,
          value[6] as double,
        ];

        setState(() {});
        widget.onFaceDetected(newStrealValue);
      },
      cancelOnError: true,
    );
    loadMesh();
  }

  Future<void> loadMesh() async {
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
