// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'PDF View',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: FilePage(),
//     );
//   }
// }
//
// class FilePage extends StatefulWidget {
//   @override
//   _FilePageState createState() => _FilePageState();
// }
//
// class _FilePageState extends State<FilePage> {
//   String file =
//       'https://firebasestorage.googleapis.com/v0/b/jiwdopani-e766d.appspot.com/o/NepaliBread%2F01%20April%202022.pdf?alt=media&token=e94d2197-2643-4b75-92d3-74c844ce6304';
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => true,
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.grey.shade200,
//           title: Text(
//             file.split('.').first,
//             style: TextStyle(color: Colors.black),
//           ),
//           centerTitle: true,
//         ),
//         body: FutureBuilder(
//             future: PDFDocument.fromURL(file),
//             builder: (context, snapshot) {
//               switch (snapshot.connectionState) {
//                 case ConnectionState.waiting:
//                 case ConnectionState.active:
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 default:
//                   var pdf = snapshot.data as PDFDocument;
//                   return PDFViewer(
//                     document: pdf,
//                     lazyLoad: true,
//                     scrollDirection: Axis.horizontal,
//                   );
//               }
//             }),
//       ),
//     );
//   }
// }
