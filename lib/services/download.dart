//
// import 'dart:isolate';
// import 'dart:ui';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class DownloadingDialog extends StatefulWidget {
//   final String song;
//   final String title;
//
//   const DownloadingDialog({Key? key, required this.song, required this.title})
//       : super(key: key);
//
//   @override
//   State<DownloadingDialog> createState() =>
//       _DownloadingDialogState(song, title);
// }
//
// class _DownloadingDialogState extends State<DownloadingDialog> {
//   late final String? song;
//   late final String? title;
//
//   _DownloadingDialogState(this.song, this.title);
//
//   Future download(String song) async {
//     var status = await Permission.storage.request();
//     if (status.isGranted) {
//       final baseStorage = await getExternalStorageDirectory();
//       await FlutterDownloader.enqueue(
//           url: song,
//           savedDir: baseStorage!.path,
//           showNotification: true,
//           openFileFromNotification: true,
//
//
//
//       );
//     }
//   }
//   ReceivePort _port = ReceivePort();
//
//   @override
//   void initState() {
//     super.initState();
//
//     IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
//     _port.listen((dynamic data) {
//       String id = data[0];
//       DownloadTaskStatus status = data[1];
//       int progress = data[2];
//       if(status == DownloadTaskStatus.complete) {
//
//         print('Download Complete');
//       }
//
//
//       setState((){ });
//     });
//
//     FlutterDownloader.registerCallback(downloadCallback);
//   }
//
//   @override
//   void dispose() {
//     IsolateNameServer.removePortNameMapping('downloader_send_port');
//     super.dispose();
//   }
//
//   @pragma('vm:entry-point')
//   static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
//     final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
//     send?.send([id, status, progress]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return download(widget.song);
//
//
//       AlertDialog(
//         backgroundColor: Colors.black,
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircularProgressIndicator.adaptive(),
//             SizedBox(
//               height: 20,
//             ),
//             Text("Downloading : downloadingProress%",
//               style: TextStyle(color: Colors.white, fontSize: 17),
//
//             )
//
//
//           ],
//
//
//         )
//
//
//     );
//   }
//   }
//
// //   Dio dio = Dio();
// //   double progress = 0.0;
// //
// //   void startDownloading() async {
// //     String url = widget.song;
// //     String fileName = "${widget.title}.mp3";
// //     String path = await _getFilePath(fileName);
// //
// //     await dio.download(
// //      url,
// //       path,
// //       onReceiveProgress: (receivedBytes, totalBytes) {
// //         setState(() {
// //           progress = receivedBytes / totalBytes;
// //         });
// //         print(progress);
// //       },
// //       deleteOnError: true,
// //     ).then((_) {
// //       Navigator.pop(context);
// //     });
// //   }
// //
// //   Future<String> _getFilePath(String fileName) async {
// //     final dir = await getExternalStorageDirectory();
// //
// //
// //     //getApplicationSupportDirectory();
// //
// //   //  getLibraryDirectory();
// //
// //  //   getDownloadsDirectory();
// //     return "${dir?.path}/$fileName";
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     startDownloading();
// //   }
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     String downloadingProress = (progress * 100).toInt().toString();
// //     return AlertDialog(
// //         backgroundColor: Colors.black,
// //         content: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             CircularProgressIndicator.adaptive(),
// //             SizedBox(
// //               height: 20,
// //             ),
// //             Text("Downloading : $downloadingProress%",
// //               style: TextStyle(color: Colors.white, fontSize: 17),
// //
// //             )
// //
// //
// //           ],
// //
// //
// //         )
// //
// //
// //     );
// //   }
// // }