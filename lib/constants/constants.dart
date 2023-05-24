import 'package:flutter/material.dart';

import '../model/language_model.dart';

//colors used in this app
const Color white = Colors.white;
const Color black = Colors.black;
const Color yellow = Color(0xFFFFD54F);

//default app padding
const double appPadding = 20.0;

class AppConstants{

  static const String COUNTRY_CODE='country_Code';
  static const String LANGUAGE_CODE ='language_code';

  static List<LanguageModel> languages =[

    LanguageModel(languageName: 'English', languageCode: 'en', countryCode: 'US'),
    LanguageModel(languageName: 'Nepali', languageCode: 'nep', countryCode: 'NP'),


  ];

}