import 'package:flutter/material.dart';
import 'package:matrix/encryption/encryption.dart';
import 'package:provider/provider.dart';
import '../misc/colors.dart';
import 'chatPage.dart';
import 'hamburger_menu.dart';
import 'homePage.dart';
import 'loginandregisterPage.dart';
import 'package:matrix/matrix.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _homeserverTextField = TextEditingController(
    text: 'matrix.org',
  );
  final TextEditingController _passwordTextField = TextEditingController();
  final TextEditingController _usernameTextField = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _homeserverTextField.dispose();
    _passwordTextField.dispose();
    _usernameTextField.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      _loading = true;
    });

    try {
      final client = Provider.of<Client>(context, listen: false);
      await client
          .checkHomeserver(Uri.https(_homeserverTextField.text.trim(), ''));
      await client.login(
        LoginType.mLoginPassword,
        password: _passwordTextField.text,
        identifier: AuthenticationUserIdentifier(user: _usernameTextField.text),
      );

      print(client.encryptionEnabled);
      final encryption = Encryption(client: client);
      encryption.autovalidateMasterOwnKey();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomePage()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 150,
                  child: const Image(
                      image: AssetImage('../img/christmes_logo.png')),
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _homeserverTextField,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Homeserver',
                    hintText: 'Enter valid homeserver'),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _usernameTextField,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter valid username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _passwordTextField,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            TextButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Forgot Password function'),
                    );
                  },
                );
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _login,
                child: _loading
                    ? const LinearProgressIndicator()
                    : const Text('Login'),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Container(
              height: 20,
              width: 200,
              child: InkWell(
                onTap: () {
                  print('Clicked on new User');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => RegisterPage()));
                },
                child: Text('New User? Create Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
