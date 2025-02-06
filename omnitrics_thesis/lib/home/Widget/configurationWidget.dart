import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Center configurationTile() {
    return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            GestureDetector(
              onTap: (){

              },
              child: Container(
              width: 100,
              height: 125,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
                ]
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                        'assets/icons/pngwing.com 1.svg',
                      width: 50,
                      height: 50,
                      ),
                    SizedBox(height: 5),
                    Text(
                      'Gallery',
                      style: TextStyle(
                      color: Colors.black, 
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      ),
                      ),
                  ],
                )
              ),
            ),
            )
            ],
          ),
        );
  }