  import 'package:flutter/material.dart';
  
    class getStartedButton extends StatelessWidget {
    final VoidCallback onPressed;
    const getStartedButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, //Call the function when pressed
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(
          horizontal: 120,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Get Started',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
