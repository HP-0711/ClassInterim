import 'package:flutter/material.dart';

class NoticeContainer extends StatefulWidget {
  final String image;
  final String Uploadedby;
  final String timestamp;
  final String text;

  const NoticeContainer(
      {Key key, this.image, this.Uploadedby, this.timestamp, this.text})
      : super(key: key);
  @override
  _NoticeContainer createState() => _NoticeContainer();
}

class _NoticeContainer extends State<NoticeContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 20, backgroundImage: null),
              SizedBox(width: 10),
              Text(
                "${widget.Uploadedby}",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            "${widget.text}",
            style: TextStyle(fontSize: 21, color: Colors.white),
          ),
          "${widget.image}" == ""
              ? SizedBox(
                  height: 0,
                )
              : Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage("${widget.image}"),
                          )),
                    )
                  ],
                ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.timestamp}",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          SizedBox(height: 10),
          Divider()
        ],
      ),
    );
  }
}
