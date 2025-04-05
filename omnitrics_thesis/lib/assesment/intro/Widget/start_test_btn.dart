import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/assesment/intro/intro_ishihara.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Container startTestBtn(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(left: 25.0.w, right: 30.0.w),
    alignment: Alignment.bottomRight,
    child: ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Reminder",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple
              ),),
              content: const Text(
                "For better accuracy, please turn off your night light and eye protection, and set your screen brightness to full.",
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IntroIshihara()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 12.h),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: const Text("Continue"),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(
        "Start the Test",
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
