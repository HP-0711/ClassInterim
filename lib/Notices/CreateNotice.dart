import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Widgets/RoundedButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class CreateNoticeScreen extends StatefulWidget {
  @override
  _CreateTweetScreenState createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends State<CreateNoticeScreen> {
  String _tweetText;
  File _pickedImage;
  bool _loading = false;

  String imageurl;
  String username;

  void initState() {
    fetchdata();
    super.initState();
  }

  fetchdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      username = preferences.getString("Username");
      print(username);
    });
  }

  Future uploadPic(File imageFile, BuildContext context) async {
    String fileName = basename(imageFile.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    imageurl = await taskSnapshot.ref.getDownloadURL();
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      username = preferences.getString("Username");
      print(username);
      print(imageurl);

      final snackBar = SnackBar(content: Text("Notice Uploaded"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  handleImageFromGallery() async {
    try {
      File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        setState(() {
          _pickedImage = imageFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0XFF252331),
      appBar: AppBar(
        backgroundColor: Color(0XFF2c75fd),
        centerTitle: true,
        title: Text(
          'Notice',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 13),
            TextField(
              style: TextStyle(color: Colors.white70, fontSize: 21),
              maxLength: 280,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: 'Enter your Notice',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF2c75fd), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF2c75fd), width: 2.0),
                ),
                hintStyle: TextStyle(
                  color: Colors.white70,
                ),
              ),
              onChanged: (value) {
                _tweetText = value;
              },
            ),
            SizedBox(height: 5),
            _pickedImage == null
                ? SizedBox.shrink()
                : Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                            color: Color(0XFF2c75fd),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(_pickedImage),
                            )),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
            GestureDetector(
              onTap: handleImageFromGallery,
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  border: Border.all(
                    color: Color(0XFF2c75fd),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 50,
                  color: Color(0XFF2c75fd),
                ),
              ),
            ),
            SizedBox(height: 20),
            RoundedButton(
              btnText: 'Upload Notice',
              onBtnPressed: () async {
                setState(() {
                  _loading = true;
                });
                if (_tweetText != null && _tweetText.isNotEmpty) {
                  if (_pickedImage == null) {
                    imageurl = '';
                  } else {
                    await uploadPic(_pickedImage, context);
                  }
                  Firestore.instance.collection("Notices").doc().set({
                    "text": _tweetText,
                    "image": imageurl,
                    "uploaded_by": username,
                    "timestamp": Timestamp.fromDate(DateTime.now())
                  });
                }
                setState(() {
                  _loading = false;
                });
              },
            ),
            SizedBox(height: 20),
            _loading ? CircularProgressIndicator() : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
