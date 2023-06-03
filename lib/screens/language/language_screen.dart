import 'package:divya/controllers/language_controller.dart';
import 'package:divya/widgets/language_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../componet/mini_player.dart';
import '../../services/song_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      appBar: AppBar(
        title: Text("Account".tr),
        toolbarHeight: 40,
        elevation: 0,
        backgroundColor: Colors.grey.withOpacity(0.05),
        leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context)
            // Navigator.push(
            // context,
            // MaterialPageRoute(
            //     builder: (context) =>
            //         SettingsPage())), // pop the current route when the back button is pressed
            ),
      ),
      body: SafeArea(child:
          GetBuilder<LocalizationController>(builder: (localizationController) {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              color: Color.fromRGBO(18, 18, 18, 1),
              child: Card(
                color: Color.fromRGBO(18, 18, 18, 1),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Select_Language'.tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            mainAxisSpacing: 20,
                            // Adjust the vertical spacing between items
                            crossAxisSpacing:
                                0, // Adjust the horizontal spacing between items
                          ),
                          itemCount: 2,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) =>
                              LanguageWidget(
                            languageModel:
                                localizationController.languages[index],
                            localizationController: localizationController,
                            index: index,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      })),
      floatingActionButton: provider.playingSong != null ? MiniPlayer() : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, //
    );
  }
}
