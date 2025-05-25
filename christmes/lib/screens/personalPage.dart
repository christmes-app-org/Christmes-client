import 'dart:io';
import 'package:christmes/misc/colors.dart';
import 'package:christmes/screens/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:hive/hive.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  final double coverHeight = 500;
  final double profileHeight = 114;

  // TODO: Logout fixen
  void _logout() async {

    final client = Provider.of<Client>(context, listen: false);
    await client.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = coverHeight - profileHeight;

    final ImageProvider imageProvider = Image.network(
        'https://matrix-client.matrix.org/_matrix/media/v3/thumbnail/matrix.org/tHwINSDGpHigLhiNfKAQxMeR?width=800&height=600&method=scale'
    ).image;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Positioned(
                top: top,
                child: buildProfileImage(),
              ),
              SettingsGroup(
                settingsGroupTitle: "App Settings",
                items: [
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.pencil_outline,
                    iconStyle: IconStyle(),
                    title: 'Appearance',
                    subtitle: "Make it to yours",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.fingerprint,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: AppColors.primary,
                    ),
                    title: 'Privacy',
                    subtitle: "Keep Privacy safe",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.dark_mode_rounded,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: AppColors.primary,
                    ),
                    title: 'Dark mode',
                    subtitle: "Automatic",
                    trailing: Switch.adaptive(
                      value: false,
                      onChanged: (value) {
                        print("b");
                      },
                    ),
                  ),
                ],
              ),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.info_rounded,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.purple,
                    ),
                    title: 'About',
                    subtitle: "Learn more about Christmes",
                  ),
                ],
              ),
              SettingsGroup(
                settingsGroupTitle: "Account",
                items: [
                  SettingsItem(
                    onTap: _logout,
                    icons: Icons.exit_to_app_rounded,
                    title: "Sign Out",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.repeat,
                    title: "Change email",
                  ),
                  SettingsItem(
                    onTap: () {},
                    icons: CupertinoIcons.delete_solid,
                    title: "Delete account",
                    titleStyle: TextStyle(
                      color: AppColors.accentRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SettingsItem(
                    icons: CupertinoIcons.info,
                    title: "Info Version V2",
                    onTap: () {
                      stderr.writeln('print me');
                    },
                    titleStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCoverImage() => Container(
    color: Colors.grey,
    child: Image.network(
      'https://images.unsplash.com/photo-1647681105535-b3d6e4f1a0b9?ixlib=rb-1.2.1&auto=format&fit=crop&w=2070&q=80',
      width: double.infinity,
      height: coverHeight,
      fit: BoxFit.cover,
    ),
  );

  Widget buildProfileImage() => CircleAvatar(
    backgroundColor: Colors.white,
    radius: (profileHeight / 1.9) * 2.2,
    child: CircleAvatar(
      radius: (profileHeight / 2) * 2,
      backgroundColor: Colors.grey.shade800,
      backgroundImage: NetworkImage(
        'https://matrix-client.matrix.org/_matrix/media/v3/thumbnail/matrix.org/tHwINSDGpHigLhiNfKAQxMeR?width=800&height=600&method=scale',
      ),
    ),
  );
}
