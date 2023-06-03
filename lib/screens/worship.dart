import 'package:divya/services/song_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../componet/mini_player.dart';
import '../model/song.dart';
import '../widgets/song_widget.dart';

class WorshipSongPage extends StatefulWidget {
  const WorshipSongPage({Key? key}) : super(key: key);

  @override
  State<WorshipSongPage> createState() => _WorshipSongPage();
}

class _WorshipSongPage extends State<WorshipSongPage> {
  late SharedPreferences _prefs;
  List<Song> newList = [];
  int currentCategoryIndex = 0;
  bool searching = false;
  List<Song> _songList = [];
  List<Song> _cacheLists = [];
  FocusNode focusNode = FocusNode();

  // Future<void> _initPrefs() async {
  //   _prefs = await SharedPreferences.getInstance();
  // }

  @override
  void initState() {
    Provider.of<SongProvider>(context, listen: false)
        .getSongsByCollection('Worship')
        .then((value) async {
      setState(() {
        _songList = value;
      });

      DefaultCacheManager cacheManager = DefaultCacheManager();
      for (var i = 0; i < _songList.length; i++) {
        final mu = await cacheManager
            .getSingleFile(Uri.encodeFull(_songList[i].music));
        final ti = await cacheManager.getSingleFile(_songList[i].title);
        final ur = await cacheManager.getSingleFile(_songList[i].url);
        final na = await cacheManager.getSingleFile(_songList[i].name);

        final _cacheList =
            Song(music: mu.path, title: ti.path, url: ur.path, name: na.path);
        _cacheLists.add(_cacheList);
        print(_cacheLists);
      }

      //_initPrefs();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          "आराधनाका गीतहरू",
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
      //         bottomNavigationBar:
      //             provider.playingSong != null ? Container(
      // constraints: BoxConstraints(
      //                 minHeight: MediaQuery
      //                     .of(context)
      //                     .size
      //                     .height * 0.06,
      //                 minWidth: MediaQuery
      //                     .of(context)
      //                     .size
      //                     .width * 0.1,),
      //                 child: MiniPlayer()) : null,
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
                      color: Color.fromRGBO(192, 192, 192, 0.9),
                      spreadRadius: 3.0,
                      blurRadius: 6.0,
                      offset: Offset(-6, -2)),
                ],
                borderRadius: BorderRadius.all(Radius.circular(300)),
                border: Border.all(color: Colors.grey.shade300, width: 10),
                image: const DecorationImage(
                    image: AssetImage('images/worship.jpg'), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            const Center(
              child: Text('आओ,हामी दण्डवत् गरौं र निहुरौं ।',
                  style: TextStyle(fontSize: 18)),
            ),
            const Center(
              child: Text('भजनसंग्रह ९५:६',
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
                        playingSongList: _songList,
                      );
                    },
                  ),
            const SizedBox(height: 50),
          ]))
          // _html(context)

          ),
      floatingActionButton: provider.playingSong != null ? MiniPlayer() : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, // change the location here
    );
  }

//body
}
