import 'package:classinterim/Attendance/Screen/Attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username;
  String department;
  bool _load = false;
  String role;
  double windowWidth = 0;
  double windowHeight = 0;

  TextEditingController courses = new TextEditingController();
  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  fetchdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("Username");
      print(username);
      department = preferences.getString("Department");
      print(department);
    });
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.indigo,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: windowWidth,
                height: windowHeight - 191,
                padding: EdgeInsets.all(32),
                //curve: Curves.fastLinearToSlowEaseIn,
                transform: Matrix4.translationValues(0, 91, 1),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40))),

                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Subjects",
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            width: 221,
                            height: 65,
                            margin: EdgeInsets.only(top: 21),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFFBC7C7C7), width: 2),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                    controller: courses,
                                    style: TextStyle(fontSize: 21),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 20),
                                      border: InputBorder.none,
                                      hintText: "Add Subjects",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() async {
                              final QuerySnapshot result = await Firestore
                                  .instance
                                  .collection('Courses')
                                  .where('Courses_name',
                                      isEqualTo: courses.text)
                                  .getDocuments();

                              final List<DocumentSnapshot> documents =
                                  result.documents;
                              if (documents.length > 0) {
                                final snackBar = SnackBar(
                                    content: Text("Course Already Added!"));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                Firestore.instance
                                    .collection('Courses')
                                    .document(courses.text)
                                    .set({
                                  'Courses_name': courses.text,
                                  'Faculty': username,
                                  'Department': department
                                });
                                final snackBar = SnackBar(
                                    content:
                                        Text("Course Added Successfully!"));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            });
                          },
                          child: Container(
                            width: 151,
                            height: 65,
                            margin: EdgeInsets.only(top: 21),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.indigo, width: 2),
                                borderRadius: BorderRadius.circular(50)),
                            padding: EdgeInsets.all(4),
                            child: Center(
                              child: FlatButton(
                                child: Text('Add Subjects',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.indigo,
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 21,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 9, bottom: 9),
                      width: 500,
                      height: 350,
                      //color: Colors.indigo,
                      transform: Matrix4.translationValues(0, 21, 2),
                      decoration: BoxDecoration(
                          color: Colors.indigo[300],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50))),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('Courses')
                              .where('Faculty', isEqualTo: username)
                              .where("Department", isEqualTo: department)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError)
                              return new Text('Error: ${snapshot.error}');
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      Text(
                                        "Connecting to Cloud ...",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontStyle: FontStyle.italic,
                                            height: 2,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                );
                              default:
                                return ListView(
                                  children: snapshot.data.documents
                                      .map((DocumentSnapshot document) {
                                    return Courses(
                                        Subject: document["Courses_name"]);
                                  }).toList(),
                                );
                            }
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Courses extends StatelessWidget {
  // ignore: non_constant_identifier_names
  String Subject;

  // ignore: non_constant_identifier_names
  Courses({@required this.Subject});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("Subject", Subject);
              print(Subject);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Attendance()));
            },
            child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                child: Row(children: [
                  Text(
                    Subject,
                    style: TextStyle(fontSize: 25),
                  ),
                ]))));
  }
}
