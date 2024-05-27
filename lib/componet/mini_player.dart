import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:divya/services/song_provider.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

import '../onTapMiniPlayer/tapMiniPlayer.dart';
import '../services/audio_player_service.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  _MiniPlayer createState() => _MiniPlayer();
}

class _MiniPlayer extends State<MiniPlayer> {
  AudioPlayer _audioPlayer = AudioPlayer();
  final audioPlayerService = AudioPlayerService.instance;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;


  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<SongProvider>(context);
    final name = provider.playingSong?.name ?? "N/A";
    final title = provider.playingSong?.title ?? "N/A";
 Duration duration = Duration.zero;
 Duration position = Duration.zero;
    return AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.width * 0.932,
        decoration: BoxDecoration(
          color: Color.fromRGBO(19, 19, 19, 1),

          // color: Colors.brown[100]?.withOpacity(0.3), // added
          //border: Border.all(color: Colors.orange, width: 5), // added
          borderRadius: BorderRadius.circular(8.0),
        ),
        child:StreamBuilder<Duration>(
            stream: audioPlayerService.positionStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                position = snapshot.data!;
                // Calculate the total duration separately
                duration = audioPlayerService.duration;
              }
              return Column(
                  children: [
                Expanded(
                    child: Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 6),
                        child: IconButton(
                          icon: const Icon(
                            Icons.skip_previous,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () async {
                            provider.playPrevSong();
                            audioPlayerService.playSong(provider.playingSong!);
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
                            size: 20,
                          ),
                          onPressed: () async {
                            if (audioPlayerService.isPlaying) {
                              await audioPlayerService.pause();
                            } else {
                              audioPlayerService.resume();
                            }
                            provider
                                .setPlayingState(audioPlayerService.isPlaying);
                          },
                        )),
                    Container(
                        padding: const EdgeInsets.only(left: 6),
                        child: IconButton(
                          icon: const Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            provider.playNextSong();
                            audioPlayerService.playSong(provider.playingSong!);
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
                          fontSize: 13,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TapMiniPlayer()),
                        );
                      },
                    )),
                  ],
                )),
                    SliderTheme(
                      data: SliderThemeData(
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 5.0),
                      ),
                      child: Slider(
                        value: position.inMilliseconds.toDouble().clamp(0.0, duration.inMilliseconds.toDouble()),
                        min: 0.0,
                        max: duration.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          final newPosition = Duration(milliseconds: value.round());
                          audioPlayerService.seekTo(newPosition);
                        },
                        activeColor: Colors.white,
                        inactiveColor: Colors.black,

                      ),
                    ),
              ]);
            }));
  }
}
