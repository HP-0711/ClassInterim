import 'package:classinterim/Notices/NoticeContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TweetContainer extends StatefulWidget {
  @override
  _TweetContainerState createState() => _TweetContainerState();
}

class _TweetContainerState extends State<TweetContainer> {
  String image;
  String Uploadedby;
  String timestamp;
  String text;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("Notices").snapshots(),
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
                    return NoticeContainer(
                      image: document['image'],
                      text: document['text'],
                      timestamp: document['timestamp']
                          .toDate()
                          .toString()
                          .substring(0, 19),
                      Uploadedby: document['uploaded_by'],
                    );
                  }).toList(),
                );
            }
          }),
    );
  }
}
