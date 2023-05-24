

import 'package:divya/screens/language/language_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../guitarTab/playerPage.dart';

class RouteHelper {

  static const String initial = '/';
  static const String splash = '/splash';
  static const String language ='/language';
  static String getSplashRoute() => '$splash';
  static String getInitialRoute() => '$initial';
  static String getLanguageRoute()=> '$language';

  static List<GetPage> routes =[

    GetPage(name:splash,page:(){

    return BottomNavPage();
    }),

    GetPage(name:language,page:(){
    return LanguageScreen();

  })

  ];



}