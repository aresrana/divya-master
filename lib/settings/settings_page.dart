import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:get/get.dart';
import 'package:wiredash/wiredash.dart';

import '../screens/login/register.dart';
import '../widgets/icon_widget.dart';
import 'account_page.dart';
import 'buyMe.dart';
import 'header_page.dart';
import 'notifications_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //AuthService authService = AuthService();

  String username = "";
  String email = "";

  @override
  void initstate() {
    super.initState();
    //gettingUsersData();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 70,

          title: Text(
            'Settings'.tr,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
          backgroundColor: Color.fromRGBO(18, 18, 18, 1),
          //You can make this transparent
          elevation: 0.0, //No shadow
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              HeaderPage(),
              const SizedBox(height: 32),
              SettingsGroup(
                title: 'GENERAL'.tr,
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
                children: <Widget>[
                  AccountPage(),
                  NotificationsPage(),
                  buildLogout(),
                  buildDeleteAccount(),
                ],
              ),
              const SizedBox(height: 32),
              SettingsGroup(
                  title: 'FEEDBACK'.tr,
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
                  children: <Widget>[
                    const SizedBox(height: 8),
                    buildSendFeedback(context),
                  ]),
              const SizedBox(height: 32),
              SettingsGroup(
                title: 'support'.tr,
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 16),
                children: <Widget>[
                  const SizedBox(height: 8),
                  buildBuyCofee(context),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildLogout() => ListTile(
        title: Text(
          'logout'.tr,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'signout'.tr,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconWidget(icon: Icons.logout, color: Colors.blueAccent),
        onTap: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
              (route) => false);
          //await authService.signOut();
        },
      );

  Widget buildDeleteAccount() => ListTile(
      title: Text(
        'Delete_Account'.tr,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        'loose'.tr,
        style: TextStyle(color: Colors.white),
      ),
      leading: IconWidget(icon: Icons.delete, color: Colors.red),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you want to delete your account?'),
                  actions: [
                    MaterialButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    MaterialButton(
                        child: Text('Yes'),
                        onPressed: () async {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                              (route) => false);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Your Account has been deleted")));

                          // await authService.removeUser();
                        })
                  ]);
            });
      });

  Widget buildSendFeedback(BuildContext context) => ListTile(
      title: Text(
        'Send_Feedback'.tr,
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        'suggestions'.tr,
        style: TextStyle(color: Colors.white),
      ),
      leading: IconWidget(icon: Icons.thumb_up, color: Colors.purple),
      onTap: () {
        Wiredash.of(context).show(inheritMaterialTheme: true);
      });

  Widget buildBuyCofee(BuildContext context) => ListTile(
        title: Text(
          'support'.tr,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          'help'.tr,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconWidget(icon: Icons.live_help, color: Colors.teal),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => BuyMe()));
        },
      );
}
