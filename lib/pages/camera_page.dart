import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/camera_provider.dart';
import 'package:frame_fit/widgets/camera_preview_widget.dart';
import 'package:frame_fit/widgets/camera_control_widget.dart';

class CameraPage extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraProvider);
    final cameraNotifier = ref.watch(cameraProvider.notifier);

    double statusBarHeight = MediaQuery.of(context).padding.top;

    if (cameraState.cameraController == null ||
        !cameraState.cameraController!.value.isInitialized) {
        cameraNotifier.initializeCamera();
        return const Center(
          child: CircularProgressIndicator(),
        );
                        }

    return Scaffold(
        backgroundColor: Colors.white,
        body: cameraState.cameraController != null && cameraState.cameraController!.value.isInitialized
        ? Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: statusBarHeight),
              child: Column(
                children: [
                  // Bagian untuk menampilkan CameraPreview
                  Expanded(
                    flex: 4,
                    child: CameraPreviewWidget(
                            cameraController: cameraState.cameraController!,
                        ),
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
            if (cameraState.isProcessing)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Mohon tunggu gambar sedang diproses',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        )
        : Center(child: CircularProgressIndicator()),
      );
    
  }
}
