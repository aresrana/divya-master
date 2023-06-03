import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../componet/mini_player.dart';
import '../services/song_provider.dart';

class NewsletterScreen extends StatefulWidget {
  @override
  _NewsletterScreenState createState() => _NewsletterScreenState();
}

class _NewsletterScreenState extends State<NewsletterScreen> {
  Stream<QuerySnapshot>? _newsletterStream;

  @override
  void initState() {
    super.initState();
    _newsletterStream =
        FirebaseFirestore.instance.collection('newsletters').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();
    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      appBar: AppBar(
        title: Text(
          '_newsletter'.tr,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.grey.withOpacity(0.05),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _newsletterStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                '_newsUpdate'.tr,
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot newsletter = snapshot.data!.docs[index];
              String title = newsletter['title'];
              String content = newsletter['content'];

              return ListTile(
                title: Text(title),
                subtitle: Text(content),
              );
            },
          );
        },
      ),
      floatingActionButton: provider.playingSong != null ? MiniPlayer() : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, //
    );
  }
}
