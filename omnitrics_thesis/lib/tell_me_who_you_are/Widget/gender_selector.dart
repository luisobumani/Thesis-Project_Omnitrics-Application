import 'package:flutter/material.dart';

class GenderSelector extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String?> onChanged;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> genderOptions = [
      'Male',
      'Female',
      'Non-binary',
      'Prefer not to say',
    ];

    return Column(
      children: genderOptions.map((option) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Radio<String>(
                value: option,
                groupValue: selectedGender,
                onChanged: onChanged,
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
