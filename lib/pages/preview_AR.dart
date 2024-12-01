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
        ? GestureDetector(
            onVerticalDragUpdate: (details) {
              // Memicu ikon panah ketika swipe ke atas
              if (details.delta.dy < 0) {
                // Gerakan swipe ke atas
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.5,
                      minChildSize: 0.3,
                      maxChildSize: 1.0,
                      builder: (context, scrollController) {
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
                          ),
                          child: Column(
                            children: [
                              Text("Semua Kacamata", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              Expanded(
                                child: GridView.builder(
                                  controller: scrollController,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // Ubah sesuai kebutuhan
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: kacamataAssets.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0), // Mengurangi padding agar sesuai
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle, // Membuat latar belakang lingkaran
                                          color: Colors.white, // Warna latar belakang
                                        ),
                                        child: ClipOval(
                                          child: Image.network(
                                            kacamataAssets[index],
                                            fit: BoxFit.contain, // Menjaga aspek rasio gambar
                                            errorBuilder: (context, error, stackTrace) {
                                              print('Error loading image: $error');
                                              return Text('Error loading image');
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
            child: Stack(
              children: [
                // Preview Kamera
                Positioned(
                  top: statusBarHeight,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: screenSize.height * 0.8, // 65% tinggi layar untuk kamera
                    width: screenSize.width,
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
                                        transform: (_cameraController!.description.lensDirection ==
                                                CameraLensDirection.front
                                            ? (Matrix4.identity()..scale(-1.0, 1.0))
                                            : Matrix4.identity()),
                                        child: CameraPreviewWidget(
                                          cameraController: _cameraController!,
                                          showCircleOverlay: false,
                                        ),
                                      ),
                                      // Kacamata Overlay
                                      ..._faces.map((face) {
                                        final leftEye = face.landmarks[FaceLandmarkType.leftEye];
                                        final rightEye = face.landmarks[FaceLandmarkType.rightEye];

                                        if (leftEye != null &&
                                            rightEye != null &&
                                            kacamataAssets.isNotEmpty) {
                                          final eyeLeftPosition = Point<double>(
                                            leftEye.position.x.toDouble(),
                                            leftEye.position.y.toDouble(),
                                          );
                                          final eyeRightPosition = Point<double>(
                                            rightEye.position.x.toDouble(),
                                            rightEye.position.y.toDouble(),
                                          );

                                          var centerX =
                                              (eyeLeftPosition.x + eyeRightPosition.x) / 2;
                                          var centerY =
                                              (eyeLeftPosition.y + eyeRightPosition.y) / 2;
                                          double eyeDistance = (eyeRightPosition.x - eyeLeftPosition.x).abs();
                                          double width = eyeDistance * 2.2;
                                          double height = width / 2;

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
                                                fit: BoxFit.contain,
                                                errorBuilder:
                                                    (context, error, stackTrace) {
                                                  print('Error loading image: $error');
                                                  return Text('Error loading image');
                                                },
                                              ),
                                            ),
                                          );
                                        } else {
                                          return SizedBox();
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

                // Widget putih di area kosong untuk swipe
                Positioned(
                  top: screenSize.height * 0.8,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: screenSize.height * 0.3, // Sisa area bawah untuk swipe
                    color: Colors.white, // Warna latar belakang putih
                  ),
                ),

                // Swiper
                Positioned(
                  top: screenSize.height * 0.8 - 60, // Setengah swiper di atas kamera
                  left: 0,
                  right: 0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 120, // Tinggi total Swiper
                                child: Swiper(
                                  itemCount: kacamataAssets.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      padding: EdgeInsets.fromLTRB(30, 10, 30, 10), // Padding spesifik
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle, // Membuat gambar berbentuk lingkaran
                                        color: const Color.fromARGB(255, 255, 255, 255), // Latar belakang lingkaran
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          kacamataAssets[index],
                                          fit: BoxFit.contain, // Menjaga aspek rasio gambar
                                          errorBuilder: (context, error, stackTrace) {
                                            print('Error loading image: $error');
                                            return Text('Error loading image');
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  viewportFraction: 0.4, // Ukuran item Swiper relatif terhadap layar
                                  scale: 0.85, // Skala item di tengah
                                  loop: false,
                                  onIndexChanged: (index) {
                                    setState(() {
                                      selectedGlassesIndex = index;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          )
        : Center(child: CircularProgressIndicator()),
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
