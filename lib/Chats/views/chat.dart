import 'dart:io';
import 'package:classinterim/Chats/helper/constants.dart';
import 'package:classinterim/Chats/helper/consts.dart';
import 'package:classinterim/Chats/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;

  Chat({this.chatRoomId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  String fileurl;

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data.documents[index];
                  return MessageTile(
                    message: data["message"],
                    file: data['file'].toString(),
                    sendByMe: Constants.myName == data["sendBy"],
                    //file: data['file'],
                  );
                })
            : Text('');
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
        "file": ""
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  File file;
  Future Upload() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;
    setState(() {
      file = File(path);
    });
    String fileName = basename(result.toString());
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(file);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    fileurl = await taskSnapshot.ref.getDownloadURL();
    Map<String, dynamic> chatMessageMap = {
      "sendBy": Constants.myName,
      "file": fileurl.toString(),
      'time': DateTime.now().millisecondsSinceEpoch,
      "message": ""
    };

    DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.darkColor,
        elevation: 2,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.blueColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Chats'),
        centerTitle: true,
      ),
      body: Container(
        child: Stack(children: [
          chatMessages(),
        ]),
      ),
      bottomNavigationBar: _buildInput(),
    );
  }

  Widget _buildInput() {
    return Container(
      margin: EdgeInsets.only(bottom: 12, left: 12, right: 12),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.darkColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Type something...",
                hintStyle: TextStyle(
                  color: Colors.white30,
                ),
              ),
              style: TextStyle(fontSize: 21, color: Colors.white30),
              controller: messageEditingController,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.attach_file,
              color: AppColors.blueColor,
            ),
            onPressed: () {
              Upload();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: AppColors.blueColor,
            ),
            onPressed: () {
              addMessage();
            },
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final String file;
  MessageTile(
      {@required this.message, @required this.sendByMe, @required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 14,
          bottom: 14,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin:
              sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(top: 12, bottom: 12, left: 20, right: 20),
          decoration: BoxDecoration(
              borderRadius: sendByMe
                  ? file == ""
                      ? null
                      : BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10))
                  : file == ""
                      ? null
                      : BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
              gradient: LinearGradient(
                colors: sendByMe
                    ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                    : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
              )),
          child: file == ""
              ? Text(message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300))
              : Image(
                  image: NetworkImage(file.toString()),
                  fit: BoxFit.contain,
                  width: 270,
                )),
    );
  }
}
