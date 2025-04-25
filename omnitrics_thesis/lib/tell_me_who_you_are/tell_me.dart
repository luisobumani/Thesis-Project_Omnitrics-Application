import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:omnitrics_thesis/assesment/intro/intro_assessment.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/first_name_field.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/last_name_field.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/birthdate_field.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/gender_selector.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/continue_button.dart';

class TellMe extends StatelessWidget {
  const TellMe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile Form',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
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
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController  = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    firstNameController.addListener(_saveData);
    lastNameController.addListener(_saveData);
    birthDateController.addListener(_saveData);
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_firstName', firstNameController.text);
    await prefs.setString('profile_lastName', lastNameController.text);
    await prefs.setString('profile_birthDate', birthDateController.text);
    await prefs.setString('profile_gender', _selectedGender ?? '');
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstNameController.text = prefs.getString('profile_firstName') ?? '';
      lastNameController.text  = prefs.getString('profile_lastName')  ?? '';
      birthDateController.text = prefs.getString('profile_birthDate') ?? '';
      _selectedGender = prefs.getString('profile_gender');
      if (_selectedGender != null && _selectedGender!.isEmpty) {
        _selectedGender = null;
      }
    });
  }

  Future<void> _clearSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_firstName');
    await prefs.remove('profile_lastName');
    await prefs.remove('profile_birthDate');
    await prefs.remove('profile_gender');
  }

  Future<void> updateUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'birthdate': birthDateController.text,
        'gender': _selectedGender ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profile updated successfully!',
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      );

      await _clearSavedData();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const IntroAssessment()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error updating profile: $e',
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
      );
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
          ),
        ),
        child: Center(
          child: Container(
            width: 340.w,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  spreadRadius: 4.r,
                  blurRadius: 16.r,
                  offset: Offset(0, 3.w),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
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
                    FirstNameField(
                      controller: firstNameController,
                      validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? 'First name is required'
                              : null,
                    ),
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
                    LastNameField(
                      controller: lastNameController,
                      validator: (v) =>
                          v == null || v.trim().isEmpty
                              ? 'Last name is required'
                              : null,
                    ),
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
                    BirthdateField(
                      controller: birthDateController,
                      validator: (v) =>
                          v == null || v.isEmpty
                              ? 'Birthdate is required'
                              : null,
                    ),
                    SizedBox(height: 20.h),

                    // Gender
                    Text(
                      'Sex',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GenderSelector(
                      initialValue: _selectedGender,
                      validator: (v) =>
                          v == null ? 'Please select sex' : null,
                      onChanged: (v) {
                        setState(() => _selectedGender = v);
                        _saveData();
                      },
                    ),
                    SizedBox(height: 24.h),

                    // Continue Button
                    ContinueButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateUserProfile();
                        }
                      },
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
