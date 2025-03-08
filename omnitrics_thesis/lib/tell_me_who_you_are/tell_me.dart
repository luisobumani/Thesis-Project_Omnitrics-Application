import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/birthdate_field.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/continue_button.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/exit_button.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/first_name_field.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/Widget/last_name_field.dart';

void main() {
  runApp(const TellMe());
}

class TellMe extends StatelessWidget {
  const TellMe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // This removes the debug banner
      title: 'Profile Form',
      theme: ThemeData(
        primarySwatch: Colors.purple,
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
  String? _selectedGender;
  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header and close button
              exitButton(),
              const SizedBox(height: 16),
              
              // First Name field
              const Text(
                'First Name',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              firstName(),
              const SizedBox(height: 16),
              
              // Last Name field
              const Text(
                'Last Name',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              lastName(),
              const SizedBox(height: 16),
              
              // Birthdate field
              const Text(
                'Birthdate',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              birthDate(),
              const SizedBox(height: 20),
              
              // Gender radio buttons
              genderButtons(),
              const SizedBox(height: 16),
              
              // Continue button
              continueBtn(),
            ],
          ),
        ),
      ),
    );
  }

  Column genderButtons() {
    return Column(
              children: _genderOptions.map((option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: _selectedGender,
                        activeColor: Colors.deepPurple,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),
                      Text(
                        option,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
  }

}