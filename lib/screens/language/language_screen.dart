import 'package:divya/controllers/language_controller.dart';
import 'package:divya/widgets/language_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child:
          GetBuilder<LocalizationController>(builder: (localizationController) {
        return Column(
          children: [
            Expanded(
                child: Center(
                    child: Scrollbar(
                        child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(5),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Image.asset(
                        "images/praise.jpg",
                        width: 120,
                      )),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Image.asset(
                          "images/gospel.jpg",
                          width: 140,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Select_Language'.tr,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                          ),
                          itemCount: 2,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) =>
                              LanguageWidget(
                                  languageModel:
                                      localizationController.languages[index],
                                  localizationController:
                                      localizationController,
                                  index: index)),
                      SizedBox(
                        height: 10,
                      ),
                      Text('you_can_change_language'.tr),
                    ],
                  ),
                ),
              ),
            ))))
          ],
        );
      }),
    ));
  }
}
