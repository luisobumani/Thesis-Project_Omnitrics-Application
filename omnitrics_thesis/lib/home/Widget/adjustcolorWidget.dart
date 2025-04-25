import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/home/image_adj/filtered_image_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget adjustColorTiles(BuildContext context) {

  return Container(
    margin: EdgeInsets.only(top: 16.h),
    child: Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const FilteredImagePage()),
          );
        },
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all<Color>(
            Colors.white
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.deepPurple.shade900;
              }
              return Colors.deepPurple;
            }
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(
              horizontal: 100.w,
              vertical: 20.h,
            )
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r)
            )
          )
        ),
        child: Text(
          'Apply Filter to Image',
          style: TextStyle(
            fontSize: 17.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
