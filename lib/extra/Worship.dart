// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../guitarTab/guitarTab.dart';
//
//
//
// enum _popValues {
//   play,
//   add,
//   info
//
// }
//
// class WorshipPage extends StatefulWidget {
//   WorshipPage({Key? key}) : super(key: key);
//   @override
//   State<WorshipPage> createState() => _WorshipPageState();
// }
//
// class _WorshipPageState extends State<WorshipPage> {
//   ScrollController _scrollController = new ScrollController();
//   bool closeTopContainer= false;
//   int currentCategoryIndex = 0;
//   bool searching = false;
//
//   FocusNode focusNode = FocusNode();
//
//
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       // appBar: AppBar(
//       //   leadingWidth: 40,
//       //   title: const Center(child: Text('Worship',style: TextStyle(color: Colors.black),)),
//       //  leading: GestureDetector(
//       //
//       //  child: const Icon(
//       //    Icons.swipe_left_sharp,
//       //    color: Colors.indigo,
//       //    size: 25,
//       //  ),
//       //    onTap: () {
//       //      Navigator.push(context,MaterialPageRoute(builder: (context) => TabPage())
//       //      );
//       //
//       //    },
//       //  ),
//       //
//       //   backgroundColor: Colors.transparent,
//       //   elevation: 0,
//       // ),
//       body: body(),
//     ));
//   }
//
//   Widget body() {
//     return SingleChildScrollView(
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//           SizedBox(
//             height: 18,
//           ),
//           Container(
//             height: MediaQuery.of(context).size.height * 0.25,
//             width: MediaQuery.of(context).size.width * 0.93,
//             decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(15)),
//                 image: DecorationImage(
//                     image: AssetImage('images/worship.jpg'),
//                     fit: BoxFit.cover)),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Center(
//             child: Text('Come, let us bow down in worship',
//                 style: TextStyle(fontSize: 18)),
//           ),
//           Center(
//             child: Text('Psalm 95:6',
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red)),
//           ),
//           SizedBox(
//             height: 40,
//           ),
//           Center(
//             child: Text(
//               'Song List',
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           _worshipSong()
//         ]));
//   }
// }
//
// Widget _worshipSong() {
//   return SingleChildScrollView(
//       child: Container(
//           child: Column(
//     children: [
//       StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection("Worship").snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasData) {
//             final snap = snapshot.data!.docs;
//             return
//               // AnimatedContainer(duration: const Duration(milliseconds: 200),
//               // width: MediaQuery.of(context).size.width,
//               // alignment: Alignment.topCenter,
//               //          child: Expanded(
//               // child:
//                ListView.builder(
//
//               shrinkWrap: true,
//               physics: BouncingScrollPhysics(),
//               primary: false,
//               itemCount: snap.length,
//               itemBuilder: (context, index) {
//                 return
//                   Stack(
//                   alignment: Alignment.topCenter,
//                   fit: StackFit.loose,
//                   clipBehavior: Clip.hardEdge,
//                   children: [
//                     GestureDetector(
//                       child: Container(
//                           height: 200,
//                           width: MediaQuery.of(context).size.width,
//                           child: Card(
//                             child: Center(
//                                 child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                   Text(
//                                     snap[index]['name'],
//                                     textAlign: TextAlign.start,
//                                     style: const TextStyle(
//                                       color: Colors.indigo,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(width: 60),
//                                   Text(
//                                     snap[index]['title'],
//                                     textAlign: TextAlign.start,
//                                     style: const TextStyle(
//                                       color: Colors.indigo,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                        PopupMenuButton <_popValues>(
//                                        itemBuilder: (BuildContext context) => [
//                                       const PopupMenuItem(
//                                           child: Text('Play Song'),
//                                         value: _popValues.play,
//
//                                       ),
//                                       const PopupMenuItem(
//                                           child: Text('Add to Playlist'),
//                                         value: _popValues.add,
//                                       ),
//                                       const PopupMenuItem(
//                                           child: Text('Info'),
//                                         value: _popValues.info,
//                                       )
//                                     ],
//                                     onSelected: (value) {
//                                          switch(value){
//                                            case _popValues.play:
//
//                                              break;
//                                            case _popValues.add:
//
//                                              break;
//
//                                            case _popValues.info:
//
//                                              break;
//
//
//                                          }
//
//
//
//                                     }
//                                   )
//                                 ])),
//                           )),
//                       onTap: () {
//                         var ur = snap[index]['url'];
//                         var ti = snap[index]['title'];
//                         var music = snap[index]['music'];
//
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     DashBoards(url: ur, le: ti, music: music)));
//                       },
//                     )
//                   ],
//                   //   ),
//                 );
//               },
//           );
//           } else {
//             return SizedBox();
//           }
//         },
//       )
//     ],
//   )));
// }
//
//
