import 'dart:async';
import 'package:final_project_2/services/fireStoreService.dart';
import 'package:final_project_2/screens/reset_password.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _accountService = AccountServices();
  bool sent = false;
  int countDown = 0;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.yellow,
          ),
        ),
        backgroundColor: Colors.blue[900],
        iconTheme: const IconThemeData(color: Colors.yellow),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your email to reset your password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              // Email Field
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontFamily: 'Poppins'),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              if (countDown > 0) const SizedBox(height: 16),
              if (countDown > 0)
                Row(
                  children: [
                    const Text('Please wait '),
                    Text('$countDown'),
                    const Text(' to resend password request'),
                  ],
                ),
              const SizedBox(height: 32),
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      if (countDown == 0) {
                        final email = _emailController.text.trim();

                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please enter your email.',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                            ),
                          );
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(email)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please enter a valid email address.',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                            ),
                          );
                        } else {
                          await _accountService.sendResetPasswordLink(email);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'A reset password link has been sent to $email. Please check your inbox.')));
                          setState(() {
                            countDown = 60;
                          });
                          Timer.periodic(const Duration(seconds: 1), (timer) {
                            setState(() {
                              if (countDown == 0) {
                                timer.cancel();
                              } else {
                                countDown--;
                              }
                            });
                          });
                        }
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('$e')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: countDown > 0
                        ? Colors.grey
                        : const Color.fromARGB(255, 169, 199, 243),
                  ),
                  child: const Text(
                    'Send Reset Link',
                    style:
                        TextStyle(fontFamily: 'Poppins', color: Colors.black),
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
