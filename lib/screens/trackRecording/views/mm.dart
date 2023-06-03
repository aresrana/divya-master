// // import 'dart:io';
// //
// // import 'package:audio_waveforms/audio_waveforms.dart';
// // import 'package:dio/dio.dart';
// // import 'package:file_picker/file_picker.dart';
// //
// // import 'package:flutter/material.dart';
// // import 'package:path_provider/path_provider.dart';
// //
// // void main() => runApp(const MyApp());
// //
// // class MyApp extends StatelessWidget {
// //   const MyApp({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       title: 'Audio Waveforms',
// //       debugShowCheckedModeBanner: false,
// //       home: Home(),
// //     );
// //   }
// // }
// //
// // class Home extends StatefulWidget {
// //   const Home({Key? key}) : super(key: key);
// //
// //   @override
// //   State<Home> createState() => _HomeState();
// // }
// //
// // class _HomeState extends State<Home> {
// //   late final RecorderController recorderController;
// //   late final PlayerController controller;
// //
// //   String? path;
// //   String? musicFile;
// //   bool isRecording = false;
// //   bool isRecordingCompleted = false;
// //   bool isLoading = true;
// //   late Directory appDirectory;
// //   List<FileSystemEntity> files = [];
// //
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _getDir();
// //     _initialiseControllers();
// //      controller = PlayerController();                   // Initialise
// //
// //   }
// //
// //   void _getDir() async {
// //     appDirectory = await getApplicationDocumentsDirectory();
// //     path = "${appDirectory.path}/recording.m4a";
// //     files = await appDirectory.list().toList();
// //
// //     isLoading = false;
// //     setState(() {});
// //   }
// //
// //   void _initialiseControllers() {
// //     recorderController = RecorderController()
// //       ..androidEncoder = AndroidEncoder.aac
// //       ..androidOutputFormat = AndroidOutputFormat.mpeg4
// //       ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
// //       ..sampleRate = 44100;
// //   }
// //
// //   void _pickFile() async {
// //     FilePickerResult? result = await FilePicker.platform.pickFiles();
// //     if (result != null) {
// //       musicFile = result.files.single.path;
// //       setState(() {});
// //     } else {
// //       debugPrint("File not picked");
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     recorderController.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFF252331),
// //       appBar: AppBar(
// //         backgroundColor: const Color(0xFF252331),
// //         elevation: 1,
// //         centerTitle: true,
// //         shadowColor: Colors.grey,
// //         title: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Image.asset(
// //               'images/cross.jpg',
// //               scale: 1.5,
// //             ),
// //             const SizedBox(width: 10),
// //             const Text('Simform'),
// //           ],
// //         ),
// //       ),
// //       body: isLoading
// //           ? const Center(
// //               child: CircularProgressIndicator(),
// //             )
// //           : SafeArea(
// //               child: Column(
// //                 children: [
// //                   const SizedBox(height: 20),
// //                   Expanded(
// //                     child: ListView.builder(
// //                       itemCount: 4,
// //                       itemBuilder: (_, index) {
// //                         // final file = recorderController.files[index];
// //                         // return Card(
// //                         //   child: ListTile(
// //                         //     leading: const Icon(Icons.music_note),
// //                         //     title: Text(file.path),
// //                         //     onTap: () {
// //                         //       setState(() {
// //                         //         musicFile = file.path;
// //                         //       });
// //                         //     },
// //                         //   ),
// //                         // );
// //                       },
// //                   )),
// //                   SafeArea(
// //                     child: Column(
// //                       children:[
// //
// //                     Row(
// //                       children: [
// //                                                IconButton(
// //                           onPressed: _refreshWave,
// //                           icon: Icon(
// //                         Icons.play_arrow,
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //                         const SizedBox(width: 16),
// //                         IconButton(
// //                           onPressed: _startOrStopRecording,
// //                           icon: Icon(isRecording ? Icons.stop : Icons.mic),
// //                           color: Colors.white,
// //                           iconSize: 28,
// //                         ),
// //
// //                         IconButton(
// //                           onPressed: _pause,
// //                           icon: Icon(
// //                              Icons.pause,
// //                             color: Colors.white,
// //                           ),
// //                         ),
// //
// //                         // AnimatedSwitcher(
// //                         //   duration: const Duration(milliseconds: 200),
// //                         //   child: isRecording?
// //                         //   AudioWaveforms(
// //                         //           enableGesture: true,
// //                         //           shouldCalculateScrolledPosition: true,
// //                         //           size: Size(
// //                         //               MediaQuery.of(context).size.width / 2,
// //                         //               50),
// //                         //           recorderController: recorderController,
// //                         //           waveStyle:  WaveStyle(
// //                         //             waveColor: Colors.blue,
// //                         //             extendWaveform: true,
// //                         //             showBottom: true,
// //                         //             backgroundColor: Colors.red,
// //                         //             showMiddleLine: true,
// //                         //           ),
// //                         //         ) : Text("Adsfdf")
// //                         //
// //                         //
// //                         // ),
// //
// //         ]
// //                   ),
// //
// //                         AudioFileWaveforms(
// //                           size: Size(MediaQuery.of(context).size.width, 100.0),
// //                           playerController: controller,
// //                           enableSeekGesture: true,
// //                           waveformType: WaveformType.long,
// //                           waveformData: controller.waveformData,
// //                           playerWaveStyle: const PlayerWaveStyle(
// //                             fixedWaveColor: Colors.white54,
// //                             liveWaveColor: Colors.blueAccent,
// //                             spacing: 6,
// //
// //                           ),
// //
// //                         )
// //
// //
// //
// //           ]
// //                     )
// //
// //
// //
// //
// //               )])));
// //
// //
// //   }
// //
// //   void _startOrStopRecording() async {
// //     try {
// //       if (isRecording) {
// //         recorderController.reset();
// //
// //         final path = await recorderController.stop();
// //
// //         if (path != null) {
// //           setState(() {
// //             isRecordingCompleted = true;
// //
// //           });
// //
// //           debugPrint(path);
// //           debugPrint("Recorded file size: ${File(path).lengthSync()}");
// //
// //          String url = 'https://firebasestorage.googleapis.com/v0/b/html-740f9.appspot.com/o/Atirikta%2F23%20mero%20hriday%20ko%20upasna.mp3?alt=media&token=687a4812-f0c3-4571-a18e-430ea015c4b2';
// //           // Play the recorded audio file
// //           String audioFilePath;
// //           final directory = await getApplicationDocumentsDirectory();
// //           audioFilePath = '${directory.path}/audio.mp3';
// //
// //           final dio = Dio();
// //           await dio.download(url, audioFilePath);
// //
// //           // Once the file is downloaded and saved, you can pass the local file path to the PlayerController
// //           await controller.preparePlayer(path: audioFilePath);
// //           await controller.preparePlayer(path: audioFilePath);
// //
// //
// //           final waveformData = await controller.extractWaveformData(
// //             path: 'path',
// //             noOfSamples: 100,
// //           );
// //         }
// //       } else {
// //
// //         await recorderController.record(path: path!);
// //
// //       }
// //     } catch (e) {
// //       debugPrint(e.toString());
// //     } finally {
// //       setState(() {
// //         isRecording = !isRecording;
// //       });
// //     }
// //   }
// //
// //   void _pause() async{
// //     await controller.pausePlayer();
// //
// //   }
// //
// //
// //   void _refreshWave() async {
// //     await controller.startPlayer();
// //     if (isRecording) recorderController.refresh();
// //   }
// // }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart' show AudioFormat, AudioMetering, FlutterAudioRecorder2;
// import 'package:path_provider/path_provider.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Audio Recorder Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AudioRecorderPage(),
//     );
//   }
// }
//
// class AudioRecorderPage extends StatefulWidget {
//   @override
//   _AudioRecorderPageState createState() => _AudioRecorderPageState();
// }
//
// class _AudioRecorderPageState extends State<AudioRecorderPage> {
//   late FlutterAudioRecorder2 audioRecorder;
//   late AudioMetering _currentMetering;
//   bool isRecording = false;
//
//   @override
//   void initState() {
//     super.initState();
//     initializeAudioRecorder();
//   }
//
//   Future<void> initializeAudioRecorder() async {
//     try {
//       String path = (await getExternalStorageDirectory()) as String;
//       String filePath = '${path}/audio.wav';
//
//       audioRecorder = FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.WAV);
//       await audioRecorder.initialized!;
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   void startRecording() async {
//     try {
//       await audioRecorder.start();
//       setState(() {
//         isRecording = true;
//       });
//
//       Timer.periodic(Duration(milliseconds: 100), (Timer timer) async {
//         if (isRecording) {
//           var currentMetering = await audioRecorder.current(channel: 0);
//           setState(() {
//             _currentMetering = currentMetering as AudioMetering;
//           });
//         } else {
//           timer.cancel();
//         }
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   void stopRecording() async {
//     try {
//       await audioRecorder.stop();
//       setState(() {
//         isRecording = false;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Audio Recorder Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextButton(
//               onPressed: isRecording ? null : startRecording,
//               child: Text('Start Recording'),
//             ),
//             SizedBox(height: 16),
//             TextButton(
//               onPressed: isRecording ? stopRecording : null,
//               child: Text('Stop Recording'),
//             ),
//             SizedBox(height: 16),
//             if (_currentMetering != null)
//               WaveProgressWidget(data: _currentMetering),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class WaveProgressWidget extends StatelessWidget {
//   final AudioMetering data;
//
//   WaveProgressWidget({required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 300,
//       height: 100,
//       child: CustomPaint(
//         painter: WavePainter(data: data),
//       ),
//     );
//   }
// }
//
// class WavePainter extends CustomPainter {
//   final AudioMetering data;
//
//   WavePainter({required this.data});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill;
//
//     final width = size.width;
//     final height = size.height;
//
//     final path = Path();
//     path.moveTo(0, height);
//
//     final step = width / (data.meters.length - 1);
//     for (int i = 0; i < data.meters.length; i++) {
//       final x = i * step;
//       final y = height - (data.meters[i] * height);
//       path.lineTo(x, y);
//     }
//
//     path.lineTo(width, height);
//     path.close();
//
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(WavePainter oldDelegate) {
//     return oldDelegate.data != data;
//   }
// }
//
