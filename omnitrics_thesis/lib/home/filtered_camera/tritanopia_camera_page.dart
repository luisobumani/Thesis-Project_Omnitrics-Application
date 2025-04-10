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

class _TritanopiaCameraPageState extends State<TritanopiaCameraPage>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  XFile? _capturedImage;
  int _selectedCameraIndex = 0;
  bool _isCameraReady = false;
  bool _isFlashOn = false;
  bool _simulateTritanopia = false;

  // Correction Filter Matrix
  final List<double> _correctionMatrix = [
    1, 0, 0, 0, 0,
    0, 0, 0, 0, 0,
    0, 0, 0, 0, 0,
    0, 0, 0, 1, 0 
  ];

  // Tritanopia Color Filter Matrix
  final List<double> _tritanopiaMatrix = [
    1.01354,  0.0,     -0.01353, 0, 0,
    0.0,      0.73348,  0.26652,  0, 0,
    0.0,      0.18377,  0.81623,  0, 0,
    0,        0,        0,        1, 0,
  ];

  ColorFilter get _correctionColorFilter =>
      ColorFilter.matrix(_correctionMatrix);
  ColorFilter get _tritanopiaColorFilter =>
      ColorFilter.matrix(_tritanopiaMatrix);

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
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
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
      await _controller!
          .setFlashMode(_isFlashOn ? FlashMode.off : FlashMode.torch);
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      print('Error toggling flash: $e');
    }
  }

  // Switch between available cameras.
  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
    await _controller?.dispose();
    setState(() {
      _isCameraReady = false;
    });
    await _initializeCamera();
  }

  // Toggle simulation mode for tritanopia.
  void _toggleSimulation() {
    setState(() {
      _simulateTritanopia = !_simulateTritanopia;
    });
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized ||
        _controller!.value.isTakingPicture) return;
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName =
        'photo_${DateTime.now().millisecondsSinceEpoch}.png';
    final String filePath = path.join(appDir.path, fileName);
    try {
      final XFile rawFile = await _controller!.takePicture();
      final File savedImage = await File(rawFile.path).copy(filePath);
      // Apply the currently active filter when saving the image.
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
      final String newPath =
          imageFile.path.replaceAll('.png', '_filtered.png');
      final File newFile = File(newPath)..writeAsBytesSync(filteredBytes);
      return newFile;
    } catch (e) {
      print('Error applying filter: $e');
      return imageFile;
    }
  }

  img.Image _applyColorMatrix(img.Image src) {
    // Choose the matrix based on simulation mode.
    final matrix = _simulateTritanopia ? _tritanopiaMatrix : _correctionMatrix;
    final w = src.width;
    final h = src.height;
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        // Get the pixel as a Pixel object.
        var pixel = src.getPixel(x, y);
        int a = pixel.a.toInt();
        int r = pixel.r.toInt();
        int g = pixel.g.toInt();
        int b = pixel.b.toInt();

        double nr = (r * matrix[0] + g * matrix[1] + b * matrix[2]);
        double ng = (r * matrix[5] + g * matrix[6] + b * matrix[7]);
        double nb = (r * matrix[10] + g * matrix[11] + b * matrix[12]);

        int fr = nr.round().clamp(0, 255).toInt();
        int fg = ng.round().clamp(0, 255).toInt();
        int fb = nb.round().clamp(0, 255).toInt();

        src.setPixelRgba(x, y, fr, fg, fb, a);
      }
    }
    return src;
  }

  Widget _thumbnailPreview() {
    return GestureDetector(
      onTap: () async {
        if (_capturedImage != null &&
            File(_capturedImage!.path).existsSync()) {
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
          child: _capturedImage != null &&
                  File(_capturedImage!.path).existsSync()
              ? Image.file(File(_capturedImage!.path), fit: BoxFit.cover)
              : Container(color: Colors.black),
        ),
      ),
    );
  }

  // Bottom control row: thumbnail preview (left), capture button (center), and eye icon (right) to toggle simulation.
  Widget _cameraControlButtons() {
    Color shutterColor = Colors.green.withOpacity(0.4);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: _thumbnailPreview(),
        ),
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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: IconButton(
            icon:
                const Icon(Icons.remove_red_eye, size: 32, color: Colors.white),
            onPressed: _toggleSimulation,
          ),
        ),
      ],
    );
  }

  
  Widget _cameraPreview() {
    if (!_isCameraReady || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final filter = _simulateTritanopia ? _tritanopiaColorFilter : _correctionColorFilter;
    return ColorFiltered(
      colorFilter: filter,
      child: CameraPreview(_controller!),
    );
  }

  Widget _cameraControlArea() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _cameraControlButtons(),
        const SizedBox(height: 8),
        Text(
          _simulateTritanopia
              ? 'Tritanopia Simulation Active'
              : 'Correction Filter Active',
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
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
                  child: _cameraPreview(),
                ),
                Expanded(
                  flex: 1,
                  child: _cameraControlArea(),
                ),
              ],
            ),
            // Top-left: Back button.
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                iconSize: 32,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Top-right: Flash toggle on top, then switch camera button.
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: _toggleFlash,
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(
                      Icons.switch_camera,
                      color: Colors.white,
                      size: 32,
                    ),
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
}
