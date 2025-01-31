import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:frame_fit/config/api_config.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

// Provider untuk ARNotifier
final ARProvider = StateNotifierProvider<ARNotifier, ARState>((ref) {
  return ARNotifier();
});

// State untuk AR
class ARState {
  final CameraController? cameraController;
  final int? selectedCameraIndex;
  final String? bentukWajah;
  final String? gender;
  final FaceDetector? faceDetector;
  final List<Face> faces;
  final List<String> kacamataAssets;
  final int selectedGlassesIndex;
  final bool isLoading;
  final bool isSwiperAndSheetEnabled;


  ARState({
    this.cameraController,
    this.selectedCameraIndex = 0,
    this.bentukWajah,
    this.gender,
    this.faceDetector,
    this.faces = const [],
    this.kacamataAssets = const [],
    this.selectedGlassesIndex = 0,
    this.isLoading = true,
    this.isSwiperAndSheetEnabled = true,

  });

  ARState copyWith({
    CameraController? cameraController,
    int? selectedCameraIndex,
    String? bentukWajah,
    String? gender,
    FaceDetector? faceDetector,
    List<Face>? faces,
    List<String>? kacamataAssets,
    int? selectedGlassesIndex,
    bool? isLoading,
    bool? isSwiperAndSheetEnabled,
  }) {
    return ARState(
      cameraController: cameraController ?? this.cameraController,
      selectedCameraIndex: selectedCameraIndex ?? this.selectedCameraIndex,
      bentukWajah: bentukWajah ?? this.bentukWajah,
      gender: gender ?? this.gender,
      faceDetector: faceDetector ?? this.faceDetector,
      faces: faces ?? this.faces,
      kacamataAssets: kacamataAssets ?? this.kacamataAssets,
      selectedGlassesIndex: selectedGlassesIndex ?? this.selectedGlassesIndex,
      isLoading: isLoading ?? this.isLoading,
      isSwiperAndSheetEnabled: isSwiperAndSheetEnabled ?? this.isSwiperAndSheetEnabled,
    );
  }
}

// Notifier untuk mengelola state AR
class ARNotifier extends StateNotifier<ARState> {
  // CameraController? cameraController;
  ARNotifier() : super(ARState()) {

    
  }

  void resetState() {
    // Hentikan image stream jika aktif
    state.cameraController?.stopImageStream();
    // Dispose camera controller
    state.cameraController?.dispose();
    state = ARState(); // Mengembalikan semua nilai ke default
  }
  
  void toggleSwiperAndSheet(bool isEnabled) {
    state = state.copyWith(isSwiperAndSheetEnabled: isEnabled);
  }

  void kacamataCoba(List<String> kacamataAssets){
    state = state.copyWith(kacamataAssets: kacamataAssets);
  }
  // void setSelectedCameraIndex(int index) {
  //   state = state.copyWith(selectedCameraIndex: index);

  // }
  void updateInformasiRekomendasi(String bentukWajah, String gender) {
    print('Updating bentuk wajah to: $bentukWajah');  // Log to confirm update
    print('Updating gender to: $gender');  // Log to confirm update
    state = state.copyWith(bentukWajah: bentukWajah);
    state = state.copyWith(gender: gender);
    print('Updated bentuk wajah: ${state.bentukWajah}');  
    print('Updated gender: ${state.gender}');  
    _fetchRekomendasiKacamata();// Log to confirm after update
  }
  void updateSelectedGlassesIndex(int index) {
    state = state.copyWith(selectedGlassesIndex: index);
  }


  void initializeFaceDetector() {
    final Detector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        enableClassification: false,
        enableTracking: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
    state = state.copyWith(faceDetector: Detector);
    
  }

  Future<void> initializeCamera() async {
    try {
      print("Inisialisasi kamera dimulai...");
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        print("Tidak ada kamera yang tersedia.");
        return;
      }
      state = state.copyWith(selectedCameraIndex: cameras.indexWhere((camera) => camera.lensDirection == CameraLensDirection.front));

      // final selectedCamera = cameras[state.selectedCameraIndex];
      final cameraController = CameraController(
        cameras[state.selectedCameraIndex ?? 0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await cameraController.initialize();
      // await state.cameraController?.stopImageStream();

      state = state.copyWith(cameraController: cameraController);
      print("Kamera berhasil diinisialisasi.");
      _startFaceDetection();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _fetchRekomendasiKacamata() async {
    if (state.bentukWajah == null || state.gender == null) {
      print('Bentuk wajah atau gender belum tersedia.');
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      // Membangun URL dengan query parameters
      final uri = Uri.parse('${ApiConfig.baseUrl}/api/rekomendasi_kacamata')
          .replace(queryParameters: {
        'bentuk_wajah': state.bentukWajah!,
        'gender': state.gender!,
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<String> photos = data
            .where((item) => item['foto'] != null)
            .map<String>((item) => item['foto'] as String)
            .toList();

        state = state.copyWith(kacamataAssets: photos, isLoading: false);
      } else {
        print('Failed to fetch glasses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching glasses data: $e');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }


  Future<void> _startFaceDetection() async {
    state.cameraController!.startImageStream((CameraImage image) async {
      try {
        final inputImage = _convertCameraImage(image);
        final faces = await state.faceDetector!.processImage(inputImage);

        state = state.copyWith(faces: faces);
      } catch (e) {
        print('Error processing image: $e');
      }
    });
  }

  InputImage _convertCameraImage(CameraImage image) {
    final bytesBuilder = BytesBuilder();
    for (var plane in image.planes) {
      bytesBuilder.add(plane.bytes);
    }
    final bytes = bytesBuilder.toBytes();

    int rotation = state.cameraController!.description.sensorOrientation;

    InputImageFormat format = InputImageFormat.nv21;

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotationValue.fromRawValue(rotation)!,
      format: format,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  void selectGlasses(int index) {
    state = state.copyWith(selectedGlassesIndex: index);
  }


  @override
  void dispose() {
    state.cameraController?.dispose();
    super.dispose();
  }

}
