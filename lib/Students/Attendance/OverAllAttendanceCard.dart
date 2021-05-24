import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VOverallAttendanceCard extends StatefulWidget {
  final String date;
  final String Rollno;
  final String Subject;
  final String Attendance;

  const VOverallAttendanceCard(
      {Key key, this.date, this.Rollno, this.Subject, this.Attendance})
      : super(key: key);

  @override
  _OverallAttendanceCardState createState() => _OverallAttendanceCardState();
}

class _OverallAttendanceCardState extends State<VOverallAttendanceCard>
    with SingleTickerProviderStateMixin {
  Animation animation, delayedAnimation;
  AnimationController animationController;

  String user;
  String role;

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
    setState(() {
      user = preferences.getString("Username");
      role = preferences.getString("Role");
      //print(user);
      //print(role);
      //print(Department);
      //print(Subject);
    });
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
                vertical: 13,
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
                          "Subject",
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
                          "${widget.Subject}",
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
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.Attendance == "Present"
                                ? Colors.green
                                : Colors.red,
                          ),
                          child: Center(
                            child: widget.Attendance == "Present"
                                ? Text(
                                    "P",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  )
                                : Text(
                                    "A",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                          ),
                        ),
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
