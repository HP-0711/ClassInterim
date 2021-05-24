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
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          leading: Container(
            height: 40,
          ),
          title: Text(
            'Notices',
            style: TextStyle(
              color: Color(0XFF252331),
            ),
          ),
        ),
        body: Container(
          child: TweetContainer(),
        ));
  }
}
