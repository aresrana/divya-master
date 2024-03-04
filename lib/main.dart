import 'package:divya/constants/app_routes.dart';
import 'package:divya/constants/constants.dart';
import 'package:divya/controllers/language_controller.dart';
import 'package:divya/screens/language/dep.dart' as dep;
import 'package:divya/screens/language/messages.dart';
import 'package:divya/secret/secrets.dart';
import 'package:divya/services/song_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wiredash/wiredash.dart';

late int? initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await FlutterDownloader.initialize(
      debug: true,
      // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
   Fluttertoast.showToast(msg: '');

  await Firebase.initializeApp();

  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);
  Map<String, Map<String, String>> _languages = await dep.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp(
      languages: _languages,
    ));
  });
  runApp(MyApp(
    languages: _languages,
  ));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;

  const MyApp({required this.languages});

  @override
  Widget build(BuildContext context) {
    return Wiredash(
        projectId: '$projectid',
        secret: '$secret',
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) => SongProvider(col: '')),
            ],
            child: GetBuilder<LocalizationController>(
                builder: (localizationController) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  splashColor: Colors.transparent,
                ),
                locale: localizationController.locale,
                translations: Messages(languages: languages),
                fallbackLocale: Locale(AppConstants.languages[0].languageCode,
                    AppConstants.languages[0].countryCode),
                initialRoute: RouteHelper.getSplashRoute(),
                getPages: RouteHelper.routes,
                // routes: {
                // 'onboard': (context)=> OnboardingScreenOne(),
                //  'home' : (context)=>  LoginCheck()
              );
            })
        ));
    //);
  }
}
