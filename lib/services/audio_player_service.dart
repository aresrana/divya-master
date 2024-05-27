import 'dart:async';
import 'dart:developer';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:divya/model/song.dart';

class AudioPlayerService {
  final _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Function? onAudioComplete;

  AudioPlayerService._() {
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
      if (onAudioComplete != null) {
        onAudioComplete!();
      }
    });
  }

  static AudioPlayerService? _instance;
  Stream<Duration> get positionStream => _audioPlayer.onAudioPositionChanged.map((event) => event);


  static AudioPlayerService get instance {
    return _instance ??= AudioPlayerService._();
  }

  pause() async {
    await _audioPlayer.pause();
  }

  resume() async {
    await _audioPlayer.resume();
  }

  playSong(Song song) async {
    // Check if the song is cached
    FileInfo? fileInfo = await DefaultCacheManager().getFileFromCache(song.music);
    if (fileInfo != null && fileInfo.file != null) {
      // Song is cached, play it from cache
      String filePath = fileInfo.file!.path;
      await _audioPlayer.pause();
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play(filePath);
      return;
    }

    // Song is not cached, continue with original logic
    await _audioPlayer.pause();
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.play(song.music);
  }


  dispose() {
    _audioPlayer.dispose();
    _instance = null;
  }

  seekTo(Duration newPosition) async {
    await _audioPlayer.seek(newPosition);
  }

  forwardBy10Seconds() async {
    final newPosition = position + Duration(seconds: 10);
    await _audioPlayer.seek(newPosition);
  }

  resumeBy10Seconds() async {
    final newPosition = position - Duration(seconds: 10);
    await _audioPlayer.seek(newPosition);
  
  }

}
