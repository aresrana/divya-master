import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:volume_controller/volume_controller.dart';

import '../../../widgets/timer_widget.dart';

class RecordingPage extends StatefulWidget {
  @override
  _RecordingPageState createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  late final RecorderController recorderController;
  bool _isPlaying = false;
  bool _isRecording = false;
  final timerController = TimerController();
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  bool _isExpanded = false;
  bool _isMuted = false;
  double _setVolumeValueTrack = 0;
  double _volumeListenerValueTrack = 0;
  bool _isPlayingTrack = false;
  bool _isRecordingTrack = false;
  double _setVolumeValueRec = 0;
  double _volumeListenerValueTrackRec = 0;
  bool _isPlayingRec = false;
  Duration audioDuration = Duration.zero;
  Duration elapsedDuration = Duration.zero;
  Duration remainingDuration = Duration.zero;
  late final PlayerController controller;

  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;
  bool isLoading = true;
  late Directory appDirectory;
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    _getDir();
    controller = PlayerController();
    controller.onCompletion.listen((event) {
      controller.seekTo(0);
    });

    VolumeController().getVolume().then((value) {
      setState(() {
        _isMuted = value == 0.0;
      });
      controller = PlayerController();
    });
    // Listen to system volume change
    VolumeController().listener((volume) {
      setState(() {
        _volumeListenerValueTrack = volume;

        _volumeListenerValueTrackRec = volume;
      });
    });

