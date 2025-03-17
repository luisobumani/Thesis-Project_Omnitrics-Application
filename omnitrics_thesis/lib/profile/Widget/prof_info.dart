import 'package:flutter/material.dart';

class ProfInfo extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProfInfo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Name tile
        Container(
          margin: const EdgeInsets.only(
              top: 35, left: 10, right: 10, bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(data['firstName']?.toString() ?? "No Name"),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(data['lastName']?.toString() ?? "No Name"),
          ),
        ),
        // Gender tile
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(data['gender']?.toString() ?? "No Gender"),
          ),
        ),
        // Birthdate tile
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title:
                Text(data['birthdate']?.toString() ?? "No Birthdate"),
          ),
        ),
        // Email tile
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(data['email']?.toString() ?? "No Email"),
          ),
        ),
      ],
    );
  }
}
