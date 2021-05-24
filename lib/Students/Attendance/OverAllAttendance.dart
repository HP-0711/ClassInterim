import 'package:classinterim/Students/Attendance/AppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'OverAllAttendanceCard.dart';

class VOverallAttendance extends StatefulWidget {
  @override
  _OverallAttendanceState createState() => _OverallAttendanceState();
}

class _OverallAttendanceState extends State<VOverallAttendance> {
  String user;
  String role;
  String Department;
  String rollno;
  String subject;

  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  fetchdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      user = preferences.getString("Username");
      role = preferences.getString("Role");
      Department = preferences.getString("Department");
      rollno = preferences.getString("Rollno");
      subject = preferences.getString("Subject");
      print(subject);
      print(rollno);
      print(Department);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0XFF252331),
        appBar: SCommonAppBar(
          title: "View Attendance",
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("Courses")
                .document(subject)
                .collection("Attendance")
                .where("Rollno", isEqualTo: rollno)
                .snapshots(),
            // ignore: missing_return
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  return new ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return VOverallAttendanceCard(
                        date: document['Date'],
                        Rollno: document["Rollno"],
                        Subject: document['Subject'],
                        Attendance: document['Attendance'],
                      );
                    }).toList(),
                  );
              }
            }));
  }
}
