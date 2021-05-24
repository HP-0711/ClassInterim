import 'package:classinterim/Students/Attendance/ViewAttendance.dart';
import 'package:classinterim/Students/bottomNavigationbar.dart';
import 'package:flutter/material.dart';

class SCommonAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool menuenabled;
  final bool notificationenabled;
  final Function ontap;
  const SCommonAppBar({
    Key key,
    this.title,
    this.menuenabled,
    this.notificationenabled,
    this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black87,
            size: 21,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SBottomNavigation()));
          }),
      title: Text(
        "${title}",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(50);
}
