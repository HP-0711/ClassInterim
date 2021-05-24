import 'dart:ui';
import 'package:classinterim/Teachers/bottomNavigationbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get_storage/get_storage.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Models/Data_Model.dart';
import 'Students/bottomNavigationbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var username = preferences.getString("Username");
  var role = preferences.getString("Role");
  print(username);
  print(role);
  runApp(MaterialApp(
    home: username == null && role == null
        ? MyApp()
        : role == "Student"
            ? SBottomNavigation()
            : BottomNavigation(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          child: LoginPage(),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Item selectedUser;
  Department selecteddepartment;
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

  int _pageState = 0;

  String role;
  String depart;
  String rollno;
  var _backgroundColor = Colors.white;
  var _headingColor = Color(0xFFB40284A);

  double _headingTop = 100;

  double _loginWidth = 0;
  double _loginHeight = 0;
  double _loginOpacity = 1;

  double _loginYOffset = 0;
  double _loginXOffset = 0;

  double _registerXOffset = 0;
  double _registerYOffset = 0;
  double _registerHeight = 0;

  double _registerOpacity = 1;
  double _registerWidth = 0;

  double _statusXOffset = 0;
  double _statusYOffset = 0;
  double _statusHeight = 0;

  double _statusOpacity = 1;
  double _statusWidth = 0;

  double _departmentXOffset = 0;
  double _departmentYOffset = 0;
  double _departmentHeight = 0;

  double _departmentOpacity = 1;
  double _departmentWidth = 0;

  double windowWidth = 0;
  double windowHeight = 0;
  bool _keyboardVisible = false;
  bool _isObscure = true;
  @override
  void initState() {
    super.initState();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
          print("Keyboard State Changed : $visible");
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    windowHeight = MediaQuery.of(context).size.height;
    windowWidth = MediaQuery.of(context).size.width;

    _loginHeight = windowHeight - 270;
    _registerHeight = windowHeight - 270;
    _statusHeight = windowHeight - 270;
    _departmentHeight = windowHeight - 270;

    switch (_pageState) {
      case 0:
        _backgroundColor = Colors.white;

        _headingTop = 0;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = windowHeight;
        //_loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _loginXOffset = 0;
        _registerYOffset = windowHeight;
        break;
      case 1:
        _backgroundColor = Color(0xFFBD34C59);
        _headingColor = Colors.white;

        _headingTop = 90;

        _loginWidth = windowWidth;
        _loginOpacity = 1;

        _loginYOffset = _keyboardVisible ? 20 : 270;
        //_loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _loginXOffset = 0;
        _registerYOffset = windowHeight;
        break;
      case 2:
        _backgroundColor = Color(0xFFBD34C59);
        _headingColor = Colors.white;

        _headingTop = 90;

        _loginWidth = windowWidth - 40;
        _registerWidth = windowWidth - 0;
        _loginOpacity = 0.7;
        _registerOpacity = 1;

        _loginYOffset = _keyboardVisible ? 20 : 270;
        //_loginHeight = _keyboardVisible ? windowHeight : windowHeight - 240;

        _loginXOffset = 20;
        _registerXOffset = 0;

        _registerYOffset = _keyboardVisible ? 20 : 270;
        //_registerHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _statusYOffset = windowHeight;
        break;
      case 3:
        _backgroundColor = Color(0xFFBD34C59);
        _headingColor = Colors.white;

        _headingTop = 90;
        _loginWidth = windowWidth - 90;
        _registerWidth = windowWidth - 40;
        _statusWidth = windowWidth - 0;

        _loginOpacity = 0.1;
        _registerOpacity = 0.7;
        _statusOpacity = 1;

        _loginYOffset = _keyboardVisible ? 20 : 270;
        //_loginHeight = _keyboardVisible ? windowHeight : windowHeight - 240;

        _registerYOffset = _keyboardVisible ? 20 : 270;
        //_registerHeight = _keyboardVisible ? windowHeight : windowHeight - 250;

        _loginXOffset = 45;
        _registerXOffset = 20;
        _statusXOffset = 0;

        _statusYOffset = _keyboardVisible ? 20 : 280;
        //_statusHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

        _departmentYOffset = windowHeight;
        break;
      case 4:
        _backgroundColor = Color(0xFFBD34C59);
        _headingColor = Colors.white;

        _headingTop = 90;
        _registerWidth = windowWidth - 90;
        _statusWidth = windowWidth - 40;
        _departmentWidth = windowWidth - 0;

        _registerOpacity = 0.1;
        _statusOpacity = 0.7;
        _departmentOpacity = 1;

        _registerYOffset = _keyboardVisible ? 20 : 270;
        //_registerHeight = _keyboardVisible ? windowHeight : windowHeight - 240;

        _statusYOffset = _keyboardVisible ? 20 : 270;
        //_statusHeight = _keyboardVisible ? windowHeight : windowHeight - 250;

        _loginXOffset = 45;
        _registerXOffset = 45;
        _statusXOffset = 20;
        _departmentXOffset = 0;

        _departmentYOffset = _keyboardVisible ? 20 : 280;
        //_departmentHeight =
        _keyboardVisible ? windowHeight : windowHeight - 270;
        break;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          AnimatedContainer(
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 1000),
              color: Colors.white,
              padding: EdgeInsets.only(top: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Center(
                      child: Image.asset(
                        "assets/Logo.png",
                        height: 240,
                      ),
                    ),
                  ),
                  Container(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_pageState == 0) {
                            _pageState = 1;
                          } else {
                            _pageState = 1;
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(32),
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                            "Get Started",
                            style: TextStyle(color: Colors.white, fontSize: 21),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )),
          AnimatedContainer(
            width: _loginWidth,
            height: _loginHeight,
            padding: EdgeInsets.all(32),
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            transform:
                Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(_loginOpacity),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Login to Continue",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFBC7C7C7), width: 2),
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: 60,
                              child: Icon(
                                Icons.supervised_user_circle,
                                size: 25,
                                color: Colors.indigo,
                              )),
                          Expanded(
                            child: TextField(
                              controller: username,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 20),
                                  border: InputBorder.none,
                                  hintText: "Enter Username"),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFBC7C7C7), width: 2),
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: 60,
                              height: 60,
                              child: Icon(
                                Icons.vpn_key,
                                size: 25,
                                color: Colors.indigo,
                              )),
                          Expanded(
                            child: TextField(
                              controller: password,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 20),
                                  border: InputBorder.none,
                                  hintText: "Enter Password",
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        _isObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.indigo,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      })),
                              textInputAction: TextInputAction.done,
                              obscureText: _isObscure,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    /* Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFB40284A), width: 2),
                          borderRadius: BorderRadius.circular(50)),
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: FlatButton(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.fingerprint,
                                size: 40,
                              ),
                              Text(
                                "   Login with Fingerprint",
                                style: TextStyle(
                                    color: Color(0xFFB40284A), fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ), */
                    GestureDetector(
                      onTap: () {
                        setState(() async {
                          SharedPreferences preferences =
                              await SharedPreferences.getInstance();
                          final QuerySnapshot result = await Firestore.instance
                              .collection('Users')
                              .where('Username', isEqualTo: username.text)
                              .where('Password', isEqualTo: password.text)
                              .getDocuments();

                          final List<DocumentSnapshot> documents =
                              result.documents;

                          if (documents.length > 0) {
                            final snackBar =
                                SnackBar(content: Text("Login Successful"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            setState(() {
                              result.documents.forEach((document) {
                                role = document['Role'].toString();
                                depart = document['Department'].toString();

                                preferences.setString(
                                    "Username", username.text);
                                preferences.setString("Role", role.toString());
                                preferences.setString(
                                    "Department", depart.toString());
                                if (role == "Student") {
                                  rollno = document['Rollno'].toString();
                                  preferences.setString("Rollno", rollno);
                                }
                              });
                              if (role == "Faculty") {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BottomNavigation()),
                                );
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SBottomNavigation()));
                              }
                            });
                          } else {
                            final snackBar =
                                SnackBar(content: Text("Invalid Credentials"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(50)),
                        padding: EdgeInsets.all(9),
                        child: Center(
                          child: FlatButton(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 2;
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.indigo, width: 2),
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.all(9),
                          child: Center(
                            child: FlatButton(
                              child: Text(
                                "Create New Account",
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 21),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
          AnimatedContainer(
            width: _registerWidth,
            height: _registerHeight,
            padding: EdgeInsets.all(32),
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            transform: Matrix4.translationValues(
                _registerXOffset, _registerYOffset, 1),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(_registerOpacity),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Create New Account",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFBC7C7C7), width: 2),
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: 60,
                              child: Icon(
                                Icons.email,
                                size: 25,
                                color: Colors.indigo,
                              )),
                          Expanded(
                            child: TextField(
                                controller: email,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 20),
                                    border: InputBorder.none,
                                    hintText: "Enter Email"),
                                textInputAction: TextInputAction.next),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFBC7C7C7), width: 2),
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: 60,
                              child: Icon(
                                Icons.supervised_user_circle,
                                size: 25,
                                color: Colors.indigo,
                              )),
                          Expanded(
                            child: TextField(
                              controller: username,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 20),
                                  border: InputBorder.none,
                                  hintText: "Enter Username"),
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFBC7C7C7), width: 2),
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: 60,
                              child: Icon(
                                Icons.vpn_key,
                                size: 25,
                                color: Colors.indigo,
                              )),
                          Expanded(
                            child: TextField(
                              controller: password,
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 20),
                                  border: InputBorder.none,
                                  hintText: "Enter Password",
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        _isObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.indigo,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                          _keyboardVisible = false;
                                        });
                                      })),
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 3;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(50)),
                        padding: EdgeInsets.all(9),
                        child: Center(
                          child: FlatButton(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 1;
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.indigo, width: 2),
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.all(9),
                          child: Center(
                            child: FlatButton(
                              child: Text(
                                "Back To Login",
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 21),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),

          //Status
          AnimatedContainer(
            width: _statusWidth,
            height: _statusHeight,
            padding: EdgeInsets.all(32),
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            transform: Matrix4.translationValues(0, _statusYOffset, 1),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(_statusOpacity),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Select Status",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFBC7C7C7), width: 2),
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 20,
                          ),
                          Expanded(
                            child: DropdownButton<Item>(
                              underline: Container(color: Colors.transparent),
                              hint: Text(
                                "Select Status",
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                              value: selectedUser,
                              onChanged: (Item value) {
                                setState(() {
                                  selectedUser = value;
                                });
                              },
                              items: users.map((Item user) {
                                return DropdownMenuItem<Item>(
                                  value: user,
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 21,
                                      ),
                                      Text(
                                        user.name,
                                        style: TextStyle(
                                            color: Colors.indigo, fontSize: 21),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 4;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(50)),
                        padding: EdgeInsets.all(9),
                        child: Center(
                          child: FlatButton(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 2;
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.indigo, width: 2),
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.all(9),
                          child: Center(
                            child: FlatButton(
                              child: Text(
                                "Back To Details",
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 21),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),

          //Department
          AnimatedContainer(
            width: _departmentWidth,
            height: _departmentHeight,
            padding: EdgeInsets.all(32),
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(milliseconds: 1000),
            transform: Matrix4.translationValues(0, _departmentYOffset, 1),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(_departmentOpacity),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Select Department",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xFFBC7C7C7), width: 2),
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 20,
                          ),
                          Expanded(
                            child: DropdownButton<Department>(
                              underline: Container(color: Colors.transparent),
                              hint: Text(
                                "Select Department",
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                              value: selecteddepartment,
                              onChanged: (Department value1) {
                                setState(() {
                                  selecteddepartment = value1;
                                });
                              },
                              items: departments.map((Department user) {
                                return DropdownMenuItem<Department>(
                                  value: user,
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        user.departments,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() async {
                          final QuerySnapshot result = await Firestore.instance
                              .collection('Users')
                              .where('Username', isEqualTo: username.text)
                              .getDocuments();
                          final List<DocumentSnapshot> documents =
                              result.documents;
                          if (documents.length > 0) {
                            final snackBar = SnackBar(
                                content: Text("User Already Exists!!"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            Firestore.instance
                                .collection('Users')
                                .document(username.text)
                                .setData({
                              'Username': username.text,
                              'Email': email.text,
                              'Password': password.text,
                              'Department': selecteddepartment.departments,
                              'Role': selectedUser.name
                            });
                            final snackBar = SnackBar(
                                content: Text("User Registered Successfully"));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                          _pageState = 1;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(50)),
                        padding: EdgeInsets.all(9),
                        child: Center(
                          child: FlatButton(
                            child: Text(
                              "Register User",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 3;
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.indigo, width: 2),
                              borderRadius: BorderRadius.circular(50)),
                          padding: EdgeInsets.all(9),
                          child: Center(
                            child: FlatButton(
                              child: Text(
                                "Back To Status",
                                style: TextStyle(
                                    color: Colors.indigo, fontSize: 21),
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
