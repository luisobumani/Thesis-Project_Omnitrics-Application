import 'package:flutter/material.dart';

Container startTestBtn(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(left: 25.0, right: 30.0),
    alignment: Alignment.bottomRight,
    child: ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Reminder",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple
              ),),
              content: const Text(
                "For better accuracy, please turn off your night light and eye protection, and set your screen brightness to full.",
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Place further actions here, if needed, such as navigating to the test screen.
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Continue"),
                ),
              ],
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        "Start the Test",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
