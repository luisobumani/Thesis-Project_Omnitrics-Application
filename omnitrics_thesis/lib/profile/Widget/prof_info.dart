import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfInfo extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProfInfo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Name tile
        Container(
          margin: EdgeInsets.only(
              top: 35.h, left: 10.w, right: 10.w, bottom: 10.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: ListTile(
            title: Text(data['firstName']?.toString() ?? "No Name"),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 10.w, left: 10.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: ListTile(
            title: Text(data['lastName']?.toString() ?? "No Name"),
          ),
        ),
        // Gender tile
        Container(
          margin: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 10.w, left: 10.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: ListTile(
            title: Text(data['gender']?.toString() ?? "No Gender"),
          ),
        ),
        // Birthdate tile
        Container(
          margin: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 10.w, left: 10.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: ListTile(
            title:
                Text(data['birthdate']?.toString() ?? "No Birthdate"),
          ),
        ),
        // Email tile
        Container(
          margin: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 10.w, left: 10.w),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: ListTile(
            title: Text(data['email']?.toString() ?? "No Email"),
          ),
        ),
      ],
    );
  }
}
