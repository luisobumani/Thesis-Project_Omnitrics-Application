import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Container profDetails() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Ram Jesler Delos Santos',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 5), 
                  Text(
                    'Deuteranopia', 
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30, left: 20),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset('assets/icons/profile.svg'),
            ),
          ],
        ),
      ),
    );
  }