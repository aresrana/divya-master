import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divya/model/song.dart';
import 'package:flutter/cupertino.dart';

class SongProvider extends ChangeNotifier {
  SongProvider({required col});

  Song? _playingSong;
  List<Song> _songs = [];
  bool _init = false;
  int _playinIndex = -1;
  bool _isLoading = true;
  bool _isPlaying = false;
  List<Song> _searchResults = [];

  //GETTER
  List<Song> get songs {
    if (_init == false) {
      throw 'Please init the song list';
    }
    return _songs;
  }

  List<Song> get searchResults => _searchResults;

  bool get isLoading => _isLoading;

  bool get init => _init;

  Song? get playingSong => _playingSong;

  bool get isPlaying => _isPlaying;

  Future<List<Song>> getSongsByCollection(String collection) async {
    try {
      final songsData = await FirebaseFirestore.instance
          .collection(collection)
          .orderBy('name')
          .get();
      _init = true;
      _isLoading = false;
      return songsData.docs.map((e) => Song.fromMap(e.data())).toList();
    } catch (e) {
      _init = true;
      _isLoading = false;
      return [];
    }
  }

  void setPlayingSong(Song song) {
    _playingSong = song;
    _playinIndex = songs.indexOf(song);
    notifyListeners();
  }

  void setSearchResults(List<Song> results) {
    _searchResults = results;
    notifyListeners();
  }

  void playNextSong() async {
    if (_playinIndex >= _songs.length ||
        _playinIndex + 1 >= _songs.length ||
        _playinIndex == -1) {
      setPlayingSong(_songs.first);
      _playinIndex = 0;
    } else {
      setPlayingSong(_songs.elementAt(_playinIndex + 1));
    }
    notifyListeners();
  }

  void setPlayingList(List<Song> songList) {
    _songs = songList;
    notifyListeners();
  }

  void playPrevSong() async {
    if (_playinIndex == 0 || _playinIndex - 1 < 0 || _playinIndex == -1) {
      setPlayingSong(_songs.last);
      _playinIndex = songs.length - 1;
    } else {
      setPlayingSong(_songs.elementAt(_playinIndex - 1));
    }
    notifyListeners();
  }

  void setPlayingState(bool state) {
    Future.microtask(() {
      _isPlaying = state;
      notifyListeners();
    });
  }
}
