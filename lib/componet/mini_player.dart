import 'package:audioplayers/audioplayers.dart';
import 'package:divya/services/song_provider.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import '../services/audio_player_service.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  _MiniPlayer createState() => _MiniPlayer();
}

class _MiniPlayer extends State<MiniPlayer> {
  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AudioPlayer _audioPlayer = AudioPlayer();
    final audioPlayerService = AudioPlayeService.instance;
    final provider = Provider.of<SongProvider>(context);
    final name = provider.playingSong?.name ?? "N/A";
    final title = provider.playingSong?.title ?? "N/A";

          return
            AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.06,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.932,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(75, 64, 54, 1),

                  // color: Colors.brown[100]?.withOpacity(0.3), // added
                  //border: Border.all(color: Colors.orange, width: 5), // added
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child:     StreamBuilder<Duration>(
    stream: AudioPlayeService.instance.positionStream,
    builder: (context, snapshot) {
      final position = snapshot.data ?? Duration.zero;


      return Column(children: [
        Expanded(
            child: Row(
              children: [
                Container(
                    padding: const EdgeInsets.only(left: 6),
                    child: IconButton(
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () async {
                        provider.playPrevSong();
                        audioPlayerService.playSong(provider
                            .playingSong!);
                        provider.setPlayingState(false);
                      },
                    )),
                Container(
                    padding: const EdgeInsets.only(left: 6),
                    child: IconButton(
                      icon: Icon(
                        provider.isPlaying
                            ? Icons.play_arrow_rounded
                            : Icons.pause,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () async {
                        if (audioPlayerService.isPlaying) {
                          await audioPlayerService.pause();
                        } else {
                          audioPlayerService.resume();
                        }
                        provider.setPlayingState(audioPlayerService
                            .isPlaying);
                      },
                    )),
                Container(
                    padding: const EdgeInsets.only(left: 6),
                    child: IconButton(
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        provider.playNextSong();
                        audioPlayerService.playSong(provider
                            .playingSong!);
                        provider.setPlayingState(false);
                      },
                    )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: GestureDetector(
                      child: Marquee(
                        textDirection: TextDirection.ltr,
                        velocity: 30,
                        blankSpace: 40,
                        text: name + "   " + title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      onTap: () {
                        print(audioPlayerService.position);
                      },
                    )),
              ],
            )),
        SliderTheme(
            data: SliderThemeData(
              thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 2.0),
              overlayShape: RoundSliderOverlayShape(
                  overlayRadius: 10.0),
            ),
            child: Slider(
              value: position.inSeconds.toDouble(),
              min: 0,
              max: audioPlayerService.duration.inSeconds.toDouble(),
              onChanged: (double value) async {
                audioPlayerService.position =
                await Duration(seconds: value.toInt());
                _audioPlayer.seek(
                    AudioPlayeService.instance.position);
                print(audioPlayerService.position);
              },
              activeColor: Colors.white,
              inactiveColor: Colors.black,
            )),
        // Container(
        //     padding: EdgeInsets.all(20),
        //     child: Row(
        //       children: [
        //         Text(formatTime(
        //             audioPlayerService.position.inSeconds)),
        //         Text(formatTime(
        //             (audioPlayerService.duration.inSeconds -
        //                 audioPlayerService.position.inSeconds))),
        //       ],
        //     ))
      ]);
    })
            );

    }}
