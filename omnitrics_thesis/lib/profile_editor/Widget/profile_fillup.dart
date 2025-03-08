import 'package:flutter/material.dart';

class FillUpSection extends StatelessWidget {
  const FillUpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        shadowedTextField(
          label: 'Name',
        ),
        shadowedTextField(
          label: 'Gender',
        ),
        BirthdayField(),
        shadowedTextField(
          label: 'Email',
        ),
        shadowedTextField(
          label: 'Current Password',
        ),
        shadowedTextField(
          label: 'New Password',
        ),
      ],
    );
  }

  Widget shadowedTextField({required String label}) {
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
          decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              fillColor: Colors.white,
              filled: true),
        ),
      ),
    );
  }
}

class BirthdayField extends StatefulWidget {
  const BirthdayField({Key? key}) : super(key: key);

  @override
  State<BirthdayField> createState() => _BirthdayFieldState();
}

class _BirthdayFieldState extends State<BirthdayField> {
  final TextEditingController birthdayController = TextEditingController();
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
        birthdayController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    birthdayController.dispose();
    super.dispose();
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
          controller: birthdayController,
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
