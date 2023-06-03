import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/icon_widget.dart';
import 'newsLetter.dart';

class NotificationsPage extends StatelessWidget {
  static const keyNews = 'key-news';
  static const keyActivity = 'key-activity';
  static const keyNewsletter = 'key-newsletter';
  static const keyAppUpdates = 'key-appUpdates';

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: ListTile(
          title: Text(
            'Notifications'.tr,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            'Newsletters'.tr,
            style: TextStyle(color: Colors.white),
          ),
          leading: IconWidget(icon: Icons.notifications, color: Colors.red),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => NewsletterScreen())),
      );
}
