import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

//import 'package:wiredash/wiredash.dart';

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

  // Future gettingUsersData() async {
  //   await HelperFunctions.getUserEmailFromSF().then((value) {
  //     setState(() {
  //       email = value!;
  //     });
  //   });
  //   await HelperFunctions.getUserNameFromSF().then((val) {
  //     setState(() {
  //       username = val!;
  //     });
  //   });
  // }


  @override
  Widget build(BuildContext context) =>
      Scaffold(
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        appBar: AppBar(
       automaticallyImplyLeading: false,
          toolbarHeight: 70,
          title: Text(
            'Settings',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
                backgroundColor: Colors.grey.shade900,
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
                title: 'GENERAL',
                titleTextStyle: TextStyle(color: Colors.white),
                children: <Widget>[
                  AccountPage(),
                  NotificationsPage(),
                  buildLogout(),
                  buildDeleteAccount(),
                ],
              ),
              const SizedBox(height: 32),
              SettingsGroup(
                  title: 'FEEDBACK',
                  titleTextStyle: TextStyle(color: Colors.white),
                  children: <Widget>[
                    const SizedBox(height: 8),
                    buildSendFeedback(context),
                  ]),
              const SizedBox(height: 32),
              SettingsGroup(
                title: 'Buy Me A Coffee',
                titleTextStyle: TextStyle(color: Colors.white),
                children: <Widget>[
                  const SizedBox(height: 8),
                  buildBuyCofee(context),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildLogout() => SimpleSettingsTile(
    title: 'Logout',
    subtitle: '',
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

  Widget buildDeleteAccount() => SimpleSettingsTile(
      title: 'Delete Account',

      subtitle: '',
      leading: IconWidget(icon: Icons.delete, color: Colors.white),
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

                          //await authService.removeUser();

                        })
                  ]);
            });
      });

  Widget buildSendFeedback(BuildContext context) =>

      SimpleSettingsTile(
          title: 'Send Feedback',
          subtitle: '',
          leading: IconWidget(icon: Icons.thumb_up, color: Colors.purple),
          onTap: () {
            //Wiredash.of(context).show(inheritMaterialTheme: true);

          });


  Widget buildBuyCofee(BuildContext context) =>
      SimpleSettingsTile(
        title: 'Buy Me a Coffee',
        subtitle: 'A help to upgrade features in app',
        leading: IconWidget(icon: Icons.live_help, color: Colors.teal),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => BuyMe()));
        },
      );



}