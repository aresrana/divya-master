import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:volume_controller/volume_controller.dart';

import '../services/audio_player_service.dart';
import '../services/song_provider.dart';

class TapMiniPlayer extends StatefulWidget {
  const TapMiniPlayer({Key? key}) : super(key: key);

  @override
  State<TapMiniPlayer> createState() => _TapMiniPlayerState();
}

class _TapMiniPlayerState extends State<TapMiniPlayer> {
  double _volumeListenerValue = 0;
  double _getVolume = 0;
  double _setVolumeValue = 0;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    VolumeController().getVolume().then((value) {
      setState(() {
        _isMuted = value == 0.0;
      });
    });
    // Listen to system volume change
    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  String formatTime(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String secondsString = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secondsString';
  }

  @override
  Widget build(BuildContext context) {
    AudioPlayer _audioPlayer = AudioPlayer();
    final audioPlayerService = AudioPlayeService.instance;
    final provider = Provider.of<SongProvider>(context);
    final name = provider.playingSong?.name ?? "N/A";
    final title = provider.playingSong?.title ?? "N/A";
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: SingleChildScrollView(
                child: StreamBuilder<Duration>(
                    stream: AudioPlayeService.instance.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.014,
                                width: MediaQuery.of(context).size.width * 0.1,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              onTap: () => Navigator.pop(context),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.6,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(200)),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 12),
                                image: const DecorationImage(
                                    image: AssetImage('images/saa.jpg'),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.11),

                            Text(
                              name + '   ' + title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),

                            // Row(
                            //      mainAxisAlignment: MainAxisAlignment.center,
                            //      children: [
                            //        Container(
                            //            height:
                            //                MediaQuery.of(context).size.height *
                            //                    0.1,
                            //            width: MediaQuery.of(context).size.width *
                            //                0.8,
                            //            child: Container(
                            //              decoration: BoxDecoration(
                            //                boxShadow: [
                            //                  BoxShadow(
                            //                      color: const Color(0xff090010)
                            //                          .withOpacity(0.6),
                            //                      // Color.fromRGBO(128, 128, 128, 0.1),
                            //                      spreadRadius: 2.0,
                            //                      blurRadius: 10.0,
                            //                      offset: const Offset(5, 5)),
                            //                  const BoxShadow(
                            //                      color: Color(0xfffb8b9bc),
                            //                      //Color.fromRGBO(228,228,228, 0.6),
                            //                      spreadRadius: 3.0,
                            //                      blurRadius: 10.0,
                            //                      offset: Offset(-5, -5)),
                            //                ],
                            //                borderRadius: const BorderRadius.all(
                            //                    Radius.circular(50)),
                            //              ),
                            //              child: Card(
                            //                shape: RoundedRectangleBorder(
                            //                    borderRadius:
                            //                        BorderRadius.circular(50)),
                            //                child: Row(
                            //                  children: [
                            //                    SizedBox(
                            //                      width: MediaQuery.of(context)
                            //                              .size
                            //                              .width *
                            //                          0.1,
                            //                    ),
                            //                    Container(
                            //                        child: IconButton(
                            //                      icon: const Icon(
                            //                        Icons.skip_next,
                            //                        color: Colors.black,
                            //                        size: 40,
                            //                      ),
                            //                      onPressed: () {
                            //                        provider.playNextSong();
                            //                        audioPlayerService.playSong(
                            //                            provider.playingSong!);
                            //                        provider
                            //                            .setPlayingState(false);
                            //                      },
                            //                    )),
                            //                    SizedBox(height: 20),
                            //                    Container(
                            //                        child: IconButton(
                            //                      icon: Icon(
                            //                        provider.isPlaying
                            //                            ? Icons.play_arrow_rounded
                            //                            : Icons.pause,
                            //                        color: Colors.black,
                            //                        size: 40,
                            //                      ),
                            //                      onPressed: () async {
                            //                        if (audioPlayerService
                            //                            .isPlaying) {
                            //                          await audioPlayerService
                            //                              .pause();
                            //                        } else {
                            //                          audioPlayerService.resume();
                            //                        }
                            //                        provider.setPlayingState(
                            //                            audioPlayerService
                            //                                .isPlaying);
                            //                      },
                            //                    )),
                            //                    SizedBox(height: 20),
                            //                    Container(
                            //                        child: IconButton(
                            //                      icon: const Icon(
                            //                        Icons.skip_previous,
                            //                        color: Colors.black,
                            //                        size: 40,
                            //                      ),
                            //                      onPressed: () async {
                            //                        provider.playPrevSong();
                            //                        audioPlayerService.playSong(
                            //                            provider.playingSong!);
                            //                        provider
                            //                            .setPlayingState(false);
                            //                      },
                            //                    )),
                            //                    Container(
                            //                        child: IconButton(
                            //                      icon: const Icon(
                            //                        Icons.replay,
                            //                        color: Colors.black,
                            //                        size: 40,
                            //                      ),
                            //                      onPressed: () async {
                            //                        provider.playPrevSong();
                            //                        audioPlayerService.playSong(
                            //                            provider.playingSong!);
                            //                        provider
                            //                            .setPlayingState(false);
                            //                      },
                            //                    )),
                            //                    Container(
                            //                        child: IconButton(
                            //                      icon:Icon(
                            //                        Icons.volume_off ,
                            //                        color: Colors.black,
                            //                        size: 40,
                            //                      ),
                            //                      onPressed: () async {
                            //                        VolumeController()
                            //                            .muteVolume();
                            //
                            //                      },
                            //                    )
                            //
                            //                    ),
                            //                  ],
                            //                ),
                            //              ),
                            //            )),
                            //      ]),
                            SizedBox(height: 20),
                            SliderTheme(
                              data: SliderThemeData(
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 4.0)),

                              child: Slider(
                                value: position.inSeconds.toDouble(),
                                min: 0,
                                max: audioPlayerService.duration.inSeconds
                                    .toDouble(),
                                onChanged: (double value) {
                                  setState(() {
                                    // position = Duration(seconds: value.toInt());
                                  });
                                },
                                onChangeEnd: (double value) async {
                                  final position =
                                      Duration(seconds: value.toInt());
                                  await _audioPlayer.seek(position);
                                  await _audioPlayer.resume();
                                },
                                activeColor: Colors.white,
                                inactiveColor: Colors.black,
                              ),

                              // Slider(
                              //   value: ,
                              //   min: 0,
                              //   max: audioPlayerService.duration.inSeconds.toDouble(),
                              //   onChanged: (double value) async {
                              //     final position = Duration(seconds: value.toInt());
                              //     setState(() {
                              //       // Update the position to the selected value
                              //       this.position = position;
                              //     });
                              //     await _audioPlayer.seek(position);
                              //   },
                              //   onChangeEnd: (double value) async {
                              //     final position = Duration(seconds: value.toInt());
                              //     await _audioPlayer.seek(position);
                              //     await _audioPlayer.resume();
                              //   },
                              //   activeColor: Colors.white,
                              //   inactiveColor: Colors.black,
                              // )
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatTime(audioPlayerService
                                          .position.inSeconds),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      formatTime((audioPlayerService
                                              .duration.inSeconds -
                                          audioPlayerService
                                              .position.inSeconds)),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                )),

                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    child: IconButton(
                                  icon: const Icon(
                                    Icons.fast_rewind,
                                    color: Colors.black,
                                    size: 45,
                                  ),
                                  onPressed: () async {
                                    provider.playPrevSong();
                                    audioPlayerService
                                        .playSong(provider.playingSong!);
                                    provider.setPlayingState(false);
                                  },
                                )),

                                Container(
                                    child: IconButton(
                                  icon: Icon(
                                    provider.isPlaying
                                        ? Icons.play_arrow_rounded
                                        : Icons.pause,
                                    color: Colors.black,
                                    size: 50,
                                  ),
                                  onPressed: () async {
                                    if (audioPlayerService.isPlaying) {
                                      await audioPlayerService.pause();
                                    } else {
                                      audioPlayerService.resume();
                                    }
                                    provider.setPlayingState(
                                        audioPlayerService.isPlaying);
                                  },
                                )),
                                Container(
                                    child: IconButton(
                                  icon: const Icon(
                                    Icons.fast_forward,
                                    color: Colors.black,
                                    size: 45,
                                  ),
                                  onPressed: () {
                                    provider.playNextSong();
                                    audioPlayerService
                                        .playSong(provider.playingSong!);
                                    provider.setPlayingState(false);
                                  },
                                )),

                                // Container(
                                //     child: IconButton(
                                //   icon: const Icon(
                                //     Icons.replay,
                                //     color: Colors.black,
                                //     size: 50,
                                //   ),
                                //   onPressed: () async {
                                //     provider.playPrevSong();
                                //     audioPlayerService.playSong(
                                //         provider.playingSong!);
                                //     provider.setPlayingState(false);
                                //   },
                                // )),
                                // Container(
                                //     child: IconButton(
                                //   icon: Icon(
                                //     Icons.volume_off,
                                //     color: Colors.black,
                                //     size: 50,
                                //   ),
                                //   onPressed: () async {
                                //     VolumeController().muteVolume();
                                //   },
                                // )),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(
                                          Icons.volume_mute,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                        Flexible(
                                            child: SliderTheme(
                                          data: SliderThemeData(
                                              thumbShape: RoundSliderThumbShape(
                                                  enabledThumbRadius: 4.0)),
                                          child: Slider(
                                            min: 0,
                                            max: 1,
                                            onChanged: (double value) {
                                              setState(() {
                                                _setVolumeValue = value;
                                                VolumeController()
                                                    .setVolume(_setVolumeValue);
                                              });
                                            },
                                            value: _setVolumeValue,
                                            activeColor: Colors.white,
                                            inactiveColor: Colors.black,
                                          ),
                                        )),
                                        const Icon(
                                          Icons.volume_up_outlined,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                      ],
                                    ),
                                  ],
                                )),

                            Container(
                                child: IconButton(
                                    icon: const Icon(
                                      Icons.bluetooth,
                                      color: Colors.black,
                                      size: 45,
                                    ),
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => MyCollectionScreen(),
                                      //   ),
                                      // );
                                    })),

                            // ),
                          ]);
                    }))));
  }
}