    VolumeController().getVolume().then((volume) {
      _setVolumeValueTrack = volume;
      _setVolumeValueRec = volume;
    });
    initRecorder();
    _initPlayer();
  }

  void _initPlayer() async {
    String url =
        'https://firebasestorage.googleapis.com/v0/b/html-740f9.appspot.com/o/Atirikta%2F23%20mero%20hriday%20ko%20upasna.mp3?alt=media&token=687a4812-f0c3-4571-a18e-430ea015c4b2';
    // Play the recorded audio file
    String audioFilePath;
    final directory = await getApplicationDocumentsDirectory();
    audioFilePath = '${directory.path}/audio.mp3';

    final dio = Dio();
    await dio.download(url, audioFilePath);

    // Once the file is downloaded and saved, you can pass the local file path to the PlayerController
    await controller.preparePlayer(path: audioFilePath);
    final waveformData = await controller.extractWaveformData(
      path: audioFilePath,
      noOfSamples: 100,
    );

    setState(() {});
  }

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    path = "${appDirectory.path}/recording.m4a";
    files = await appDirectory.list().toList();

    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    VolumeController().removeListener();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status == PermissionStatus.granted) {
      await recorder.openRecorder();

      isRecorderReady = true;
      recorder.setSubscriptionDuration(
        const Duration(milliseconds: 500),
      );
    }
    {
      throw 'Microphone Permission Not Granted';
    }
  }

  Future playTrack() async {
    controller.startPlayer();
  }

  Future pauseTrack() async {
    controller.pausePlayer();
  }

  Future resetTrack() async {
    controller.seekTo(0);
  }

  Future record() async {
    if (!isRecorderReady) return;

    if (recorder.isPaused) {
      await recorder.resumeRecorder();
    } else {
      await recorder.startRecorder(toFile: 'audio');
    }

    timerController.startTimer();
  }

  Future stop() async {
    if (!isRecorderReady) return;

    final path = await recorder.stopRecorder();
    final audioFile = File(path!);

    print('Recorded audio: $audioFile');

    timerController.resetTimer();
  }

  Future pause() async {
    if (!isRecorderReady) return;

    await recorder.pauseRecorder();
    timerController.pauseTimer();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: AnimatedSwitcher(
                      switchInCurve: Curves.fastLinearToSlowEaseIn,
                      duration: const Duration(milliseconds: 200),
                      child: AudioFileWaveforms(
                        size: Size(MediaQuery.of(context).size.width, 100.0),
                        playerController: controller,
                        continuousWaveform: false,
                        enableSeekGesture: true,
                        waveformType: WaveformType.fitWidth,
                        waveformData: controller.waveformData,
                        playerWaveStyle: const PlayerWaveStyle(
                            seekLineColor: Colors.black,
                            fixedWaveColor: Colors.red,
                            liveWaveColor: Colors.black,
                            spacing: 8,
                            showSeekLine: true,
                            showBottom: true,
                            showTop: true,
                            waveCap: StrokeCap.butt),
                      ))),
            )
          ]),

          Container(
            color: Colors.grey[300],
            height: MediaQuery.of(context).size.height *
                0.15, // set the desired height of your custom widget
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    setState(() {
                      playTrack();
                      _isPlaying = !_isPlaying;
                    });
                  },
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  icon: const Icon(Icons.stop),
                  onPressed: () async {
                    await stop();
                    pauseTrack();
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: Icon(
                    recorder.isRecording ? Icons.pause : Icons.mic,
                  ),
                  onPressed: () async {
                    if (recorder.isRecording) {
                      await pause();
                    } else {
                      await record();
                    }
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: Icon(Icons.undo_outlined),
                  onPressed: () {
                    setState(() {
                      resetTrack();
                      _isRecording = !_isRecording;
                    });
                  },
                ),
              ],
            ),
          ),

          //
          // Row(
          //   children: [
          //     GestureDetector(
          //         onTap: () {
          //           setState(() {
          //             _isExpanded = !_isExpanded;
          //           });
          //         },
          //         child: AnimatedContainer(
          //             duration: const Duration(milliseconds: 500),
          //             curve: Curves.easeInOut,
          //             width: _isExpanded
          //                 ? MediaQuery.of(context).size.width * 0.4
          //                 : MediaQuery.of(context).size.width * 0.1,
          //             height: MediaQuery.of(context).size.height * 0.85,
          //             decoration: BoxDecoration(
          //               border: Border(
          //                 right: const BorderSide(
          //                   color: Colors.black,
          //                   width: 1.0,
          //                 ),
          //                 bottom: const BorderSide(
          //                   color: Colors.black,
          //                   width: 1.0,
          //                 ),
          //               ),
          //             ),
          //             child: Column(children: [
          //               Container(
          //                 width: _isExpanded
          //                     ? MediaQuery.of(context).size.width * 0.4
          //                     : MediaQuery.of(context).size.width * 0.1,
          //                 height: MediaQuery.of(context).size.height * 0.15,
          //                 decoration: BoxDecoration(
          //                   border: Border(
          //                     bottom: const BorderSide(
          //                       color: Colors.black,
          //                       width: 1.0,
          //                     ),
          //                   ),
          //                 ),
          //                 child: Row(children: [
          //                   SizedBox(
          //                     width: 10,
          //                   ),
          //                   Expanded(
          //                     child: Container(
          //                         child: _isExpanded
          //                             ? Row(
          //                                 mainAxisAlignment:
          //                                     MainAxisAlignment.start,
          //                                 children: [
          //                                   IconButton(
          //                                     icon: Icon(
          //                                       _isMuted
          //                                           ? Icons.mic_off
          //                                           : Icons.mic_none,
          //                                     ),
          //                                     onPressed: () async {
          //                                       if (recorder.isRecording) {
          //                                         await pause();
          //                                       } else {
          //                                         await record();
          //                                       }
          //
          //                                       setState(() {});
          //                                     },
          //                                   ),
          //                                   SizedBox(
          //                                     width: 10,
          //                                   ),
          //                                   IconButton(
          //                                     splashColor: Colors.transparent,
          //                                     icon: Icon(_isPlayingTrack
          //                                         ? Icons.pause
          //                                         : Icons.play_arrow),
          //                                     onPressed: () {
          //                                       setState(() {
          //                                         _isPlayingTrack =
          //                                             !_isPlayingTrack;
          //                                       });
          //                                     },
          //                                   ),
          //                                   SizedBox(
          //                                     width: 10,
          //                                   ),
          //                                   SliderTheme(
          //                                     data: SliderThemeData(
          //                                         thumbShape:
          //                                             RoundSliderThumbShape(
          //                                                 enabledThumbRadius:
          //                                                     4.0)),
          //                                     child: Slider(
          //                                       min: 0,
          //                                       max: 1,
          //                                       onChanged: (double value) {
          //                                         setState(() {
          //                                           _setVolumeValueTrack =
          //                                               value;
          //                                           VolumeController().setVolume(
          //                                               _setVolumeValueTrack);
          //                                         });
          //                                       },
          //                                       value: _setVolumeValueTrack,
          //                                       activeColor: Colors.black,
          //                                       inactiveColor: Colors.white,
          //                                     ),
          //                                   ),
          //                                   SizedBox(
          //                                     width: 10,
          //                                   ),
          //                                   Icon(Icons.audiotrack_rounded)
          //                                 ],
          //                               )
          //                             : Icon(Icons.audiotrack_rounded)),
          //                   ),
          //                 ]),
          //               )
          //             ]))),
          //
          //     //
          //     //
          //     // Expanded(
          //     //  child :SingleChildScrollView(
          //     // scrollDirection: Axis.horizontal,
          //     //
          //     // child: Container(
          //     // //  color: Colors.grey[300],
          //     //   width: MediaQuery.of(context).size.width,
          //     //   decoration: BoxDecoration(
          //     //           border: Border(
          //     //             right: const BorderSide(
          //     //               color: Colors.black,
          //     //               width: 1.0,
          //     //             ),
          //     //             bottom: const BorderSide(
          //     //               color: Colors.black,
          //     //               width: 1.0,
          //     //             ),
          //     //           ),
          //     //         ),
          //     //
          //     // )
          //     //  )
          //     //   )
          //   ],
          // )

          //  Row(
          //    children:[
          //
          //      Expanded(
          //          child:
          //          GestureDetector(
          //  onTap: () {
          //   setState(() {
          //     _isExpanded = !_isExpanded;
          //   });
          // },
          //
          //   child: AnimatedContainer(
          //     duration: const Duration(milliseconds: 300),
          //     height: MediaQuery.of(context).size.height*0.85,
          //     width: _isExpanded
          //         ? MediaQuery.of(context).size.width * 0.01
          //         : MediaQuery.of(context).size.width * 0.01,
          //     // Change the height based on isExpanded value
          //     decoration: BoxDecoration(
          //       border: Border(
          //         right: const BorderSide(
          //           color: Colors.black,
          //           width: 1.0,
          //         ),
          //         bottom: const BorderSide(
          //           color: Colors.black,
          //           width: 1.0,
          //         ),
          //       ),
          //     ),
          //     child:
          //
          //     Column(children: [
          //       Container(
          //         height: MediaQuery.of(context).size.height * 0.2,
          //         decoration: BoxDecoration(
          //           border: Border(
          //             bottom: const BorderSide(
          //               color: Colors.black,
          //               width: 1.0,
          //             ),
          //           ),
          //         ),
          //         child: Row(children: [
          //           SizedBox(
          //             width: 10,
          //           ),
          //           Expanded(
          //             child: Container(
          //                 child: _isExpanded
          //                     ? Row(
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   children: [
          //                     IconButton(
          //                       icon: Icon(
          //                         _isMuted
          //                             ? Icons.mic_off
          //                             : Icons.mic_none,
          //                       ),
          //                       onPressed: () async {
          //                         if (recorder.isRecording) {
          //                           await pause();
          //                         } else {
          //                           await record();
          //                         }
          //
          //                         setState(() {});
          //                       },
          //                     ),
          //                     SizedBox(
          //                       width: 10,
          //                     ),
          //                     IconButton(
          //                       splashColor: Colors.transparent,
          //                       icon: Icon(_isPlayingTrack
          //                           ? Icons.pause
          //                           : Icons.play_arrow),
          //                       onPressed: () {
          //                         setState(() {
          //                           _isPlayingTrack = !_isPlayingTrack;
          //                         });
          //                       },
          //                     ),
          //                     SizedBox(
          //                       width: 10,
          //                     ),
          //                     SliderTheme(
          //                       data: SliderThemeData(
          //                           thumbShape: RoundSliderThumbShape(
          //                               enabledThumbRadius: 4.0)),
          //                       child: Slider(
          //                         min: 0,
          //                         max: 1,
          //                         onChanged: (double value) {
          //                           setState(() {
          //                             _setVolumeValueTrack = value;
          //                             VolumeController().setVolume(
          //                                 _setVolumeValueTrack);
          //                           });
          //                         },
          //                         value: _setVolumeValueTrack,
          //                         activeColor: Colors.black,
          //                         inactiveColor: Colors.white,
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       width: 10,
          //                     ),
          //                     Icon(Icons.audiotrack_rounded)
          //                   ],
          //                 )
          //                     : Icon(Icons.audiotrack_rounded)),
          //           ),
          //         ]),
          //       ),
          //       Container(
          //         height: MediaQuery.of(context).size.height * 0.2,
          //         decoration: BoxDecoration(
          //           border: Border(
          //             bottom: const BorderSide(
          //               color: Colors.black,
          //               width: 1.0,
          //             ),
          //           ),
          //         ),
          //         child: Row(children: [
          //           SizedBox(
          //             width: 10,
          //           ),
          //           Expanded(
          //             child: Container(
          //                 child: _isExpanded
          //                     ? Row(
          //                   mainAxisAlignment: MainAxisAlignment.start,
          //                   children: [
          //                     IconButton(
          //                       icon: Icon(
          //                         _isMuted
          //                             ? Icons.mic_off
          //                             : Icons.mic_none,
          //                       ),
          //                       onPressed: () async {
          //                         if (recorder.isRecording) {
          //                           await pause();
          //                         } else {
          //                           await record();
          //                         }
          //
          //                         setState(() {});
          //                       },
          //                     ),
          //                     SizedBox(
          //                       width: 10,
          //                     ),
          //                     IconButton(
          //                       splashColor: Colors.transparent,
          //                       icon: Icon(_isPlayingRec
          //                           ? Icons.pause
          //                           : Icons.play_arrow),
          //                       onPressed: () {
          //                         setState(() {
          //                           _isPlayingRec = !_isPlayingRec;
          //                         });
          //                       },
          //                     ),
          //                     SizedBox(
          //                       width: 10,
          //                     ),
          //                     SliderTheme(
          //                       data: SliderThemeData(
          //                           thumbShape: RoundSliderThumbShape(
          //                               enabledThumbRadius: 4.0)),
          //                       child: Slider(
          //                         min: 0,
          //                         max: 1,
          //                         onChanged: (double value) {
          //                           setState(() {
          //                             _setVolumeValueRec = value;
          //                             VolumeController().setVolume(
          //                                 _setVolumeValueRec);
          //                           });
          //                         },
          //                         value: _setVolumeValueRec,
          //                         activeColor: Colors.black,
          //                         inactiveColor: Colors.white,
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       width: 10,
          //                     ),
          //                     Icon(Icons.audiotrack_rounded)
          //                   ],
          //                 )
          //                     : Icon(Icons.audiotrack_rounded)),
          //           ),
          //         ]),
          //       )
          //     ]),
          //   ),)),
          //
          //      Container(
          //        child: Text("arests"),
          //
          //
          //      )
          //
          //    ]
          //
          //
          //
          //               ),
          //
          //  Expanded(
          //   child: GestureDetector(
          //     onTap: () {
          //       setState(() {
          //         _isExpanded = !_isExpanded;
          //       });
          //     },
          //     child: AnimatedContainer(
          //       duration: const Duration(milliseconds: 300),
          //       width: _isExpanded
          //           ? MediaQuery.of(context).size.width * 0.4
          //           : MediaQuery.of(context).size.height * 0.2,
          //       // Change the height based on isExpanded value
          //       decoration: BoxDecoration(
          //         border: Border(
          //           right: const BorderSide(
          //             color: Colors.black,
          //             width: 1.0,
          //           ),
          //           bottom: const BorderSide(
          //             color: Colors.black,
          //             width: 1.0,
          //           ),
          //         ),
          //       ),
          //       child:
          //
          //       Column(children: [
          //         Container(
          //           height: MediaQuery.of(context).size.height * 0.2,
          //           decoration: BoxDecoration(
          //             border: Border(
          //               bottom: const BorderSide(
          //                 color: Colors.black,
          //                 width: 1.0,
          //               ),
          //             ),
          //           ),
          //           child: Row(children: [
          //             SizedBox(
          //               width: 10,
          //             ),
          //             Expanded(
          //               child: Container(
          //                   child: _isExpanded
          //                       ? Row(
          //                           mainAxisAlignment: MainAxisAlignment.start,
          //                           children: [
          //                             IconButton(
          //                               icon: Icon(
          //                                 _isMuted
          //                                     ? Icons.mic_off
          //                                     : Icons.mic_none,
          //                               ),
          //                               onPressed: () async {
          //                                 if (recorder.isRecording) {
          //                                   await pause();
          //                                 } else {
          //                                   await record();
          //                                 }
          //
          //                                 setState(() {});
          //                               },
          //                             ),
          //                             SizedBox(
          //                               width: 10,
          //                             ),
          //                             IconButton(
          //                               splashColor: Colors.transparent,
          //                               icon: Icon(_isPlayingTrack
          //                                   ? Icons.pause
          //                                   : Icons.play_arrow),
          //                               onPressed: () {
          //                                 setState(() {
          //                                   _isPlayingTrack = !_isPlayingTrack;
          //                                 });
          //                               },
          //                             ),
          //                             SizedBox(
          //                               width: 10,
          //                             ),
          //                             SliderTheme(
          //                               data: SliderThemeData(
          //                                   thumbShape: RoundSliderThumbShape(
          //                                       enabledThumbRadius: 4.0)),
          //                               child: Slider(
          //                                 min: 0,
          //                                 max: 1,
          //                                 onChanged: (double value) {
          //                                   setState(() {
          //                                     _setVolumeValueTrack = value;
          //                                     VolumeController().setVolume(
          //                                         _setVolumeValueTrack);
          //                                   });
          //                                 },
          //                                 value: _setVolumeValueTrack,
          //                                 activeColor: Colors.black,
          //                                 inactiveColor: Colors.white,
          //                               ),
          //                             ),
          //                             SizedBox(
          //                               width: 10,
          //                             ),
          //                             Icon(Icons.audiotrack_rounded)
          //                           ],
          //                         )
          //                       : Icon(Icons.audiotrack_rounded)),
          //             ),
          //           ]),
          //         ),
          //         Container(
          //           height: MediaQuery.of(context).size.height * 0.2,
          //           decoration: BoxDecoration(
          //             border: Border(
          //               bottom: const BorderSide(
          //                 color: Colors.black,
          //                 width: 1.0,
          //               ),
          //             ),
          //           ),
          //           child: Row(children: [
          //             SizedBox(
          //               width: 10,
          //             ),
          //             Expanded(
          //               child: Container(
          //                   child: _isExpanded
          //                       ? Row(
          //                           mainAxisAlignment: MainAxisAlignment.start,
          //                           children: [
          //                             IconButton(
          //                               icon: Icon(
          //                                 _isMuted
          //                                     ? Icons.mic_off
          //                                     : Icons.mic_none,
          //                               ),
          //                               onPressed: () async {
          //                                 if (recorder.isRecording) {
          //                                   await pause();
          //                                 } else {
          //                                   await record();
          //                                 }
          //
          //                                 setState(() {});
          //                               },
          //                             ),
          //                             SizedBox(
          //                               width: 10,
          //                             ),
          //                             IconButton(
          //                               splashColor: Colors.transparent,
          //                               icon: Icon(_isPlayingRec
          //                                   ? Icons.pause
          //                                   : Icons.play_arrow),
          //                               onPressed: () {
          //                                 setState(() {
          //                                   _isPlayingRec = !_isPlayingRec;
          //                                 });
          //                               },
          //                             ),
          //                             SizedBox(
          //                               width: 10,
          //                             ),
          //                             SliderTheme(
          //                               data: SliderThemeData(
          //                                   thumbShape: RoundSliderThumbShape(
          //                                       enabledThumbRadius: 4.0)),
          //                               child: Slider(
          //                                 min: 0,
          //                                 max: 1,
          //                                 onChanged: (double value) {
          //                                   setState(() {
          //                                     _setVolumeValueRec = value;
          //                                     VolumeController().setVolume(
          //                                         _setVolumeValueRec);
          //                                   });
          //                                 },
          //                                 value: _setVolumeValueRec,
          //                                 activeColor: Colors.black,
          //                                 inactiveColor: Colors.white,
          //                               ),
          //                             ),
          //                             SizedBox(
          //                               width: 10,
          //                             ),
          //                             Icon(Icons.audiotrack_rounded)
          //                           ],
          //                         )
          //                       : Icon(Icons.audiotrack_rounded)),
          //             ),
          //           ]),
          //         )
          //       ]),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
