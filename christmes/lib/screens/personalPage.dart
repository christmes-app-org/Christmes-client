import 'dart:io';
import 'dart:js_util';
import 'package:christmes/misc/colors.dart';
import 'package:christmes/screens/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:hive/hive.dart';
class PersonalPage extends StatefulWidget {

  @override
  _PersonalPageState createState() => _PersonalPageState();
}
class _PersonalPageState extends State<PersonalPage> {


    final double coverHeight = 500;
    final double profileHeight = 114;


    @override
    Widget build(BuildContext context) {
      final top = coverHeight - profileHeight;

      final ImageProvider imageProvider = Image.network('https://matrix-client.matrix.org/_matrix/media/v3/thumbnail/matrix.org/tHwINSDGpHigLhiNfKAQxMeR?width=800&height=600&method=scale').image;

     return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          //backgroundColor: Colors.white.withOpacity(.94),
          backgroundColor: AppColors.backgroundLight,
          //backgroundColor: AppColors.backgroundDark,
          body: Padding(
            padding: const EdgeInsets.all(10),

            child: ListView(
              children: [
                // user card
                /*BigUserCard(
                  userName: "sammx22",
                  userProfilePic: imageProvider,
                  cardColor: Colors.blue.withOpacity(.90),

                ),*/
                //buildCoverImage(),
                Positioned(
                    top: top,
                    child:
                    buildProfileImage()
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
                        onChanged: (value) {print("b");},
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
                      subtitle: "Lern more about christmes",
                    ),
                  ],
                ),
                // You can add a settings title
                SettingsGroup(
                  settingsGroupTitle: "Account",
                  items: [
                    SettingsItem(
                      onTap: () {
                        String username= Hive.box('client').get("username");
                        String pwd= Hive.box('client').get("pwd");
                        print("before"+username+pwd);
                        Hive.box('client').delete("username");
                        Hive.box('client').delete("pwd");
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => LoginPage()));
                      },
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
                        )
                    )

                  ],
                ),
              ],

            ),
          ),
        ),
      );


     /* return Scaffold(
            body: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                buildCoverImage(),
                Positioned(
                    top: top,
                    child:
                    buildProfileImage()
                ),
              ],
            ),
        );*/

    }




    Widget buildCoverImage() =>
        Container(
            color: Colors.grey,
            child: Image.network(
                'https://images.unsplash.com/photo-1647681105535-b3d6e4f1a0b9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
                width: double.infinity,
                height: coverHeight,
                fit: BoxFit.cover,
            ),
        );

    Widget buildProfileImage() =>
     CircleAvatar(
       backgroundColor: Colors.white,
       radius: (profileHeight / 1.9) * 2.2,
        child:
        CircleAvatar(
          radius: (profileHeight / 2) * 2,
          backgroundColor: Colors.grey.shade800,
          backgroundImage: NetworkImage(

              'https://matrix-client.matrix.org/_matrix/media/v3/thumbnail/matrix.org/tHwINSDGpHigLhiNfKAQxMeR?width=800&height=600&method=scale'
          ),
        ),

     );
}





/* return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        backgroundColor: Colors.white.withOpacity(.94),
        body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
        children: [
        // user card
        BigUserCard(
        userName: "sammx22",
        userProfilePic: ,
        cardColor: Colors.red.withOpacity(.90),

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
        backgroundColor: Colors.red,
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
        backgroundColor: Colors.red,
        ),
        title: 'Dark mode',
        subtitle: "Automatic",
        trailing: Switch.adaptive(
        value: false,
        onChanged: (value) {},
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
        subtitle: "Lern more about christmes",
        ),
        ],
        ),
        // You can add a settings title
        SettingsGroup(
        settingsGroupTitle: "Account",
        items: [
        SettingsItem(
        onTap: () {},
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
        color: Colors.red,
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
            )
        )

        ],
        ),
        ],

        ),
        ),
        ),
        );
  }*/

/*
width: 120,
height: 120,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(90),
color: Colors.redAccent
),
child:
Text("Personal"),

 */
