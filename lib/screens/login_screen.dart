import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_2/services/fireStoreService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project_2/screens/home_screen.dart';
import 'package:final_project_2/screens/signup_screen.dart';
import 'package:final_project_2/screens/forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF0D47A1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, size: 60, color: Colors.white),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(children: [
                          TextSpan(
                            text: 'Hello, Welcome To Make A Wish',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          TextSpan(text: '\n\n'),
                          TextSpan(
                            text: 'user wishlist maker application',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: InputForm(),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                        text: "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      TextSpan(
                        text: " Sign up",
                        style: TextStyle(
                          color: Color.fromARGB(255, 199, 176, 81),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  final AuthServices _firestoreservice = AuthServices();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String? emailErrorMessage;
  String? passwordErrorMessage;

  // Email Validation
  String? validateEmail(String value) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email (e.g., example@domain.com)';
    }
    return null;
  }

  // Password Validation
  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  void _submit() async {
    String? emailErrorMessage1 = validateEmail(emailController.text);
    String? passwordErrorMessage1 = validatePassword(passwordController.text);
    String? emailErrorMessage2 = await _firestoreservice.userInDatabase(
        emailController.text, passwordController.text);
    // User? asd123 = await _firestoreservice.asd123(
    //     emailController.text, passwordController.text);
    // String? passwordErrorMessage2 = await _firestoreservice
    //     .userPasswordInDatabase(emailController.text, passwordController.text);
    // print(
    //     'eeeeeeeeeeeeeeeeee: ${emailErrorMessage2}, ${passwordErrorMessage2}');
    setState(() {
      emailErrorMessage = emailErrorMessage1;
      passwordErrorMessage = passwordErrorMessage1 ?? emailErrorMessage2;
      if (emailErrorMessage == null && passwordErrorMessage == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidthAll = MediaQuery.of(context).size.width;
    double screenWidth = screenWidthAll * 0.8;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Email Field
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF80A4FF),
              borderRadius: BorderRadius.circular(10),
            ),
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: InputBorder.none,
                  labelStyle:
                      TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                ),
              ),
            ),
          ),
          if (emailErrorMessage != null)
            Container(
              width: screenWidth,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 8),
                child: Text(
                  emailErrorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),

          const SizedBox(height: 10),

          // Password Field
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF80A4FF),
              borderRadius: BorderRadius.circular(10),
            ),
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: InputBorder.none,
                  labelStyle: const TextStyle(
                      color: Colors.white, fontFamily: 'Poppins'),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          if (passwordErrorMessage != null)
            Container(
              width: screenWidth,
              child: Padding(
                padding: EdgeInsets.only(left: 10, top: 8),
                child: Text(
                  passwordErrorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),

          const SizedBox(height: 5),

          // Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 50),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Login Button
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 199, 176, 81),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Color.fromARGB(255, 199, 176, 81),
                ),
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }
}
