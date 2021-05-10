import 'package:classinterim/Chats/views/chatrooms.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(chatmain());
}

class chatmain extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<chatmain> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FlutterChat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xff145C9E),
          scaffoldBackgroundColor: Color(0xff1F1F1F),
          accentColor: Color(0xff007EF4),
          fontFamily: "OverpassRegular",
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ChatRoom());
  }
}
