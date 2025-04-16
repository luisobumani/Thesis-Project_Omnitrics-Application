import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FilteredImagePage extends StatefulWidget {
  const FilteredImagePage({Key? key}) : super(key: key);

  @override
  _FilteredImagePageState createState() => _FilteredImagePageState();
}

class _FilteredImagePageState extends State<FilteredImagePage> {
  final ImagePicker _picker = ImagePicker();
  File? _originalImage;
  Future<File>? _filterFuture;

  // 4x5 matrices for the three filters.
  final List<double> _deuteranopiaMatrix = [
    0.625, 0.375, 0,    0, 0,  // Red output
    0.70,  0.30,  0,    0, 0,  // Green output
    0,     0,     1,    0, 0,  // Blue output
    0,     0,     0,    1, 0,  // Alpha (unused here)
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
    // Automatically open the gallery when this page is loaded.
    _pickImage();
  }

  /// Lets the user select an image from the gallery.
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _originalImage = File(pickedFile.path);
        _filterFuture = null; // Reset any previous filtering.
      });
    }
  }

  /// Applies a local filter using the given color matrix and returns a filtered image file.
  Future<File> _applyLocalFilter(List<double> matrix) async {
    if (_originalImage == null) {
      throw Exception('No image selected.');
    }

    // Read and decode the image.
    final bytes = await _originalImage!.readAsBytes();
    img.Image? decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw Exception('Failed to decode image.');
    }

    // Apply the color matrix.
    decoded = _applyColorMatrix(decoded, matrix);

    // Encode the filtered image as PNG.
    final filteredBytes = img.encodePng(decoded);

    // Save the result to a temporary file with a unique name.
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final file = File(
        '$tempPath/filtered_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(filteredBytes);
    return file;
  }

  /// Wrapper around _applyLocalFilter that ensures at least a 3-second delay.
  Future<File> _applyLocalFilterWithDelay(List<double> matrix) async {
    final startTime = DateTime.now();
    final filteredFile = await _applyLocalFilter(matrix);
    final elapsed = DateTime.now().difference(startTime);
    const delay = Duration(seconds: 3);
    if (elapsed < delay) {
      await Future.delayed(delay - elapsed);
    }
    return filteredFile;
  }

  /// Applies the given 4x5 color matrix to each pixel of the image.
  /// Uses only the first 3 rows (for red, green, blue).
  img.Image _applyColorMatrix(img.Image src, List<double> mat) {
    for (int y = 0; y < src.height; y++) {
      for (int x = 0; x < src.width; x++) {
        // Get the pixel color.
        final pixel = src.getPixel(x, y);
        num a = pixel.a;
        num r = pixel.r;
        num g = pixel.g;
        num b = pixel.b;

        // Calculate new channels.
        double newR = (r * mat[0] + g * mat[1] + b * mat[2]);
        double newG = (r * mat[5] + g * mat[6] + b * mat[7]);
        double newB = (r * mat[10] + g * mat[11] + b * mat[12]);

        src.setPixelRgba(
          x,
          y,
          newR.round().clamp(0, 255),
          newG.round().clamp(0, 255),
          newB.round().clamp(0, 255),
          a,
        );
      }
    }
    return src;
  }

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) {
          if (states.contains(WidgetState.pressed)) {
            return Colors.deepPurple.shade900;
          }
          return Colors.deepPurple.shade400;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    // If no image has been selected, display only the prompt.
    if (_originalImage == null) {
      content = const Center(
        child: Text(
          'Please select an image from the gallery...',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      // If an image is selected, show the filtering UI.
      Widget imageDisplay;
      if (_filterFuture != null) {
        imageDisplay = FutureBuilder<File>(
          future: _filterFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple.shade400),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return Image.file(snapshot.data!);
            }
            return const SizedBox();
          },
        );
      } else {
        imageDisplay = Image.file(_originalImage!);
      }

      content = SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageDisplay,
            const SizedBox(height: 20),
            // Row of filter buttons.
            Wrap(
              spacing: 10,
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
                  child: const Text(
                    'Deuteranopia',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _filterFuture =
                          _applyLocalFilterWithDelay(_protanopiaMatrix);
                    });
                  },
                  style: _buttonStyle(),
                  child: const Text(
                    'Protanopia',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _filterFuture =
                          _applyLocalFilterWithDelay(_tritanopiaMatrix);
                    });
                  },
                  style: _buttonStyle(),
                  child: const Text(
                    'Tritanopia',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Button to pick a new image.
            ElevatedButton(
              onPressed: _pickImage,
              style: _buttonStyle(),
              child: const Text(
                'Pick Another Image',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Color Blindness Filters',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.shade700,
                Colors.deepPurple.shade400,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(child: content),
    );
  }
}
