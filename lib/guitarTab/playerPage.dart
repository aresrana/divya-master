import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:divya/screens/homePage.dart';
import 'package:divya/services/audio_player_service.dart';
import 'package:divya/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../componet/mini_player.dart';
import '../screens/trial.dart';
import '../services/song_provider.dart';

class BottomNavPage extends StatefulWidget {


  const BottomNavPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  late ValueNotifier<File?> _imageNotifier;
  File? _imageFile;
  bool isPlaying = false;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _imageNotifier = ValueNotifier<File?>(null);
    init();

  }
  void init() async {
    final provider = Provider.of<SongProvider>(context, listen: false);
    await provider.getSongsByCollection('Worship').then((value) {
      provider.setPlayingList(value);
    });
    AudioPlayeService.instance.onAudioComplet = () {
      provider.playNextSong();
      AudioPlayeService.instance.playSong(provider.playingSong!);
    };
    _imageNotifier.value = _imageFile;
  }

  final screens = [
    MyHomePage(),
    const DashBoard(),
    //const Playlist(),
    const DashBoard(),
    SettingsPage()
  ];

  @override
  void dispose() {
    AudioPlayeService.instance.dispose();
    super.dispose();
  }

  final items = const [
    Icon(Icons.home, size: 20,color: Colors.white,),
     Icon(Icons.music_note, size: 20,color:Colors.white),
    Icon(Icons.add , size: 20,color: Colors.white),
    Icon(Icons.settings, size:20,color: Colors.white),

  ];
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SongProvider>(context);
    return WillPopScope(
        onWillPop: ()
        async {
      return false;

        }
        , child:


      SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        body: screens[index],
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (provider.playingSong != null)  MiniPlayer(),
            CurvedNavigationBar(
              animationCurve: Curves.fastLinearToSlowEaseIn,
              items: items,
              index: index,
              height: 60,
              color: Color.fromRGBO(18,18, 18,1) ,
              backgroundColor:  Color.fromRGBO(18,18, 18,1) ,
                buttonBackgroundColor: Color.fromRGBO(18,18, 18,1) ,
              onTap: (index) => setState(() => this.index = index),
            ),
          ],
          // floatingActionButton: (widget.le!.isNotEmpty)? _playerControl(context):null,
        ),
      ),
    ));
  }
}
