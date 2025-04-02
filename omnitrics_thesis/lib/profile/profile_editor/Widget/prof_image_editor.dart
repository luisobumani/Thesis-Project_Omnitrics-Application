import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileImageEditor extends StatefulWidget {
  const ProfileImageEditor({super.key});

  @override
  State<ProfileImageEditor> createState() => _ProfileImageEditorState();
}

class _ProfileImageEditorState extends State<ProfileImageEditor> {
  final ImagePicker _picker = ImagePicker();
  File? _localImage;

  @override
  void initState() {
    super.initState();
    _loadExistingImage();
  }

  /// Loads the previously saved image file path from SharedPreferences.
  Future<void> _loadExistingImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? path = prefs.getString('profileImagePath');
    if (path != null && path.isNotEmpty) {
      setState(() {
        _localImage = File(path);
      });
      print("Loaded existing image at: $path");
    }
  }

  /// Picks an image from the gallery, saves it locally, and stores its path.
  Future<void> _pickAndSaveImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Get the app's documents directory.
      final Directory appDir = await getApplicationDocumentsDirectory();
      // Create a unique filename using timestamp.
      final String fileName = 'profile_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final File localImageFile = await File(pickedFile.path).copy('${appDir.path}/$fileName');

      // Save the file path in SharedPreferences.
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImagePath', localImageFile.path);

      setState(() {
        _localImage = localImageFile;
      });
      print("Image saved locally at: ${localImageFile.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h, bottom: 20.h),
      alignment: Alignment.center,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 65,
            backgroundImage: _localImage != null ? FileImage(_localImage!) : null,
            child: _localImage == null
                ? SvgPicture.asset('assets/icons/profile.svg')
                : null,
          ),
          Positioned(
            bottom: -10.h,
            left: 80.w,
            child: IconButton(
              onPressed: _pickAndSaveImage,
              icon: const Icon(Icons.add_a_photo),
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}
