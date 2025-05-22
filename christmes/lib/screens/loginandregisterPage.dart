import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'loginPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordRepeatController = TextEditingController();
  final homeserverController = TextEditingController(text: 'matrix.org');


  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    passwordRepeatController.dispose();
    homeserverController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              SvgPicture.asset(
                'assets/icons/christmes_Logo_2025.svg',
                height: 120,
              ),

              const SizedBox(height: 24),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration('Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: usernameController,
                decoration: _inputDecoration('Username'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: _inputDecoration('Password'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordRepeatController,
                obscureText: true,
                decoration: _inputDecoration('Repeat Password'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: homeserverController,
                decoration: _inputDecoration('Homeserver'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Registrierung implementieren
                  },
                  style: ElevatedButton.styleFrom(
                    // TODO: Farbe ggf. anpassen (aktuell Blau)
                    backgroundColor: const Color(0xff2e6ca4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text('Register'),
                ),
              ),
              const SizedBox(height: 32),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                },
                child: const Text(
                  'Already have an account? Login here!',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
