import 'package:divya/constants/app_routes.dart';
import 'package:divya/screens/language/language_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import '../../utils.dart';
import '../widgets/icon_widget.dart';

class AccountPage extends StatelessWidget {
  static const keyLanguage = 'key-language';
  static const keyLocation = 'key-location';
  static const keyPassword = 'key-password';

  @override
  Widget build(BuildContext context) =>
      GestureDetector(

     child: ListTile(
        title: Text('Account Settings',style: TextStyle(color: Colors.white),),
        subtitle: Text('Privacy, Security, Language',style: TextStyle(color: Colors.white),),
        leading: IconWidget(icon: Icons.person, color: Colors.green),
    trailing: Icon(Icons.chevron_right,color: Colors.white,),
      ),
      onTap:() {


       Navigator.push(context,
          MaterialPageRoute(builder: (context) => LanguageScreen()));}
      );

  // Widget buildLanguage() => DropDownSettingsTile(
  //       settingKey: keyLanguage,
  //       title: 'Language',
  //       selected: 1,
  //       values: <int, String>{
  //         1: 'English',
  //         2: 'Spanish',
  //         3: 'Chinese',
  //         4: 'Hindi',
  //       },
  //       onChange: (language) {/* NOOP */},
  //     );
  //
  // Widget buildLocation() => TextInputSettingsTile(
  //       settingKey: keyLocation,
  //       title: 'Location',
  //       initialValue: 'Australia',
  //       onChange: (location) {/* NOOP */},
  //     );
  //
  // Widget buildPassword() => TextInputSettingsTile(
  //       settingKey: keyPassword,
  //       title: 'Password',
  //       obscureText: true,
  //       validator: (password) => password != null && password.length >= 6
  //           ? null
  //           : 'Enter 6 characters',
  //     );
  //
  // Widget buildPrivacy(BuildContext context) => SimpleSettingsTile(
  //       title: 'Privacy',
  //       subtitle: '',
  //       leading: IconWidget(icon: Icons.lock, color: Colors.blue),
  //       onTap: () => Utils.showSnackBar(context, 'Clicked Privacy'),
  //     );
  //
  // Widget buildSecurity(BuildContext context) => SimpleSettingsTile(
  //       title: 'Security',
  //       subtitle: '',
  //       leading: IconWidget(icon: Icons.security, color: Colors.red),
  //       onTap: () => Utils.showSnackBar(context, 'Clicked Security'),
  //     );
  //
  // Widget buildAccountInfo(BuildContext context) => SimpleSettingsTile(
  //       title: 'Account Info',
  //       subtitle: '',
  //       leading: IconWidget(icon: Icons.text_snippet, color: Colors.purple),
  //       onTap: () => Utils.showSnackBar(context, 'Clicked Account Info'),
  //     );
}
