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
          colorModesText(),
          colorModesTiles(),
          configurationText(),
          configurationTile(),
          generalCamBtn()
        ]
      ),
      ),
    );
  }

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

  Container configurationText() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        'Configuration',
        style: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container colorModesText() {
    return Container(
        margin: EdgeInsets.only(top: 30, left: 20),
        alignment: Alignment.centerLeft,
        child: Text(
          'Color Modes',
          style: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.bold,
          ),
        ),
      );
  }

  Center colorModesTiles() {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildColorModeTile('Deuteranopia', 'assets/icons/821826-200 4.svg', () {
          // Handle Deuteranopia tile tap
        }),
        _buildColorModeTile('Protanopia', 'assets/icons/821826-200 4.svg', () {
          // Handle Protanopia tile tap
        }),
        _buildColorModeTile('Tritanopia', 'assets/icons/821826-200 4.svg', () {
          // Handle Tritanopia tile tap
        }),
      ],
    ),
  );
}

Widget _buildColorModeTile(String title, String assetPath, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap, // Action when tapped
    child: Container(
      width: 100,
      height: 125,
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: SvgPicture.asset(
                assetPath,
                width: 50,
                height: 50,
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
            title: Text('Adjust Color Settings',
            style: TextStyle(
              fontSize: 14,
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
              fontSize: 14,
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
              child: ClipOval(
                child: SvgPicture.asset(
                  'assets/icons/821826-200 4.svg',
                  width: 30,
                  height: 30,
                ),
              )
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