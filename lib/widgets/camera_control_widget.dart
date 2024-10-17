import 'package:flutter/material.dart';

class CameraControlWidget extends StatelessWidget {
  final Function onSwitchCamera;
  final Function onTakePicture;

  const CameraControlWidget({
    Key? key,
    required this.onSwitchCamera,
    required this.onTakePicture,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.cameraswitch_rounded),
          onPressed: () => onSwitchCamera(),
          tooltip: 'Ganti Kamera',
        ),
        SizedBox(width: 20),
        IconButton(
          icon: Icon(Icons.camera_alt_rounded),
          onPressed: () => onTakePicture(),
          tooltip: 'Ambil Foto',
          iconSize: 64,
        ),
      ],
    );
  }
}
