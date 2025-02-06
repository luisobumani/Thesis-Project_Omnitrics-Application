import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Center generalCamBtn() {
    return Center(
          child: Container(
            margin: EdgeInsets.only(top: 70),
            width: 200,
            child: GestureDetector(
              onTap: () {

              },
              child: SvgPicture.asset(
                'assets/icons/agbnakolbn;aslnm 1.svg'
              ),
            )
          )
        );
  }