import 'package:flutter/material.dart';

Column profileInfoTiles() {
  return Column(
    children: [
      Container(
          margin:
              const EdgeInsets.only(top: 35, left: 10, right: 10, bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text("Ram Jesler Delos Santos"),
          )),
      Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text("Male"),
          )),
      Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text("November 18, 2003"),
          )),
      Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text("ramjesler.delossantos@gmail.com"),
          )),
      Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text("********"),
          )),
    ],
  );
}
