import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraWidget extends StatefulWidget {
  final Function(File file) onFile;
  const CameraWidget({super.key, required this.onFile});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController? _cameraController;

  @override
  void initState() {
    super.initState();
    asyncInitState();
  }

  Future asyncInitState() async {
    var cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.veryHigh);
    await _cameraController!.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController?.value.isInitialized != true) {
      return const SizedBox.shrink();
    }

    var camera = _cameraController!.value;

    return LayoutBuilder(
      builder: (context, boxConstraints) {
        var scale = min(boxConstraints.maxWidth, boxConstraints.maxHeight) /
            max(boxConstraints.maxWidth, boxConstraints.maxHeight) *
            camera.aspectRatio;

        if (scale < 1) {
          scale = 1 / scale;
        }

        return Stack(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.blue),
              child: Transform.scale(
                  scale: scale, child: CameraPreview(_cameraController!)),
            ),
            Container(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 120,
                  child: Stack(children: [
                    const Center(
                      child: Icon(
                        Icons.circle,
                        size: 70,
                        color: Color.fromARGB(100, 242, 236, 236),
                      ),
                    ),
                    Center(
                        child: IconButton(
                      style: IconButton.styleFrom(padding: EdgeInsets.zero),
                      onPressed: () async {
                        var xfile = await _cameraController!.takePicture();
                        widget.onFile(File(xfile.path));
                      },
                      iconSize: 100,
                      icon: const Icon(
                        Icons.circle,
                        color: Color.fromARGB(50, 242, 236, 236),
                      ),
                    )),
                  ]),
                ))
          ],
        );
      },
    );
  }
}
