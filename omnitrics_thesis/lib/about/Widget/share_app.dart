import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

ListTile shareApp() {
  return ListTile(
    leading: const Icon(
      Icons.share,
      color: Colors.deepPurple,
    ),
    title: const Text(
      'Share App',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    onTap: () {
      Share.share(
          'Check out this awesome app https://github.com/Ram-Delos-Santos/Thesis-Project_Omnitrics-Application',
          subject: 'OmniTrics Mobile App');
    },
  );
}
