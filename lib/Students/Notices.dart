import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'CRUDMethods.dart';

class Notice extends StatefulWidget {
  noticeState createState() => noticeState();
}

class noticeState extends State<Notice> {
  CrudMethods crudMethods = new CrudMethods();

  Stream blogsStream;

  Widget BlogsList() {
    return Container(
      child: blogsStream != null
          ? Column(
              children: <Widget>[
                StreamBuilder(
                  stream: blogsStream,
                  builder: (context, snapshot) {
                    return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemCount: snapshot.data.documents.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var data = snapshot.data.documents[index];
                          return BlogsTile(
                            UploadedBy: data['Uploaded_by'],
                            Date: data["Upload_date"],
                            Time: data["Upload_time"],
                            description: data['Notice Description'],
                            imgUrl: data['image_url'],
                          );
                        });
                  },
                )
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void initState() {
    crudMethods.getData().then((result) {
      setState(() {
        blogsStream = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Notices",
              style: TextStyle(fontSize: 31, color: Colors.blue),
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: BlogsList(),
    );
  }
}

class BlogsTile extends StatelessWidget {
  String imgUrl, UploadedBy, description, Date, Time;
  BlogsTile(
      {@required this.imgUrl,
      @required this.UploadedBy,
      @required this.description,
      @required this.Date,
      @required this.Time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 300,
      child: Stack(
        children: <Widget>[
          Container(
            height: 300,
            decoration: BoxDecoration(
                color: Colors.black45.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6)),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Uploaded By @' + UploadedBy,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 2,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image(
                    image: NetworkImage(imgUrl.toString()),
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
