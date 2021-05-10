import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:classinterim/Chats/Chatmain.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Notices.dart';
import 'ProfilePage.dart';

class SBottomNavigation extends StatefulWidget {
  bottomnavigation createState() => bottomnavigation();
}

class bottomnavigation extends State<SBottomNavigation> {
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
  }

  int _currentIndex = 0;
  String username;
  double windowWidth = 0;
  double windowHeight = 0;

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              child: chatmain(),
            ),
            Container(
              child: Notice(),
            ),
            Container(),
            Container(
              child: SProfilePage(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => {
          setState(() => _currentIndex = index),
          _pageController.jumpToPage(index)
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: Icon(Icons.messenger),
            title: Text('Chats'),
            activeColor: Colors.pink,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.notifications),
            title: Text('notifications'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.add),
            title: Text(
              'Attendance',
            ),
            activeColor: Colors.pink,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person_rounded),
            title: Text('Profile'),
            activeColor: Colors.blue,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
