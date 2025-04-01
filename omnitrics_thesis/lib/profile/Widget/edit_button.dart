import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/profile/profile_editor/profile_edit_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditButton extends StatefulWidget {
  const EditButton({Key? key}) : super(key: key);

  @override
  _EditButtonState createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 10.w, left: 10.w),
      child: InkWell(
        onHighlightChanged: (isPressed) {
          setState(() {
            _isPressed = isPressed;
          });
        },
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileEditPage()),
          );
        },
        borderRadius: BorderRadius.circular(30.r),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isPressed
                  ? [Colors.deepPurple.shade900, Colors.deepPurple.shade600]
                  : [Colors.deepPurple.shade700, Colors.deepPurple.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
            child: Text(
              'Edit Information',
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

