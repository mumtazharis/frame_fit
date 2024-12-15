import 'package:flutter/material.dart';

class CameraControlWidget extends StatelessWidget {
  final VoidCallback onSwitchCamera;
  final VoidCallback onTakePicture;
  final VoidCallback onSelectImage;

  const CameraControlWidget({
    Key? key,
    required this.onSwitchCamera,
    required this.onTakePicture,
    required this.onSelectImage, // Tambahkan parameter fungsi onSelectImage
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.photo_library_rounded), // Ikon untuk memilih gambar dari galeri
          onPressed: () => onSelectImage(), // Fungsi untuk memilih gambar dari galeri
          iconSize: 48, // Ukuran ikon disamakan
        ),
     
        const SizedBox(width: 40), // Jarak antar ikon diperbesar
            IconButton(
          icon: Image.asset(
            'assets/icon/camerabutton.png', // Ganti dengan path gambar yang benar
            width: 72, // Ukuran gambar disamakan
            height: 72,
          ),
          onPressed: () => onTakePicture(), // Fungsi untuk memilih gambar dari galeri
        ),
        const SizedBox(width: 40), // Jarak antar ikon diperbesar
        IconButton(
          icon: const Icon(Icons.cameraswitch_rounded),
          onPressed: () => onSwitchCamera(),
          tooltip: 'Ganti Kamera',
          iconSize: 48, // Ukuran ikon disamakan
        ),
      ],
    );
  }
}
