import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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

  // This will store the color from the center pixel.
  Color _centerColor = Colors.grey;

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
      if (_cameras == null || _cameras!.isEmpty) {
        throw Exception('No cameras found');
      }

      _controller = CameraController(
        _cameras![_selectedCameraIndex],
        ResolutionPreset.medium,
        enableAudio: false,
        // Ensure we use YUV420 for image stream processing.
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _controller!.initialize();

      // Once the controller is initialized, start the image stream.
      _controller!.startImageStream(_processCameraImage);

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
      setState(() => _isFlashOn = !_isFlashOn);
    } catch (e) {
      print('Error toggling flash: $e');
    }
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

  /// Processes each camera frame to extract the center pixel color.
  void _processCameraImage(CameraImage image) {
    // Get the center coordinates in the image
    final int centerX = image.width ~/ 2;
    final int centerY = image.height ~/ 2;
    final Color newColor = _getColorFromYUV(image, centerX, centerY);

    // Only update state if color changes to avoid excessive rebuilds.
    if (newColor != _centerColor) {
      setState(() {
        _centerColor = newColor;
      });
    }
  }

  /// Converts a YUV420 image pixel to a [Color] (RGB).
  Color _getColorFromYUV(CameraImage image, int x, int y) {
    // Get the Y, U, and V planes.
    final Plane yPlane = image.planes[0];
    final Plane uPlane = image.planes[1];
    final Plane vPlane = image.planes[2];

    // Calculate index for the Y plane.
    final int yRowStride = yPlane.bytesPerRow;
    final int yPixelStride = yPlane.bytesPerPixel ?? 1;
    final int yIndex = y * yRowStride + x * yPixelStride;
    final int Y = yPlane.bytes[yIndex];

    // U and V are subsampled by a factor of 2.
    final int uvX = x ~/ 2;
    final int uvY = y ~/ 2;

    final int uRowStride = uPlane.bytesPerRow;
    final int uPixelStride = uPlane.bytesPerPixel ?? 1;
    final int uvIndexU = uvY * uRowStride + uvX * uPixelStride;
    final int U = uPlane.bytes[uvIndexU];

    final int vRowStride = vPlane.bytesPerRow;
    final int vPixelStride = vPlane.bytesPerPixel ?? 1;
    final int uvIndexV = uvY * vRowStride + uvX * vPixelStride;
    final int V = vPlane.bytes[uvIndexV];

    // Convert YUV to RGB using standard formulas.
    double yf = Y.toDouble();
    double uf = U.toDouble();
    double vf = V.toDouble();

    int r = (1.164 * (yf - 16) + 1.596 * (vf - 128)).clamp(0, 255).toInt();
    int g = (1.164 * (yf - 16) - 0.813 * (vf - 128) - 0.391 * (uf - 128))
        .clamp(0, 255)
        .toInt();
    int b = (1.164 * (yf - 16) + 2.018 * (uf - 128)).clamp(0, 255).toInt();

    return Color.fromARGB(255, r, g, b);
  }

  /// Converts a [Color] to a hex string (e.g. "#RRGGBB").
  String _toHex(Color color) {
    return '#${(color.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  Widget _cameraPreview() {
    if (!_isCameraReady || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return CameraPreview(_controller!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview with a black bar at the bottom.
            Column(
              children: [
                Expanded(
                  flex: 6,
                  child: _cameraPreview(),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: ColoredBox(color: Colors.black),
                  ),
                ),
              ],
            ),
            // Close button in the top-left.
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                iconSize: 32,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Flash toggle & switch camera in the top-right.
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
            // Overlay: Center crosshair.
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            // Overlay: Display the RGB/HEX color code and color swatch at the top center.
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Color preview swatch
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _centerColor,
                          border: Border.all(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Display RGB and HEX values
                      Text(
                        'RGB: (${_centerColor.red}, ${_centerColor.green}, ${_centerColor.blue}) ${_toHex(_centerColor)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
