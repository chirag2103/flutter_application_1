import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelViewerWidget extends StatelessWidget {
  final String modelUrl;
  final String? alt;
  final bool autoRotate;
  final bool ar;

  const ModelViewerWidget({
    Key? key,
    required this.modelUrl,
    this.alt,
    this.autoRotate = true,
    this.ar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ModelViewer(
        src: modelUrl,
        alt: alt ?? '3D Model',
        ar: ar,
        autoRotate: autoRotate,
        cameraControls: true,
        disableZoom: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
