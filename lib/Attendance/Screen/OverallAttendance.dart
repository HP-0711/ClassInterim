import 'package:classinterim/Attendance/Widgets/OverAllAttendanceCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OverallAttendance extends StatefulWidget {
  @override
  _OverallAttendanceState createState() => _OverallAttendanceState();
}

class _OverallAttendanceState extends State<OverallAttendance> {
  String date = DateFormat("dd/MM/yyyy").format(DateTime.now());
  String user;
  String role;
  String department;

  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  Future fetchdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      department = pref.getString("Department");
      user = pref.getString("Username");
      role = pref.getString("Role");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF252331),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection("Users")
              .where("Role", isEqualTo: "Student")
              .where("Department", isEqualTo: department)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
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
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return OverallAttendanceCard(
                      date: date,
                      Rollno: document["Rollno"],
                    );
                  }).toList(),
                );
            }
          }),
    );
  }
}
