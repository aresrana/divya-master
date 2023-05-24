import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth.dart';

class HeaderPage extends StatefulWidget {
  @override
  State<HeaderPage> createState() => _HeaderPage();
}

class _HeaderPage extends State<HeaderPage> {
  String userName = "";
  String email = "";
  final _picker = ImagePicker();
  File? _imageFile;
  final User? user = Auth().currentUser;
  @override
  void initState() {
    super.initState();

    showData();
  }

  Future<void> takePhoto(ImageSource source) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final image = await _picker.getImage(source: source);
    if (image != null) {
      final imageTemporary = File(image.path);
      setState(() {
        _imageFile = imageTemporary;
      });
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      await prefs.setString('myImageKey', base64Image);
    }
  }

  Future<File?> showData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('myImageKey');
    if (base64Image != null) {
      final bytes = base64Decode(base64Image);
      final appDir = await getApplicationDocumentsDirectory();
      final imageFile = File('${appDir.path}/myImage.jpg');
      await imageFile.writeAsBytes(bytes);
      setState(() {
        _imageFile = imageFile;
      });
      return _imageFile;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          imageProfile(context),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ashish Rana Magar",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                '${user?.email}',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),

          // Icon(Icons.chevron_right_sharp,color: Colors.white,),
        ],
      ),
    );
  }

  imageProfile(BuildContext context) {
    return Center(
      child: Stack(children: <Widget>[
        Row(children: <Widget>[
          Container(
            height: 100,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.transparent,
              backgroundImage: _imageFile != null || _imageFile?.path != null
                  ? FadeInImage(
                      placeholder: AssetImage('assets/placeholder_image.png'),
                      // Replace with your own placeholder image asset
                      image: _imageFile != null
                          ? FileImage(_imageFile!) as ImageProvider<Object>
                          : CachedNetworkImageProvider(_imageFile!.path),
                    ).image
                  : null,
              child: _imageFile == null && _imageFile?.path == null
                  ? Icon(Icons.person, size: 40) // Placeholder icon
                  : null,
            ),
          )
        ]),
        Positioned(
          bottom: -5.0,
          right: 6.0,
          child: InkWell(
            onTap: () {
              if (Platform.isIOS) {
                showCupertinoModalPopup<ImageSource>(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    actions: [
                      CupertinoActionSheetAction(
                          child: Text('Camera'),
                          onPressed: () async {
                            Navigator.pop(context);
                            takePhoto(ImageSource.camera);
                          }),
                      CupertinoActionSheetAction(
                          child: Text('Gallery'),
                          onPressed: () async {
                            Navigator.pop(context);
                            takePhoto(ImageSource.gallery);
                          }),
                    ],
                  ),
                );
              } else
                showModalBottomSheet(
                  builder: ((builder) => bottomSheet()),
                  context: context,
                );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 24.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(this.context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            IconButton(
              icon: Icon(Icons.camera, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                takePhoto(ImageSource.camera);

              },
            ),
            IconButton(
              icon: Icon(
                Icons.image,
                color: Color.fromRGBO(179, 179, 179, 100),
              ),
              onPressed: () {
                Navigator.pop(context);
                takePhoto(ImageSource.gallery);

              },
            ),
          ])
        ],
      ),
    );
  }
}
