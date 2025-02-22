import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  // Removed _capturedImage since thumbnail preview is no longer needed.
  int _selectedCameraIndex = 0;
  bool _isCameraReady = false;

  // Flash toggle
  bool _isFlashOn = false;

  // -------------------------------------------------------
  // Filter Index and Matrices
  // -------------------------------------------------------
  // 0 = Protanopia, 1 = Deuteranopia, 2 = Tritanopia
  int _currentFilterIndex = 0;
  final List<String> _filterNames = ['Protanopia', 'Deuteranopia', 'Tritanopia'];

  // Assign each filter a representative color for the shutter button (not used now)
  final List<Color> _filterColors = [
    Colors.red,    // Protanopia
    Colors.green,  // Deuteranopia
    Colors.blue,   // Tritanopia
  ];

  // Original protanopia and tritanopia matrices (unchanged)
  final List<double> _protanopiaMatrix = [
    0.152286, 1.052583, -0.204868, 0, 0,
    0.114503, 0.786281,  0.099216, 0, 0,
    0.004733, -0.048681, 1.043948, 0, 0,
    0,        0,         0,        1, 0,
  ];

  final List<double> _tritanopiaMatrix = [
    1.01354,  0.0,     -0.01353, 0, 0,
    0.0,      0.73348,  0.26652, 0, 0,
    0.0,      0.18377,  0.81623, 0, 0,
    0,        0,        0,       1, 0,
  ];

  // LMS-based deuteranopia matrix.
  final List<double> _deuteranopiaMatrix = [
    0.5492,  0.6315, -0.0653,  0, 0,
    0.3866,  0.45115, 0.0562,   0, 0,
   -0.02488, 0.03491, 0.99357,  0, 0,
    0,       0,       0,        1, 0,
  ];

  // Returns the matrix for the current filter
  ColorFilter get _currentColorFilter {
    switch (_currentFilterIndex) {
      case 0:
        return ColorFilter.matrix(_protanopiaMatrix);
      case 1:
        return ColorFilter.matrix(_deuteranopiaMatrix);
      case 2:
      default:
        return ColorFilter.matrix(_tritanopiaMatrix);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _controller != null) {
      _controller!.initialize();
    }
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isEmpty) {
      throw Exception('No cameras found');
    }
    _controller = CameraController(
      _cameras![_selectedCameraIndex],
      ResolutionPreset.medium,
    );

    await _controller!.initialize();
    if (!mounted) return;
    setState(() {
      _isCameraReady = true;
    });
  }

  // Toggle flash on/off
  Future<void> _toggleFlash() async {
    if (!_isCameraReady || _controller == null) return;

    setState(() {
      _isFlashOn = !_isFlashOn;
    });

    await _controller!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  // Removed _takePicture and gallery-saving functionality.

  Future<File> _applyFilterToImage(File imageFile, int filterIndex) async {
    final bytes = await imageFile.readAsBytes();
    final decodedImage = img.decodeImage(bytes);

    if (decodedImage == null) {
      return imageFile;
    }

    List<double> matrix;
    if (filterIndex == 0) {
      matrix = _protanopiaMatrix;
    } else if (filterIndex == 1) {
      matrix = _deuteranopiaMatrix;
    } else {
      matrix = _tritanopiaMatrix;
    }

    final filtered = _applyColorMatrix(decodedImage, matrix);
    final filteredBytes = img.encodePng(filtered);
    final String newPath =
        imageFile.path.replaceAll('.png', '_filtered.png');
    final File newFile = File(newPath)..writeAsBytesSync(filteredBytes);

    return newFile;
  }

  img.Image _applyColorMatrix(img.Image src, List<double> mat) {
    final w = src.width;
    final h = src.height;

    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        int pixel = src.getPixel(x, y) as int;
        int a = (pixel >> 24) & 0xFF;
        int r = (pixel >> 16) & 0xFF;
        int g = (pixel >> 8) & 0xFF;
        int b = pixel & 0xFF;

        double nr = (r * mat[0] + g * mat[1] + b * mat[2] + a * mat[3] + mat[4]);
        double ng = (r * mat[5] + g * mat[6] + b * mat[7] + a * mat[8] + mat[9]);
        double nb = (r * mat[10] + g * mat[11] + b * mat[12] + a * mat[13] + mat[14]);
        double na = (r * mat[15] + g * mat[16] + b * mat[17] + a * mat[18] + mat[19]);

        int fr = nr.round().clamp(0, 255);
        int fg = ng.round().clamp(0, 255);
        int fb = nb.round().clamp(0, 255);
        int fa = na.round().clamp(0, 255);

        src.setPixelRgba(x, y, fr, fg, fb, fa);
      }
    }
    return src;
  }

  // Switch front/back camera
  Future<void> _switchCamera() async {
    if (_cameras!.length < 2) return;

    _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
    await _controller!.dispose();
    setState(() {
      _isCameraReady = false;
    });
    await _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Full-screen with a floating "X" in the top-left
      body: SafeArea(
        child: Stack(
          children: [
            // Main content: camera preview with filter
            GestureDetector(
              // Detect horizontal swipes to change filter
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity == null) return;
                if (details.primaryVelocity! < 0) {
                  // Swiped left => next filter
                  setState(() {
                    _currentFilterIndex = (_currentFilterIndex + 1) % 3;
                  });
                } else if (details.primaryVelocity! > 0) {
                  // Swiped right => previous filter
                  setState(() {
                    _currentFilterIndex = (_currentFilterIndex - 1 + 3) % 3;
                  });
                }
              },
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: _cameraPreviewWithFilter(),
                  ),
                  // Removed bottom control area (thumbnail & capture button)
                ],
              ),
            ),

            // "X" button in the top-left corner
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                iconSize: 32,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),

            // Flash icon and switch camera button in the top-right corner
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    ),
                    iconSize: 32,
                    onPressed: _toggleFlash,
                  ),
                  IconButton(
                    icon: const Icon(Icons.switch_camera, color: Colors.white),
                    iconSize: 32,
                    onPressed: _switchCamera,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Camera preview wrapped with the current color filter
  Widget _cameraPreviewWithFilter() {
    if (!_isCameraReady || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ColorFiltered(
      colorFilter: _currentColorFilter,
      child: CameraPreview(_controller!),
    );
  }
}
