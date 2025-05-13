import 'package:christmes/screens/chatPage.dart';
import 'package:christmes/screens/homePage.dart';
import 'package:christmes/screens/loginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = Client(
    'Matrix Example Chat',
    verificationMethods: {
      KeyVerificationMethod.emoji,
    },
    databaseBuilder: (_) async {
      final db = MatrixSdkDatabase(
        'matrix_flutter_client',
      );
      await db.open();
      return db;
    },
  );
  await client.init();
  runApp(Christmes(client: client));
}

class Christmes extends StatelessWidget {
  final Client client;

  const Christmes({required this.client, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matrix Example Chat',
      builder: (context, child) => Provider<Client>(
        create: (context) => client,
        child: child,
      ),
      home: client.isLogged() ? HomePage() : const LoginPage(),
    );
  }
}
