import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  XFile? _capturedImage;
  int _selectedCameraIndex = 0;
  bool _isCameraReady = false;

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

    _controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isCameraReady = true;
      });
    });
  }

  Future<void> _takePicture() async {
  if (!_controller!.value.isInitialized) return;

  final Directory appDir = await getApplicationDocumentsDirectory();
  final String fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.png';
  final String filePath = path.join(appDir.path, fileName);

  if (_controller!.value.isTakingPicture) return;

  try {
    final XFile file = await _controller!.takePicture();

   
    final File savedImage = await File(file.path).copy(filePath);
    
    await GallerySaver.saveImage(savedImage.path);
    
    setState(() {
      _capturedImage = XFile(savedImage.path);
    });
  } catch (e) {
    print('Error taking picture: $e');
  }
}


  Future<void> _switchCamera() async {
    if (_cameras!.length < 2) return;

    _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
    await _controller!.dispose();
    setState(() {
      _isCameraReady = false;
    });
    await _initializeCamera();
  }

  Widget _cameraPreview() {
    if (!_isCameraReady || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: CameraPreview(_controller!),
    );
  }

  Widget _thumbnailPreview() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipOval(
        child: _capturedImage != null
            ? Image.file(File(_capturedImage!.path), fit: BoxFit.cover)
            : Container(color: Colors.black),
      ),
    );
  }

  Widget _cameraControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: _thumbnailPreview(),
        ),
        IconButton(
          icon: const Icon(Icons.camera, size: 60, color: Colors.white),
          onPressed: _takePicture,
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: _cameraPreview(),
            ),
            Expanded(
              flex: 1,
              child: _cameraControlButtons(),
            ),
          ],
        ),
      ),
    );
  }
}