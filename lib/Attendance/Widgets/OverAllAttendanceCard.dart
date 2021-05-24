import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OverallAttendanceCard extends StatefulWidget {
  final String date;
  final String Rollno;

  const OverallAttendanceCard({
    Key key,
    this.date,
    this.Rollno,
  }) : super(key: key);

  @override
  _OverallAttendanceCardState createState() => _OverallAttendanceCardState();
}

class _OverallAttendanceCardState extends State<OverallAttendanceCard>
    with SingleTickerProviderStateMixin {
  Animation animation, delayedAnimation;
  AnimationController animationController;

  String user;
  String role;
  String Department;
  String Subject;

  @override
  void initState() {
    fetchdata();
    super.initState();

    animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.2, 0.6, curve: Curves.fastOutSlowIn)));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();
  }

  void fetchdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    user = preferences.getString("Username");
    role = preferences.getString("Role");
    Department = preferences.getString("Department");
    Subject = preferences.getString("Subject");
    //print(user);
    //print(role);
    //print(Department);
    //print(Subject);
  }

  Future<void> Attendance(attendance) {
    Firestore.instance
        .collection("Courses")
        .document(Subject)
        .collection("Attendance")
        .document()
        .set(attendance)
        .catchError((e) {
      print(e.toString());
    });
  }

  Present() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> attendance = {
      "Subject": Subject,
      "Faculty": user,
      "Rollno": "${widget.Rollno}",
      "Attendance": "Present",
      "Date": DateFormat("dd/MM/yyyy").format(DateTime.now()),
      "Time": DateFormat("hh:mm:ss ").format(DateTime.now()),
      "Department": pref.getString("Department")
    };

    Attendance(attendance);
  }

  Absent() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map<String, dynamic> attendance = {
      "Subject": Subject,
      "Faculty": user,
      "Rollno": "${widget.Rollno}",
      "Attendance": "Absent",
      'Date': DateFormat("dd/MM/yyyy").format(DateTime.now()),
      "Time": DateFormat("hh:mm:ss").format(DateTime.now()),
      "Department": pref.getString("Department")
    };

    Attendance(attendance);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    animationController.forward();
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Transform(
            transform:
                Matrix4.translationValues(delayedAnimation.value * width, 0, 0),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white70,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 3),
                    //blurRadius: 3,
                    //spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Date",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${widget.date}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rollno",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${widget.Rollno}",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Row(children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                //fetchdata();
                                print("Present");
                                Present();
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green),
                                child: Text(
                                  "P",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ))),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                print("Absent");
                                Absent();
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.red),
                              child: Text(
                                "A",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            )),
                      ]),
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
