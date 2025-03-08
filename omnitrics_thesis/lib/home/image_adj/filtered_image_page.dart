import 'dart:io';
import 'dart:typed_data';
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
  File? _filteredImage;

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

  /// Let the user select an image from the gallery.
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _originalImage = File(pickedFile.path);
        _filteredImage = null; // Reset any previous filtered image.
      });
    }
  }

  /// Applies a local filter using the given color matrix.
  Future<void> _applyLocalFilter(List<double> matrix) async {
    if (_originalImage == null) return;
    setState(() {
      _filteredImage = null; // Clear previous filtered image.
    });
    try {
      // Read and decode the image.
      final bytes = await _originalImage!.readAsBytes();
      img.Image? decoded = img.decodeImage(bytes);
      if (decoded == null) return;

      // Apply the color matrix.
      decoded = _applyColorMatrix(decoded, matrix);

      // Encode the filtered image as PNG.
      final filteredBytes = img.encodePng(decoded);

      // Save the result to a temporary file with a unique name.
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final file = File('$tempPath/filtered_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(filteredBytes);

      // Update UI with the new filtered image.
      setState(() {
        _filteredImage = file;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Blindness Filters'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: _originalImage == null
            ? const Text('Please select an image from the gallery...')
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Display the filtered image if available; otherwise, display the original.
                    _filteredImage != null
                        ? Image.file(_filteredImage!)
                        : Image.file(_originalImage!),
                    const SizedBox(height: 20),
                    // Row of filter buttons for Deuteranopia, Protanopia, and Tritanopia.
                    Wrap(
                      spacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              _applyLocalFilter(_deuteranopiaMatrix),
                          child: const Text('Deuteranopia'),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              _applyLocalFilter(_protanopiaMatrix),
                          child: const Text('Protanopia'),
                        ),
                        ElevatedButton(
                          onPressed: () =>
                              _applyLocalFilter(_tritanopiaMatrix),
                          child: const Text('Tritanopia'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Button to let the user pick another image.
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Pick Another Image'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
