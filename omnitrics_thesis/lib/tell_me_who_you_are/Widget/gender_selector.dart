import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderSelector extends FormField<String> {
  GenderSelector({
    Key? key,
    String? initialValue,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    required ValueChanged<String?> onChanged,
  }) : super(
    key: key,
    initialValue: initialValue,
    onSaved: onSaved,
    validator: validator,
    builder: (state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: ['Male', 'Female'].map((option) {
              return Expanded(
                child: RadioListTile<String>(
                  title: Text(
                    option,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                  ),
                  value: option,
                  groupValue: state.value,
                  onChanged: (value) {
                    state.didChange(value);
                    onChanged(value);
                  },
                ),
              );
            }).toList(),
          ),
          if (state.hasError)
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                state.errorText!,
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            ),
        ],
      );
    },
  );
}
