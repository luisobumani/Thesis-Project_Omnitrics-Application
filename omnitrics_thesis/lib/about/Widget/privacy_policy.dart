import 'package:flutter/material.dart';

ListTile privacyPolicy(BuildContext context) {
  return ListTile(
    leading: const Icon(
      Icons.privacy_tip,
      color: Colors.deepPurple,
    ),
    title: const Text(
      'Privacy Policy',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
    onTap: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(20.0),
            title: const Text('Privacy Policy'),
            content: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.7,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Last updated May 05, 2025',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This Privacy Notice for Purple Inc. ("we," "us," or "our"), describes how and why we might access, collect, store, use, and/or share ("process") your personal information when you use our services ("Services"), including when you:',
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0), // Adjust the indent as needed.
                      child: const Text(
                        '• Download and use our mobile application (OmniTrics), or any other application of ours that links to this Privacy Notice',
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0), // Adjust the indent as needed.
                      child: const Text(
                        '•	Use OmniTrics. A mobile application to assist color-blind user using Image Processsing',
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0), // Adjust the indent as needed.
                      child: const Text(
                        '•	Engage with us in other related ways, including any sales, marketing, or events',
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Questions or concerns?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Reading this Privacy Notice will help you understand your privacy rights and choices. We are responsible for making decisions about how your personal information is processed. If you do not agree with our policies and practices, please do not use our Services. If you still have any questions or concerns, please contact us at omnitrics.db@gmail.com.'),
                    SizedBox(height: 10),
                    Text(
                      'SUMMARY OF KEY POINTS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This summary provides key points from our Privacy Notice, but you can find out more details about any of these topics by clicking the link following each key point or by using our table of contents below to find the section you are looking for.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'What personal information do we process? ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'When you visit, use, or navigate our Services, we may process personal information depending on how you interact with us and the Services, the choices you make, and the products and features you use. Learn more about personal information you disclose to us.',
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Do we process any sensitive personal information? ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ],
          );
        },
      );
    },
  );
}
