import 'dart:io';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:classinterim/Attendance/home.dart';
import 'package:classinterim/Chats/Chatmain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

import 'ProfilePage.dart';

class BottomNavigation extends StatefulWidget {
  bottomnavigation createState() => bottomnavigation();
}

class bottomnavigation extends State<BottomNavigation> {
  PageController _pageController;
  KeyboardVisibilityNotification _keyboardVisibility =
      new KeyboardVisibilityNotification();
  bool _keyboardVisible = false;
  bool _keyboardState;
  int _keyboardVisibilitySubscriberId;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _keyboardState = _keyboardVisibility.isKeyboardVisible;

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
          print("Keyboard State Changed : $visible");
        });
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
  }

  int _currentIndex = 0;
  File _image;
  String imageurl;
  String username;
  double windowWidth = 0;
  double windowHeight = 0;
  String date = DateFormat("dd/mm/yyyy ").format(DateTime.now());
  String time = DateFormat("hh:mm:ss ").format(DateTime.now());
  TextEditingController description = new TextEditingController();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    imageurl = await taskSnapshot.ref.getDownloadURL();
    print(imageurl);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString("Username");

    setState(() {
      final snackBar = SnackBar(content: Text("Notice Uploaded"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              child: chatmain(),
            ),
            Container(
              color: Colors.indigo,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: windowWidth,
                      height:
                          _keyboardVisible ? windowHeight : windowHeight - 250,
                      padding: EdgeInsets.all(32),
                      //curve: Curves.fastLinearToSlowEaseIn,
                      transform: Matrix4.translationValues(0, 71, 1),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40))),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Upload Notice",
                                style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFBC7C7C7), width: 2),
                                    borderRadius: BorderRadius.circular(0)),
                                height: 200,
                                child: (_image != null)
                                    ? Image.file(_image, fit: BoxFit.fill)
                                    : Image.network(
                                        'https://th.bing.com/th/id/Rff4cebf1453d33962d8134e37c78ba3e?rik=r%2bzfchFd8MDF8Q&riu=http%3a%2f%2fwhatcommasoniclodge.org%2fwp-content%2fuploads%2f2016%2f12%2f112815904-stock-vector-no-image-available-icon-flat-vector-illustration.jpg&ehk=WU10UibQsy%2b0gBsq43vu4TVeZanFlRmXLbiZFH84X0s%3d&risl=&pid=ImgRaw',
                                        fit: BoxFit.contain,
                                      )),
                            Padding(
                              padding: EdgeInsets.only(top: 1),
                              child: IconButton(
                                icon: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.indigo,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  getImage();
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xFFBC7C7C7), width: 2),
                                  borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      width: 60,
                                      height: 60,
                                      child: Icon(
                                        Icons.message_outlined,
                                        size: 25,
                                        color: Colors.indigo,
                                      )),
                                  Expanded(
                                    child: TextField(
                                      controller: description,
                                      style: TextStyle(fontSize: 21),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        border: InputBorder.none,
                                        hintText: "Enter Notice Description",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  Firestore.instance
                                      .collection('Notices')
                                      .document()
                                      .setData({
                                    'Notice Description': description.text,
                                    'Uploaded_by': username,
                                    'Upload_date': date,
                                    'Upload_time': time,
                                    'image_url': imageurl.toString()
                                  });
                                  print('pressed');
                                  uploadPic(context);
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 21),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.indigo, width: 2),
                                    borderRadius: BorderRadius.circular(50)),
                                padding: EdgeInsets.all(9),
                                child: Center(
                                  child: FlatButton(
                                    child: Text(
                                      'Upload Notice',
                                      style: TextStyle(
                                          fontSize: 23, color: Colors.indigo),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: AttendanceScreen(),
            ),
            Container(
              child: ProfilePage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => {
          setState(() => _currentIndex = index),
          _pageController.jumpToPage(index)
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.messenger),
            title: Text('Chats'),
            activeColor: Colors.pink,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.notifications),
            title: Text('notifications'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.add),
            title: Text(
              'Attendance',
            ),
            activeColor: Colors.pink,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person_rounded),
            title: Text('Profile'),
            activeColor: Colors.blue,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
