import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/auth/services/authentication.dart';
import 'package:omnitrics_thesis/auth/sign-in/Widget/snack_bar.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/tell_me.dart'; // Redirect to detailed info page
import 'Widget/login_button.dart';
import 'Widget/text_field.dart';
import 'package:omnitrics_thesis/auth/sign-in/login.dart'; // Retain login for existing users

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers for the input fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose(){
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void userSignup() async {
    // Check if any field is empty
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showSnackBar(context, "Please fill all the fields.");
      return;
    }
    // Sign up process
    String res = await AuthServices().userSignup(
      email: emailController.text, 
      password: passwordController.text, 
      name: nameController.text,
    );

    if (res == "Signup successful!") {
      setState(() {
        isLoading = true;
      });
      // Redirect to the detailed info (Tell Me Who You Are) page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const TellMe(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }
  
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
                child: Image.asset("assets/images/signup.jpg"),
              ),
              TextFieldInput(
                textEditingController: nameController, 
                hintText: "Enter your name", 
                icon: Icons.person,
              ),
              TextFieldInput(
                textEditingController: emailController, 
                hintText: "Enter your email", 
                icon: Icons.email,
              ),
              TextFieldInput(
                textEditingController: passwordController, 
                hintText: "Enter your password", 
                icon: Icons.lock,
              ),
              LoginButton(onTab: userSignup, text: "Sign Up"),
              SizedBox(height: height / 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?", 
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, 
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      " Log In ", 
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
        ),
      ),
    );
  }
}
