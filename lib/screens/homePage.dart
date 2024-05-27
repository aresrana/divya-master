import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divya/screens/Dedication.dart';
import 'package:divya/screens/gospel.dart';
import 'package:divya/screens/newYear.dart';
import 'package:divya/screens/praise.dart';
import 'package:divya/screens/prayer.dart';
import 'package:divya/screens/rapture.dart';
import 'package:divya/screens/resurrection.dart';
import 'package:divya/screens/romanized.dart';
import 'package:divya/screens/trackRecording/trackList.dart';
import 'package:divya/screens/witness.dart';
import 'package:divya/services/searchSong.dart';
import 'package:divya/services/song_provider.dart';
import 'package:epub_view/epub_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/subMeetingModel.dart';
import '../model/song.dart';
import '../services/auth.dart';
import 'Meetings/meetings.dart';
import 'Promise.dart';
import 'atirikta.dart';
import 'calling.dart';
import 'christLife.dart';
import 'death.dart';
import 'worship.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int currentCategoryIndex = 0;
  final User? user = Auth().currentUser;
  bool searching = false;
  File? _imageFile;
  late Future<File?> _imageFuture;

  //1-first create a song list that you gonna display in the page
  List<Song> _songList = [];
  FocusNode focusNode = FocusNode();
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    // _imageFuture = showData();
    // });
    Provider.of<SongProvider>(context, listen: false)
        .getSongsByCollection('Worship')
        .then((value) {
      if (mounted) {
        setState(() {
          _songList = value;
        });
      }
    });

    _stream = FirebaseFirestore.instance.collection('Countries').snapshots();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final provider = context.watch<SongProvider>();
    return Scaffold(
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //
                //   children: [
                child: Column(children: [
                  Text('Dear ${user?.email}',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                  Text('Praise_the_Lord'.tr,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(179, 179, 179, 100))),
                  SizedBox(height: 15),
                ]),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(children: [
                    SizedBox(width: 5),
                    Text('सियोनका गीतहरू'.tr,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                  ])),
              const SizedBox(
                height: 10,
              ),
              _songs(context),
              const SizedBox(height: 5),
              Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(children: [
                    SizedBox(width: 10),
                    Text('सभाका गीतहरू'.tr,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                  ])),
              const SizedBox(
                height: 20,
              ),
              _meetings(context),
              const SizedBox(height: 20),
              Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(children: [
                    SizedBox(width: 10),
                    Text('Romanized Songs'.tr,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                  ])),
              const SizedBox(height: 20),
              _romanizedSong(context),
              const SizedBox(height: 20),
              Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(children: [
                    SizedBox(width: 10),
                    Text('Recording Tracks'.tr,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                  ])),
              const SizedBox(height: 20),
              _trackRecording(context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.10),
              // Container(
              //     padding: const EdgeInsets.only(left: 10),
              //     child: Row(children: const [
              //       Icon(Icons.music_note_sharp, color: Colors.indigo, size: 20),
              //       SizedBox(width: 10),
              //       Text('Recommended Songs', style: TextStyle(fontSize: 18))
              //     ])),
              //             const SizedBox(height: 15),
              // provider.isLoading
              //     ? const CircularProgressIndicator()
              //     //4-Create your own widget to display the song list i recommend keeping this one
              //     : ListView.builder(
              //         shrinkWrap: true,
              //         primary: false,
              //         padding: const EdgeInsets.symmetric(horizontal: 10),
              //         itemCount: _songList.length,
              //         itemBuilder: (context, index) {
              //           final song = _songList[index];
              //           //5-pass the song and the song list to SongWidget
              //           return SongWidget(song: song, playingSongList: _songList);
              //         },
              //       ),
              // const SizedBox(height: 50),
            ]))
            // _html(context)

            ));
    //);
  }

  Widget _songs(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.22,
        padding: const EdgeInsets.only(left: 5),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.18,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: const DecorationImage(
                        image: AssetImage('images/worship.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorshipSongPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "Worship".tr,
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(children: [
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.18,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: const DecorationImage(
                        image: AssetImage('images/praise.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PraisePage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "Praise".tr,
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(children: [
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.18,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: const DecorationImage(
                        image: AssetImage('images/pray.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PrayerPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "Pray".tr,
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              ),
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(children: [
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.18,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: const DecorationImage(
                        image: AssetImage('images/promise.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PromisePage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "Promise".tr,
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(children: [
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.18,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: const DecorationImage(
                        image: AssetImage('images/dedication.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DedicationPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "Dedication".tr,
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(children: [
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.18,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: const DecorationImage(
                        image: AssetImage('images/witness.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WitnessPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "Witness".tr,
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(children: [
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.18,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: const DecorationImage(
                        image: AssetImage('images/life.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChristLifePage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "Christian_Life".tr,
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(children: [
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.18,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    //  border: Border.all(color: Colors.grey.shade300, width: 8),
                    image: const DecorationImage(
                        image: AssetImage('images/cross.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CallingPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "Christ's_Call".tr,
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(children: [
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.18,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: const DecorationImage(
                        image: AssetImage('images/gospel.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GospelPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "Gospel".tr,
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(children: [
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.18,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: const DecorationImage(
                        image: AssetImage('images/resurrection.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResurrectionPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "Resurrection".tr,
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(children: [
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.18,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: const DecorationImage(
                        image: AssetImage('images/rapture.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RapturePage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "Rapture".tr,
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(children: [
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.18,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: const DecorationImage(
                        image: AssetImage('images/tomb.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DeathPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "Death".tr,
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(children: [
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.18,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: const DecorationImage(
                        image: AssetImage('images/renew.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewYearPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "New_Year".tr,
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(children: [
              GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.18,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    image: const DecorationImage(
                        image: AssetImage('images/Atirikta.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AtiriktaPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "Additional".tr,
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
          ],
        ));
  }

  Widget _meetings(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 5),
        height: MediaQuery.of(context).size.height * 0.18,
        child: StreamBuilder<QuerySnapshot>(
            stream: _stream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return Shimmer.fromColors(
                  child: Container(
                    color: Colors.white, // Placeholder color
                  ),
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                );
              }

              // Map each document in the collection to a custom object
              List<MyObject> myObjects = snapshot.data!.docs
                  .map((doc) => MyObject.fromSnapshot(doc))
                  .toList();

              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: myObjects.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              if (snapshot.hasData) {
                                final meetingDocuments = snapshot.data!.docs;
                                if (index < meetingDocuments.length) {
                                  return MyMeetingScreen(
                                    meetingDocuments[index].id,
                                    myObjects[index].country,
                                  );
                                }
                              }
                              return Container(); // Replace with your desired fallback widget or handle the null case accordingly
                            },
                          ));
                        },
                        child: Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Container(
                              width: MediaQuery.of(context).size.height * 0.18,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(22)),
                              ),
                              child: GestureDetector(
                                  child: Card(
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(0.2),
                                              BlendMode.darken),
                                          child: CachedNetworkImage(
                                            imageUrl: myObjects[index].image,
                                            fit: BoxFit.cover,
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.18,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.18,
                                          )),
                                    ),
                                  ],
                                ),
                              )),
                            )));
                  });
            }));
  }

  Widget _romanizedSong(BuildContext context) {
    return Container(
        // height: MediaQuery.of(context).size.height * 0.21,
        padding: const EdgeInsets.only(left: 15),
        child: GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.16,
              // height: 140,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  image: DecorationImage(
                      image: AssetImage('images/worship.jpg'),
                      fit: BoxFit.cover)),
            ),
            onTap: () {

                //         Navigator.of(context).push(PageTransition(
                // child:  EpubReader()
                // type: PageTransitionType.rightToLeft,
                // duration: const Duration(milliseconds: 600),
                // reverseDuration: const Duration(milliseconds: 600),
                // opaque: false)


              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EpubReaders()));


  }
        ));
  }

  Widget _trackRecording(BuildContext context) {
    return Container(
        // height: MediaQuery.of(context).size.height * 0.21,
        padding: const EdgeInsets.only(left: 15),
        child: GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.height * 0.16,
              // height: 140,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  image: DecorationImage(
                      image: AssetImage('images/equalizer.jpg'),
                      fit: BoxFit.cover)),
            ),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => SearchSongsPage(songList: _songList)));
            }));
  }
}
