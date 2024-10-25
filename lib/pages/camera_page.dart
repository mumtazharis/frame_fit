import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart'; // Tambahkan package image_picker
import '../widgets/camera_preview_widget.dart';
import '../widgets/camera_control_widget.dart';
import 'preview_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:screen_brightness/screen_brightness.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _selectedCameraIndex = 0;
  String? _imagePath;
  bool _isFlashOn = false;
  final ImagePicker _picker = ImagePicker(); // Inisialisasi ImagePicker

  @override
    void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _selectedCameraIndex = _cameras!.indexWhere((camera) => camera.lensDirection == CameraLensDirection.front);

    if (_selectedCameraIndex == -1) {
      _selectedCameraIndex = 0;
    }

    _cameraController = CameraController(
      _cameras![_selectedCameraIndex],
      ResolutionPreset.high,
    );
    await _cameraController!.initialize();
    
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) {
      print('Error: Kamera belum terinisialisasi.');
      return;
    }

    try {
      // Ambil gambar
      final image = await _cameraController!.takePicture();

      if (mounted) {
        setState(() {
          _imagePath = image.path;
        });
      }

      // Cek apakah kamera yang digunakan adalah kamera belakang
      if (_cameras![_selectedCameraIndex].lensDirection == CameraLensDirection.back) {
        // Matikan flash setelah mengambil foto
        await _cameraController!.setFlashMode(FlashMode.off);
        _isFlashOn = false;
        setState(() {});
      }

      // Jika menggunakan kamera depan, gambar perlu dicerminkan (mirrored)
      if (_cameras![_selectedCameraIndex].lensDirection == CameraLensDirection.front) {
        await _mirrorImage(_imagePath!);
      }

      // Pergi ke halaman preview
      await _goToPreviewPage();
    } catch (e) {
      print('Error saat mengambil gambar: $e');
    }
  }


  Future<void> _mirrorImage(String imagePath) async {
    final originalImage = img.decodeImage(File(imagePath).readAsBytesSync());

    if (originalImage != null) {
      final mirroredImage = img.flipHorizontal(originalImage);
      final mirroredImagePath = imagePath.replaceFirst('.jpg', '_mirrored.jpg');
      File(mirroredImagePath).writeAsBytesSync(img.encodeJpg(mirroredImage));

      if (mounted) {
        setState(() {
          _imagePath = mirroredImagePath;
        });
      }
    }
  }

  Future<void> _goToPreviewPage() async {
    if (_imagePath != null) {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: SpinKitCircle(
                color: Colors.blue,
                size: 70.0,
              ),
            );
          },
        );
      }

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.of(context).pop();
        final result = await Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ImagePreviewPage(
              imagePath: _imagePath!,
              selectedCameraIndex: _selectedCameraIndex, // Kirim nilai selectedCameraIndex
               cameraController: _cameraController!,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );

        // Menerima selectedCameraIndex yang dikembalikan dari halaman lain
        if (result != null && result is int) {
          setState(() {
            _selectedCameraIndex = result;
          });
        }
      }
    }
  }


  void _switchCamera() async {
    if (_cameras == null || _cameras!.isEmpty) {
      return;
    }
    
    await _cameraController?.dispose();
    
    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras!.length;
    });

    _cameraController = CameraController(
      _cameras![_selectedCameraIndex],
      ResolutionPreset.high,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _selectPicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
      await _goToPreviewPage();
    }
  }
  Future<void> _toggleFlash() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      CameraDescription cameraDescription = _cameraController!.description;

      // Check if we are using the back camera (most devices support flash for the back camera)
      if (cameraDescription.lensDirection == CameraLensDirection.back) {
        _isFlashOn = !_isFlashOn;
        if (_isFlashOn) {
          await _cameraController!.setFlashMode(FlashMode.torch);
        } else {
          await _cameraController!.setFlashMode(FlashMode.off);
        }
      } else if (cameraDescription.lensDirection == CameraLensDirection.front) {
        // For front cameras (which might not have a flash), increase screen brightness as a workaround
        _isFlashOn = !_isFlashOn;
        if (_isFlashOn) {
          await _setMaxBrightness();  // Maximize screen brightness
        } else {
          await _resetBrightness();   // Restore previous brightness
        }
      }

      setState(() {});
    }
  }



  Future<void> _setMaxBrightness() async {
    try {
      // Mengatur kecerahan maksimum (1.0)
      await ScreenBrightness.instance.setApplicationScreenBrightness(1.0);
    } catch (e) {
      // Menangani error jika terjadi saat mengatur brightness
      print("Error setting brightness: $e");
    }
  }

  Future<void> _resetBrightness() async {
    _isFlashOn = false;
    try {
      // Ambil nilai system brightness
      // double brightness = await ScreenBrightness.instance.system;

      // Set application brightness ke nilai system brightness
      await ScreenBrightness.instance.resetApplicationScreenBrightness();

    } catch (e) {
      print("Error resetting brightness: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: statusBarHeight),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: _cameraController == null || !_cameraController!.value.isInitialized
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox.expand(
                          child: CameraPreviewWidget(
                            cameraController: _cameraController!,
                            showCircleOverlay: true),
                        ),
                ),
                Expanded(
                  flex: 1,
                    child: CameraControlWidget(
                    onSwitchCamera: () {
                      _resetBrightness(); // Reset brightness sebelum switch camera
                      _switchCamera(); // Panggil fungsi switch camera
                    },
                    onTakePicture: () {
                      _takePicture(); // Panggil fungsi ambil gambar
                      _resetBrightness();
                    },
                    onSelectImage: () {
                      _resetBrightness(); // Reset brightness sebelum memilih gambar
                      _selectPicture(); // Panggil fungsi memilih gambar
                    }, // Tambahkan fungsi _selectPicture
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50, // Posisi tombol silang dari atas preview
            left: 16, // Jarak dari sisi kiri
            child: Container(
              width: 40, // Lebar yang diinginkan untuk latar belakang
              height: 40, // Tinggi yang diinginkan untuk latar belakang
              decoration: BoxDecoration(
                color: Colors.white, // Ganti dengan warna latar belakang yang diinginkan
                borderRadius: BorderRadius.circular(15), // Radius sudut untuk tampilan yang lebih halus
              ),
              child: IconButton(
                icon: const Icon(Icons.close, size: 20, color: Colors.black), // Ikon silang
                onPressed: () {
                  _resetBrightness();
                  Navigator.pop(context); // Fungsi untuk kembali
                },
                tooltip: 'Tutup',
              ),
            ),
          ),
          Positioned(
            top: 50, // Posisi tombol flash dari atas preview (sama dengan tombol silang)
            right: 16, // Jarak dari sisi kanan
            child: Container(
              width: 40, // Lebar yang diinginkan untuk latar belakang
              height: 40, // Tinggi yang diinginkan untuk latar belakang
              decoration: BoxDecoration(
                color: _isFlashOn ? Colors.white : Colors.grey, // Ganti dengan warna latar belakang yang diinginkan
                borderRadius: BorderRadius.circular(15), // Radius sudut untuk tampilan yang lebih halus
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.lightbulb, // Ganti ikon berdasarkan status flash
                  size: 20,
                  color: Colors.black,
                ),
                onPressed: () {
                  _toggleFlash(); // Ganti dengan fungsi untuk mengubah status flash
                },
                tooltip: 'Flash', // Tooltip untuk tombol
              ),
            ),
          ),

        ],
      ),
    );
  }
  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
