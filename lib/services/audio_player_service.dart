import 'dart:async';
import 'dart:developer';

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
      isPlaying = state == PlayerState.playing;
    });
    _audioPlayer.onDurationChanged.listen((newDuration) {
      duration = newDuration;
    });
    _audioPlayer.onPositionChanged.listen((newPosition) {
      position = newPosition;
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      if (onAudioComplet != null) {
        onAudioComplet!();
      }
    });
  }

  static AudioPlayeService? _instance;

  Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;

  static AudioPlayeService get instance {
    return _instance ??= AudioPlayeService._();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  void playSong(Song song) async {
    // final file = await DefaultCacheManager().getSingleFile(song.music);
    // String filePath = file.path;
    await _audioPlayer.pause();
    await _audioPlayer.seek(Duration.zero);

    await _audioPlayer.play(song.music as Source);
  }

  void dispose() {
    _audioPlayer.dispose();
    _instance = null;
  }

  void seekTo() {
    log('$duration');
    _audioPlayer.seek(const Duration(minutes: 5));
  }
}
