import 'package:classinterim/Chats/helper/consts.dart';
import 'package:classinterim/Chat/models/chat_model.dart';
import 'package:classinterim/Chat/pages/chat_item_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController searchusername = new TextEditingController();
  List<ChatModel> list = ChatModel.list;
  QuerySnapshot searchsnapshot;

  getUserbyUsername(String username) async {
    FirebaseFirestore.instance
        .collection('Users')
        .where("Username", isEqualTo: username)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          print(doc["Username"]);
          print(doc["Email"]);
          return searchsnapshot != null
              ? ListView.builder(
                  itemCount: searchsnapshot.documents.length,
                  itemBuilder: (context, index) {
                    return SearchTile(
                      username: doc["Username"],
                      email: doc["Email"],
                    );
                  })
              : Container(
                  child: Text('No'),
                );
        });
        return Text("loading");
      },
    );
  }

  initiatesearch() {
    getUserbyUsername(searchusername.text);
  }

  @override
  void initState() {
    initiatesearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.mainColor,
        title: Text(
          "Chats",
          style: TextStyle(
            fontSize: 32,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.filter,
              color: AppColors.blueColor,
            ),
            onPressed: null,
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(11),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: AppColors.darkColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white54,
                  ),
                  hintText: "Search Username",
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 21),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.indigo,
                      size: 25,
                    ),
                    onPressed: () {
                      initiatesearch();
                    },
                  )),
              controller: searchusername,
              style: TextStyle(color: Colors.white54, fontSize: 23),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatItemPage(),
                      ),
                    );
                  },
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                      image: DecorationImage(
                        image: ExactAssetImage(""),
                      ),
                    ),
                  ),
                  title: Text(
                    list[index].contact.name,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
        ),
        backgroundColor: AppColors.blueColor,
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String username;
  final String email;

  SearchTile({this.username, this.email});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                title: Text(username),
                subtitle: Text(email),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Message'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
