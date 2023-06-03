// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:logger/logger.dart';
//
// import '../../widgets/timer_widget.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => MaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData(
//       brightness: Brightness.dark,
//       backgroundColor: Colors.red.shade900,
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           padding: const EdgeInsets.all(16),
//           shape: const CircleBorder(),
//           primary: Colors.white,
//           onPrimary: Colors.black,
//         ),
//       ),
//       textTheme: const TextTheme(
//         bodyText2: TextStyle(
//           fontSize: 80,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//     home: const MainPage(),
//   );
// }
//
// class MainPage extends StatefulWidget {
//   const MainPage({Key? key}) : super(key: key);
//
//   @override
//   _MainPageState createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   final timerController = TimerController();
//   final recorder = FlutterSoundRecorder();
//   bool isRecorderReady = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     initRecorder();
//   }
//
//   @override
//   void dispose() {
//     recorder.closeRecorder();
//
//     super.dispose();
//   }
//
//   Future initRecorder() async {
//     final status = await Permission.microphone.request();
//
//     if (status == PermissionStatus.granted) {
//       recorder.setLogLevel(Level.error);
//
//       await recorder.openRecorder();
//       isRecorderReady = true;
//     }
//   }
//
//   Future record() async {
//     if (!isRecorderReady) return;
//
//     if (recorder.isPaused) {
//       await recorder.resumeRecorder();
//     } else {
//       await recorder.startRecorder(toFile: 'audio');
//     }
//
//     timerController.startTimer();
//   }
//
//   Future pause() async {
//     if (!isRecorderReady) return;
//
//     await recorder.pauseRecorder();
//     timerController.pauseTimer();
//   }
//
//   Future stop() async {
//     if (!isRecorderReady) return;
//
//     final path = await recorder.stopRecorder();
//     final audioFile = File(path!);
//     print('Recorded audio: $audioFile');
//
//     timerController.resetTimer();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isRecording = recorder.isRecording;
//
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TimerWidget(controller: timerController),
//             const SizedBox(height: 32),
//             Stack(
//               children: [
//                 Center(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       primary: isRecording ? Colors.green : Colors.white,
//                     ),
//                     child: Icon(
//                       isRecording ? Icons.pause : Icons.mic,
//                       color: isRecording ? Colors.white : Colors.black,
//                       size: 80,
//                     ),
//                     onPressed: () async {
//                       if (recorder.isRecording) {
//                         await pause();
//                       } else {
//                         await record();
//                       }
//
//                       setState(() {});
//                     },
//                   ),
//                 ),
//                 if (isRecording)
//                   Positioned(
//                     left: -190,
//                     right: 0,
//                     bottom: 0,
//                     child: Center(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           primary: Colors.red.shade400,
//                         ),
//                         child: const Icon(Icons.delete, color: Colors.white),
//                         onPressed: () async {
//                           await stop();
//                           setState(() {});
//                         },
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
