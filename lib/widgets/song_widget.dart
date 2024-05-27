// import 'dart:isolate';
// import 'dart:ui';
//
// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:divya/model/song.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:flutter_share/flutter_share.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
//
// import '../screens/lyrics.dart';
// import '../services/audio_player_service.dart';
// import '../services/song_provider.dart';
//
// class SongWidget extends StatefulWidget {
//   final Song song;
//   final List<Song> playingSongList;
//
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   SongWidget({
//     required this.song,
//     required this.playingSongList,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<SongWidget> createState() => _SongWidgetState(song, playingSongList);
// }
//
// class _SongWidgetState extends State<SongWidget> {
//   late final Song song;
//
//   late final List<Song> playingSongList;
//
//   _SongWidgetState(this.song, this.playingSongList);
//
//   Future download(String song) async {
//     var status = await Permission.storage.request();
//     if (status.isGranted) {
//       final baseStorage = await getExternalStorageDirectory();
//
//       await FlutterDownloader.enqueue(
//           url: song,
//           savedDir: baseStorage!.path,
//           showNotification: true,
//           openFileFromNotification: true,
//           saveInPublicStorage: true);
//     }
//   }
//
//   ReceivePort _port = ReceivePort();
//
//   @override
//   void initState() {
//     super.initState();
//
//     IsolateNameServer.registerPortWithName(
//         _port.sendPort, 'downloader_send_port');
//     _port.listen((dynamic data) {
//       String id = data[0];
//       DownloadTaskStatus status = data[1];
//       int progress = data[2];
//       if (status == DownloadTaskStatus.complete) {
//         print('Download Complete');
//       }
//
//       setState(() {});
//     });
//
//     FlutterDownloader.registerCallback(downloadCallback as DownloadCallback);
//   }
//
//   @override
//   void dispose() {
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//     super.dispose();
//   }
//
//   @pragma('vm:entry-point')
//   static void downloadCallback(String id, int status, int progress) {
//     final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
//     send?.send([id, status, progress]);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitDown,
//       DeviceOrientation.portraitUp,
//     ]);
//     final provider = context.read<SongProvider>();
//     return SingleChildScrollView(
//         child: Stack(
//       children: [
//         SizedBox(
//             height: 55,
//             width: MediaQuery.of(context).size.width,
//             child: Container(
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                         color: const Color(0xff090010).withOpacity(0.6),
//                         // Color.fromRGBO(128, 128, 128, 0.1),
//                         spreadRadius: 2.0,
//                         blurRadius: 10.0,
//                         offset: const Offset(5, 5)),
//                     const BoxShadow(
//                         color: Color(0xfffb8b9bc),
//                         //Color.fromRGBO(228,228,228, 0.6),
//                         spreadRadius: 3.0,
//                         blurRadius: 10.0,
//                         offset: Offset(-5, -5)),
//                   ],
//                   borderRadius: const BorderRadius.all(Radius.circular(10)),
//                 ),
//                 child: Card(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.7,
//                           child: InkWell(
//                             splashColor: Colors.grey[300],
//                             child: Row(children: [
//                               const SizedBox(width: 10),
//                               SizedBox(
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.08,
//                                   child: Text(
//                                     song.name,
//                                     textAlign: TextAlign.start,
//                                     style: const TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   )),
//                               SizedBox(
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.1),
//                               Text(
//                                 song.title,
//                                 textAlign: TextAlign.start,
//                                 style: const TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ]),
//                             onTap: () async {
//                              // DefaultCacheManager cacheManager =
//                                  // DefaultCacheManager();
//                            //   await cacheManager
//                                //   .getSingleFile(widget.song.music);
//                               widget.song.music;
//                               provider.setPlayingList(widget.playingSongList);
//                               provider.setPlayingState(false);
//                               provider.setPlayingSong(widget.song);
//                               // provider.setPlayingSong(widget.ares);
//                               AudioPlayerService.instance.playSong(widget.song);
//                             },
//                           ),
//                         ),
//                         // SizedBox(
//                         //     width: MediaQuery.of(context).size.width * 0.09),
//                         // SizedBox(
//                         //     width: MediaQuery.of(context).size.width * 0.2,
//                         //     child: Row(children: [
//                         //       const SizedBox(
//                         //         width: 2,
//                         //       ),
//                         //       IconButton(
//                         //         icon: const Icon(Icons.bookmark_sharp),
//                         //         onPressed: () {
//                         //           Navigator.push(
//                         //               context,
//                         //               MaterialPageRoute(
//                         //                   builder: (context) => Lyrics(
//                         //                       widget.song.url,
//                         //                       widget.song.title)));
//                         //         },
//                         //       ),
//                         //       // const SizedBox(
//                         //       //   width: 2,
//                         //       // ),
//                         //       // IconButton(
//                         //       //   icon: const Icon(Icons.download),
//                         //       //   onPressed: () async {
//                         //       //     await FlutterShare.share(
//                         //       //       title: 'Check out this song!',
//                         //       //       text:
//                         //       //           '${widget.song.title} - ${widget.song.name}',
//                         //       //       linkUrl: widget.song.music,
//                         //       //       chooserTitle: 'Share this song',
//                         //       //     );
//                         //       //     download(widget.song.music);
//                         //       //   },
//                         //       // )
//                         //     ]))
//                       ],
//                     )))),
//       ],
//     ));
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:divya/model/song.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import '../services/audio_player_service.dart';
// import '../services/songHelper.dart';
// import '../services/song_provider.dart';
//
// class SongWidget extends StatefulWidget {
//   final Song song;
//   final List<Song> playingSongList;
//
//   const SongWidget({
//     required this.song,
//     required this.playingSongList,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<SongWidget> createState() => _SongWidgetState();
// }
//
// class _SongWidgetState extends State<SongWidget> {
//   late final Song song;
//
//   late final List<Song> playingSongList;
//
//   @override
//   void initState() {
//     super.initState();
//     song = widget.song;
//     playingSongList = widget.playingSongList;
//   }
//
//   Future<void> _playSong(BuildContext context) async {
//     final provider = context.read<SongProvider>();
//
//     // Check if song is cached
//     final fileInfo = await DefaultCacheManager().getFileFromCache(song.music);
//
//     if (fileInfo != null && fileInfo.file != null) {
//       // Song is available in cache, play it directly
//       print('Song is loaded from cache: ${song.title}');
//       provider.setPlayingList(playingSongList);
//       provider.setPlayingState(false);
//       provider.setPlayingSong(song);
//       AudioPlayerService.instance.playSong(song);
//     } else {
//       // Fetch song from the local database
//       final songFromDB = await SongDatabaseHelper.getSongByMusic(song.music);
//
//       if (songFromDB != null) {
//         // Song is available in local database, play it directly
//         print('Song is loaded from local database: ${song.title}');
//         provider.setPlayingList(playingSongList);
//         provider.setPlayingState(false);
//         provider.setPlayingSong(songFromDB);
//         AudioPlayerService.instance.playSong(songFromDB);
//       } else {
//         // Song is not available locally, fetch from Firestore and then play
//         print('Fetching song from Firestore: ${song.title}');
//         List<Song> songsFromFirestore = await Provider.of<SongProvider>(context, listen: false).getSongsByCollection('Worship');
//         final songFromFirestore = songsFromFirestore.firstWhere((element) => element.music == song.music, orElse: () => song);
//
//         // Update the local database and cache
//         await SongDatabaseHelper.insertSong(songFromFirestore);
//         await DefaultCacheManager().downloadFile(songFromFirestore.music);
//
//         // Play the song
//         print('Song ${song.title} fetched from Firestore and cached.');
//         provider.setPlayingList(playingSongList);
//         provider.setPlayingState(false);
//         provider.setPlayingSong(songFromFirestore);
//         AudioPlayerService.instance.playSong(songFromFirestore);
//       }
//     }
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitDown,
//       DeviceOrientation.portraitUp,
//     ]);
//     return SingleChildScrollView(
//       child: Stack(
//         children: [
//           SizedBox(
//             height: 55,
//             width: MediaQuery.of(context).size.width,
//             child: Container(
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xff090010).withOpacity(0.6),
//                     spreadRadius: 2.0,
//                     blurRadius: 10.0,
//                     offset: const Offset(5, 5),
//                   ),
//                   const BoxShadow(
//                     color: Color(0xfffb8b9bc),
//                     spreadRadius: 3.0,
//                     blurRadius: 10.0,
//                     offset: Offset(-5, -5),
//                   ),
//                 ],
//                 borderRadius: const BorderRadius.all(Radius.circular(10)),
//               ),
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: InkWell(
//                   splashColor: Colors.grey[300],
//                   onTap: () => _playSong(context),
//                   child: Row(
//                     children: [
//                       const SizedBox(width: 10),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.08,
//                         child: Text(
//                           song.name,
//                           textAlign: TextAlign.start,
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           song.title,
//                           textAlign: TextAlign.start,
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:provider/provider.dart';
// import '../model/song.dart';
// import '../services/audio_player_service.dart';
// import '../services/songHelper.dart';
// import '../services/song_provider.dart';
//
// class SongWidget extends StatefulWidget {
//   final Song song;
//   final List<Song> playingSongList;
//   final String collectionName;
//
//   const SongWidget({
//     required this.song,
//     required this.playingSongList,
//     required this.collectionName,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<SongWidget> createState() => _SongWidgetState();
// }
//
// class _SongWidgetState extends State<SongWidget> {
//   late final Song song;
//   late final List<Song> playingSongList;
//   late final String collectionName;
//
//   @override
//   void initState() {
//     super.initState();
//     song = widget.song;
//     playingSongList = widget.playingSongList;
//     collectionName = widget.collectionName;
//   }
//
//   Future<void> _playSong(BuildContext context) async {
//     final provider = context.read<SongProvider>();
//
//     // Check if song is cached
//     final fileInfo = await DefaultCacheManager().getFileFromCache(song.music);
//
//     if (fileInfo != null && fileInfo.file != null) {
//       // Song is available in cache, play it directly
//       print('Song is loaded from cache: ${song.title}');
//       provider.setPlayingList(playingSongList);
//       provider.setPlayingState(false);
//       provider.setPlayingSong(song);
//       AudioPlayerService.instance.playSong(song);
//     } else {
//       // Fetch song from the local database
//       final songFromDB = await SongDatabaseHelper.getSongByMusic(song.music);
//
//       if (songFromDB != null) {
//         // Song is available in local database, play it directly
//         print('Song is loaded from local database: ${song.title}');
//         provider.setPlayingList(playingSongList);
//         provider.setPlayingState(false);
//         provider.setPlayingSong(songFromDB);
//         AudioPlayerService.instance.playSong(songFromDB);
//       } else {
//         // Song is not available locally, fetch from Firestore and then play
//         print('Fetching song from Firestore: ${song.title}');
//         List<Song> songsFromFirestore = await Provider.of<SongProvider>(context, listen: false).getSongsByCollection(collectionName);
//         final songFromFirestore = songsFromFirestore.firstWhere((element) => element.music == song.music, orElse: () => song);
//
//         // Update the local database and cache
//         await SongDatabaseHelper.insertSong(songFromFirestore);
//         await DefaultCacheManager().downloadFile(songFromFirestore.music);
//
//         // Play the song
//         print('Song ${song.title} fetched from Firestore and cached.');
//         provider.setPlayingList(playingSongList);
//         provider.setPlayingState(false);
//         provider.setPlayingSong(songFromFirestore);
//         AudioPlayerService.instance.playSong(songFromFirestore);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitDown,
//       DeviceOrientation.portraitUp,
//     ]);
//     return SingleChildScrollView(
//       child: Stack(
//         children: [
//           SizedBox(
//             height: 55,
//             width: MediaQuery.of(context).size.width,
//             child: Container(
//               decoration: BoxDecoration(
//                 boxShadow: [
//                   BoxShadow(
//                     color: const Color(0xff090010).withOpacity(0.6),
//                     spreadRadius: 2.0,
//                     blurRadius: 10.0,
//                     offset: const Offset(5, 5),
//                   ),
//                   const BoxShadow(
//                     color: Color(0xfffb8b9bc),
//                     spreadRadius: 3.0,
//                     blurRadius: 10.0,
//                     offset: Offset(-5, -5),
//                   ),
//                 ],
//                 borderRadius: const BorderRadius.all(Radius.circular(10)),
//               ),
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: InkWell(
//                   splashColor: Colors.grey[300],
//                   onTap: () => _playSong(context),
//                   child: Row(
//                     children: [
//                       const SizedBox(width: 10),
//                       SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.08,
//                         child: Text(
//                           song.name,
//                           textAlign: TextAlign.start,
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           song.title,
//                           textAlign: TextAlign.start,
//                           style: const TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import '../model/song.dart';
import '../services/audio_player_service.dart';
import '../services/songHelper.dart';
import '../services/song_provider.dart';

class SongWidget extends StatefulWidget {
  final Song song;
  final List<Song> playingSongList;
  final String collectionName;

  const SongWidget({
    required this.song,
    required this.playingSongList,
    required this.collectionName,
    Key? key,
  }) : super(key: key);

  @override
  State<SongWidget> createState() => _SongWidgetState();
}

class _SongWidgetState extends State<SongWidget> {
  late final Song song;
  late final List<Song> playingSongList;
  late final String collectionName;

  @override
  void initState() {
    super.initState();
    song = widget.song;
    playingSongList = widget.playingSongList;
    collectionName = widget.collectionName;
  }

  Future<void> _playSong(BuildContext context) async {
    final provider = context.read<SongProvider>();

    // Check if song is cached
    final fileInfo = await DefaultCacheManager().getFileFromCache(song.music);

    if (fileInfo != null && fileInfo.file != null) {
      // Song is available in cache, play it directly
      print('Song is loaded from cache: ${song.title}');
      provider.setPlayingList(playingSongList);
      provider.setPlayingState(false);
      provider.setPlayingSong(song);
      AudioPlayerService.instance.playSong(song);
    } else {
      // Fetch song from the local database
      final songFromDB = await SongDatabaseHelper.getSongByMusic(song.music);

      if (songFromDB != null) {
        // Song is available in local database, play it directly
        print('Song is loaded from local database: ${song.title}');
        provider.setPlayingList(playingSongList);
        provider.setPlayingState(false);
        provider.setPlayingSong(songFromDB);
        AudioPlayerService.instance.playSong(songFromDB);
      } else {
        // Song is not available locally, fetch from Firestore and then play
        print('Fetching song from Firestore: ${song.title}');
        List<Song> songsFromFirestore = await Provider.of<SongProvider>(context, listen: false).getSongsByCollection(collectionName);
        final songFromFirestore = songsFromFirestore.firstWhere((element) => element.music == song.music, orElse: () => song);

        // Update the local database and cache
        await SongDatabaseHelper.insertSong(songFromFirestore);
        await DefaultCacheManager().downloadFile(songFromFirestore.music);

        // Play the song
        print('Song ${song.title} fetched from Firestore and cached.');
        provider.setPlayingList(playingSongList);
        provider.setPlayingState(false);
        provider.setPlayingSong(songFromFirestore);
        AudioPlayerService.instance.playSong(songFromFirestore);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
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
                    spreadRadius: 2.0,
                    blurRadius: 10.0,
                    offset: const Offset(5, 5),
                  ),
                  const BoxShadow(
                    color: Color(0xfffb8b9bc),
                    spreadRadius: 3.0,
                    blurRadius: 10.0,
                    offset: Offset(-5, -5),
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  splashColor: Colors.grey[300],
                  onTap: () => _playSong(context),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.08,
                        child: Text(
                          song.name,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          song.title,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
