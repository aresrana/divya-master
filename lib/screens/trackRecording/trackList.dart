import 'package:divya/services/song_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../componet/mini_player.dart';
import '../../model/song.dart';
import '../../widgets/trackWidget.dart';

class TrackList extends StatefulWidget {
  const TrackList({Key? key}) : super(key: key);

  @override
  State<TrackList> createState() => _TrackListState();
}

class _TrackListState extends State<TrackList> {
  int currentCategoryIndex = 0;
  bool searching = false;
  List<Song> _songList = [];
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    Provider.of<SongProvider>(context, listen: false)
        .getSongsByCollection('Gospel')
        .then((value) {
      setState(() {
        _songList = value;
      });
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
              provider.isLoading
                  ? const CircularProgressIndicator()
                  : ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: _songList.length,
                      itemBuilder: (context, index) {
                        final song = _songList[index];
                        return TrackWidget(
                          song: song,
                          playingSongList: _songList,
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
