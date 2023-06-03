import 'package:divya/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/language_controller.dart';
import '../model/language_model.dart';

class LanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final LocalizationController localizationController;
  final int index;

  LanguageWidget({
    required this.languageModel,
    required this.localizationController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        localizationController.setLanguage(Locale(
          AppConstants.languages[index].languageCode,
          AppConstants.languages[index].countryCode,
        ));
        localizationController.setSelectIndex(index);
      },
      leading: Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.white,
          radioTheme: RadioThemeData(
            fillColor: MaterialStateColor.resolveWith((states) => Colors.green),
          ),
        ),
        child: Radio<int>(
          value: index,
          groupValue: localizationController.selectedIndex,
          onChanged: (int? value) {
            localizationController.setLanguage(Locale(
              AppConstants.languages[value!].languageCode,
              AppConstants.languages[value].countryCode,
            ));
            localizationController.setSelectIndex(value);
          },
        ),
      ),
      title: Text(
        languageModel.languageName.tr,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}
