

import 'package:divya/guitarTab/playerPage.dart';
import 'package:flutter/cupertino.dart';

import '../screens/login/register.dart';
import '../services/auth.dart';


class LoginCheck extends StatefulWidget {
  const LoginCheck({Key? key}) : super(key: key);

  @override
  State<LoginCheck> createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return BottomNavPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}