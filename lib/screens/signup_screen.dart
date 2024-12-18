import 'package:final_project_2/services/fireStoreService.dart';
import 'package:flutter/material.dart';
import 'package:final_project_2/screens/login_screen.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
<<<<<<< HEAD
  final AuthServices firestoreservice = AuthServices();
=======
  final AccountServices firestoreservice = AccountServices();
>>>>>>> 1789ac33cd312c7c493ac4c20a263a6a124c1375

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Email validation
  String? validateEmail(String? value) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email (e.g., example@domain.com)';
    }
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    final passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$');
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (!passwordRegex.hasMatch(value)) {
      return 'Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, and a number.';
    }
    return null;
  }

  // Check if the passwords match
  bool _isPasswordMatch() {
    return passwordController.text == confirmPasswordController.text;
  }

  // Confirm Password validation
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (!_isPasswordMatch()) {
      return 'Passwords do not match';
    }
    return null;
  }

  // First name validation
  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name is required';
    }
    return null;
  }

  // Last name validation
  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name is required';
    }
    return null;
  }

  // Helper method to handle password visibility toggle
  void _togglePasswordVisibility(bool isConfirmPassword) {
    setState(() {
      if (isConfirmPassword) {
        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
      } else {
        _isPasswordVisible = !_isPasswordVisible;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(
        title: Text(
          'Your Wish',
          style: TextStyle(
            color: const Color.fromARGB(255, 245, 233, 66),
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.yellow),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // First Name
                      TextFormField(
                        controller: firstNameController,
                        style: const TextStyle(fontFamily: 'Poppins'),
                        decoration: const InputDecoration(
                          labelText: 'First Name',
                          border: UnderlineInputBorder(),
                        ),
                        validator: validateFirstName,
                      ),
                      const SizedBox(height: 10),

                      // Last Name
                      TextFormField(
                        controller: lastNameController,
                        style: const TextStyle(fontFamily: 'Poppins'),
                        decoration: const InputDecoration(
                          labelText: 'Last Name',
                          border: UnderlineInputBorder(),
                        ),
                        validator: validateLastName,
                      ),
                      const SizedBox(height: 10),

                      // Email Field
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(fontFamily: 'Poppins'),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: UnderlineInputBorder(),
                        ),
                        validator: validateEmail,
                      ),
                      const SizedBox(height: 10),

                      // Password Field
                      TextFormField(
                        controller: passwordController,
                        obscureText: !_isPasswordVisible,
                        style: const TextStyle(fontFamily: 'Poppins'),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const UnderlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => _togglePasswordVisibility(false),
                          ),
                        ),
                        validator: validatePassword,
                      ),
                      const SizedBox(height: 10),

                      // Confirm Password Field
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        style: const TextStyle(fontFamily: 'Poppins'),
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: const UnderlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () => _togglePasswordVisibility(true),
                          ),
                        ),
                        validator: validateConfirmPassword,
                      ),
                      const SizedBox(height: 20),

                      // Create Account Button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 220, 224, 228),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // All validations are passed, proceed to Home screen
                              firestoreservice.signUpAccount(
                                  emailController.text,
                                  passwordController.text);
                              emailController.clear();
                              passwordController.clear();
                              confirmPasswordController.clear();
                              firstNameController.clear();
                              lastNameController.clear();
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please fill in all fields correctly')),
                              );
                            }
                          },
                          child: const Text(
                            'Create Account',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Already Have Account Link
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            'Already Have Account? Sign in',
                            style: TextStyle(
                              color: Colors.blue[400],
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
