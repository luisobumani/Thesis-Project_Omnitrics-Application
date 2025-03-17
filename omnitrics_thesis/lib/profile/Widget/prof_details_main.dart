import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfDetailsMain extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProfDetailsMain({super.key, required this.data});

  /// Retrieves the locally saved profile image path from SharedPreferences.
  Future<String?> _getProfileImagePath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('profileImagePath');
  }

  @override
  Widget build(BuildContext context) {
    // Determine the display name: use firstName + lastName if available; else fallback to name.
    final String firstName = data['firstName']?.toString() ?? "";
    final String lastName = data['lastName']?.toString() ?? "";
    final String displayName = (firstName.isNotEmpty && lastName.isNotEmpty)
        ? "$firstName $lastName"
        : data['name']?.toString() ?? "No Name";

    // Static condition text.
    const String condition = "Deuteranopia";

    return Container(
      margin: const EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.center,
        child: Row(
          children: [
            // Left side: display text details.
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    condition,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Right side: display profile image.
            Container(
              margin: const EdgeInsets.only(top: 30, left: 20),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: FutureBuilder<String?>(
                future: _getProfileImagePath(),
                builder: (context, snapshot) {
                  // While waiting, show a loading indicator.
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // If a valid image path is available, display the image.
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.isNotEmpty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(snapshot.data!),
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  // Otherwise, display the default SVG.
                  return SvgPicture.asset('assets/icons/profile.svg');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
