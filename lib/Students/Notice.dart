import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Notice extends StatefulWidget {
  @override
  notice createState() => notice();
}

class notice extends State<Notice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: FlatButton(
            child: Text('Logout'),
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.remove("Username");
              preferences.remove("Status");
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyApp()));
            },
          ),
        ),
      ),
    );
  }
}
