import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class _ProtanopiaCameraPageState extends State<ProtanopiaCameraPage>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  XFile? _capturedImage;
  int _selectedCameraIndex = 0;
  bool _isCameraReady = false;
  bool _isFlashOn = false;
  bool _simulateProtanopia = false; 

 //Color Correction Filter Matrix
  final List<double> _correctionMatrix = [
    1, 0, 0, 0, 0,
    0, 0, 0, 0, 0,
    0, 0, 0, 0, 0,
    0, 0, 0, 1, 0 
  ];

  // Protanopia Color Filter Matrix 
  final List<double> _protanopiaMatrix = [
    0.152286, 1.052583, -0.204868, 0, 0,
    0.114503, 0.786281,  0.099216, 0, 0,
    0.004733, -0.048681, 1.043948, 0, 0,
    0,        0,         0,        1, 0,
  ];

  ColorFilter get _correctionColorFilter =>
      ColorFilter.matrix(_correctionMatrix);
  ColorFilter get _protanopiaColorFilter =>
      ColorFilter.matrix(_protanopiaMatrix);

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

  @override
  void _showWebPreview(XFile file) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.black,
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix(
          _simulateProtanopia ? _protanopiaMatrix : _correctionMatrix,
        ),
        child: Image.network(file.path),
      ),
    ),
  );
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

 
  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
    _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
    await _controller?.dispose();
    setState(() {
      _isCameraReady = false;
    });
    await _initializeCamera();
  }

  
  void _toggleSimulation() {
    setState(() {
      _simulateProtanopia = !_simulateProtanopia;
    });
  }

  Future<void> _takePicture() async {
  if (_controller == null || !_controller!.value.isInitialized) return;

  try {
    final XFile rawFile = await _controller!.takePicture();

    if (kIsWeb) {
      final bytes = await rawFile.readAsBytes();
      setState(() => _capturedImage = rawFile);
      _showFilteredPreview(_simulateProtanopia
          ? await _applyFilterToBytes(bytes)
          : bytes);
      return;
    }

    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.png';
    final File savedImage = await File(rawFile.path).copy('${appDir.path}/$fileName');
    final File filteredImage = await _applyFilterToImage(savedImage);

    await GallerySaver.saveImage(filteredImage.path);
    setState(() => _capturedImage = XFile(filteredImage.path));
  } catch (e) {
    print('[!] Error: $e');
  }
}

Future<Uint8List> _applyFilterToBytes(Uint8List bytes) async {
  final image = img.decodeImage(bytes);
  if (image == null) return bytes;
  final filtered = _applyColorMatrix(image);
  return Uint8List.fromList(img.encodePng(filtered));
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
    // Choose the matrix based on the simulation mode.
    final matrix = _simulateProtanopia ? _protanopiaMatrix : _correctionMatrix;
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
  if (_capturedImage == null) return _placeholderThumb();

  return GestureDetector(
    onTap: () {
      if (kIsWeb) {
        _showFilteredPreview(null); // No file system
      } else {
        _showFilteredPreview(File(_capturedImage!.path));
      }
    },
    child: Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.w),
      ),
      child: ClipOval(
        child: kIsWeb
            ? Image.network(_capturedImage!.path, fit: BoxFit.cover)
            : Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
      ),
    ),
  );
}

Widget _placeholderThumb() => Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.w),
        color: Colors.grey,
      ),
    );

  
  Widget _cameraControlButtons() {
    Color shutterColor = Colors.green.withOpacity(0.4);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.all(20.0.h),
          child: _thumbnailPreview(),
        ),
        Container(
          width: 70.w,
          height: 70.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: shutterColor,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: IconButton(
            icon: Icon(Icons.camera, size: 40.sp, color: Colors.white),
            onPressed: _takePicture,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0.h),
          child: IconButton(
            icon: Icon(Icons.remove_red_eye, size: 32.sp, color: Colors.white),
            onPressed: _toggleSimulation,
          ),
        ),
      ],
    );
  }

  
  void _showFilteredPreview(dynamic fileOrBytes) {
  final matrix = _simulateProtanopia ? _protanopiaMatrix : _correctionMatrix;

  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: Colors.black,
      child: kIsWeb
          ? ColorFiltered(
              colorFilter: ColorFilter.matrix(matrix),
              child: Image.memory(fileOrBytes as Uint8List),
            )
          : Image.file(fileOrBytes as File),
    ),
  );
}

  Widget _cameraPreview() {
    if (!_isCameraReady || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Only apply live filter on mobile (not web)
    if (!kIsWeb) {
      final matrix = _simulateProtanopia ? _protanopiaMatrix : _correctionMatrix;
      final filter = ColorFilter.matrix(matrix);
      return ColorFiltered(
        colorFilter: filter,
        child: CameraPreview(_controller!),
      );
    }

    return CameraPreview(_controller!);
  }

  Widget _cameraControlArea() {
    return SingleChildScrollView(
    padding: EdgeInsets.only(bottom: 44.h), // Accommodate overflow
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _cameraControlButtons(),
        SizedBox(height: 8.h),
        Text(
          _simulateProtanopia ? 'Protanopia Mode' : 'Color Correction',
          style: TextStyle(color: Colors.white, fontSize: 12.sp),
        ),
        if (kIsWeb)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              'Limited web functionality',
              style: TextStyle(color: Colors.grey, fontSize: 10.sp),
            ),
          ),
      ],
    ),
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
        
            Positioned(
              top: 16.h,
              left: 16.w,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                iconSize: 32.sp,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            
            Positioned(
              top: 16.h,
              right: 16.w,
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                      size: 32.sp,
                    ),
                    onPressed: _toggleFlash,
                  ),
                  SizedBox(height: 8.h),
                  IconButton(
                    icon: Icon(
                      Icons.switch_camera,
                      color: Colors.white,
                      size: 32.sp,
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
