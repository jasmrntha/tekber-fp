import 'package:flutter/material.dart';
import 'package:final_project_2/screens/signup_screen.dart';

class RuleForSignPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Latar belakang biru navy
        backgroundColor: Colors.blue[900],
        appBar: AppBar(
          // Header dengan text "Your Wish" berwarna biru muda dan ditengahkan
          title: const Text('Your Wish',
              style: TextStyle(color: const Color.fromARGB(255, 245, 233, 66))),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true, // Tambahkan ini untuk menengahkan judul
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),

                // Container putih untuk bagian form
                Container(
                  width: double.infinity, // Atur lebar container
                  height: 600, // Atur tinggi container
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Judul "Rules for sign up" di dalam container
                      const Text(
                        'Rules for sign up',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Aturan 1-10 untuk sign up dengan padding
                      Expanded(
                        child: ListView(
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                '1. Pastikan Anda telah membaca dan memahami syarat dan ketentuan.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                '2. Gunakan alamat email yang valid.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                '3. Password harus memiliki minimal 8 karakter.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '4. Password harus mengandung huruf besar, huruf kecil, dan angka.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '5. Jangan menggunakan password yang sama dengan akun lain.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '6. Pastikan Anda telah memasukkan nama depan dan nama belakang yang benar.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '7. Alamat email harus unik dan tidak boleh digunakan oleh pengguna lain.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '8. Pastikan Anda telah memasukkan alamat yang benar.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '9. Tanggal lahir harus diisi dengan benar.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '10. Pastikan Anda telah membaca dan menyetujui kebijakan privasi.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tombol "Sign Up" setelah aturan
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 220, 224, 228),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()),
                            );
                          },
                          child: Text('Sign Up ->'),
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
