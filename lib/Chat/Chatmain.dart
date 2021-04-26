import 'package:classinterim/Chat/pages/chat_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(ChatMain());

class ChatMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatPage(),
    );
  }
}
