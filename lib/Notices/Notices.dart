import 'package:flutter/material.dart';

import 'Widgets/TweetContainer.dart';

class Notices extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Notices> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0XFF1e1c26),
          elevation: 0.5,
          centerTitle: true,
          leading: Container(
            height: 40,
          ),
          title: Text(
            'Notices',
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
        body: Container(
          child: TweetContainer(),
        ));
  }
}
