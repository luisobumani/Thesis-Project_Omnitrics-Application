import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FillUpSection extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController genderController;
  final TextEditingController birthdayController;
  final TextEditingController emailController;

  const FillUpSection({
    Key? key,
    required this.firstNameController,
    required this.lastNameController,
    required this.genderController,
    required this.birthdayController,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        shadowedTextField(label: 'First Name', controller: firstNameController),
        shadowedTextField(label: 'Last Name', controller: lastNameController),
        // Replace gender text field with dropdown
        GenderDropdown(controller: genderController),
        BirthdayField(controller: birthdayController),
        // Email field shown as read-only.
        shadowedTextField(label: 'Email', controller: emailController, readOnly: true),
      ],
    );
  }

  Widget shadowedTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 12.h, bottom: 12.h, right: 12.w, left: 12.w),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1.r,
              blurRadius: 5.r,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10.r),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}

class GenderDropdown extends StatefulWidget {
  final TextEditingController controller;

  const GenderDropdown({Key? key, required this.controller}) : super(key: key);

  @override
  State<GenderDropdown> createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String? _selectedGender;

  final List<String> _genderOptions = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    // Set initial value if the controller already has a value.
    if (widget.controller.text.isNotEmpty) {
      _selectedGender = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.h, bottom: 12.h, right: 12.w, left: 12.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1.r,
            blurRadius: 5.r,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Gender',
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10.r),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
             EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedGender,
            hint: const Text('Select Gender'),
            isExpanded: true,
            items: _genderOptions.map((String gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedGender = newValue;
                widget.controller.text = newValue ?? '';
              });
            },
          ),
        ),
      ),
    );
  }
}

class BirthdayField extends StatefulWidget {
  final TextEditingController controller;
  const BirthdayField({Key? key, required this.controller}) : super(key: key);

  @override
  State<BirthdayField> createState() => _BirthdayFieldState();
}

class _BirthdayFieldState extends State<BirthdayField> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        widget.controller.text = DateFormat('MM/dd/yyyy').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            labelText: 'Birthday',
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: const Icon(Icons.calendar_today),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
