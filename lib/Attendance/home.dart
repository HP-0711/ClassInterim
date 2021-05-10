import 'package:classinterim/Attendance/MarkAttendance.dart';
import 'package:classinterim/Attendance/ViewAttendanceAll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
  SharedPreferences prefs;
  bool _load = false;
  String role;
  double windowWidth = 0;
  double windowHeight = 0;
  var department;
  var rollno;
  TextEditingController courses = new TextEditingController();
  @override
  void initState() {
    super.initState();
    try {
      SharedPreferences.getInstance().then((sharedPrefs) {
        setState(() {
          prefs = sharedPrefs;
          username = prefs.getString('Username');
          role = prefs.getString('Role');
          print(role);
        });
      });
    } catch (e) {
      print(e.message);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  getdata(String username) async {
    return await FirebaseFirestore.instance
        .collection("Courses")
        .where("Faculty", isEqualTo: username)
        .snapshots();
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
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              username = preferences.getString("Username");
                              final QuerySnapshot result = await Firestore
                                  .instance
                                  .collection('Courses')
                                  .where('Courses_name',
                                      isEqualTo: courses.text)
                                  .where('Faculty', isEqualTo: username)
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
                                    .document()
                                    .setData({
                                  'Courses_name': courses.text,
                                  'Faculty': username,
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
                      height: 300,
                      //color: Colors.indigo,
                      transform: Matrix4.translationValues(0, 21, 2),
                      decoration: BoxDecoration(
                          color: Colors.indigo[300],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40))),
                      child: StreamBuilder(
                          stream: getdata(username),
                          builder: (context, snapshot) {
                            return ListView.builder(
                              padding: EdgeInsets.all(10.0),
                              itemBuilder: (context, index) {
                                var data = snapshot.data.documents[index];
                                return Courses(
                                  Subject: data['Courses_name'],
                                );
                              },
                            );
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

  /*Widget button(String course, List students) {
    return RaisedButton(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    MarkAttendance(course: course, students: students)));
      },
      textColor: Colors.white,
      padding: EdgeInsets.all(0.0),
      child: Container(
        alignment: Alignment.center,
        width: _width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          gradient: LinearGradient(
            colors: <Color>[Colors.orange[200], Colors.pinkAccent],
          ),
        ),
        padding: const EdgeInsets.all(12.0),
      ),
    );

  }*/
}

class Courses extends StatelessWidget {
  String Subject;

  Courses({@required this.Subject});

  @override
  Widget build(BuildContext context) {}
}
