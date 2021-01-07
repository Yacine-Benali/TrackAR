import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:headtrack/app/home_bloc.dart';

class FaceDetectionScreen extends StatefulWidget {
  FaceDetectionScreen({Key key, @required this.bloc}) : super(key: key);
  final HomeBloc bloc;
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
    _channel.receiveBroadcastStream().listen((value) {
      List<double> l = [
        value[0],
        value[1],
        value[2],
        value[3],
        value[4],
        value[5],
        value[6],
      ];
      //List<double> q = [l[3], l[4], l[5], l[6]]; // {x, y, z, w}.

      //print(q);
      widget.bloc.sendFace('192.168.1.3', 4242, l, 4269);
    }, cancelOnError: true);
    loadMesh();
  }

  loadMesh() async {
    final ByteData textureBytes =
        await rootBundle.load('assets/fox_face_mesh_texture.png');

    arCoreFaceController.loadMesh(
        textureBytes: textureBytes.buffer.asUint8List(),
        skin3DModelFilename: 'fox_face.sfb');
  }

  @override
  void dispose() {
    arCoreFaceController.dispose();
    super.dispose();
  }
}
