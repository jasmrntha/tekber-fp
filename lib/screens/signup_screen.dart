import 'package:flutter/material.dart';
import 'package:final_project_2/screens/login_screen.dart'; 

class SignUpPage extends StatelessWidget {
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
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 500,
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      style: TextStyle(fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      style: TextStyle(fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      style: TextStyle(fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      style: TextStyle(fontFamily: 'Poppins'),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 220, 224, 228),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text('Create Account', style: TextStyle(fontFamily: 'Poppins')),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to LoginScreen when tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(
                          'Already Have Account? Sign in',
                          style: TextStyle(color: Colors.blue[400], fontFamily: 'Poppins'),
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
    );
  }
}
