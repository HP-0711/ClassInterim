import 'package:classinterim/Chats/models/attendance_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Formcontroller {
  final void Function(String) callback;

  static const String url =
      "https://script.google.com/macros/s/AKfycbxGWTRKguN8FKB6giUqp7uIxLGFLhY2IYfIPCcabkKMR7WusRT6pcWfp4ky6l4nngDV/exec";
  static const STATUS_SUCCESS = "SUCCESS";

  Formcontroller(this.callback);

  void submitForm(AttendanceForm attendanceForm) async {
    try {
      await http.get(url + attendanceForm.toParams()).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      print(e);
    }
  }
}
