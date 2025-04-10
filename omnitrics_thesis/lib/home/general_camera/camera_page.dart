import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for Clipboard

/// Helper class to store a name and its corresponding [Color].
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

  // This stores the color from the center pixel.
  Color _centerColor = Colors.grey;

  // When true, the camera image stream is paused (captured).
  bool _isCaptured = false;

  /// Large color palette referencing your provided images.
  /// You can add or remove entries as needed.
  final List<NamedColor> _colorPalette = [
    // -- Standard Imprint Colors Example --
    NamedColor('White',         Color(0xFFFFFFFF)),
    NamedColor('Black',         Color(0xFF000000)),
    NamedColor('Red',           Color(0xFFFF0000)),
    NamedColor('Cardinal Red',  Color(0xFF8C1515)),
    NamedColor('Yellow',        Color(0xFFFFFF00)),
    NamedColor('Athletic Gold', Color(0xFFFFD700)),
    NamedColor('Orange',        Color(0xFFFFA500)),
    NamedColor('Texas Orange',  Color(0xFFBF5700)),
    NamedColor('Light Blue',    Color(0xFFADD8E6)),
    NamedColor('Contact Blue',  Color(0xFF6495ED)), // or pick your own
    NamedColor('Royal Blue',    Color(0xFF4169E1)),
    NamedColor('Navy Blue',     Color(0xFF000080)),
    NamedColor('Light Purple',  Color(0xFFBA55D3)), // or #EE82EE
    NamedColor('Purple',        Color(0xFF800080)),
    NamedColor('Light Green',   Color(0xFF90EE90)),
    NamedColor('Green',         Color(0xFF008000)),
    NamedColor('Kelly Green',   Color(0xFF4CBB17)),
    NamedColor('Forest Green',  Color(0xFF228B22)),
    NamedColor('Burgundy',      Color(0xFF800020)),
    NamedColor('Flesh',         Color(0xFFFFCBA4)), // approximate
    NamedColor('Tan',           Color(0xFFD2B48C)),
    NamedColor('Brown',         Color(0xFFA52A2A)),
    NamedColor('Pink',          Color(0xFFFFC0CB)),
    NamedColor('Magenta',       Color(0xFFFF00FF)),
    NamedColor('Light Grey',    Color(0xFFD3D3D3)),
    NamedColor('Dark Grey',     Color(0xFFA9A9A9)),
    NamedColor('Turquoise',     Color(0xFF40E0D0)),
    NamedColor('Teal',          Color(0xFF008080)),
    NamedColor('Metallic Silver', Color(0xFFC0C0C0)),
    NamedColor('Metallic Gold', Color(0xFFFFD700)),

    // -- Todoist Label Colors Example --
    NamedColor('Berry Red',     Color(0xFFB8255F)),
    NamedColor('Orange (Todoist)', Color(0xFFFF9933)),
    NamedColor('Grape',         Color(0xFF4073FF)),
    NamedColor('Yellow (Todoist)', Color(0xFFFFDD00)),
    NamedColor('Olive Green',   Color(0xFF7ECC49)),
    NamedColor('Green (Todoist)', Color(0xFF299438)),
    NamedColor('Mint Green',    Color(0xFF6ACFCC)),
    NamedColor('Teal (Todoist)', Color(0xFF158FAD)),
    NamedColor('Sky Blue',      Color(0xFF14AAF5)),
    NamedColor('Light Purple (Todoist)', Color(0xFFAF38EB)),
    NamedColor('Lavender',      Color(0xFFEB96EB)),
    NamedColor('Navy Blue (Todoist)', Color(0xFF4073FF)),
    NamedColor('Grey',          Color(0xFF808080)),
    NamedColor('Taupe',         Color(0xFFCCAC93)),
    NamedColor('Salmon',        Color(0xFFFF8D85)),
    NamedColor('Brown (Todoist)', Color(0xFF854442)),
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // Handle camera re-initialization during lifecycle changes.
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
      if (_cameras == null || _cameras!.isEmpty) {
        throw Exception('No cameras found');
      }

      _controller = CameraController(
        _cameras![_selectedCameraIndex],
        ResolutionPreset.medium,
        enableAudio: false,
        // Use YUV420 for image stream processing.
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _controller!.initialize();

      // Start the image stream only if not captured.
      if (!_isCaptured) {
        _controller!.startImageStream(_processCameraImage);
      }

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
    // Only update if not captured to avoid "freezing" a color.
    if (_isCaptured) return;

    // Middle pixel coordinates.
    final int centerX = image.width ~/ 2;
    final int centerY = image.height ~/ 2;

    final Color newColor = _getColorFromYUV(image, centerX, centerY);

    // Update the center color only if it has changed to reduce rebuilds.
    if (newColor != _centerColor) {
      setState(() {
        _centerColor = newColor;
      });
    }
  }

  /// Converts a YUV420 image pixel to an RGB [Color].
  Color _getColorFromYUV(CameraImage image, int x, int y) {
    final Plane yPlane = image.planes[0];
    final Plane uPlane = image.planes[1];
    final Plane vPlane = image.planes[2];

    final int yRowStride = yPlane.bytesPerRow;
    final int yPixelStride = yPlane.bytesPerPixel ?? 1;
    final int yIndex = y * yRowStride + x * yPixelStride;
    final int Y = yPlane.bytes[yIndex];

    // U and V subsampled by factor of 2.
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

    final double yf = Y.toDouble();
    final double uf = U.toDouble();
    final double vf = V.toDouble();

    // Standard YUV -> RGB conversion.
    final int r = (1.164 * (yf - 16) + 1.596 * (vf - 128)).clamp(0, 255).toInt();
    final int g = (1.164 * (yf - 16)
            - 0.813 * (vf - 128)
            - 0.391 * (uf - 128))
        .clamp(0, 255)
        .toInt();
    final int b = (1.164 * (yf - 16) + 2.018 * (uf - 128)).clamp(0, 255).toInt();

    return Color.fromARGB(255, r, g, b);
  }

  /// Converts a [Color] to a HEX string, e.g. "#RRGGBB".
  String _toHex(Color color) {
    return '#${(color.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  /// Euclidean distance between two RGB colors.
  double _colorDistance(Color a, Color b) {
    return pow(a.red - b.red, 2) +
        pow(a.green - b.green, 2) +
        pow(a.blue - b.blue, 2).toDouble();
  }

  /// Finds the closest color name in [_colorPalette] to the given [color].
  String getColorName(Color color) {
    double minDistance = double.infinity;
    String closestName = 'Unknown';

    for (final namedColor in _colorPalette) {
      final double distance = _colorDistance(color, namedColor.color);
      if (distance < minDistance) {
        minDistance = distance;
        closestName = namedColor.name;
      }
    }

    return closestName;
  }

  /// Determines if a color is considered "dark" (for text color choice).
  bool isDarkColor(Color color) {
    final double brightness =
        0.299 * color.red + 0.587 * color.green + 0.114 * color.blue;
    return brightness < 128;
  }

  Widget _cameraPreview() {
    if (!_isCameraReady || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return CameraPreview(_controller!);
  }

  /// Captures (pauses) the color detection.
  Future<void> _captureImage() async {
    if (_controller != null && _controller!.value.isStreamingImages) {
      await _controller!.stopImageStream();
    }
    setState(() {
      _isCaptured = true;
    });
  }

  /// Resumes the camera image stream (un-pauses).
  Future<void> _resumeCamera() async {
    if (_controller != null && !_controller!.value.isStreamingImages) {
      await _controller!.startImageStream(_processCameraImage);
    }
    setState(() {
      _isCaptured = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String colorHex = _toHex(_centerColor);
    final String colorName = getColorName(_centerColor);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Main layout: camera preview (top) + bottom color bar
            Column(
              children: [
                Expanded(
                  flex: 6,
                  child: _cameraPreview(),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    color: _centerColor, // The bar takes on the color we detect.
                    child: GestureDetector(
                      onTap: () {
                        // Copy hex code only if we are in "captured" state.
                        if (_isCaptured) {
                          Clipboard.setData(ClipboardData(text: colorHex));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Hex code $colorHex copied!'),
                            ),
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          // Shows RGB, hex, and name of closest match
                          'RGB: (${_centerColor.red}, ${_centerColor.green}, ${_centerColor.blue})  '
                          '$colorHex  $colorName',
                          style: TextStyle(
                            color:
                                isDarkColor(_centerColor) ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Close (exit) button in top-left
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                iconSize: 32,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            // Flash toggle & camera switch in the top-right
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

            // Crosshair in the center
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

            // Capture/Resume button at the bottom center
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton(
                  onPressed: _isCaptured ? _resumeCamera : _captureImage,
                  child: Icon(
                    _isCaptured ? Icons.arrow_back : Icons.camera_alt,
                    size: 32,
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
