import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/auth/forgetPassword/forgot_password.dart';
import 'package:omnitrics_thesis/auth/googleSignIn/google_auth.dart';
import 'package:omnitrics_thesis/auth/sign-in/Widget/login_button.dart';
import 'package:omnitrics_thesis/auth/sign-in/Widget/text_field.dart';
import 'package:omnitrics_thesis/auth/sign-in/sign_up.dart';
import 'package:omnitrics_thesis/home/homepage.dart';
import '../services/authentication.dart';
import 'Widget/snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void userLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showSnackBar(context, "Please fill all the fields.");
      return;
    }
    String res = await AuthServices().userLogin(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res == "Login successful!") {
      showSnackBar(context, "Successfully logged in!");
      setState(() {
        isLoading = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      });
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  void googleSignIn() async {
    var userCredential = await FirebaseServices().signInWithGoogle();
    
    if (userCredential == null) {
      // If no account was selected, we don't navigate to the homepage
      showSnackBar(context, "Account selection canceled or failed.");
      return;  // Don't navigate to the homepage if no account was selected
    }
    
    // Only proceed to homepage if sign-in was successful
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
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
                child: Image.asset("assets/images/login.jpg"),
              ),
              TextFieldInput(
                  textEditingController: emailController,
                  hintText: "Enter your email",
                  icon: Icons.email),
              TextFieldInput(
                  textEditingController: passwordController,
                  hintText: "Enter your password",
                  icon: Icons.lock),
              const ForgotPassword(),
              LoginButton(onTab: userLogin, text: "Log In"),
              Row(
                children: [
                  Expanded(child: Container(height: 1, color: Colors.black26)),
                  Expanded(child: Container(height: 1, color: Colors.black26))
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () async {
                    googleSignIn(); // Call the method to handle Google sign-in
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Image.asset(
                          "assets/images/googleLogo.png",
                          height: 35,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "Continue with Google",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 77, 76, 76),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        " Sign Up ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
