import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    ];

    return Column(
      children: genderOptions.map((option) {
        return Padding(
          padding: EdgeInsets.only(bottom: 0.0.h),
          child: Row(
            children: [
              Radio<String>(
                value: option,
                groupValue: selectedGender,
                onChanged: onChanged,
              ),
              Text(
                option,
                style: TextStyle(fontSize: 14.sp,
                fontWeight: FontWeight.w500,),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
