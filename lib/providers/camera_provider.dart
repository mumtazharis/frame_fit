import 'dart:io';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:screen_brightness/screen_brightness.dart';
import 'package:image/image.dart' as img;
import '../config/api_config.dart';
import 'package:flutter/material.dart';
import '../pages/preview_page.dart';

final cameraProvider = StateNotifierProvider<CameraNotifier, CameraState>((ref) {
  return CameraNotifier();
});

class CameraState {
  final CameraController? cameraController;
  final List<CameraDescription>? cameras;
  final int selectedCameraIndex;
  final String? imagePath;
  final bool isFlashOn;
  final Map<String, dynamic>? predictionResult;
  final bool isProcessing;

  CameraState({
    this.cameraController,
    this.cameras,
    this.selectedCameraIndex = 0,
    this.imagePath,
    this.isFlashOn = false,
    this.predictionResult,
    this.isProcessing = false,
  });

  CameraState copyWith({
    CameraController? cameraController,
    List<CameraDescription>? cameras,
    int? selectedCameraIndex,
    String? imagePath,
    bool? isFlashOn,
    Map<String, dynamic>? predictionResult,
    bool? isProcessing,
  }) {
    return CameraState(
      cameraController: cameraController ?? this.cameraController,
      cameras: cameras ?? this.cameras,
      selectedCameraIndex: selectedCameraIndex ?? this.selectedCameraIndex,
      imagePath: imagePath ?? this.imagePath,
      isFlashOn: isFlashOn ?? this.isFlashOn,
      predictionResult: predictionResult ?? this.predictionResult,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

class CameraNotifier extends StateNotifier<CameraState> {
  CameraNotifier() : super(CameraState()) {
    _initializeCamera();
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    int selectedCameraIndex = cameras.indexWhere((camera) => camera.lensDirection == CameraLensDirection.front);

    if (selectedCameraIndex == -1) {
      selectedCameraIndex = 0;
    }

    final cameraController = CameraController(
      cameras[selectedCameraIndex],
      ResolutionPreset.high,
    );

    await cameraController.initialize();
    state = state.copyWith(
      cameras: cameras,
      selectedCameraIndex: selectedCameraIndex,
      cameraController: cameraController,
    );
  }

Future<void> takePicture(BuildContext context) async {
  final controller = state.cameraController;

  if (controller == null || !controller.value.isInitialized) {
    print('Error: Kamera belum terinisialisasi.');
    return;
  }

  try {
    // Aktifkan loading
    state = state.copyWith(isProcessing: true);

    final image = await controller.takePicture();

    state = state.copyWith(imagePath: image.path, predictionResult: null);  // Reset prediction result

    print('Gambar berhasil diambil: ${image.path}');

    // Jika menggunakan kamera depan, gambar perlu dicerminkan (mirrored)
    if (state.cameras![state.selectedCameraIndex].lensDirection == CameraLensDirection.front) {
      await _mirrorImage(image.path);
    }

    // Kirim gambar ke API prediksi
    final prediction = await _sendImageToPredictApi(image.path);

    // Simpan hasil prediksi dalam state
    state = state.copyWith(predictionResult: prediction);

    // Pindah ke halaman preview
    await goToPreviewPage(context);
  } catch (e) {
    print('Error saat mengambil gambar: $e');
  } finally {
    // Nonaktifkan loading
    state = state.copyWith(isProcessing: false);
  }
}


  Future<void> _mirrorImage(String imagePath) async {
    final originalImage = img.decodeImage(File(imagePath).readAsBytesSync());

    if (originalImage != null) {
      final mirroredImage = img.flipHorizontal(originalImage);
      final mirroredImagePath = imagePath.replaceFirst('.jpg', '_mirrored.jpg');
      File(mirroredImagePath).writeAsBytesSync(img.encodeJpg(mirroredImage));

      // Perbarui path di state jika diperlukan
      state = state.copyWith(imagePath: mirroredImagePath);
    }
  }

  Future<void> goToPreviewPage(BuildContext context) async {
    if (state.imagePath != null) {
      await _resetBrightness();
      await state.cameraController?.setFlashMode(FlashMode.off);
      state = state.copyWith(isFlashOn: false);

      await Navigator.push(
  
        context,
        MaterialPageRoute(
          builder: (context) => const ImagePreviewPage(),
        ),
      );

      if (state.cameras![state.selectedCameraIndex].lensDirection == CameraLensDirection.back) {
        state = state.copyWith(selectedCameraIndex: 0);
      } else {
        state = state.copyWith(selectedCameraIndex: 1);
      }
    }
      
  }


  Future<void> switchCamera() async {
    final cameras = state.cameras;
    if (cameras == null || cameras.isEmpty) return;

    await state.cameraController?.dispose();

    final newIndex = (state.selectedCameraIndex + 1) % cameras.length;
    final cameraController = CameraController(
      cameras[newIndex],
      ResolutionPreset.medium,
    );

    await cameraController.initialize();
    state = state.copyWith(
      selectedCameraIndex: newIndex,
      cameraController: cameraController,
    );
  }

  Future<void> toggleFlash() async {
    final controller = state.cameraController;
    if (controller == null || !controller.value.isInitialized) return;

    final isFlashOn = !state.isFlashOn;

    if (state.cameras![state.selectedCameraIndex].lensDirection == CameraLensDirection.back) {
      await controller.setFlashMode(isFlashOn ? FlashMode.torch : FlashMode.off);
    } else {
      if (isFlashOn) {
        await _setMaxBrightness();
      } else {
        await _resetBrightness();
      }
    }

    state = state.copyWith(isFlashOn: isFlashOn);
  }

  Future<void> _setMaxBrightness() async {
    try {
      await ScreenBrightness.instance.setApplicationScreenBrightness(1.0);
    } catch (e) {
      print("Error setting brightness: $e");
    }
  }

  Future<void> _resetBrightness() async {
    try {
      await ScreenBrightness.instance.resetApplicationScreenBrightness();
    } catch (e) {
      print("Error resetting brightness: $e");
    }
  }

  Future<Map<String, dynamic>?> _sendImageToPredictApi(String imagePath) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('${ApiConfig.baseUrl}/api/predict'));
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> responseJson = jsonDecode(responseBody);

        // Mengembalikan map dengan nilai predicted_label dan confidence
        return {
          'predicted_label': responseJson['predicted_label'],
          'confidence': responseJson['confidence'],
        };
      } 
      else {
        // Jika status bukan 200, ambil pesan error dari JSON respons
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> errorJson = jsonDecode(responseBody);
        
        // Menampilkan pesan error
        print('Error: ${errorJson['error']}');
        return {'error': errorJson['error']}; // Kembalikan pesan error
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
Future<void> selectPicture(BuildContext context) async {
  // Menggunakan ImagePicker untuk memilih gambar dari galeri
  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    try {
      // Aktifkan loading
      state = state.copyWith(isProcessing: true);

      // Jika gambar berhasil dipilih, perbarui imagePath di state
      state = state.copyWith(imagePath: pickedFile.path);

      // Kirim gambar ke API untuk prediksi jika diperlukan
      final prediction = await _sendImageToPredictApi(pickedFile.path);

      if (prediction != null) {
        // Simpan hasil prediksi dalam state
        state = state.copyWith(predictionResult: prediction);
      }

      // Pindah ke halaman preview
      await goToPreviewPage(context); // Memastikan context sudah tersedia
    } catch (e) {
      print('Error saat memilih gambar: $e');
    } finally {
      // Nonaktifkan loading
      state = state.copyWith(isProcessing: false);
    }
  } else {
    print("Gambar tidak dipilih");
  }
}

  @override
  void dispose() {
    state.cameraController?.dispose();
    super.dispose();
  }
}
