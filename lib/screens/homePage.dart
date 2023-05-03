import 'dart:convert';
import 'dart:io';
import 'package:divya/screens/Dedication.dart';
import 'package:divya/screens/praise.dart';
import 'package:divya/screens/prayer.dart';
import 'package:divya/screens/romanized.dart';
import 'package:divya/screens/witness.dart';
import 'package:divya/services/song_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/song.dart';
import '../services/auth.dart';
import 'Promise.dart';
import 'calling.dart';
import 'christLife.dart';
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

  @override
  void initState() {
    super.initState();
   // _imageFuture = showData();
    // });
    Provider.of<SongProvider>(context, listen: false)
        .getSongsByCollection('Worship')
        .then((value) {
      setState(() {
        _songList = value;
      });
    });
  }

  // Future<File?> showData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final base64Image = prefs.getString('myImageKey');
  //   if (base64Image != null) {
  //     final bytes = base64Decode(base64Image);
  //     final appDir = await getApplicationDocumentsDirectory();
  //     final imageFile = File('${appDir.path}/myImage.jpg');
  //     await imageFile.writeAsBytes(bytes);
  //     setState(() {
  //       _imageFile = imageFile;
  //     });
  //     return _imageFile;
  //   } else {
  //     return null;
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                     child: Column(
                         children: [
                        Text('Dear ${user?.email}',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                        const Text('PRAISE THE LORD (जयमसिही कि!)',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color.fromRGBO(179, 179, 179, 100))),
                        SizedBox(height: 15),
                      ]),
                      // Container(
                      //   height: 50,
                      //   width: 50,
                      //   child: FutureBuilder<File?>(
                      //     future: _imageFuture,
                      //     builder: (context, snapshot) {
                      //       if (snapshot.connectionState ==
                      //           ConnectionState.waiting) {
                      //         return CircularProgressIndicator();
                      //       } else if (snapshot.hasError) {
                      //         return Text('Error: ${snapshot.error}');
                      //       } else if (snapshot.data == null) {
                      //         return Text('No image available');
                      //       } else {
                      //         File imageFile = snapshot.data!;
                      //         return CircleAvatar(
                      //           radius: 20,
                      //           backgroundImage: imageFile != null
                      //               ? FileImage(imageFile!)
                      //               : null,
                      //         );
                      //       }
                      //     },
                      //   ),
                      //
                      //   // Container(
                      //   //     height: 100,
                      //   //     width: 100,
                      //   //     child: FutureBuilder<File?>(
                      //   //       future: _imageFuture,
                      //   //       builder: (context, snapshot) {
                      //   //         if (snapshot.connectionState ==
                      //   //             ConnectionState.waiting) {
                      //   //           return CircularProgressIndicator();
                      //   //         } else if (snapshot.hasError) {
                      //   //           return Text('Error: ${snapshot.error}');
                      //   //         } else if (snapshot.data == null) {
                      //   //           return Text('No image available');
                      //   //         } else {
                      //   //           File imageFile = snapshot.data!;
                      //   //           return CircleAvatar(
                      //   //             radius: 40,
                      //   //             backgroundImage: imageFile != null && imageFile.existsSync()
                      //   //                 ? FileImage(imageFile)
                      //   //                 : null,
                      //   //           );
                      //   //         }
                      //   //       },
                      //   //     )
                      //
                      //   //
                      //   // ValueListenableBuilder<File?>(
                      //   //   valueListenable: imageNotifier,
                      //   //   builder: (context, imageFile, _) {
                      //   //     if (imageFile == null) {
                      //   //       return CircularProgressIndicator(); // show a loading indicator
                      //   //     } else {
                      //   //       return CircleAvatar(
                      //   //         radius: 50,
                      //   //         backgroundImage: FileImage(imageFile),
                      //   //       );
                      //   //     }
                      //   //   },
                      //   // )
                      // ),
                  //  ],
                //  )
        ),
              const SizedBox(
                height: 15,
              ),
              Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(children: const [
                    SizedBox(width: 5),
                    Text('सियोनका गीतहरू',
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
                  child: Row(children: const [
                    SizedBox(width: 10),
                    Text('सभाका गीतहरू',
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
                  child: Row(children: const [
                    SizedBox(width: 10),
                    Text('Romanized Songs',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white))
                  ])),
              const SizedBox(height: 20),
              _romanizedSong(context),
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
            ])

    )
            // _html(context)

            ));
    //);
  }

  Widget _songs(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.21,
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
                "worship(आराधना)",
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
                "praise(प्रशंसा)",
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrayerPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "pray(प्रार्थना)",
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PromisePage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "promise(प्रतिज्ञा)",
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
                "dedication(समर्पण)",
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WitnessPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "witness(साक्षी)",
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
                "Christian life(मसीही जीवन)",
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CallingPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "Lord's call(मसीही आह्वान )",
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorshipSongPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "gospel(सुसमाचार)",
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
                          builder: (context) => WorshipSongPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "resurrection(पुनरूत्थान)",
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorshipSongPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "rapture(दोस्रो आगमन)",
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorshipSongPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "death(मृत्यु)",
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorshipSongPage()));
                },
              ),
              SizedBox(height: 8),
              Text(
                "New Year(नयाँ वर्ष )",
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
          ],
        ));
  }

  Widget _meetings(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.21,
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
                "worship(आराधना)",
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
                "worship(आराधना)",
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
                "worship(आराधना)",
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
                "worship(आराधना)",
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
                "worship(आराधना)",
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
                "worship(आराधना)",
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
                "worship(आराधना)",
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
                "worship(आराधना)",
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
                "worship(आराधना)",
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
                "worship(आराधना)",
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
                "worship(आराधना)",
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
                "worship(आराधना)",
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(179, 179, 179, 100)),
              )
            ]),
          ],
        ));
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
            onTap: () => Navigator.of(context).push(PageTransition(
                child: const EpubReader(),
                type: PageTransitionType.rightToLeft,
                duration: const Duration(milliseconds: 600),
                reverseDuration: const Duration(milliseconds: 600),
                opaque: false))));
  }
}
