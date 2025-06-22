import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

class FilteredImagePage extends StatefulWidget {
  const FilteredImagePage({Key? key}) : super(key: key);

  @override
  _FilteredImagePageState createState() => _FilteredImagePageState();
}

class _FilteredImagePageState extends State<FilteredImagePage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _originalImageBytes;
  Future<Uint8List>? _filterFuture;

  final List<double> _deuteranopiaMatrix = [
    0.625, 0.375, 0, 0, 0,
    0.7,   0.3,   0, 0, 0,
    0,     0,     1, 0, 0,
    0,     0,     0, 1, 0,
  ];

  final List<double> _protanopiaMatrix = [
    0.152286, 1.052583, -0.204868, 0, 0,
    0.114503, 0.786281,  0.099216, 0, 0,
    0.004733, -0.048681, 1.043948, 0, 0,
    0,        0,         0,        1, 0,
  ];

  final List<double> _tritanopiaMatrix = [
    0.95,  0.05,   0,     0, 0,
    0,     0.433,  0.567, 0, 0,
    0,     0.475,  0.525, 0, 0,
    0,     0,      0,     1, 0,
  ];

  @override
  void initState() {
    super.initState();
    _pickImage();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _originalImageBytes = bytes;
        _filterFuture = null;
      });
    }
  }

  Future<Uint8List> _applyLocalFilterWithDelay(List<double> matrix) async {
    final startTime = DateTime.now();
    final result = await _applyLocalFilter(matrix);
    final elapsed = DateTime.now().difference(startTime);
    const delay = Duration(seconds: 3);
    if (elapsed < delay) {
      await Future.delayed(delay - elapsed);
    }
    return result;
  }

  Future<Uint8List> _applyLocalFilter(List<double> matrix) async {
    if (_originalImageBytes == null) {
      throw Exception('No image selected.');
    }

    final decoded = img.decodeImage(_originalImageBytes!);
    if (decoded == null) throw Exception('Image decoding failed.');

    final filtered = _applyColorMatrix(decoded, matrix);
    return Uint8List.fromList(img.encodePng(filtered));
  }

  img.Image _applyColorMatrix(img.Image src, List<double> mat) {
    for (int y = 0; y < src.height; y++) {
      for (int x = 0; x < src.width; x++) {
        final pixel = src.getPixel(x, y);
        final a = pixel.a, r = pixel.r, g = pixel.g, b = pixel.b;

        final nr = (r * mat[0] + g * mat[1] + b * mat[2]).round().clamp(0, 255);
        final ng = (r * mat[5] + g * mat[6] + b * mat[7]).round().clamp(0, 255);
        final nb = (r * mat[10] + g * mat[11] + b * mat[12]).round().clamp(0, 255);

        src.setPixelRgba(x, y, nr, ng, nb, a);
      }
    }
    return src;
  }

  ButtonStyle _buttonStyle() => ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple.shade400,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      );

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_originalImageBytes == null) {
      content = const Center(
        child: Text(
          'Please select an image from the gallery...',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      Widget imageDisplay;
      if (_filterFuture != null) {
        imageDisplay = FutureBuilder<Uint8List>(
          future: _filterFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Image.memory(snapshot.data!);
            }
            return const SizedBox();
          },
        );
      } else {
        imageDisplay = Image.memory(_originalImageBytes!);
      }

      content = SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageDisplay,
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _filterFuture =
                          _applyLocalFilterWithDelay(_deuteranopiaMatrix);
                    });
                  },
                  style: _buttonStyle(),
                  child: const Text('Deuteranopia'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _filterFuture =
                          _applyLocalFilterWithDelay(_protanopiaMatrix);
                    });
                  },
                  style: _buttonStyle(),
                  child: const Text('Protanopia'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _filterFuture =
                          _applyLocalFilterWithDelay(_tritanopiaMatrix);
                    });
                  },
                  style: _buttonStyle(),
                  child: const Text('Tritanopia'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              style: _buttonStyle(),
              child: const Text('Pick Another Image'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Color Blindness Filters',
        style: TextStyle(
          color: Colors.white
        ),),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: content,
    );
  }
}
