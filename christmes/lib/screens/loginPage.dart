import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:matrix/matrix.dart';
import '../misc/colors.dart';
import 'chatPage.dart';
import 'hamburger_menu.dart';
import 'homePage.dart';
import 'loginandregisterPage.dart';
import 'package:matrix/encryption/encryption.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _homeserverController = TextEditingController(text: 'matrix.org');
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _homeserverController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() => _loading = true);
    try {
      final client = Provider.of<Client>(context, listen: false);
      await client.checkHomeserver(Uri.https(_homeserverController.text.trim(), ''));
      await client.login(
        LoginType.mLoginPassword,
        password: _passwordController.text,
        identifier: AuthenticationUserIdentifier(user: _usernameController.text),
      );

      final encryption = Encryption(client: client);
      encryption.autovalidateMasterOwnKey();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomePage()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _loading = false);
    }
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
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              SvgPicture.asset(
                'assets/icons/christmes_Logo_2025.svg',
                height: 120,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _homeserverController,
                decoration: _inputDecoration('Homeserver'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: _inputDecoration('Username'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputDecoration('Password'),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Forgot Password function'),
                      ),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 350,
                child: ElevatedButton(
                  onPressed: _loading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    // TODO: Farbe ggf. anpassen (aktuell Blau)
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white, // <- Textfarbe explizit setzen
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                      : const Text('Login'),
                ),
              ),
              const SizedBox(height: 32),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RegisterPage()),
                  );
                },
                child: Text(
                  'New User? Create Account',
                  style: TextStyle(color: Colors.blue.shade600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
