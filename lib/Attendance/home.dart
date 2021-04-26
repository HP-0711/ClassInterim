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
  final db = FirebaseFirestore.instance;
  double _height, _width;
  SharedPreferences prefs;
  bool _load = false;
  String _uid, _role;
  double windowWidth = 0;
  double windowHeight = 0;
  var username;
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
          _uid = prefs.getString('Username');
          _role = prefs.getString('Role');
        });
      });
    } catch (e) {
      print(e.message);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: !_load
          ? checkRole()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  Widget checkRole() {
    switch (_role) {
      case 'Faculty':
        return listViewAdmin();
        break;
      default:
        return Center(
          child: Text('Not a valid user role'),
        );
    }
  }

  /* Widget listViewStudents() {
    try {
      return new StreamBuilder(
        stream: Firestore.instance
            .collection('Courses')
            .where('students', arrayContains: _uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          return new ListView(
            children: snapshot.data.documents.map((document) {
              return new Card(
                child: ListTile(
                  title: new Text(document.documentID),
                  subtitle: new Text(document['name']),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ViewAttendanceStud(
                                  code: document.documentID,
                                  uid: _uid,
                                )));
                  },
                ),
              );
            }).toList(),
          );
        },
      );
    } catch (e) {
      print(e.message);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      return Center(child: Text(e.message));
    }
  }*/

  Widget listViewAdmin() {
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
                      child: StreamBuilder<QuerySnapshot>(
                        stream: db
                            .collection('Courses')
                            .where('Faculty', isEqualTo: username)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white70,
                              ),
                            );
                          } else
                            return ListView(
                              padding: EdgeInsets.all(10.0),
                              children: snapshot.data.docs.map((doc) {
                                return Card(
                                    color: Colors.white70,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        doc.data()['Courses_name'],
                                        style: TextStyle(fontSize: 25),
                                      ),
                                      onTap: () {
                                        setState(() async {
                                          final QuerySnapshot result =
                                              await Firestore.instance
                                                  .collection('Users')
                                                  .where('Role',
                                                      isEqualTo: 'Students')
                                                  .where('Department',
                                                      isEqualTo:
                                                          department.toString())
                                                  .getDocuments();
                                          final List<DocumentSnapshot>
                                              documents = result.documents;
                                          setState(
                                            () {
                                              result.documents
                                                  .forEach((document) {
                                                rollno = document['Rollno']
                                                    .toString();
                                              });
                                              if (documents.length > 0) {
                                                print(
                                                    doc.data()['Courses_name']);
                                                print(rollno);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            MarkAttendance(
                                                                course: doc
                                                                        .data()[
                                                                    'Courses_name'],
                                                                students:
                                                                    rollno)));
                                              }
                                            },
                                          );
                                        });
                                      },
                                    ));
                              }).toList(),
                            );
                        },
                      ),
                    ),
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
