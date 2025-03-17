import 'package:flutter/material.dart';

ListTile faqS() {
  return ListTile(
        leading: const Icon(
          Icons.question_mark_sharp,
          color: Colors.deepPurple,
        ),
        title: const Text(
          "FAQ's",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          // Add your onTap functionality here
        },
      );
}