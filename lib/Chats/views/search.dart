import 'package:classinterim/Chats/helper/constants.dart';
import 'package:classinterim/Chats/helper/consts.dart';
import 'package:classinterim/Chats/services/database.dart';
import 'package:classinterim/Chats/views/chat.dart';
import 'package:classinterim/Chats/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await databaseMethods
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.documents.length,
            itemBuilder: (context, index) {
              var data = searchResultSnapshot.documents[index].data();
              return userTile(
                data["Username"],
                data["Email"],
              );
            })
        : Container();
  }

  sendMessage(String userName) {
    print(userName);
    List<String> users = [Constants.myName, userName];

    String chatRoomId = getChatRoomId(Constants.myName, userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  chatRoomId: chatRoomId,
                )));
  }

  Widget userTile(String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: AppColors.blueColor,
                  borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              color: AppColors.mainColor,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 51, left: 21, right: 21, bottom: 21),
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
                          hintStyle:
                              TextStyle(color: Colors.white54, fontSize: 21),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.search,
                              color: Colors.indigo,
                              size: 25,
                            ),
                            onPressed: () {
                              initiateSearch();
                            },
                          )),
                      controller: searchEditingController,
                      style: TextStyle(color: Colors.white54, fontSize: 23),
                    ),
                  ),
                  userList()
                ],
              ),
            ),
    );
  }
}
