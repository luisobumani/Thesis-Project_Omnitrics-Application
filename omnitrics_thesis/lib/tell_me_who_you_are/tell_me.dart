import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnitrics_thesis/assesment/intro/intro_assessment.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/birthdate_field.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/continue_button.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/exit_button.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/first_name_field.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/gender_selector.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/last_name_field.dart';


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
          const SnackBar(content: Text("Profile updated successfully!")),
        );
        // Navigate to another screen if desired
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const IntroAssessment(),
        ),
      );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: $e")),
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
      // Use a SingleChildScrollView to handle potential overflow
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 103, 58, 183).withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exit / header

                const SizedBox(height: 16),

                // First Name
                const Text('First Name', 
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,)),
                const SizedBox(height: 8),
                FirstNameField(controller: firstNameController),
                const SizedBox(height: 16),

                // Last Name
                const Text('Last Name', style: TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.w500,)),
                const SizedBox(height: 8),
                LastNameField(controller: lastNameController),
                const SizedBox(height: 16),

                // Birthdate
                const Text('Birthdate', style: TextStyle(
                  fontSize: 14, 
                  fontWeight: FontWeight.w500,)),
                const SizedBox(height: 8),
                BirthdateField(controller: birthDateController),
                const SizedBox(height: 20),

                // Gender radio buttons
                const Text('Sex', style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,)),
                GenderSelector(
                  selectedGender: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),

                const SizedBox(height: 16),
                // Continue Button
                ContinueButton(
                  onPressed: () {
                    // Validate fields if needed
                    updateUserProfile();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
