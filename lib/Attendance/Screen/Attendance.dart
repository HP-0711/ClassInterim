import 'package:flutter/material.dart';
import '../AppBar.dart';
import 'OverallAttendance.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: CommonAppBar(
        title: "Attendance",
      ),
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DefaultTabController(
              length: 2, // length of tabs
              initialIndex: 0,
              child: Container(
                height: MediaQuery.of(context).size.height *
                    0.68, //height of TabBarView
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: OverallAttendance(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
