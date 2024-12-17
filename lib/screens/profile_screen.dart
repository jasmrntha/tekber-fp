import 'package:final_project_2/screens/login_screen.dart';
import 'package:final_project_2/screens/change_password_screen.dart'; 
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50.0, 
              child: Icon(
                Icons.person, 
                size: 50.0, 
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmation of Logout', style: TextStyle(fontFamily: 'Poppins')),
                      content: const Text('Sure you want to logout?', style: TextStyle(fontFamily: 'Poppins')),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Not sure', style: TextStyle(fontFamily: 'Poppins')),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Logout Successful', style: TextStyle(fontFamily: 'Poppins')),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => LoginScreen()),
                                        );
                                      },
                                      child: const Center(
                                        child: Text(
                                          'OK',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontFamily: 'Poppins'),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text("I'm sure", style: TextStyle(fontFamily: 'Poppins')),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:  Colors.red,
                minimumSize: const Size(200, 50), 
              ),
              child: const Text(
                'LOGOUT',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
