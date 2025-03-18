import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_02.dart';

class IshiharaTest01 extends StatefulWidget {
  const IshiharaTest01({Key? key}) : super(key: key);

  @override
  _IshiharaTest01State createState() => _IshiharaTest01State();
}

class _IshiharaTest01State extends State<IshiharaTest01> {
  final List<String> options = ['16', '8', '6', '29'];
  final int correctAnswerIndex = 0;

  int selectedOption = -1;

  List<Color?> optionColors = [null, null, null, null];

  void _handleOptionTap(int index) {
    if (selectedOption != -1) return;

    setState(() {
      selectedOption = index;
      if (index == correctAnswerIndex) {
        optionColors[index] = Colors.green;
      } else {
        optionColors[index] = Colors.red;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.push(context, 
      MaterialPageRoute(builder: (context) => IshiharaTest02()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ishihara Test 1',
        style: TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: Image.asset(
                  'assets/images/ishihara_01.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Display the answer options.
            Expanded(
              flex: 3,
              child: ListView.separated(
                itemCount: options.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () => _handleOptionTap(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: optionColors[index],
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      options[index],
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
