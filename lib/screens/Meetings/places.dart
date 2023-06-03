import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:divya/screens/Meetings/year.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../services/song_provider.dart';

class PlacesScreen extends StatefulWidget {
  final String meeting;
  final String meetingId;
  final String country;

  const PlacesScreen({
    required this.meeting,
    required this.meetingId,
    required this.country,
  });

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  late Stream<QuerySnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection(
            'Countries/${widget.country}/Meetings/${widget.meetingId}/Location')
        .snapshots();
  }

  //
  // @override
  // Widget build(BuildContext context) {
  //   final provider = context.watch<SongProvider>();
  //
  //   return Scaffold(
  //     backgroundColor: Color.fromRGBO(18, 18, 18, 1),
  //     body: StreamBuilder<QuerySnapshot>(
  //       stream: _stream,
  //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //   print('Snapshot has data: ${snapshot.hasData}');
  //   print('Snapshot error: ${snapshot.error}');
  //
  //
  //   if (snapshot.hasError) {
  //           return Text('Error: ${snapshot.error}');
  //         }
  //
  //         if (!snapshot.hasData) {
  //           return CircularProgressIndicator();
  //         }
  //
  //         // Map each document in the collection to a custom object
  //         List<Place> myPlaces = snapshot.data!.docs.map((doc) => Place.fromSnapshot(doc)).toList();
  //
  //         return ListView.builder(
  //           itemCount: myPlaces.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             return GestureDetector(
  //                 onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => YearScreen(myPlaces[index].church,widget.meetingId,widget.country,snapshot.data!.docs[index].id)),
  //               );
  //             },
  //               child:Card(
  //                 color: Color(0xffe69036).withOpacity(1),
  //                 child: Stack(
  //                   children: [
  //                                            CachedNetworkImage(
  //                         imageUrl:  myPlaces[index].imageLink,
  //                         fit: BoxFit.cover,
  //                         width: double.infinity,
  //                         height: double.infinity,
  //                         placeholder: (BuildContext context, String url) =>
  //                             Shimmer.fromColors(
  //                               child: Container(
  //                                 color: Colors.white, // Placeholder color
  //                               ),
  //                               baseColor: Colors.grey[300]!,
  //                               highlightColor: Colors.grey[100]!,
  //                             ),
  //                         errorWidget: (BuildContext context, String url,
  //                             dynamic error) =>
  //                             Container(
  //                               color: Colors.grey, // Placeholder color
  //                             ),
  //                       ),
  //                     // Text
  //                     Positioned(
  //                       bottom: 0,
  //                       left: 0,
  //                       right: 0,
  //                       child: ListTile(
  //                         contentPadding: EdgeInsets.all(16.0),
  //                         title: Text(
  //                           myPlaces[index].church,
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                             fontSize: 18.0,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         subtitle: Text(
  //                           myPlaces[index].place,
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                             fontSize: 14.0,
  //                           ),
  //                         ),
  //
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             );
  //           },
  //         );
  //       },
  //     )
  //
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SongProvider>();

    return Scaffold(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(
                        'Countries/${widget.country}/Meetings/${widget.meetingId}/Location')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final meetingDocuments = snapshot.data!.docs;
                  final List<String> imageUrls = meetingDocuments
                      .map((document) => document['image'] as String)
                      .toList();

                  return CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 0.9,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 2),
                      autoPlayAnimationDuration: Duration(milliseconds: 1000),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: imageUrls.map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          final index = imageUrls.indexOf(imageUrl);
                          final document = meetingDocuments[index];
                          final church = document['church'] as String;
                          final place = document['place'] as String;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => YearScreen(
                                        church,
                                        widget.meetingId,
                                        widget.country,
                                        snapshot.data!.docs[index].id)),
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        placeholder: (BuildContext context,
                                                String url) =>
                                            Shimmer.fromColors(
                                          child: Container(
                                            color: Colors
                                                .white, // Placeholder color
                                          ),
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                        ),
                                        errorWidget: (BuildContext context,
                                                String url, dynamic error) =>
                                            Container(
                                          color:
                                              Colors.grey, // Placeholder color
                                        ),
                                      ),
                                      Positioned(
                                        top: 10.0,
                                        left: 20.0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              church,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              place,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
