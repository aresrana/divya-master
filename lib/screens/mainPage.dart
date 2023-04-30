// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import '../guitarTab/guitarTab.dart';
//
// class SongPage extends StatefulWidget {
//   const SongPage({Key? key}) : super(key: key);
//   @override
//   State<SongPage> createState() => _SongPageState();
// }
//
// class _SongPageState extends State<SongPage> {
//   bool _isLoading = false;
//
//   //categories
//   List<String> categories = [
//     "Popular",
//     "Recommended",
//     "Special Order",
//     "Fresh Juice",
//     "Trending",
//     "Customize"
//   ];
//   int currentCategoryIndex = 0;
//   bool searching = false;
//   final _searchController = TextEditingController();
//
//   FocusNode focusNode = FocusNode();
//   @override
//   void initState() {
//     //add products
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const Icon(
//           Icons.menu,
//           color: Colors.black,
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         actions: const [
//           Padding(
//               padding: EdgeInsets.only(right: 50),
//               child: Icon(
//                 Icons.print,
//                 color: Colors.black,
//               ))
//         ],
//       ),
//       body: body(),
//     );
//   }
//
// //body
//   Widget body() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [_buildCategories(), _html(context)],
//     );
//   }
//
//   Widget _buildCategories() {
//     return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20),
//         child: SizedBox(
//           height: 30,
//           child: ListView.builder(
//               itemCount: categories.length,
//               shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//               itemBuilder: (context, index) {
//                 return currentCategoryIndex == index
//                     ? _buildCurrentCategory(index)
//                     : _buildCategory(index);
//               }),
//         ));
//   }
//
//   Widget _buildCurrentCategory(int index) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       decoration: BoxDecoration(
//         color: Colors.black,
//         border: Border.all(),
//         borderRadius: const BorderRadius.all(Radius.circular(15)),
//       ),
//       child: Text(
//         categories.elementAt(index),
//         style: const TextStyle(fontSize: 12, color: Colors.white),
//       ),
//     );
//   }
//
//   Widget _buildCategory(index) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           currentCategoryIndex = index;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//         margin: const EdgeInsets.symmetric(horizontal: 4),
//         decoration: BoxDecoration(
//           border: Border.all(),
//           borderRadius: const BorderRadius.all(Radius.circular(15)),
//         ),
//         child: Text(
//           categories.elementAt(index),
//           style: const TextStyle(
//             fontSize: 12,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// Widget _html(BuildContext context) {
//   return Column(
//     children: [
//       const Text("\nWorship"),
//       StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection("Worship").snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasData) {
//             final snap = snapshot.data!.docs;
//             return ListView.builder(
//               shrinkWrap: true,
//               primary: false,
//               itemCount: snap.length,
//               itemBuilder: (context, index) {
//                 return Stack(
//                   children: [
//                     GestureDetector(
//                       child: Container(
//                           height: 50,
//                           width: MediaQuery.of(context).size.width,
//                           child: Card(
//                             child: Center(
//                                 child: Row(children: [
//                               Text(
//                                 snap[index]['name'],
//                                 textAlign: TextAlign.start,
//                                 style: const TextStyle(
//                                   color: Colors.black54,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(width: 50),
//                               Text(
//                                 snap[index]['title'],
//                                 textAlign: TextAlign.start,
//                                 style: const TextStyle(
//                                   color: Colors.black54,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ])),
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
//             );
//           } else {
//             return const SizedBox();
//           }
//         },
//       )
//     ],
//   );
// }//product model class
//
