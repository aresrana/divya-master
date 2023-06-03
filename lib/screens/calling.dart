import 'package:divya/services/song_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../componet/mini_player.dart';
import '../model/song.dart';
import '../widgets/song_widget.dart';

class CallingPage extends StatefulWidget {
  const CallingPage({Key? key}) : super(key: key);

  @override
  State<CallingPage> createState() => _CallingPageState();
}

class _CallingPageState extends State<CallingPage> {
  int currentCategoryIndex = 0;
  bool searching = false;
  List<Song> _songList = [];
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    Provider.of<SongProvider>(context, listen: false)
        .getSongsByCollection('Calling')
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
        appBar: AppBar(
          backgroundColor: Colors.grey[300],
          elevation: 0,
          title: Text(
            "मसीही आह्वानका गीतहरू",
            style: TextStyle(color: Colors.black),
          ),
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
                      image: AssetImage('images/cross.jpg'), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(
                height: 28,
              ),
              const Center(
                child: Text('पपरमेश्वरको राज्य र उहाँको धार्मिकताको खोज गर।',
                    style: TextStyle(fontSize: 18)),
              ),
              const Center(
                child: Text('मती ६:३३',
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

            ));
  }

//body
}
