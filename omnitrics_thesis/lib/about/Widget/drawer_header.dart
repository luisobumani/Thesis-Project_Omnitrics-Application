import 'package:flutter/material.dart';

DrawerHeader drawerHeader() {
  return DrawerHeader(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ), // Deep purple header background
        ),
        child: const Text(
          'About',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      );
}