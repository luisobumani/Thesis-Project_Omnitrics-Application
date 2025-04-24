import 'package:flutter/material.dart';

/// A simple FAQ page with expandable questions and answers.
class FAQPage extends StatefulWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<_FAQItem> _items = <_FAQItem>[
    _FAQItem(
      question: 'What is Omnitrics?',
      answer:
          'Omnitrics is an assistive mobile application that helps people with color vision deficiency by using real-time image processing techniques.',
    ),
    _FAQItem(
      question: 'What is the purpose of this app?',
      answer:
          'This app helps users with color vision deficiencies (protanopia, deuteranopia, tritanopia) by providing real-time color detection, correction filters, and simulation modes so you can better distinguish and understand colors in your environment.',
    ),
    _FAQItem(
      question: 'Which types of color vision deficiency are supported?',
      answer:
          'We support the three main types: Protanopia(red receptor deficiency), Deuteranopia(green receptor deficiency), and Tritanopia(blue receptor deficiency)',
    ),
    _FAQItem(
      question: 'How does real-time color detection work?', 
      answer: 'Using your device’s camera, the app samples the exact pixel under a center crosshair, analyzes its RGB values, and translates them into a named color with visual and textual feedback.'),
    _FAQItem(
      question: 'Do I need to calibrate the camera?', 
      answer: 'Calibration isn’t required, but for best accuracy: Ensure good lighting, Clean your camera lens, and Avoid extreme reflections or low-light conditions'),
    _FAQItem(
      question: 'How accurate is the color detection?', 
      answer: 'Under good lighting, detection is accurate to within a few percentage points of the true RGB values. Variance can occur due to camera quality and lighting.'),
    _FAQItem(
      question: 'How do I apply color correction filters?', 
      answer: 'In Color Correction mode, choose your deficiency type; the app overlays a tailored filter (e.g., enhanced red contrast) onto the live camera feed to make colors more distinguishable.'),
    _FAQItem(
      question: 'Can I use the app offline?', 
      answer: 'Yes. All core features (real-time detection, simulation, and correction) run locally on your device—no internet required. But in order to log in, you need to be online first'),
    _FAQItem(
      question: 'What permissions does the app need?', 
      answer: 'Camera access: for live detection and simulation and Optional storage access: to save snapshots or share color readings. No personal data (locations, contacts, etc.) is collected.'),
    _FAQItem(
      question: 'Why do colors sometimes appear different than expected?', 
      answer: 'Variations in ambient light (e.g., warm indoor lighting vs. daylight), shadows, and reflections can shift camera color balance. Try adjusting your environment or using the on-screen brightness slider.'),
    _FAQItem(
      question: 'What if the app crashes or freezes?', 
      answer: 'Restart your device.'),
    _FAQItem(
      question: 'Who can I contact for feedback or support?', 
      answer: 'Email us at omnitrics.db@gmail.com or tap Help & Feedback in the app’s main menu. We welcome bug reports, feature requests, and general feedback!'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.deepPurple.shade700,
              Colors.deepPurple.shade400
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight)
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ExpansionPanelList.radio(
            initialOpenPanelValue: null,
            children: _items
                .map<ExpansionPanelRadio>(
                    (_FAQItem item) => ExpansionPanelRadio(
                          value: item.question,
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                              title: Text(
                                item.question,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isExpanded ? Colors.deepPurple : null,
                                ),
                              ),
                            );
                          },
                          body: ListTile(
                            title: Text(item.answer),
                          ),
                        ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _FAQItem {
  final String question;
  final String answer;
  _FAQItem({required this.question, required this.answer});
}
