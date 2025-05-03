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
          'Check out this awesome app https://drive.google.com/drive/folders/1Ac92QPdgWq1aaMFfqi7MYcljBRTUgqFH?usp=sharing',
          subject: 'OmniTrics Mobile App');
    },
  );
}
