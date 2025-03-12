import 'package:flutter/material.dart';

class FillUpSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController genderController;
  final TextEditingController birthdayController;
  final TextEditingController emailController;
  final TextEditingController? currentPasswordController;
  final TextEditingController? newPasswordController;
  final bool showPasswordFields;

  const FillUpSection({
    super.key,
    required this.nameController,
    required this.genderController,
    required this.birthdayController,
    required this.emailController,
    this.currentPasswordController,
    this.newPasswordController,
    this.showPasswordFields = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        shadowedTextField(label: 'Name', controller: nameController),
        shadowedTextField(label: 'Gender', controller: genderController),
        BirthdayField(controller: birthdayController),
        shadowedTextField(label: 'Email', controller: emailController),
        if (showPasswordFields)
          shadowedTextField(label: 'Current Password', controller: currentPasswordController!),
        if (showPasswordFields)
          shadowedTextField(label: 'New Password', controller: newPasswordController!),
      ],
    );
  }

  Widget shadowedTextField({required String label, required TextEditingController controller}) {
    return Container(
      margin: const EdgeInsets.all(12),
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
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white,
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
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        widget.controller.text = "${pickedDate.toLocal()}".split(' ')[0];
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
