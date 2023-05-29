import 'package:divya/constants/app_routes.dart';
import 'package:divya/screens/language/language_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:get/get.dart';

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
        title: Text('Account_Settings'.tr,style: TextStyle(color: Colors.white),),
        subtitle: Text('PSL'.tr,style: TextStyle(color: Colors.white),),
        leading: IconWidget(icon: Icons.person, color: Colors.green),
    trailing: Icon(Icons.chevron_right,color: Colors.white,),
      ),
      onTap:() {


       Navigator.push(context,
          MaterialPageRoute(builder: (context) => LanguageScreen()));}
      );

}
