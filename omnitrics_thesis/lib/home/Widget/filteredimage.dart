import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  // Change this to your actual server IP or 10.0.2.2 for Android emulator
  final String _serverUrl = 'http://10.0.2.2:5000/apply_filter';

  @override
  void initState() {
    super.initState();
    // Automatically open the gallery when this page is loaded
    _pickImage();
  }

  /// 1) Let the user select an image from the gallery
  /// 2) Display that image as the "original"
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _originalImage = File(pickedFile.path);
        _filteredImage = null; // Reset any previous filtered image
      });
    }
  }

  /// Apply a chosen color-blindness filter by sending a POST request
  /// to your Python/Flask backend
  Future<void> _applyFilter(String filterType) async {
    if (_originalImage == null) return;

    try {
      // Prepare multipart request
      var request = http.MultipartRequest('POST', Uri.parse(_serverUrl))
        ..fields['filter'] = filterType
        ..files.add(await http.MultipartFile.fromPath('image', _originalImage!.path));

      // Send request
      var response = await request.send();

      if (response.statusCode == 200) {
        // Read the processed image bytes
        Uint8List bytes = await response.stream.toBytes();

        // Save it to a temporary file
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File file = File('$tempPath/filtered_$filterType.png');
        await file.writeAsBytes(bytes);

        // Update UI
        setState(() {
          _filteredImage = file;
        });
      } else {
        // Error handling
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exception: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no image is selected yet, just show a text
    // Once user picks from the gallery, show the original + filter buttons
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Blindness Filter'),
      ),
      body: Center(
        child: _originalImage == null
            ? const Text('Please select an image from the gallery...')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display either the original or the filtered image
                  _filteredImage == null
                      ? Image.file(_originalImage!)
                      : Image.file(_filteredImage!),

                  const SizedBox(height: 20),

                  // Row of filter buttons: Deuteranopia, Protanopia, Tritanopia
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _applyFilter('deuteranopia'),
                        child: const Text('Deuteranopia'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _applyFilter('protanopia'),
                        child: const Text('Protanopia'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _applyFilter('tritanopia'),
                        child: const Text('Tritanopia'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // A button to let user pick a new image if desired
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Another Image'),
                  ),
                ],
              ),
      ),
    );
  }
}
