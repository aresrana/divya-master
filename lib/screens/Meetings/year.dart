import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

import '../../componet/mini_player.dart';
import '../../model/subMeetingModel.dart';
import '../../services/song_provider.dart';
import 'meetingSong.dart';

class YearScreen extends StatefulWidget {
  final String meeting;
  final String meetingId;
  final String country;
  final String placeId;

  YearScreen(this.meeting, this.meetingId, this.country, this.placeId);

  @override
  _YearScreenState createState() => _YearScreenState();
}

class _YearScreenState extends State<YearScreen>
    with SingleTickerProviderStateMixin {
  late Stream<QuerySnapshot> _stream;
  late TabController _tabController;
  List<Year> _years = [];

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection(
            'Countries/${widget.country}/Meetings/${widget.meetingId}/Location/${widget.placeId}/Years')
        .orderBy('year')
        .snapshots();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        toolbarHeight: 150,
        flexibleSpace: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/calendar.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 173,
              right: 2,
              bottom: 0,
              left: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.black.withOpacity(0.2),
                    child: Text(
                      '_teach'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey,
              // Set the base color for shimmer effect
              highlightColor: Colors.grey,
              // Set the highlight color for shimmer effect
              child: Container(
                color: Colors
                    .transparent, // Set the background color as transparent for the shimmer effect
              ),
            ),
          ],
        ),
      ),
      body: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
          // Add padding to the left, right, and top sides
          child: StreamBuilder<QuerySnapshot>(
            stream: _stream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              print('Snapshot has data: ${snapshot.hasData}');
              print('Snapshot error: ${snapshot.error}');

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return Shimmer.fromColors(
                  child: Container(
                    color: Colors.white, // Placeholder color
                  ),
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                );
              }

              // Map each document in the collection to a custom object
              List<Year> year = snapshot.data!.docs
                  .map((doc) => Year.fromSnapshot(doc))
                  .toList();
              return Timeline.builder(
                itemCount: year.length,
                itemBuilder: (BuildContext context, int index) {
                  final randomColor =
                      RandomColor(); // Create an instance of the RandomColor class

                  final cardColor = randomColor.randomColor();
                  return TimelineModel(
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MeetingSong(
                                  year[index].year,
                                  widget.meetingId,
                                  widget.country,
                                  widget.placeId,
                                  snapshot.data!.docs[index].id)),
                        );
                      },
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        width: 100.0,
                        height: 100.0,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  // Apply the color based on the index
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: ListTile(
                                      title: Text(
                                        year[index].year.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    position: index % 2 == 0
                        ? TimelineItemPosition.left
                        : TimelineItemPosition.right,
                    iconBackground: Colors.black,
                    //   icon: Icon(Icons.info),
                  );
                },
                position: TimelinePosition.Center,
                lineColor: Colors.black,
              );
            },
          )),
      floatingActionButton: provider.playingSong != null ? MiniPlayer() : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked, //
    );
  }
}
