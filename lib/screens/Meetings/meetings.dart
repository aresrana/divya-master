import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divya/screens/Meetings/places.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../componet/mini_player.dart';
import '../../model/subMeetingModel.dart';
import '../../services/song_provider.dart';

class MyMeetingScreen extends StatefulWidget {
  final String countryName;
  final String country;

  MyMeetingScreen(this.country, this.countryName);

  @override
  _MyMeetingScreenState createState() => _MyMeetingScreenState();
}

class _MyMeetingScreenState extends State<MyMeetingScreen> {
  late List<MyMeetingObject> myMeetingObjects = [];

//  late List<bool> isSelected;
  bool _showPlaces = false;
  int selectedIndex = -1;
  late List<DocumentSnapshot> meetingDocuments = [];
  DocumentSnapshot<Object?>? _selectedMeeting;
  List<bool> selectedCards = [];


  @override
  void initState() {
    super.initState();
    initializeSelectedCards();

    // Set the status bar color to transparent
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    FirebaseFirestore.instance
        .collection('Countries/${widget.country}/Meetings')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        meetingDocuments = querySnapshot.docs;
      });
      initializeSelectedCards();
    });
  }

  void initializeSelectedCards() {
    selectedCards = List.generate(
      meetingDocuments.length,
          (index) => index == 0,
    );
  }



  void togglePlaces(int index) {
    setState(() {
      if (selectedCards.isEmpty) {
        initializeSelectedCards();
      }

      if (selectedIndex == index) {
        selectedIndex = -1;
        _selectedMeeting = null;
      } else {
        selectedIndex = index;
        _selectedMeeting = meetingDocuments[selectedIndex];
      }

      for (int i = 0; i < selectedCards.length; i++) {
        selectedCards[i] = (i == selectedIndex);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();

    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        elevation: 0,
        title: Text(
          'Meetings'.tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Countries/${widget.country}/Meetings')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Shimmer.fromColors(
                      child: Container(
                        color: Colors.white, // Placeholder color
                      ),
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                    ),
                  );
                }

                final meetingDocuments = snapshot.data!.docs;

                return Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: SizedBox.expand(
                    child: Stack(
                      children: List.generate(meetingDocuments.length, (index) {
                        final document = meetingDocuments[index];
                        final meeting = document['meeting'] as String;
                        final imageUrl = document['image'] as String;
                        bool isSelected = selectedCards[index];

                        return Positioned(
                          top: index * 70.0,
                          left: index * 1.0,
                          child: GestureDetector(
                            onTap: () {
                              togglePlaces(index);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width *
                                  0.94, // Specify the desired width
                              height: MediaQuery.of(context).size.height *
                                  0.27, // Specify the desired height
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Stack(
                                    children: [
                                      if (imageUrl != null)
                                        CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          placeholder: (BuildContext context,
                                                  String url) =>
                                              Shimmer.fromColors(
                                            child: Container(
                                              color: Colors
                                                  .white, // Placeholder color
                                            ),
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                          ),
                                          errorWidget: (BuildContext context,
                                                  String url, dynamic error) =>
                                              Container(
                                            color: Colors
                                                .grey, // Placeholder color
                                          ),
                                        ),
                                      Positioned(
                                        top: 20.0,
                                        left: 20.0,
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          // Aligns the text to the center
                                          meeting.tr,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "abcdef",
                                          ),
                                        ),
                                      ),
                                      if (isSelected)
                                        Positioned(
                                          top: 30.0,
                                          right: 15.0,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.black,
                                            size: 15.0,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          ),
          Visibility(
            visible: selectedCards.any((isSelected) => isSelected),
            child: selectedCards.any((isSelected) => isSelected)
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                      child: PlacesScreen(
                        meeting: meetingDocuments[selectedCards.indexOf(true)]
                            ['meeting'] as String,
                        meetingId:
                            meetingDocuments[selectedCards.indexOf(true)].id,
                        country: widget.country,
                      ),
                    ),
                  )
                : Text("No Data Available"),
          ),
        ],
      ),
      floatingActionButton: provider.playingSong != null ? MiniPlayer() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
