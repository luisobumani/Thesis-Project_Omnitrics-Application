import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omnitrics_thesis/home/general_camera/camera_page.dart';

Center generalCamBtn(BuildContext context) {
  return Center(
    child: Container(
      margin: const EdgeInsets.only(top: 70),
      width: 200,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context, // Now, this context is the BuildContext passed in
            MaterialPageRoute(
              builder: (ctx) => const CameraPage(), // Renamed inner context to 'ctx'
            ),
          );
        },
        child: SvgPicture.asset(
          'assets/icons/agbnakolbn;aslnm 1.svg',
        ),
      ),
    ),
  );
}
