import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class ProtanopiaCameraPage extends StatefulWidget {
  const ProtanopiaCameraPage({super.key});

  @override
  _ProtanopiaCameraPageState createState() => _ProtanopiaCameraPageState();
}

class _ProtanopiaCameraPageState extends State<ProtanopiaCameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  XFile? _capturedImage;
  int _selectedCameraIndex = 0;
  bool _isCameraReady = false;
  bool _isFlashOn = false;

  // Protanopia Color Filter Matrix
  final List<double> _protanopiaMatrix = [
    0.152286, 1.052583, -0.204868, 0, 0,
    0.114503, 0.786281,  0.099216, 0, 0,
    0.004733, -0.048681, 1.043948, 0, 0,
    0,        0,         0,        1, 0,
  ];

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

  Future<void> _toggleFlash() async {
    if (!_isCameraReady || _controller == null) return;
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    await _controller!.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) return;

    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.png';
    final String filePath = path.join(appDir.path, fileName);

    if (_controller!.value.isTakingPicture) return;

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
    final bytes = await imageFile.readAsBytes();
    final decodedImage = img.decodeImage(bytes);
    if (decodedImage == null) return imageFile;

    final filtered = _applyColorMatrix(decodedImage, _protanopiaMatrix);
    final filteredBytes = img.encodePng(filtered);
    final String newPath = imageFile.path.replaceAll('.png', '_filtered.png');
    return File(newPath)..writeAsBytesSync(filteredBytes);
  }

  img.Image _applyColorMatrix(img.Image src, List<double> mat) {
    for (int y = 0; y < src.height; y++) {
      for (int x = 0; x < src.width; x++) {
        int pixel = src.getPixel(x, y) as int;
        int a = (pixel >> 24) & 0xFF;
        int r = (pixel >> 16) & 0xFF;
        int g = (pixel >> 8) & 0xFF;
        int b = pixel & 0xFF;

        double nr = (r * mat[0] + g * mat[1] + b * mat[2]);
        double ng = (r * mat[5] + g * mat[6] + b * mat[7]);
        double nb = (r * mat[10] + g * mat[11] + b * mat[12]);

        src.setPixelRgba(x, y, nr.round().clamp(0, 255), ng.round().clamp(0, 255), nb.round().clamp(0, 255), a);
      }
    }
    return src;
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
    await _controller?.dispose();
    setState(() {
      _isCameraReady = false;
    });
    _initializeCamera();
  }

  Widget _thumbnailPreview() {
    return GestureDetector(
      onTap: () async {
        if (_capturedImage != null) {
          final file = File(_capturedImage!.path);
          if (file.existsSync()) {
            await OpenFile.open(_capturedImage!.path);
          }
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
    Color shutterColor = Colors.red.withOpacity(0.4);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Thumbnail preview on the left
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: _thumbnailPreview(),
        ),
        // Capture button in the middle
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
        // Switch camera button on the right
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
          'Protanopia Mode',
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
      colorFilter: ColorFilter.matrix(_protanopiaMatrix),
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
                Expanded(flex: 5, child: _cameraPreviewWithFilter()),
                Expanded(flex: 1, child: _cameraControlArea()),
              ],
            ),
            // Close button in the top-left
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                iconSize: 32,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Flash toggle in the top-right
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
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
