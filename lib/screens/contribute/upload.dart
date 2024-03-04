import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../services/auth.dart';

class PlatformFileWithProgress extends PlatformFile {
  double? uploadProgress;
  UploadTask? uploadTask; // Added property to track the upload task
  String editedName; // Added property to store the edited filename

  PlatformFileWithProgress(PlatformFile file)
      : editedName = file.name,
        super(
        name: file.name,
        size: file.size,
        path: file.path,
      );
}

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  List<PlatformFileWithProgress> selectedFiles = [];
  bool isLoading = false;
  final User? user = Auth().currentUser;
  TextEditingController countryController = TextEditingController();
  TextEditingController meetingController = TextEditingController();
  TextEditingController churchController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int uploadedFileCount = 0;

  void selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'mp3'],
    );

    if (result != null) {
      setState(() {
        selectedFiles = result.files
            .map((file) => PlatformFileWithProgress(file))
            .toList();
      });
    } else {
      // User canceled the file selection
    }
  }

  Future<void> uploadFiles() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedFiles.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please select a file to upload',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    List<Future<void>> uploadTasks = [];

    for (var file in selectedFiles) {
      final country = countryController.text;
      final meeting = meetingController.text;
      final church = churchController.text;
      final place = placeController.text;
      final year = yearController.text;

      final folderPath =
          'userUploads/$country/$meeting/$church/$place/$year';

      final ref =
      FirebaseStorage.instance.ref().child('$folderPath/${file.name}');
      UploadTask task = ref.putFile(File(file.path!));

      file.uploadTask = task; // Assign the upload task to the uploadTask property

      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        setState(() {
          file.uploadProgress = progress;
        });

        if (progress == 1.0) {
          bool allFilesUploaded =
          selectedFiles.every((file) => file.uploadProgress == 1.0);
          if (allFilesUploaded) {
            uploadedFileCount++; // Increment the uploaded file count
            if (uploadedFileCount == selectedFiles.length) {
              send(); // Send email when all files are uploaded
              Fluttertoast.showToast(
                msg: 'All files uploaded successfully!',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
              );
            }
          }
        }
      });

      Future<void> uploadTask = task.whenComplete(() {
        setState(() {
          selectedFiles.remove(file);
        });
      });

      uploadTasks.add(uploadTask);
    }

    await Future.wait(uploadTasks);

    setState(() {
      isLoading = false;
      countryController.clear();
      meetingController.clear();
      churchController.clear();
      placeController.clear();
      yearController.clear();
    });
  }

  void deleteFile(int index) {
    setState(() {
      final file = selectedFiles[index];
      file.uploadTask?.cancel(); // Cancel the upload task if it exists
      if (file.uploadProgress == 1.0) {
        uploadedFileCount--; // Decrement the uploaded file count
      }
      selectedFiles.removeAt(index);
    });
  }

  Future send() async {
    const serviceId = 'service_sy4ttq9';
    const templateId = 'template_2nmfrv3';
    const userId = '5qyQwL4ckVddoO_1Q';
    const email = 'aresnov3@gmail.com';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {'to_email': email}
      }),
    );
    //if (kDebugMode) {
    log(response.body);
    //}
  }

  @override
  void dispose() {
    countryController.dispose();
    meetingController.dispose();
    churchController.dispose();
    placeController.dispose();
    yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('upload'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: countryController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'isCountryRequired'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Country',
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: meetingController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'isMeetingRequired'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Meeting',
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: churchController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'isChurchRequired'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Church',
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: placeController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'isPlaceRequired'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Place',
                  ),
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: yearController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'isYearRequired'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Year',
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: selectFiles,
                  child: Text('Select Files'),
                ),
                SizedBox(height: 10.0),
                Container(
                  height: 200.0, // Set a fixed height for the ListView
                  child: ListView.builder(
                    itemCount: selectedFiles.length,
                    itemBuilder: (context, index) {
                      final file = selectedFiles[index];
                      return ListTile(
                        title: Text(file.editedName),
                        subtitle: file.uploadProgress != null
                            ? LinearProgressIndicator(
                          value: file.uploadProgress,
                        )
                            : null,
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteFile(index);
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: isLoading ? null : uploadFiles,
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text('Upload Files'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
