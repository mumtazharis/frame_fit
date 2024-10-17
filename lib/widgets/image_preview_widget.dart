import 'package:flutter/material.dart';
import 'dart:io';

class ImagePreviewWidget extends StatelessWidget {
  final String imagePath;

  const ImagePreviewWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.file(File(imagePath)),
    );
  }
}
