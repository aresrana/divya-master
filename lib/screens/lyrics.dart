import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../componet/mini_player.dart';
import '../services/song_provider.dart';

class Lyrics extends StatelessWidget {
  late final String url;
  late final String title;

  Lyrics(this.url, this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(title,
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center)),
        backgroundColor: Colors.grey[200],
        shadowColor: Colors.grey[300],
        elevation: 10,
      ),
      body: WebViewPlus(
        initialUrl: '$url',
        javascriptMode: JavascriptMode.unrestricted,
      ),
      bottomNavigationBar: provider.playingSong != null ? MiniPlayer() : null,
    );
  }
}
