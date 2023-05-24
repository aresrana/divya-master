import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import '../widgets/icon_widget.dart';


class NotificationsPage extends StatelessWidget {
  static const keyNews = 'key-news';
  static const keyActivity = 'key-activity';
  static const keyNewsletter = 'key-newsletter';
  static const keyAppUpdates = 'key-appUpdates';

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text('Notifications',style: TextStyle(color: Colors.white),),
    subtitle: Text('Newsletter, App Updates',style: TextStyle(color: Colors.white),),
    leading: IconWidget(icon: Icons.notifications, color: Colors.red),
    trailing: Icon(Icons.chevron_right,color: Colors.white,),
  );
}
