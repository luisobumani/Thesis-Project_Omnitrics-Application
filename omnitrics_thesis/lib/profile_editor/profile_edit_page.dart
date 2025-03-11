import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnitrics_thesis/profile_editor/Widget/prof_image_editor.dart';
import 'package:omnitrics_thesis/profile_editor/Widget/profile_fillup.dart';

/// Returns true if the current user signed in with Google.
bool isGoogleUser(User? user) {
  if (user == null) return false;
  return user.providerData.any((provider) => provider.providerId == "google.com");
}

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  // Controllers for form fields.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool isLoading = false;
  // This flag will be false for Google users (no password fields needed).
  bool showPasswordFields = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Loads the current user's data from Firestore and populates the controllers.
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // If the user signed in with Google, we hide password fields.
      setState(() {
        showPasswordFields = !isGoogleUser(user);
      });

      final doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = data['name'] ?? "";
          genderController.text = data['gender'] ?? "";
          birthdayController.text = data['birthdate'] ?? "";
          emailController.text = data['email'] ?? "";
          // For security, we do not prefill password fields.
        });
      }
    }
  }

  /// Updates the Firestore document with new values.
  Future<void> _saveChanges() async {
    setState(() {
      isLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
          "name": nameController.text,
          "gender": genderController.text,
          "birthdate": birthdayController.text,
          "email": emailController.text,
          // Password update is handled separately.
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: $e")),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    genderController.dispose();
    birthdayController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // The profile image editor widget (unchanged).
              profileImageEditor(),
              // Pass controllers and the showPasswordFields flag.
              FillUpSection(
                nameController: nameController,
                genderController: genderController,
                birthdayController: birthdayController,
                emailController: emailController,
                currentPasswordController: currentPasswordController,
                newPasswordController: newPasswordController,
                showPasswordFields: showPasswordFields,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.purple,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
