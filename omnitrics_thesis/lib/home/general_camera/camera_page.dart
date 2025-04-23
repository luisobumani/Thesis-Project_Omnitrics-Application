import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NamedColor {
  final String name;
  final Color color;
  NamedColor(this.name, this.color);
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraReady = false;
  bool _isFlashOn = false;
  int _selectedCameraIndex = 0;

  Color _centerColor = Colors.grey;
  bool _isCaptured = false;
  XFile? _capturedPhoto;
  Size? _previewSize;

  final List<NamedColor> _colorPalette = [
    NamedColor('White', Color(0xFFFFFFFF)),
    NamedColor('Black', Color(0xFF000000)),
    NamedColor('Light Red', Color(0xFFFF6666)),
    NamedColor('Red', Color(0xFFFF0000)),
    NamedColor('Dark Red', Color(0xFF8B0000)),
    NamedColor('Light Orange', Color(0xFFFFB84D)),
    NamedColor('Orange', Color(0xFFFFA500)),
    NamedColor('Dark Orange', Color(0xFFCC5500)),
    NamedColor('Light Yellow', Color(0xFFFFFF99)),
    NamedColor('Yellow', Color(0xFFFFFF00)),
    NamedColor('Dark Yellow', Color(0xFFCCCC00)),
    NamedColor('Light Green', Color(0xFF90EE90)),
    NamedColor('Green', Color(0xFF008000)),
    NamedColor('Dark Green', Color(0xFF006400)),
    NamedColor('Light Blue', Color(0xFFADD8E6)),
    NamedColor('Blue', Color(0xFF0000FF)),
    NamedColor('Dark Blue', Color(0xFF00008B)),
    NamedColor('Light Purple', Color(0xFFB19CD9)),
    NamedColor('Purple', Color(0xFF800080)),
    NamedColor('Dark Purple', Color(0xFF4B0082)),
    NamedColor('Light Brown', Color(0xFFD2B48C)),
    NamedColor('Brown', Color(0xFFA52A2A)),
    NamedColor('Dark Brown', Color(0xFF654321)),
    NamedColor('Light Pink', Color(0xFFFFB6C1)),
    NamedColor('Pink', Color(0xFFFF69B4)),
    NamedColor('Dark Pink', Color(0xFFCC3366)),
    NamedColor('Light Grey', Color(0xFFD3D3D3)),
    NamedColor('Grey', Color(0xFF808080)),
    NamedColor('Dark Grey', Color(0xFF404040)),
    NamedColor('Light Cyan', Color(0xFFE0FFFF)),
    NamedColor('Cyan', Color(0xFF00FFFF)),
    NamedColor('Dark Cyan', Color(0xFF008B8B)),
    NamedColor('Gold', Color(0xFFFFD700)),
    NamedColor('Silver', Color(0xFFC0C0C0)),
  ];

  get _switchCamera => null;

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
    if (_controller == null) return;
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      await _controller!.dispose();
      setState(() => _isCameraReady = false);
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) throw Exception('No cameras found');

      _controller = CameraController(
        _cameras![_selectedCameraIndex],
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await _controller!.initialize();
      _previewSize = _controller!.value.previewSize;
      await _controller!.startImageStream(_processCameraImage);

      if (!mounted) return;
      setState(() => _isCameraReady = true);
    } catch (e) {
      print('Camera init error: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (!_isCameraReady || _controller == null) return;
    try {
      await _controller!.setFlashMode(_isFlashOn ? FlashMode.off : FlashMode.torch);
      setState(() => _isFlashOn = !_isFlashOn);
    } catch (e) {
      print('Flash toggle error: $e');
    }
  }

  void _processCameraImage(CameraImage image) {
    if (_isCaptured || _previewSize == null) return;

    final Color c = _averageColor(image);
    if (c != _centerColor) setState(() => _centerColor = c);
  }

  Color _averageColor(CameraImage img) {
    int sumR = 0, sumG = 0, sumB = 0, count = 0;
    int cx = img.width ~/ 2;
    int cy = img.height ~/ 2;

    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        Color c = _getColorFromYUV(img, cx + dx, cy + dy);
        sumR += c.red;
        sumG += c.green;
        sumB += c.blue;
        count++;
      }
    }

    return Color.fromARGB(255, (sumR ~/ count), (sumG ~/ count), (sumB ~/ count));
  }

  Color _getColorFromYUV(CameraImage img, int x, int y) {
    final Plane yP = img.planes[0], uP = img.planes[1], vP = img.planes[2];
    final int Y = yP.bytes[y * yP.bytesPerRow + x];
    final int uvX = x ~/ 2, uvY = y ~/ 2;
    final int U = uP.bytes[uvY * uP.bytesPerRow + uvX];
    final int V = vP.bytes[uvY * vP.bytesPerRow + uvX];

    final double yf = Y.toDouble(), uf = U.toDouble(), vf = V.toDouble();
    final int r = (1.164 * (yf - 16) + 1.596 * (vf - 128)).clamp(0, 255).toInt();
    final int g = (1.164 * (yf - 16) - 0.813 * (vf - 128) - 0.391 * (uf - 128)).clamp(0, 255).toInt();
    final int b = (1.164 * (yf - 16) + 2.018 * (uf - 128)).clamp(0, 255).toInt();

    return Color.fromARGB(255, r, g, b);
  }

  String _toHex(Color c) =>
      '#${(c.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  double _colorDistance(Color a, Color b) =>
      sqrt(pow(a.red - b.red, 2) + pow(a.green - b.green, 2) + pow(a.blue - b.blue, 2));

  String getColorName(Color c) {
    double bestDistance = double.infinity;
    String bestName = 'Unknown';

    final int r = c.red;
    final int g = c.green;
    final int b = c.blue;
    final int maxVal = [r, g, b].reduce(max);
    final int minVal = [r, g, b].reduce(min);
    final int chroma = maxVal - minVal;

    final bool excludeGreys = chroma > 25;

    for (var p in _colorPalette) {
      if (excludeGreys && p.name.toLowerCase().contains("grey")) continue;

      final double d = _colorDistance(c, p.color);
      if (d < bestDistance) {
        bestDistance = d;
        bestName = p.name;
      }
    }

    return bestName;
  }

  bool isDark(Color c) =>
      (0.299 * c.red + 0.587 * c.green + 0.114 * c.blue) < 128;

  Future<void> _onToggleCapture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (!_isCaptured) {
      await _controller!.stopImageStream();
      _capturedPhoto = await _controller!.takePicture();
    } else {
      _capturedPhoto = null;
      await _controller!.startImageStream(_processCameraImage);
    }

    setState(() => _isCaptured = !_isCaptured);
  }

  Widget _cameraPreview() {
    if (!_isCameraReady || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_capturedPhoto != null) {
      return Image.file(File(_capturedPhoto!.path), fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    }
    return CameraPreview(_controller!);
  }

  @override
  Widget build(BuildContext context) {
    final String hex = _toHex(_centerColor);
    final String name = getColorName(_centerColor);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(child: _cameraPreview()),

            // Red Center Dot
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // Crosshair Lines
            Positioned.fill(
              child: Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    children: [
                      Positioned(top: 0, left: 49, right: 49, child: Container(height: 40, width: 1.5, color: Colors.black)),
                      Positioned(bottom: 0, left: 49, right: 49, child: Container(height: 40, width: 1.5, color: Colors.black)),
                      Positioned(left: 0, top: 49, bottom: 49, child: Container(width: 40, height: 1.5, color: Colors.black)),
                      Positioned(right: 0, top: 49, bottom: 49, child: Container(width: 40, height: 1.5, color: Colors.black)),
                    ],
                  ),
                ),
              ),
            ),

            // Color Info Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  if (_isCaptured) {
                    Clipboard.setData(ClipboardData(text: hex));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Copied $hex')),
                    );
                  }
                },
                child: Container(
                  height: 60,
                  color: _centerColor,
                  alignment: Alignment.center,
                  child: Text(
                    'RGB: (${_centerColor.red}, ${_centerColor.green}, ${_centerColor.blue})   $hex   $name',
                    style: TextStyle(
                      color: isDark(_centerColor) ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // Capture/Unfreeze Button
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton(
                  onPressed: _onToggleCapture,
                  child: Icon(
                    _isCaptured ? Icons.arrow_back : Icons.camera_alt,
                    size: 32,
                  ),
                ),
              ),
            ),

            // Close Button
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                iconSize: 32,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            // Flash and Camera Flip
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
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
}