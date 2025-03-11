import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnitrics_thesis/profile_editor/Widget/prof_image_editor.dart';
import 'package:omnitrics_thesis/profile_editor/Widget/profile_fillup.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  // Controllers for the form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Loads the current user's data from Firestore and populates the controllers.
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = data["name"] ?? "";
          genderController.text = data["gender"] ?? "";
          birthdayController.text = data["birthdate"] ?? "";
          emailController.text = data["email"] ?? "";
          // For security reasons, we do not prefill password fields.
        });
      }
    }
  }

  /// Updates the Firestore document with the new values from the form.
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
          // Password update would be handled separately via Firebase Auth.
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
      appBar: appBarProf(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile image editor remains as before.
              profileImageEditor(),
              // Pass controllers to the FillUpSection widget.
              FillUpSection(
                nameController: nameController,
                genderController: genderController,
                birthdayController: birthdayController,
                emailController: emailController,
                currentPasswordController: currentPasswordController,
                newPasswordController: newPasswordController,
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
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBarProf() {
    return AppBar(
      title: const Text(
        'Edit Profile',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }
}
