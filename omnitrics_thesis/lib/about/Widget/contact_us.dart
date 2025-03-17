import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

ListTile contactUs() {
  return ListTile(
        leading: const Icon(
          Icons.email,
          color: Colors.deepPurple,
        ),
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () async {
          String? encodeQueryParameters(Map<String, String> params) {
            return params.entries
                .map((MapEntry<String, String> e) =>
                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                .join('&');
          }
          final Uri emailUri = Uri(
            scheme: 'mailto',
            path: 'omnitrics.db@gmail.com',
            query: encodeQueryParameters(<String, String>{
              'subject' : 'Comments and Suggestions',
              'body' : 
                'Give us your comments and suggestions for the app!'
            })
          );
          if (await canLaunchUrl(emailUri)){
            launchUrl(emailUri);
          } else {
            throw Exception('Could not launch $emailUri');
          }
        },
      );
}