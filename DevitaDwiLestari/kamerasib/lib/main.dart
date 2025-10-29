import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const CameraApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp>
    with SingleTickerProviderStateMixin {
  late CameraController _controller;
  int _selectedCamera = 0;
  String? _imagePath;
  bool _isTakingPicture = false;
  bool _isPressed = false; // untuk efek sentuh (untuk ambil foto)
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _initializeCamera(_selectedCamera);
    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
  }

  // TUGAS: Inisialisasi kamera
  Future<void> _initializeCamera(int cameraIndex) async {
    _controller =
        CameraController(_cameras[cameraIndex], ResolutionPreset.high);
    try {
      await _controller.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  // Mengganti kamera depan/belakang
  Future<void> _switchCamera() async {
    _selectedCamera = (_selectedCamera + 1) % _cameras.length;
    await _controller.dispose();
    await _initializeCamera(_selectedCamera);
  }

  // Mengambil gambar dan simpan ke direktori lokal
  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized || _isTakingPicture) return;

    setState(() {
      _isTakingPicture = true;
      _isPressed = true;
    });

    _animController.forward().then((_) => _animController.reverse());

    final Directory dir = await getApplicationDocumentsDirectory();
    final String filePath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    try {
      final XFile picture = await _controller.takePicture();
      await picture.saveTo(filePath);

      setState(() => _imagePath = filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto disimpan di: $filePath')),
      );
    } catch (e) {
      debugPrint('Error taking picture: $e');
    } finally {
      Future.delayed(const Duration(milliseconds: 150), () {
        setState(() {
          _isTakingPicture = false;
          _isPressed = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Center(child: CameraPreview(_controller)),

            // efek flash putih saat ambil foto
            if (_isTakingPicture)
              Container(
                color: Colors.white.withOpacity(0.3),
              ),

            // UI Kamera
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Thumbnail foto terakhir (kiri)
                  GestureDetector(
                    onTap: _imagePath != null
                        ? () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                backgroundColor: Colors.black,
                                child: Image.file(File(_imagePath!)),
                              ),
                            );
                          }
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white38, width: 2),
                        image: _imagePath != null
                            ? DecorationImage(
                                image: FileImage(File(_imagePath!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _imagePath == null
                          ? const Icon(Icons.image, color: Colors.white54)
                          : null,
                    ),
                  ),

                  // Tombol ambil foto (tengah)
                  ScaleTransition(
                    scale:
                        Tween(begin: 1.0, end: 0.85).animate(_animController),
                    child: GestureDetector(
                      onTap: _takePicture,
                      onTapDown: (_) => setState(() => _isPressed = true),
                      onTapUp: (_) => setState(() => _isPressed = false),
                      onTapCancel: () => setState(() => _isPressed = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isPressed
                                ? Colors.blueAccent
                                : Colors.white,
                            width: 5,
                          ),
                        ),
                        child: Center(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _isPressed
                                  ? Colors.blueAccent
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Tombol ganti kamera (kanan)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white38, width: 2),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.cameraswitch,
                          color: Colors.white, size: 30),
                      onPressed: _switchCamera,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
