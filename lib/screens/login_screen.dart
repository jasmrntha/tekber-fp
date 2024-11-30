import 'package:final_project_2/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project_2/screens/home_screen.dart';
import 'package:final_project_2/screens/forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;

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
              const Expanded(
                flex: 5,
                child: inputForm(),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()),
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

class inputForm extends StatefulWidget {
  const inputForm({super.key});

  @override
  _inputFormState createState() => _inputFormState();
}

class _inputFormState extends State<inputForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF80A4FF),
            border: Border.all(color: const Color(0xFF80A4FF)),
            borderRadius: BorderRadius.circular(10),
          ),
          width: screenwidth * 0.8,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: InputBorder.none,
                labelStyle:
                    TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF80A4FF),
            border: Border.all(color: const Color(0xFF80A4FF)),
            borderRadius: BorderRadius.circular(10),
          ),
          width: screenwidth * 0.8,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: InputBorder.none,
                labelStyle:
                    TextStyle(color: Colors.white, fontFamily: 'Poppins'),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
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
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: 'Poppins'),
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
      ],
    );
  }
}
