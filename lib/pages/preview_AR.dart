import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../widgets/camera_preview_widget.dart';
import 'dart:math';
import 'package:card_swiper/card_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:frame_fit/config/api_config.dart';
import 'dart:convert';

class ARPreviewPage extends StatefulWidget {
  final int selectedCameraIndex;
  final String bentuk_wajah;

  ARPreviewPage({Key? key, required this.selectedCameraIndex, required this.bentuk_wajah}) : super(key: key);

  @override
  _ARPreviewPageState createState() => _ARPreviewPageState();
}

class _ARPreviewPageState extends State<ARPreviewPage> {
  late FaceDetector _faceDetector;
  CameraController? _cameraController;
  List<Face> _faces = [];
  List<String> kacamataAssets = []; // Daftar URL kacamata dari API
  int selectedGlassesIndex = 0; // Simpan indeks kacamata yang dipilih
  bool isLoading = true; // Indikator pemuatan data kacamata

  @override
  void initState() {
    super.initState();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        enableClassification: false,
        enableTracking: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
      _fetchRekomendasiKacamata();
    _initializeCamera();
  }
Future<void> _fetchRekomendasiKacamata() async {
  try {
    // Debugging: Log URL yang dipanggil
    print('Fetching glasses recommendation from: ${ApiConfig.baseUrl}/api/rekomendasi_kacamata?bentuk_wajah=${widget.bentuk_wajah}');

    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/rekomendasi_kacamata?bentuk_wajah=${widget.bentuk_wajah}'),
    );

    // Debugging: Log status kode dari respons
    print('Response status code: ${response.statusCode}');

    if (response.statusCode == 200) {
      // Debugging: Log isi body dari respons
      print('Response body: ${response.body}');

      final List<dynamic> data = json.decode(response.body); // Decode sebagai array JSON

      // Filter dan ambil nilai 'foto' dari setiap objek di array
      final List<String> photos = data
          .where((item) => item['foto'] != null) // Pastikan 'foto' tidak null
          .map<String>((item) => item['foto'] as String) // Ambil nilai 'foto' sebagai String
          .toList();

      if (photos.isNotEmpty) {
        setState(() {
          kacamataAssets = photos; // Simpan URL gambar di daftar
        });
        print('Loaded glasses assets: $kacamataAssets');
      } else {
        print('No glasses data found for the given face shape');
      }
    } else {
      print('Failed to fetch glasses: ${response.statusCode}');
    }
  } catch (e) {
    // Debugging: Log jika terjadi kesalahan
    print('Error fetching glasses data: $e');
  } finally {
    setState(() {
      isLoading = false;
    });
    print('Fetch glasses recommendation completed. isLoading: $isLoading');
  }
}


  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    
    // Memilih kamera berdasarkan index yang dipilih
    _cameraController = CameraController(
      cameras[widget.selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      // Menginisialisasi kamera
      await _cameraController!.initialize();

      // Mengatur tampilan agar selalu portrait
      // _setPortraitOrientation();

      _startFaceDetection();
    } catch (e) {
      print('Error initializing camera: $e');
      _showErrorDialog('Error initializing camera: $e');
    }
  }


  Future<void> _startFaceDetection() async {
    _cameraController!.startImageStream((CameraImage image) async {
      try {
        final inputImage = _convertCameraImage(image);
        final faces = await _faceDetector.processImage(inputImage);

        if (mounted) {
          setState(() {
            _faces = faces;
          });
        }
      } catch (e) {
        print('Error processing image: $e');
      }
    });
  }

  InputImage _convertCameraImage(CameraImage image) {
    final BytesBuilder bytesBuilder = BytesBuilder();
    for (var plane in image.planes) {
      bytesBuilder.add(plane.bytes);
    }
    final bytes = bytesBuilder.toBytes();

    // Dapatkan orientasi sensor dari CameraController.description
    int rotation = _cameraController!.description.sensorOrientation;

    InputImageFormat format = InputImageFormat.nv21;

    final metadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: InputImageRotationValue.fromRawValue(rotation)!,
      format: format,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
@override
Widget build(BuildContext context) {
  double statusBarHeight = MediaQuery.of(context).padding.top;
  Size screenSize = MediaQuery.of(context).size;

  return Scaffold(
    body: _cameraController != null && _cameraController!.value.isInitialized
        ? Stack(
            children: [
              // Video dengan rasio 3:4 di bagian atas
              Padding(
                padding: EdgeInsets.only(top: statusBarHeight),
                child: Container(
                  width: screenSize.width,
                  height: screenSize.height * 2/3, // Sisakan ruang untuk swiper
                  child: ClipRect(
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: (_cameraController!.value.previewSize != null)
                            ? SizedBox(
                                width: _cameraController!.value.previewSize!.height,
                                height: _cameraController!.value.previewSize!.width,
                                child: Stack(
                                  children: [
                                    Transform(
                                      alignment: Alignment.center,
                                      transform: (_cameraController!.description.lensDirection == CameraLensDirection.front
                                          ? (Matrix4.identity()..scale(-1.0, 1.0)) // Membalik untuk kamera depan
                                          : Matrix4.identity()),
                                      child: CameraPreviewWidget(
                                        cameraController: _cameraController!,
                                        showCircleOverlay: false,
                                      ),
                                    ),

                                    // Kacamata
                                    ..._faces.map((face) {
                                      final leftEye = face.landmarks[FaceLandmarkType.leftEye];
                                      final rightEye = face.landmarks[FaceLandmarkType.rightEye];

                                      if (leftEye != null && rightEye != null && kacamataAssets.isNotEmpty) {
                                        final eyeLeftPosition = Point<double>(
                                          leftEye.position.x.toDouble(),
                                          leftEye.position.y.toDouble(),
                                        );
                                        final eyeRightPosition = Point<double>(
                                          rightEye.position.x.toDouble(),
                                          rightEye.position.y.toDouble(),
                                        );

                                        // Hitung posisi rata-rata antara kedua mata
                                        var centerX = (eyeLeftPosition.x + eyeRightPosition.x) / 2;
                                        var centerY = (eyeLeftPosition.y + eyeRightPosition.y) / 2;

                                        // Hitung jarak antara kedua mata
                                        double eyeDistance = (eyeRightPosition.x - eyeLeftPosition.x).abs();
                                        double width = eyeDistance * 2.2; // Skala yang lebih besar untuk menyesuaikan dengan bingkai kacamata
                                        double height = width / 2; // Aspek rasio default kacamata (sesuaikan jika berbeda)

                                        double dx = eyeRightPosition.x - eyeLeftPosition.x;
                                        double dy = eyeRightPosition.y - eyeLeftPosition.y;
                                        double angle = atan2(dy, dx);

                                        return Positioned(
                                          left: centerX - (width / 2),
                                          top: centerY - (height / 2),
                                          child: Transform.rotate(
                                            angle: angle,
                                            child: Image.network(
                                              kacamataAssets[selectedGlassesIndex],
                                              width: width,
                                              height: height,
                                              fit: BoxFit.contain, // Menjaga aspek rasio gambar
                                              errorBuilder: (context, error, stackTrace) {
                                                print('Error loading image: $error');
                                                return Text('Error loading image');
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        return SizedBox(); // Tampilkan widget kosong jika tidak ada landmark atau data
                                      }
                                    }).toList(),
                                  ],
                                ),
                              )
                            : Center(child: Text('Preview tidak tersedia')),
                      ),
                    ),
                  ),
                ),
              ),
// Swiper di atas preview
Positioned(
  bottom: 0, // Letakkan di bagian bawah
  left: 0,
  right: 0,
  child: isLoading
      ? Center(child: CircularProgressIndicator())
      : Container(
          height: 120, // Tinggi kontainer swiper
          margin: EdgeInsets.symmetric(vertical: 0), // Mengurangi margin untuk memberikan lebih banyak ruang
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)), // Menambahkan sudut melengkung pada bagian atas
          ),
          child: Swiper(
            itemCount: kacamataAssets.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 50, // Atur lebar kontainer lingkaran yang lebih besar
                height: 50, // Atur tinggi kontainer lingkaran yang lebih besar
               padding: EdgeInsets.fromLTRB(50, 10, 50, 10),// Menambahkan padding agar gambar tidak menyentuh tepi
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Mengatur bentuk menjadi lingkaran
                  color: Colors.white, // Atur warna latar belakang
                ),
                child: ClipOval( // Menggunakan ClipOval untuk memastikan gambar berada di dalam lingkaran
                  child: Image.network(
                    kacamataAssets[index],
                    fit: BoxFit.contain, // Mengatur gambar agar memenuhi area lingkaran
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return Text('Error loading image');
                    },
                  ),
                ),
              );
            },
            viewportFraction: 0.5, // Mengurangi viewportFraction untuk menghindari gambar berdempetan
            scale: 0.85, // Menyesuaikan skala untuk memberikan jarak yang lebih baik antar gambar
            onIndexChanged: (index) {
              setState(() {
                selectedGlassesIndex = index; // Perbarui kacamata yang dipilih
              });
            },
          ),
        ),
),


            ],
          )
        : Center(child: CircularProgressIndicator()), // Menampilkan loading saat kamera belum siap
  );
}



  @override
  void dispose() {
    _faceDetector.close();
    _cameraController?.stopImageStream(); // Tambahkan ini untuk menghentikan stream
    _cameraController?.dispose();
    super.dispose();
  }

}
