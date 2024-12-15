import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../providers/AR_provider.dart';
import '../widgets/camera_preview_widget.dart';
import 'package:card_swiper/card_swiper.dart';
class ARPreviewPage extends ConsumerWidget {
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arState = ref.watch(ARProvider);
    final arNotifier = ref.watch(ARProvider.notifier);
    
    double statusBarHeight = MediaQuery.of(context).padding.top;
    Size screenSize = MediaQuery.of(context).size;
    
    // Cek jika cameraController sudah diinisialisasi
    if (arState.cameraController == null ||
        !arState.cameraController!.value.isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    SwiperController _swiperController = SwiperController();

    return Scaffold(
      body: arState.cameraController != null && arState.cameraController!.value.isInitialized
        ? GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy < 0) {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return DraggableScrollableSheet(
                  initialChildSize: 1.0,
                  minChildSize: 0.9,
                  maxChildSize: 1.0,
                  builder: (context, scrollController) {
                    return Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10.0)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Semua Kacamata",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: GridView.builder(
                              controller: scrollController,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1,
                              ),
                              itemCount: arState.kacamataAssets.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      arNotifier.updateSelectedGlassesIndex(index);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: ClipOval(
                                        child: Image.network(
                                          arState.kacamataAssets[index],
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            print('Error loading image: $error');
                                            return Center(child: Text('Error'));
                                          },
                                        ),
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
            Positioned(
              top: statusBarHeight,
              left: 0,
              right: 0,
              child: Container(
                height: screenSize.height * 0.8,
                width: screenSize.width,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: arState.cameraController!.value.previewSize !=
                              null
                          ? SizedBox(
                              width: arState.cameraController!.value.previewSize!.height,
                              height: arState.cameraController!.value.previewSize!.width,
                              child: Stack(
                                children: [
                                  Transform(
                                    alignment: Alignment.center,
                                    transform: (arState.cameraController!
                                                .description.lensDirection ==
                                            CameraLensDirection.front
                                        ? (Matrix4.identity()..scale(-1.0, 1.0))
                                        : Matrix4.identity()),
                                    child: CameraPreviewWidget(
                                      cameraController:
                                          arState.cameraController!,
                                      showCircleOverlay: false,
                                    ),
                                  ),
                                  ...arState.faces.map((face) {
                                    final leftEye = face.landmarks[FaceLandmarkType.leftEye];
                                    final rightEye = face.landmarks[FaceLandmarkType.rightEye];

                                    if (leftEye != null &&
                                        rightEye != null &&
                                        arState.kacamataAssets.isNotEmpty) {
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
                                           arState.kacamataAssets[arState.selectedGlassesIndex],
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
            Positioned(
              top: screenSize.height * 0.8,
              left: 0,
              right: 0,
              child: Container(
                height: screenSize.height * 0.3,
                color: Colors.white,
              ),
            ),
            Positioned(
            
                top: screenSize.height * 0.8 - 60,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: arState.isLoading
                      ? Center()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 120,
                              child: Swiper(
                                controller: _swiperController, // Menggunakan controller yang sudah didefinisikan
                                index: arState.selectedGlassesIndex,
                                itemCount:arState.kacamataAssets.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        arState.kacamataAssets[index],
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          print('Error loading image: $error');
                                          return Text('Error loading image');
                                        },
                                      ),
                                    ),
                                  );
                                },
                                viewportFraction: 0.4,
                                scale: 0.85,
                                loop: false,
                                onIndexChanged: (index) {
                                  arNotifier.updateSelectedGlassesIndex(index);
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
                  icon: const Icon(Icons.close, size: 24, color: Colors.black), // Ikon silang
                  onPressed: () {
                    arNotifier.resetState();
                    Navigator.pop(context); // Menutup halaman
                  },
                  tooltip: 'Tutup',
                ),
              ),
            ),
          ],
        ),
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}
