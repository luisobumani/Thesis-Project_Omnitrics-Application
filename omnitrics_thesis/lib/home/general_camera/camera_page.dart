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
    _cameras = await availableCameras();
    if (_cameras == null || _cameras!.isEmpty) {
      throw Exception('No cameras found');
    }

    _controller = CameraController(
      _cameras![_selectedCameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
    } catch (e) {
      print('Error initializing camera: $e');
      return;
    }
    if (!mounted) return;
    setState(() {
      _isCameraReady = true;
    });
  }

  Future<void> _toggleFlash() async {
    if (!_isCameraReady || _controller == null) return;
    try {
      await _controller!.setFlashMode(_isFlashOn ? FlashMode.off : FlashMode.torch);
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
            // Camera preview (top) + black bar (bottom)
            Column(
              children: [
                Expanded(
                  flex: 6, // Increase flex to make camera preview taller
                  child: _cameraPreview(),
                ),
                const Expanded(
                  flex: 1, // Shorter black bar
                  child: SizedBox(
                    width: double.infinity,
                    child: ColoredBox(color: Colors.black),
                  ),
                ),
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
            // Flash toggle & switch camera in the top-right
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
}
