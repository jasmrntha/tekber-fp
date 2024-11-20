import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.yellow, fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.blue[900],
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50.0, // Warna latar belakang lingkaran
              child: Icon(
                Icons.person, // Ikon people
                size: 50.0,   // Ukuran ikon
                color: Colors.white, // Warna ikon
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'user@gmail.com',
              style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement logout logic here
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 169, 199, 243)),
              child: const Text('Logout', ),
            ),
          ],
        ),
      ),
    );
  }
}
