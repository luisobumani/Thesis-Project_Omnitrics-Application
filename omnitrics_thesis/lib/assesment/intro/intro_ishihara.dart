import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_01.dart';

class IntroIshihara extends StatefulWidget {
  const IntroIshihara({Key? key}) : super(key: key);

  @override
  State<IntroIshihara> createState() => _IntroIshiharaState();
}

class _IntroIshiharaState extends State<IntroIshihara>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeText;
  late Animation<Offset> _slideText;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _fadeText = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeIn),
      ),
    );

    _slideText =
        Tween<Offset>(begin: const Offset(0, 2.0), end: Offset.zero).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade700, 
              Colors.deepPurple.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _fadeText,
                  child: SlideTransition(
                    position: _slideText,
                    child: Container(
                      margin: EdgeInsets.only(top: 350),
                      child: textIshihara(),
                    )
                  ),
                ),
                FadeTransition(
                  opacity: _fadeText,
                  child: SlideTransition(
                    position: _slideText,
                    child: Container(
                      margin: EdgeInsets.only(top: 350),
                      child: Container(
                        margin: EdgeInsets.only(right: 25),
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.pressed)) {
                                return Colors.green; // Color when pressed
                              }
                              return Colors.white; // Default color
                            },
                          ),
                        ),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => IshiharaTest01()));
                          }, 
                          child: Text(
                            'Start →',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 30
                            ),
                          )),
                      ),
                    )
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

  Text textIshihara() {
    return const Text(
                      'Ishihara Test',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      ),
                    );
  }
}
