import 'dart:isolate';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divya/model/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../screens/trackRecording/recordingPage.dart';
import '../services/song_provider.dart';

class TrackWidget extends StatefulWidget {
  final Song song;
  final List<Song> playingSongList;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TrackWidget({
    required this.song,
    required this.playingSongList,
    Key? key,
  }) : super(key: key);

  @override
  State<TrackWidget> createState() => _TrackWidget(song, playingSongList);
}

class _TrackWidget extends State<TrackWidget> {
  late final Song song;

  late final List<Song> playingSongList;

  _TrackWidget(this.song, this.playingSongList);

  Future download(String song) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();

      await FlutterDownloader.enqueue(
          url: song,
          savedDir: baseStorage!.path,
          showNotification: true,
          openFileFromNotification: true,
          saveInPublicStorage: true);
    }
  }

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if (status == DownloadTaskStatus.complete) {
        print('Download Complete');
      }

      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    final provider = context.read<SongProvider>();
    return SingleChildScrollView(
        child: Stack(
      children: [
        SizedBox(
            height: 55,
            width: MediaQuery.of(context).size.width,
            child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xff090010).withOpacity(0.6),
                        // Color.fromRGBO(128, 128, 128, 0.1),
                        spreadRadius: 2.0,
                        blurRadius: 10.0,
                        offset: const Offset(5, 5)),
                    const BoxShadow(
                        color: Color(0xfffb8b9bc),
                        //Color.fromRGBO(228,228,228, 0.6),
                        spreadRadius: 3.0,
                        blurRadius: 10.0,
                        offset: Offset(-5, -5)),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: GestureDetector(
                            child: Row(children: [
                              const SizedBox(width: 10),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                  child: Text(
                                    song.name,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.1),
                              Text(
                                song.title,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                            onTap: () async {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return RecordingPage();
                                  },
                                ),
                              );

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => RecordingPage()),
                              // );
                              // DefaultCacheManager cacheManager = DefaultCacheManager();
                              // await cacheManager.getSingleFile(widget.song.music);
                              //
                              // provider.setPlayingList(widget.playingSongList);
                              // provider.setPlayingState(false);
                              // provider.setPlayingSong(widget.song);
                              // // provider.setPlayingSong(widget.ares);
                              // AudioPlayerService.instance.playSong(widget.song);
                            },
                          ),
                        ),
                        // SizedBox(
                        //     width: MediaQuery.of(context).size.width * 0.08),
                        // SizedBox(
                        //     width: MediaQuery.of(context).size.width * 0.25,
                        //     child: Row(children: [
                        //         const SizedBox(
                        //         width: 2,
                        //       ),
                        //       IconButton(
                        //         icon: const Icon(Icons.play_arrow),
                        //         onPressed: () {
                        //           provider.setPlayingList(widget.playingSongList);
                        //           provider.setPlayingState(false);
                        //           provider.setPlayingSong(widget.song);
                        //           // provider.setPlayingSong(widget.ares);
                        //           AudioPlayerService.instance.playSong(widget.song);
                        //         },
                        //       ),
                        //       const SizedBox(
                        //         width: 2,
                        //       ),
                        //       IconButton(
                        //         icon: const Icon(Icons.fiber_manual_record_sharp  ),
                        //         onPressed: () {
                        //           download(widget.song.music);
                        //         },
                        //       )
                        //     ]))
                      ],
                    )))),
      ],
    ));
  }
}
