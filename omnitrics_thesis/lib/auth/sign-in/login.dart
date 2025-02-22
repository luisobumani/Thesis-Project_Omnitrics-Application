import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/auth/sign-in/Widget/login_button.dart';
import 'package:omnitrics_thesis/auth/sign-in/Widget/text_field.dart';
import 'package:omnitrics_thesis/auth/sign-in/sign_up.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> { // Class for the Sign up screen
// For the controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SizedBox(
        child: Column(
          children: [
            SizedBox(
                height: height / 2.7, 
                child: Image.asset("assets/images/login.jpg"),
              ), 
              TextFieldInput(
                textEditingController: emailController, 
                hintText: "Enter your email", 
                icon: Icons.email
                ),
                TextFieldInput(
                textEditingController: passwordController, 
                hintText: "Enter your password", 
                icon: Icons.lock
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    child: Align(
                    alignment: Alignment.centerRight,
                    child: Text("Forgot password?", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue
                    ),
                  ),
                ),
              ),
              LoginButton(onTab: () {}, text: "Log In"),
              SizedBox(height: height / 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?", style: TextStyle(fontSize: 16),),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, 
                      MaterialPageRoute(
                        builder: (context)=> const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(" Sign Up ", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,                      
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}    
        
      
   