import 'package:final_project_2/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project_2/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Color(0xFF0D47A1),
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
                      Icon(Icons.star, size: 60, color: Colors.white),           
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
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
                child: inputForm(),
                flex: 5,
              ),
              Expanded(
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
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class inputForm extends StatefulWidget {
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
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Color.fromARGB(255, 199, 176, 81),
              ),
            ),
          ),
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Poppins'),
          ),
        ),
      ],
    );
  }
}
