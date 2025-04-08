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
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.white
                    ),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                        horizontal: 20.w, 
                        vertical: 12.h
                      )
                    ),
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.deepPurple.shade900;
                        }
                        return Colors.deepPurple;
                      }
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)
                      )
                    )
                    ),
                  child: const Text("Continue"),
                ),
              ],
            );
          },
        );
      },
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.white;
            }
            return Colors.deepPurple;
          }
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.deepPurple.shade900;
            }
            return Colors.white;
          }
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(
            horizontal: 20.w, 
            vertical: 12.h
          )
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r)
          )
        )
      ),
      child: Text(
        "Start the Test",
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
