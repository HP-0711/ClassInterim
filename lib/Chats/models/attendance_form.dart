class AttendanceForm {
  String Sr;
  String Course;
  String Subject;
  String Faculty;
  String Date;
  String Time;
  String StudentRollno;

  AttendanceForm(this.Sr, this.Subject, this.Course, this.Faculty, this.Date,
      this.Time, this.StudentRollno);

  String toParams() =>
      "?sr=$Sr&subject=$Subject&course=$Course&faculty=$Faculty&date=$Date&time=$Time&studentrollno=$StudentRollno";
}
