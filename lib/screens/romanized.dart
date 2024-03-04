// import 'dart:typed_data';
//
// import 'package:epub_view/epub_view.dart';
// import 'package:flutter/material.dart';
//
// class EpubReader extends StatefulWidget {
//   const EpubReader({Key? key}) : super(key: key);
//
//   @override
//   _EpubReader createState() => _EpubReader();
// }
//
// class _EpubReader extends State<EpubReader> {
//   late EpubController _epubReaderController;
//   late final Uint8List ares = Uint8List(0);
//
//   @override
//   void initState() {
//     _epubReaderController = EpubController(
//         document: EpubDocument.openAsset('assets/Romanized.epub'));
//     // epubCfi:
//     //     'epubcfi(/6/26[id4]!/4/2/2[id4]/22)', // book.epub Chapter 3 paragraph 10
//     // epubCfi:
//     //     'epubcfi(/6/6[chapter-2]!/4/2/1612)', // book_2.epub Chapter 16 paragraph 3
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _epubReaderController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           title: EpubViewActualChapter(
//             controller: _epubReaderController,
//             builder: (chapterValue) => Text(
//               chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? '',
//               textAlign: TextAlign.start,
//             ),
//           ),
//           actions: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.save_alt),
//               color: Colors.white,
//               onPressed: () => _showCurrentEpubCfi(context),
//             ),
//           ],
//         ),
//         drawer: Drawer(
//           child: EpubViewTableOfContents(controller: _epubReaderController),
//         ),
//         body: EpubView(
//           builders: EpubViewBuilders<DefaultBuilderOptions>(
//             options: const DefaultBuilderOptions(),
//             chapterDividerBuilder: (_) => const Divider(),
//           ),
//           controller: _epubReaderController,
//         ),
//       );
//
//   void _showCurrentEpubCfi(context) {
//     final cfi = _epubReaderController.generateEpubCfi();
//
//     if (cfi != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(cfi),
//           action: SnackBarAction(
//             label: 'GO',
//             onPressed: () {
//               _epubReaderController.gotoEpubCfi(cfi);
//             },
//           ),
//         ),
//       );
//     }
//   }
// }
