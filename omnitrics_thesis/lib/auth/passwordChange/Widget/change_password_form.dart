import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea( 
      child: Column(
        children: [
          colorSettingsText(),
          adjustColorTiles1(),
          adjustColorTiles2(),
          
        ]
      ),
      ),
    );
  }

  Container adjustColorTiles1() {
    return Container(
          margin: const EdgeInsets.all(10), 
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), 
            boxShadow: [
              BoxShadow(
              color: Colors.grey, 
              spreadRadius: 2, 
              blurRadius: 5,
              offset: const Offset(0, 3), 
              ),
            ],
          ),
          child: ListTile(
            title: Text('Adjust color settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )
            ),
            leading: Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/icons/Camera.svg',
                width: 30,
                height: 30,),
            ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              onPressed: () {},
              child: Text(
                'Apply',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )
              ),
            )
          ),
        );
  }

  Container adjustColorTiles2() {
    return Container(
          margin: const EdgeInsets.all(10), 
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), 
            boxShadow: [
              BoxShadow(
              color: Colors.grey, 
              spreadRadius: 2, 
              blurRadius: 5,
              offset: const Offset(0, 3), 
              ),
            ],
          ),
          child: ListTile(
            title: Text('Color Contrast',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )
            ),
            leading: Container(
              margin: EdgeInsets.all(10),
              alignment: Alignment.center,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                'assets/icons/821826-200 4.svg',
                width: 30,
                height: 30,),
              ),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              onPressed: () {},
              child: Text(
                'Apply',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )
              ),
            )
          ),
        );
  }

  Container colorSettingsText() {
    return Container(
          margin: EdgeInsets.only(top: 30, left: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            'Color Settings',
            style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            ),
          ),
        );
  }

  AppBar appBar() {
    return AppBar(
      title: Text('OmniTrics',
        style: TextStyle(
          color: Colors.black,
          fontSize: 38,
          fontWeight: FontWeight.bold,
        )
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 6.0,
      shadowColor: Colors.grey,
      actions: [
        GestureDetector(
          onTap: () {
        },
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/icons/Display Picture Variants.svg',
          ),
        ),
        ),
      ],
    );
  }
}