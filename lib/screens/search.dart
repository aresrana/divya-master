import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../model/song.dart';
import '../services/audio_player_service.dart';
import '../services/auth.dart';
import '../services/song_provider.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String keyword = "";



  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<List<DocumentSnapshot>> searchDocuments(String keyword) async {
    final List<QuerySnapshot> snapshots = await Future.wait([
      FirebaseFirestore.instance
          .collection('Worship')
          .where('search', arrayContains: keyword)
          .get(),
      FirebaseFirestore.instance
          .collection('Praise')
          .where('search', arrayContains: keyword)
          .get(),
      FirebaseFirestore.instance
          .collection('Pray')
          .where('search', arrayContains: keyword)
          .get(),
      FirebaseFirestore.instance
          .collection('Countries/ZHi1WnS3maIggJGFJymD/Meetings/4laRfp0CdH8yE6r7IXrx/Location/OmLWliL7boKVQtTfvpLi/Years/4MUj1kbwXUNsBB7yWNCJ/Songs')
          .where('search', arrayContains: keyword)
          .get(),

    ]);



    List<DocumentSnapshot> results = [];
    for (var snapshot in snapshots) {
      results.addAll(snapshot.docs);
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<SongProvider>();

    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      endDrawerEnableOpenDragGesture: false,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: Color.fromRGBO(18, 18, 18, 1),
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: Color.fromARGB(50, 255, 255, 255),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      hintText: "search".tr,
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      alignLabelWithHint: false,
                    ),
                    onChanged: (val) {
                      setState(() {
                        keyword = val;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            keyword = '';
                          });
                        },
                        icon: Icon(Icons.clear, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: searchDocuments(keyword),
        builder: (context, results) {
          if (results.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (results.hasData) {
            final List<DocumentSnapshot> documents = results.data!;
            if (documents.isEmpty) {
              return Center(
                child: Text('No results found.'),
              );
            } else {
              final List<Song> songs = documents.map((doc) {
                final Map<String, dynamic> data =
                    doc.data() as Map<String, dynamic>;
                return Song.fromMap(data);
              }).toList();

              SchedulerBinding.instance?.addPostFrameCallback((_) {
                provider.setSearchResults(songs);
              });

              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot document = documents[index];
                  return Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: GestureDetector(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              ((document.data()
                                          as Map<String, dynamic>)['name'] ??
                                      '') +
                                  "   " +
                                  ((document.data()
                                          as Map<String, dynamic>)['title'] ??
                                      ''),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () async {
                        FocusScope.of(context).unfocus();

                        final DocumentSnapshot document = documents[index];
                        final String collectionName = document.reference.parent!.id; // Retrieve the collection name
                        final List<DocumentSnapshot> playlist = await FirebaseFirestore.instance
                            .collection(collectionName)
                        .orderBy('name')
                            .get()
                            .then((snapshot) => snapshot.docs);

                        final List<Song> songs = playlist.map((doc) => Song.fromMap(doc.data() as Map<String, dynamic>)).toList();

                        provider.setPlayingList(songs);
                        provider.setPlayingState(false);

                        final Song selectedSong = Song.fromMap(document.data() as Map<String, dynamic>);
                        provider.setPlayingSong(selectedSong);

                        AudioPlayerService.instance.playSong(selectedSong);

                        final List<String> files = (document.data() as Map<String, dynamic>)['files'];
                        print('List of Files: $files');
                      },

                      // onTap: () async {
                      //   final DocumentSnapshot document = documents[index];
                      //   final String collectionName = document.reference.parent!.id; // Retrieve the collection name
                      //   final List<DocumentSnapshot> playlist = await FirebaseFirestore.instance
                      //       .collection(collectionName)
                      //       .orderBy('name')
                      //       .get()
                      //       .then((snapshot) => snapshot.docs);
                      //
                      //   final List<Song> songs = playlist.map((doc) => Song.fromMap(doc.data() as Map<String, dynamic>)).toList();
                      //
                      //   provider.setPlayingList(songs);
                      //   provider.setPlayingState(false);
                      //   provider.setPlayingSong(songs[index]);
                      //   AudioPlayerService.instance.playSong(songs[index]);
                      // },

                      // onTap: () {
                      //   final List<Song> songs = documents.map((doc) {
                      //     final Map<String, dynamic> data =
                      //         (doc.data() as Map<String, dynamic>?)!;
                      //     return Song.fromMap(data);
                      //   }).toList();
                      //
                      //   provider.setPlayingList(songs);
                      //   provider.setPlayingState(false);
                      //   provider.setPlayingSong(songs[index]);
                      //   AudioPlayerService.instance.playSong(songs[index]);
                      // },
                    ),
                  );
                },
              );
            }
          } else if (results.hasError) {
            return Center(
              child: Text('Error: ${results.error}'),
            );
          } else {
            return Center(
              child: Text('Enter a search keyword.'),
            );
          }
        },
      ),
    );
  }
}
