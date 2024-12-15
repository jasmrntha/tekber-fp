import 'package:flutter/material.dart';
import 'package:final_project_2/screens/forgot_password_screen.dart';
import 'package:final_project_2/screens/home_screen.dart';
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validasi password: minimal 8 karakter, mengandung huruf besar, huruf kecil, dan angka
  bool _isPasswordValid(String password) {
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    return regex.hasMatch(password);
  }

  bool _isPasswordMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
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
            children: [
              // Current Password Field
              TextField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: const TextStyle(fontFamily: 'Poppins'),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isCurrentPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isCurrentPasswordVisible,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 16),

              // New Password Field
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  labelStyle: const TextStyle(fontFamily: 'Poppins'),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isNewPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isNewPasswordVisible,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(fontFamily: 'Poppins'),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isConfirmPasswordVisible,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
              const SizedBox(height: 32),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen()),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  final currentPassword =
                      _currentPasswordController.text.trim();
                  final newPassword = _newPasswordController.text.trim();
                  final confirmPassword =
                      _confirmPasswordController.text.trim();

                  // Validasi untuk memastikan kolom tidak kosong
                  if (currentPassword.isEmpty ||
                      newPassword.isEmpty ||
                      confirmPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please fill in all fields.',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                    );
                  } else if (!_isPasswordValid(currentPassword)) {
                    // Validasi untuk currentPassword
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Current password must be at least 8 characters long, contain uppercase, lowercase, and a number.',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                    );
                  } else if (!_isPasswordValid(newPassword)) {
                    // Validasi untuk newPassword
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'New password must be at least 8 characters long, contain uppercase, lowercase, and a number.',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      ),
                    );
                  } else if (!_isPasswordMatch(newPassword, confirmPassword)) {
                    // Validasi untuk confirmPassword
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwords do not match',
                            style: TextStyle(fontFamily: 'Poppins')),
                      ),
                    );
                  } else if (newPassword == currentPassword) {
                    // Validasi untuk memastikan password baru tidak sama dengan password lama
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'New password cannot be the same as the current password',
                            style: TextStyle(fontFamily: 'Poppins')),
                      ),
                    );
                  } else {
                    // Password valid dan cocok
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Password successfully changed!',
                              style: TextStyle(fontFamily: 'Poppins'))),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 169, 199, 243),
                ),
                child: const Text(
                  'Save New Password',
                  style: TextStyle(fontFamily: 'Poppins', color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
