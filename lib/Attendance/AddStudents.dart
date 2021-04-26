import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddStudent extends StatelessWidget {
  final String course;
  final List students;
  const AddStudent({
    Key key,
    @required this.students,
    @required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AddStudentScreen(
      course: course,
      students: students,
    ));
  }
}

class AddStudentScreen extends StatefulWidget {
  final String course;
  final List students;
  const AddStudentScreen({
    Key key,
    @required this.course,
    @required this.students,
  }) : super(key: key);

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  @override
  Widget build(BuildContext context) {}
}
