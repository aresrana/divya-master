import 'package:divya/services/song_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:divya/model/song.dart';
import '../componet/mini_player.dart';
import '../services/songHelper.dart';
import '../widgets/song_widget.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


class PraisePage extends StatefulWidget {
  const PraisePage({Key? key}) : super(key: key);

  @override
  State<PraisePage> createState() => _PraisePageState();
}

class _PraisePageState extends State<PraisePage> {
  List<Song> _songList = [];


  @override
  void initState() {
    super.initState();
    _fetchSongsAndCache();
  }

  Future<void> _fetchSongsAndCache() async {
    // Fetch songs directly from Firestore
    List<Song> songs = await Provider.of<SongProvider>(context, listen: false).getSongsByCollection('Praise');
    setState(() {
      _songList = songs;
    });

    // Cache and store songs in the local database
    await _cacheSongs(songs);

    // Update the song list


    // Print the count of songs
    print('Count of songs: ${_songList.length}');
  }

  Future<void> _cacheSongs(List<Song> songs) async {
    for (var song in songs) {
      // Check if the song is already cached
      FileInfo? fileInfo = await DefaultCacheManager().getFileFromCache(song.music);
      if (fileInfo == null || fileInfo.file == null) {
        // Cache the song if not already cached
        await DefaultCacheManager().downloadFile(song.music);
        print('Song ${song.title} cached successfully.');
      } else {
        print('Song ${song.title} is already cached.');
        print('Song ${song.title} is already cached.');
      }

      // Check if the song is stored in the local database
      bool songExists = await SongDatabaseHelper.songExists(song.music);
      if (!songExists) {
        // Insert the song into the local database
        await SongDatabaseHelper.insertSong(song);
        print('Song ${song.title} stored in the local database.');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    final provider = context.watch<SongProvider>();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "प्रशंसाका गीतहरू",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.grey[300],
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(
                context), // pop the current route when the back button is pressed
          ),
        ),
        backgroundColor: Colors.grey[300],
        floatingActionButton:
            provider.playingSong != null ? MiniPlayer() : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
              SizedBox(
                height: 18,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.36,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        spreadRadius: 3.0,
                        blurRadius: 6.0,
                        offset: Offset(6, 2)),
                    BoxShadow(
                        color: Color.fromRGBO(255, 255, 255, 0.9),
                        spreadRadius: 3.0,
                        blurRadius: 6.0,
                        offset: Offset(-6, -2)),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(300)),
                  border: Border.all(color: Colors.grey.shade300, width: 12),
                  image: const DecorationImage(
                      image: AssetImage('images/praise.jpg'),
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                height: 28,
              ),
              const Center(
                child: Text('म सदा-सर्वदा तपाईंको नामको प्रशंसा गर्नेछु।',
                    style: TextStyle(
                      fontSize: 18,
                    )),
              ),
              const Center(
                child: Text('भजनसंग्रह १४५:२',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ),
              const SizedBox(
                height: 40,
              ),
              provider.isLoading
                  ? const CircularProgressIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: _songList.length,
                      itemBuilder: (context, index) {
                        final song = _songList[index];
                        return SongWidget(
                          song: song,
                          playingSongList: _songList, collectionName: 'Praise',
                        );
                      },
                    ),
              const SizedBox(height: 50),
            ]))
            // _html(context)

            ));
  }

//body
}


