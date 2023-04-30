// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class DashBoards extends StatefulWidget {
//   final String url;
//   final String le;
//   final String music;
//   const DashBoards(
//       {Key? key, required this.url, required this.le, required this.music})
//       : super(key: key);
//
//   @override
//   _DashBoardsState createState() => _DashBoardsState(url, le, music);
// }
//
// class _DashBoardsState extends State<DashBoards> {
//   List<String> categories = [
//     "Popular",
//     "Recommended",
//     "Special Order",
//     "Fresh Juice",
//     "Trending",
//     "Customize"
//   ];
//   int currentCategoryIndex = 0;
//   FocusNode focusNode = FocusNode();
//   late final String url;
//   late final String music;
//   late final String le;
//   final audioPlayer = AudioPlayer();
//   bool isPlaying = false;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;
//   bool _isLoading = false;
//   _DashBoardsState(url, le, music);
//
//   @override
//   void initState() {
//     super.initState();
//     setAudio();
//
//     audioPlayer.onPlayerStateChanged.listen((state) {
//       setState(() {
//         isPlaying = state == PlayerState.PLAYING;
//       });
//     });
//
//     audioPlayer.onDurationChanged.listen((newDuration) {
//       setState(() {
//         duration = newDuration;
//       });
//     });// import 'package:audioplayers/audioplayers.dart';
// // import 'package:flutter/material.dart';
// // import 'package:webview_flutter/webview_flutter.dart';
// //
// // class DashBoards extends StatefulWidget {
// //   final String url;
// //   final String le;
// //   final String music;
// //   const DashBoards(
// //       {Key? key, required this.url, required this.le, required this.music})
// //       : super(key: key);
// //
// //   @override
// //   _DashBoardsState createState() => _DashBoardsState(url, le, music);
// // }
// //
// // class _DashBoardsState extends State<DashBoards> {
// //   List<String> categories = [
// //     "Popular",
// //     "Recommended",
// //     "Special Order",
// //     "Fresh Juice",
// //     "Trending",
// //     "Customize"
// //   ];
// //   int currentCategoryIndex = 0;
// //   FocusNode focusNode = FocusNode();
// //   late final String url;
// //   late final String music;
// //   late final String le;
// //   final audioPlayer = AudioPlayer();
// //   bool isPlaying = false;
// //   Duration duration = Duration.zero;
// //   Duration position = Duration.zero;
// //   bool _isLoading = false;
// //   _DashBoardsState(url, le, music);
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     setAudio();
// //
// //     audioPlayer.onPlayerStateChanged.listen((state) {
// //       setState(() {
// //         isPlaying = state == PlayerState.PLAYING;
// //       });
// //     });
// //
// //     audioPlayer.onDurationChanged.listen((newDuration) {
// //       setState(() {
// //         duration = newDuration;
// //       });
// //     });
// //
// //     audioPlayer.onAudioPositionChanged.listen((newPosition) {
// //       setState(() {
// //         position = newPosition;
// //       });
// //     });
// //   }
// //
// //   Future setAudio() async {
// //     audioPlayer.setReleaseMode(ReleaseMode.LOOP);
// //     audioPlayer.setUrl(widget.music);
// //   }
// //
// //   @override
// //   void dispose() {
// //     audioPlayer.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       //backgroundColor: Colors.white60,
// //       endDrawerEnableOpenDragGesture: false,
// //       appBar: AppBar(
// //         title: Text(widget.le),
// //         backgroundColor: Colors.green,
// //       ),
// //       body: Column(
// //         children: [
// //           _buildCategories(),
// //           Expanded(
// //               child: WebView(
// //             javascriptMode: JavascriptMode.unrestricted,
// //             initialUrl: widget.url,
// //           )),
// //           Container(
// //               color: Colors.transparent,
// //               child: Slider(
// //                 activeColor: Colors.black,
// //                 inactiveColor: Colors.red,
// //                 thumbColor: Colors.white,
// //                 min: 0,
// //                 max: duration.inSeconds.toDouble(),
// //                 value: position.inSeconds.toDouble(),
// //                 onChanged: (value) async {
// //                   final position = Duration(seconds: value.toInt());
// //                   await audioPlayer.seek(position);
// //                   audioPlayer.resume();
// //                 },
// //               )),
// //           Container(
// //               color: Colors.transparent,
// //               padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Text(formatTime(position)),
// //                   CircleAvatar(
// //                     backgroundColor: Colors.black,
// //                     radius: 20,
// //                     child: IconButton(
// //                       icon: Icon(
// //                         isPlaying ? Icons.pause : Icons.play_arrow_rounded,
// //                         color: Colors.white,
// //                       ),
// //                       onPressed: () async {
// //                         if (isPlaying) {
// //                           await audioPlayer.pause();
// //                         } else {
// //                           await audioPlayer.resume();
// //                         }
// //                       },
// //                     ),
// //                   ),
// //                   Text(formatTime(duration - position)),
// //                 ],
// //               )),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCategories() {
// //     return Padding(
// //         padding: const EdgeInsets.symmetric(vertical: 20),
// //         child: SizedBox(
// //           height: 30,
// //           child: ListView.builder(
// //               itemCount: categories.length,
// //               shrinkWrap: true,
// //               scrollDirection: Axis.horizontal,
// //               itemBuilder: (context, index) {
// //                 return currentCategoryIndex == index
// //                     ? _buildCurrentCategory(index)
// //                     : _buildCategory(index);
// //               }),
// //         ));
// //   }
// //
// //   Widget _buildCurrentCategory(int index) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
// //       margin: const EdgeInsets.symmetric(horizontal: 4),
// //       decoration: BoxDecoration(
// //         color: Colors.black,
// //         border: Border.all(),
// //         borderRadius: const BorderRadius.all(Radius.circular(15)),
// //       ),
// //       child: Text(
// //         categories.elementAt(index),
// //         style: const TextStyle(fontSize: 12, color: Colors.white),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildCategory(index) {
// //     return InkWell(
// //       onTap: () {
// //         setState(() {
// //           currentCategoryIndex = index;
// //         });
// //       },
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
// //         margin: const EdgeInsets.symmetric(horizontal: 4),
// //         decoration: BoxDecoration(
// //           border: Border.all(),
// //           borderRadius: const BorderRadius.all(Radius.circular(15)),
// //         ),
// //         child: Text(
// //           categories.elementAt(index),
// //           style: const TextStyle(
// //             fontSize: 12,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   String formatTime(Duration duration) {
// //     String twoDigits(int n) => n.toString().padLeft(2, '0');
// //     final hours = twoDigits(duration.inHours);
// //     final minutes = twoDigits(duration.inMinutes.remainder(60));
// //     final seconds = twoDigits(duration.inSeconds.remainder(60));
// //     return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
// //   }
// // }
//
//     audioPlayer.onAudioPositionChanged.listen((newPosition) {
//       setState(() {
//         position = newPosition;
//       });
//     });
//   }
//
//   Future setAudio() async {
//     audioPlayer.setReleaseMode(ReleaseMode.LOOP);
//     audioPlayer.setUrl(widget.music);
//   }
//
//   @override
//   void dispose() {
//     audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //backgroundColor: Colors.white60,
//       endDrawerEnableOpenDragGesture: false,
//       appBar: AppBar(
//         title: Text(widget.le),
//         backgroundColor: Colors.green,
//       ),
//       body: Column(
//         children: [
//           _buildCategories(),
//           Expanded(
//               child: WebView(
//             javascriptMode: JavascriptMode.unrestricted,
//             initialUrl: widget.url,
//           )),
//           Container(
//               color: Colors.transparent,
//               child: Slider(
//                 activeColor: Colors.black,
//                 inactiveColor: Colors.red,
//                 thumbColor: Colors.white,
//                 min: 0,
//                 max: duration.inSeconds.toDouble(),
//                 value: position.inSeconds.toDouble(),
//                 onChanged: (value) async {
//                   final position = Duration(seconds: value.toInt());
//                   await audioPlayer.seek(position);
//                   audioPlayer.resume();
//                 },
//               )),
//           Container(
//               color: Colors.transparent,
//               padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(formatTime(position)),
//                   CircleAvatar(
//                     backgroundColor: Colors.black,
//                     radius: 20,
//                     child: IconButton(
//                       icon: Icon(
//                         isPlaying ? Icons.pause : Icons.play_arrow_rounded,
//                         color: Colors.white,
//                       ),
//                       onPressed: () async {
//                         if (isPlaying) {
//                           await audioPlayer.pause();
//                         } else {
//                           await audioPlayer.resume();
//                         }
//                       },
//                     ),
//                   ),
//                   Text(formatTime(duration - position)),
//                 ],
//               )),
//         ],
//       ),
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
//
//   String formatTime(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final hours = twoDigits(duration.inHours);
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
//   }
// }
