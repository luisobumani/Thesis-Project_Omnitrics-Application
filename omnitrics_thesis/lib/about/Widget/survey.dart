import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SurveyTile extends StatelessWidget {
  const SurveyTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          Icons.document_scanner,
          color: Colors.deepPurple,
        ),
        title: Text(
          'Take the Survey!',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onTap: () async {
          final Uri url = Uri.parse('https://forms.gle/1nw5kgTgEmzYyEPU7');
          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open survey')),
            );
          }
        });
  }
}
