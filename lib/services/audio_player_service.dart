import 'dart:async';
import 'dart:developer';
import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:divya/model/song.dart';




class AudioPlayeService  {
  final _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Function? onAudioComplet;

  AudioPlayeService._() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      isPlaying = state == PlayerState.PLAYING;
    });
    _audioPlayer.onDurationChanged.listen((newDuration) {
      duration = newDuration;
    });
    _audioPlayer.onAudioPositionChanged.listen((newPosition) {
      position = newPosition;
    });
    _audioPlayer.onPlayerCompletion.listen((event) {
      if (onAudioComplet != null) {
        onAudioComplet!();
      }
    });
  }

  static AudioPlayeService? _instance;

  Stream<Duration> get positionStream => _audioPlayer.onAudioPositionChanged;

  static AudioPlayeService get instance {
    return _instance ??= AudioPlayeService._();
  }

 pause() async {
    await _audioPlayer.pause();
  }

resume() async {
    await _audioPlayer.resume();
  }

 playSong(Song song) async {
    // final file = await DefaultCacheManager().getSingleFile(song.music);
    // String filePath = file.path;
    await _audioPlayer.pause();
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.play(song.music);
  }

dispose() {
    _audioPlayer.dispose();
    _instance = null;
  }

   seekTo(Duration position) {
    log('$duration');
    _audioPlayer.seek(const Duration(minutes: 5));
  }
}
