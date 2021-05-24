import 'package:classinterim/Chats/helper/constants.dart';
import 'package:classinterim/Chats/helper/consts.dart';
import 'package:classinterim/Chats/services/database.dart';
import 'package:classinterim/Chats/views/chat.dart';
import 'package:classinterim/Chats/views/search.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var data = snapshot.data.documents[index];
                  return ChatRoomsTile(
                    userName: data['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: data["chatRoomId"],
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Constants.myName = await preferences.getString("Username");
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print(
            "we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: AppColors.darkColor,
        title: Text(
          "Chats",
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: AppColors.blueColor,
                size: 31,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search()));
              })
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: 50,
        height: 71,
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.all(
            Radius.circular(00),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 11,
            ),
            CircleAvatar(
              child: Text(userName.substring(0, 2),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 21,
            ),
            Text(userName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
