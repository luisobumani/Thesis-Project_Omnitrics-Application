import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class TritanopiaCameraPage extends StatefulWidget {
  const TritanopiaCameraPage({super.key});

  @override
  _TritanopiaCameraPageState createState() => _TritanopiaCameraPageState();
}

class _TritanopiaCameraPageState extends State<TritanopiaCameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  XFile? _capturedImage;
  int _selectedCameraIndex = 0;
  bool _isCameraReady = false;
  bool _isFlashOn = false;

  final List<double> _tritanopiaMatrix = [
    1.01354,  0.0,     -0.01353, 0, 0,
    0.0,      0.73348,  0.26652, 0, 0,
    0.0,      0.18377,  0.81623, 0, 0,
    0,        0,        0,       1, 0,
  ];

  ColorFilter get _currentColorFilter => ColorFilter.matrix(_tritanopiaMatrix);

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
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      await _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isEmpty) throw Exception('No cameras found');

      _controller = CameraController(
        _cameras![_selectedCameraIndex],
        ResolutionPreset.medium,
      );

      await _controller!.initialize();
      if (!mounted) return;
      setState(() {
        _isCameraReady = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (!_isCameraReady || _controller == null) return;
    try {
      await _controller!.setFlashMode(_isFlashOn ? FlashMode.off : FlashMode.torch);
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      print('Error toggling flash: $e');
    }
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized || _controller!.value.isTakingPicture) return;

    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.png';
    final String filePath = path.join(appDir.path, fileName);

    try {
      final XFile rawFile = await _controller!.takePicture();
      final File savedImage = await File(rawFile.path).copy(filePath);
      final File filteredFile = await _applyFilterToImage(savedImage);
      await GallerySaver.saveImage(filteredFile.path);
      setState(() {
        _capturedImage = XFile(filteredFile.path);
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<File> _applyFilterToImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final decodedImage = img.decodeImage(bytes);
      if (decodedImage == null) return imageFile;

      final filtered = _applyColorMatrix(decodedImage);
      final filteredBytes = img.encodePng(filtered);
      final String newPath = imageFile.path.replaceAll('.png', '_filtered.png');
      final File newFile = File(newPath)..writeAsBytesSync(filteredBytes);
      return newFile;
    } catch (e) {
      print('Error applying filter: $e');
      return imageFile;
    }
  }

   img.Image _applyColorMatrix(img.Image src) {
    final w = src.width;
    final h = src.height;

    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        int pixel = src.getPixel(x, y) as int;
        int a = (pixel >> 24) & 0xFF;
        int r = (pixel >> 16) & 0xFF;
        int g = (pixel >> 8) & 0xFF;
        int b = pixel & 0xFF;

        double nr = (r * _tritanopiaMatrix[0] + g * _tritanopiaMatrix[1] + b * _tritanopiaMatrix[2]);
        double ng = (r * _tritanopiaMatrix[5] + g * _tritanopiaMatrix[6] + b * _tritanopiaMatrix[7]);
        double nb = (r * _tritanopiaMatrix[10] + g * _tritanopiaMatrix[11] + b * _tritanopiaMatrix[12]);

        int fr = nr.round().clamp(0, 255);
        int fg = ng.round().clamp(0, 255);
        int fb = nb.round().clamp(0, 255);

        src.setPixelRgba(x, y, fr, fg, fb, a);
      }
    }
    return src;
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
    await _controller!.dispose();
    setState(() {
      _isCameraReady = false;
    });
    await _initializeCamera();
  }

  Widget _thumbnailPreview() {
    return GestureDetector(
      onTap: () async {
        if (_capturedImage != null && File(_capturedImage!.path).existsSync()) {
          await OpenFile.open(_capturedImage!.path);
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: ClipOval(
          child: _capturedImage != null && File(_capturedImage!.path).existsSync()
              ? Image.file(File(_capturedImage!.path), fit: BoxFit.cover)
              : Container(color: Colors.black),
        ),
      ),
    );
  }

  Widget _cameraControlButtons() {
    // Shutter button tinted in green to indicate deuteranopia filter.
    Color shutterColor = Colors.green.withOpacity(0.4);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Thumbnail preview on the left.
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: _thumbnailPreview(),
        ),
        // Shutter button in the middle.
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: shutterColor,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: IconButton(
            icon: const Icon(Icons.camera, size: 40, color: Colors.white),
            onPressed: _takePicture,
          ),
        ),
        // Switch camera button on the right.
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: IconButton(
            icon: const Icon(Icons.switch_camera, size: 40, color: Colors.white),
            onPressed: _switchCamera,
          ),
        ),
      ],
    );
  }

  Widget _cameraControlArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _cameraControlButtons(),
        const SizedBox(height: 8),
        const Text(
          'Tritanopia Mode',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _cameraPreviewWithFilter() {
    if (!_isCameraReady || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ColorFiltered(
      colorFilter: _currentColorFilter,
      child: CameraPreview(_controller!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 5,
                  child: _cameraPreviewWithFilter(),
                ),
                Expanded(
                  flex: 1,
                  child: _cameraControlArea(),
                ),
              ],
            ),
            // Back button ("X") in the top-left corner.
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                iconSize: 32,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Flash toggle in the top-right corner.
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: Icon(
                  _isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: Colors.white,
                ),
                iconSize: 32,
                onPressed: _toggleFlash,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
