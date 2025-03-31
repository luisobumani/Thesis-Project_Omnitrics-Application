import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/auth/sign-in/sign_up.dart';

Row exitButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        'Tell me who you are',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SignUpScreen()),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          );
        },
      ),
    ],
  );
}
