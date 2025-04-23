import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/about/faqs/faqpage.dart';

ListTile faqS(BuildContext context) {
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FAQPage()));
        },
      );
}