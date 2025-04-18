import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnitrics_thesis/assesment/intro/intro_assessment.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/birthdate_field.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/continue_button.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/first_name_field.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/gender_selector.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/last_name_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TellMe extends StatelessWidget {
  const TellMe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Form',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const ProfileForm(),
    );
  }
}

class ProfileForm extends StatefulWidget {
  const ProfileForm({Key? key}) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  // Controllers for detailed profile fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  // For gender radio buttons
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    // Add listeners to persist data as the user types
    firstNameController.addListener(_saveData);
    lastNameController.addListener(_saveData);
    birthDateController.addListener(_saveData);
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_firstName', firstNameController.text);
    await prefs.setString('profile_lastName', lastNameController.text);
    await prefs.setString('profile_birthDate', birthDateController.text);
    await prefs.setString('profile_gender', _selectedGender ?? "");
  }

  // Load saved data (if any)
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstNameController.text = prefs.getString('profile_firstName') ?? '';
      lastNameController.text = prefs.getString('profile_lastName') ?? '';
      birthDateController.text = prefs.getString('profile_birthDate') ?? '';
      _selectedGender = prefs.getString('profile_gender');
      if (_selectedGender != null && _selectedGender!.isEmpty) {
        _selectedGender = null;
      }
    });
  }

  // Clear saved data once profile is successfully updated
  Future<void> _clearSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_firstName');
    await prefs.remove('profile_lastName');
    await prefs.remove('profile_birthDate');
    await prefs.remove('profile_gender');
  }

  // Save the profile info to Firestore
  Future<void> updateUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'birthdate': birthDateController.text,
          'gender': _selectedGender ?? "",
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Profile updated successfully!",
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        );
        // Clear the saved profile data after successful update.
        await _clearSavedData();
        // Navigate to the intro assessment screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const IntroAssessment(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error updating profile: $e",
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using a SingleChildScrollView to handle potential overflow
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Colors.deepPurple.shade700,
            Colors.deepPurple.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Center(
          child: Container(
            width: 340.w, // Responsive width
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                  spreadRadius: 4.r,
                  blurRadius: 16.r,
                  offset: Offset(0.w, 3.w),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  // First Name
                  Text(
                    'First Name',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  FirstNameField(controller: firstNameController),
                  SizedBox(height: 16.h),
                  // Last Name
                  Text(
                    'Last Name',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  LastNameField(controller: lastNameController),
                  SizedBox(height: 16.h),
                  // Birthdate
                  Text(
                    'Birthdate',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BirthdateField(controller: birthDateController),
                  SizedBox(height: 20.h),
                  // Gender radio buttons
                  Text(
                    'Sex',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GenderSelector(
                    selectedGender: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                      // Save the changed gender as well.
                      _saveData();
                    },
                  ),
                  SizedBox(height: 16.h),
                  // Continue Button
                  ContinueButton(
                    onPressed: () {
                      // Validate fields if needed and then update the profile.
                      updateUserProfile();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
