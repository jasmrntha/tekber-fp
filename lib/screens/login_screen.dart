import 'package:flutter/material.dart';
import 'package:final_project_2/screens/signup_screen.dart';
import 'package:final_project_2/screens/home_screen.dart';
<<<<<<< HEAD
import 'package:final_project_2/screens/signup_screen.dart';
=======
import 'package:final_project_2/screens/guide_screen.dart';
>>>>>>> 92961b5cc6fbf0f1043bcefdcde132b9d61440fd
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
<<<<<<< HEAD
=======
                child: InputForm(),
>>>>>>> 92961b5cc6fbf0f1043bcefdcde132b9d61440fd
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String? emailErrorMessage;
  String? passwordErrorMessage;

  // Email Validation
  String? validateEmail(String value) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email (e.g., example@domain.com)';
    }
    return null;
  }

  // Password Validation
  String? validatePassword(String value) {
    final passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
    if (value.isEmpty) {
      return 'Password is required';
    } else if (!passwordRegex.hasMatch(value)) {
      return 'Password must be at least 8 characters long,\ninclude an uppercase letter, a lowercase letter, and a number.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    double screenWidth = MediaQuery.of(context).size.width;

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
=======
    double screenwidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF80A4FF),
            border: Border.all(color: Color(0xFF80A4FF)),
            borderRadius: BorderRadius.circular(10),
          ),
          width: screenwidth * 0.8,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: InputBorder.none,
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF80A4FF),
            border: Border.all(color: Color(0xFF80A4FF)),
            borderRadius: BorderRadius.circular(10),
          ),
          width: screenwidth * 0.8,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: InputBorder.none,
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen()),
            );
          },
          child: const Text(
            "Forgot password?",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 199, 176, 81),
            shape: RoundedRectangleBorder(
>>>>>>> 92961b5cc6fbf0f1043bcefdcde132b9d61440fd
              borderRadius: BorderRadius.circular(10),
            ),
            width: screenWidth * 0.8,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: InputBorder.none,
                  labelStyle: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                  errorText: emailErrorMessage,
                ),
                onChanged: (value) {
                  setState(() {
                    emailErrorMessage = validateEmail(value);
                  });
                },
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
            width: screenWidth * 0.8,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextFormField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: InputBorder.none,
                  labelStyle: const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  errorText: passwordErrorMessage,
                ),
                onChanged: (value) {
                  setState(() {
                    passwordErrorMessage = validatePassword(value);
                  });
                },
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
                    MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
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
            onPressed: () {
              final email = emailController.text.trim();
              final password = passwordController.text.trim();

              // Validate form fields
              if (_formKey.currentState!.validate()) {
                if (emailErrorMessage == null && passwordErrorMessage == null) {
                  // If validation passes and no errors
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              } else {
                // Show error snackbars if fields are invalid
                if (emailErrorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(emailErrorMessage!)),
                  );
                } else if (passwordErrorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(passwordErrorMessage!)),
                  );
                }
              }
            },
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
              style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }
}
