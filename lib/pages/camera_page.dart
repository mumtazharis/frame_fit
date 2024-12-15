import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/camera_provider.dart';
import 'package:frame_fit/widgets/camera_preview_widget.dart';
import 'package:frame_fit/widgets/camera_control_widget.dart';

class CameraPage extends ConsumerWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraProvider);
    final cameraNotifier = ref.read(cameraProvider.notifier);

    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: statusBarHeight),
            child: Column(
              children: [
                // Bagian untuk menampilkan CameraPreview
                Expanded(
                  flex: 4,
                  child: cameraState.cameraController == null ||
                          !cameraState.cameraController!.value.isInitialized
                      ? const Center(child: CircularProgressIndicator())
                      : CameraPreviewWidget(cameraController: cameraState.cameraController!),
                ),
                // Bagian untuk kontrol kamera
                Expanded(
                  flex: 1,
                  child: CameraControlWidget(
                    onSwitchCamera: () => cameraNotifier.switchCamera(),
                    onTakePicture: () => cameraNotifier.takePicture(context),
                    onSelectImage: () => cameraNotifier.selectPicture(context),
                  ),
                ),
              ],
            ),
          ),
          // Tombol tutup
          // Positioned(
          //   top: 50, // Posisi tombol silang dari atas preview
          //   left: 16, // Jarak dari sisi kiri
          //   child: Container(
          //     width: 40, // Lebar yang diinginkan untuk latar belakang
          //     height: 40, // Tinggi yang diinginkan untuk latar belakang
          //     decoration: BoxDecoration(
          //       color: Colors.white, // Ganti dengan warna latar belakang yang diinginkan
          //       borderRadius: BorderRadius.circular(15), // Radius sudut untuk tampilan yang lebih halus
          //     ),
          //     child: IconButton(
          //       icon: const Icon(Icons.close, size: 24, color: Colors.black), // Ikon silang
          //       onPressed: () => Navigator.pop(context), // Fungsi untuk kembali
          //       tooltip: 'Tutup',
          //     ),
          //   ),
          // ),

          Positioned(
            top: 50, // Posisi tombol flash dari atas preview (sama dengan tombol silang)
            right: 16, // Jarak dari sisi kanan
            child: Container(
              width: 40, // Lebar yang diinginkan untuk latar belakang
              height: 40, // Tinggi yang diinginkan untuk latar belakang
              decoration: BoxDecoration(
                color: cameraState.isFlashOn ? Colors.white : Colors.grey, // Ganti dengan warna latar belakang yang diinginkan
                borderRadius: BorderRadius.circular(15), // Radius sudut untuk tampilan yang lebih halus
              ),
              child: IconButton(
                icon: Icon(
                  cameraState.isFlashOn ? Icons.flash_on : Icons.flash_off, // Ikon flash berdasarkan status
                  size: 24,
                  color: cameraState.isFlashOn ? Colors.yellow : Colors.black,
                ),
                onPressed: () => cameraNotifier.toggleFlash(), // Fungsi untuk toggle flash
                tooltip: 'Flash', // Tooltip untuk tombol flash
              ),
            ),
          ),

        ],
      ),
    );
  }
}
