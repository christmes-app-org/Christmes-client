import 'package:christmes/screens/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'homePage.dart';



class RegisterPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  final passwordController = TextEditingController();
  final userController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordrepeatController = TextEditingController();
  final homeserverController = TextEditingController();
  static const bluecolor = const Color(0xff2e6ca4);
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    passwordController.dispose();
    userController.dispose();
    super.dispose();
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

                  child: const Image(image: AssetImage('../img/christmes_logo.png')),
                  // Icon(Icons.login,color: Colors.grey.shade600, size: 100,)
                ),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: userController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id to register'),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter a Username to register'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: passwordrepeatController,
                obscureText: true,

                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Repeat Password',
                    hintText: 'Repeat your password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: homeserverController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Homeserver',
                    hintText: 'Enter the homeserver of your organisation'),
              ),
            ),
            Container(
                child: SizedBox(
                  height: 15,
                  child: Text(""),
                )
            ),

            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: bluecolor, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {

                  //Navigator.push(
                  //    context, MaterialPageRoute(builder: (_) => HomePage()));
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Container(
              height: 20,
              width: 250,
              child: InkWell(
                onTap: () {
                  print('Login Page');
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => LoginPage()));
                },
                child: Text('Your have a Account? Login here!'),
              ),
            ),


          ],
        ),
      ),
    );
  }
}