import 'package:divya/screens/onboarding/screen_one.dart';
import 'package:divya/services/song_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:wiredash/wiredash.dart';

import 'componet/loginCheck.dart';


late int? initScreen;
 Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized( );

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
  );

  await Firebase.initializeApp();

  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen',1);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
     //  Wiredash(
     //    projectId: '$projectid',
     //    secret: '$secret',
     //
     // child:

     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SongProvider(col: '')),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          initialRoute: initScreen ==0 || initScreen == null ? 'onboard' : 'home',
          routes: {
          'onboard': (context)=> OnboardingScreenOne(),
           'home' : (context)=>  LoginCheck()           }
    )
     );
    //);
  }
}
