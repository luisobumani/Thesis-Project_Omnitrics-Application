import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnitrics_thesis/profile/profile_editor/Widget/prof_image_editor.dart';
import 'package:omnitrics_thesis/profile/profile_editor/Widget/profile_fillup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  // Controllers for form fields.
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

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
      final doc = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          firstNameController.text = data['firstName'] ?? "";
          lastNameController.text = data['lastName'] ?? "";
          genderController.text = data['gender'] ?? "";
          birthdayController.text = data['birthdate'] ?? "";
          emailController.text = data['email'] ?? "";
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
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "gender": genderController.text,
          "birthdate": birthdayController.text,
          // Email is not updated as it's read-only.
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
    firstNameController.dispose();
    lastNameController.dispose();
    genderController.dispose();
    birthdayController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // The profile image editor widget.
              const ProfileImageEditor(),
              // The FillUpSection widget now displays only Name, Gender, Birthday and a read-only Email.
              FillUpSection(
                firstNameController: firstNameController,
                lastNameController: lastNameController,
                genderController: genderController,
                birthdayController: birthdayController,
                emailController: emailController,
              ),
              SizedBox(height: 15.h,),
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 10.w, left: 10.w),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _saveChanges,
                        style: ButtonStyle(
                          elevation: WidgetStateProperty.all<double>(10.h),
                          backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.deepPurple.shade900;
                              }
                              return Colors.deepPurple.shade600;
                            }
                          ),
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                          ),
                          foregroundColor: WidgetStateProperty.all<Color> (
                            Colors.white,
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
      )
    );
  }
}
