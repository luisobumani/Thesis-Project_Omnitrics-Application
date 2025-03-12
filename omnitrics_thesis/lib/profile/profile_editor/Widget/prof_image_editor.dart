import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Container profileImageEditor() {
  return Container(
    margin: const EdgeInsets.only(top: 30, bottom: 20),
    alignment: Alignment.center,
    child: Stack(
      children: [
        CircleAvatar(
          radius: 65,
          child: SvgPicture.asset('assets/icons/profile.svg'),
        ),
        Positioned(
          bottom: -10,
          left: 80,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add_a_photo),
          ),
        ),
      ],
    ),
  );
}
