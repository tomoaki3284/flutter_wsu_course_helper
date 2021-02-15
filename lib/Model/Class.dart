import 'Hours.dart';

class Class {

  final String courseCRN;
  final String subject;
  final String title;
  final String classDescription;
  final String faculty;
  final String room;
  final String timeString;
  final double credit;
  final bool isLab;
  final bool isCancelled;
  final List<String> cores;
  final Map<String, List<Hours>> weeklyHours;

  Class({
      this.courseCRN,
      this.subject,
      this.title,
      this.classDescription,
      this.faculty,
      this.room,
      this.timeString,
      this.credit,
      this.isLab,
      this.isCancelled,
      this.cores,
      this.weeklyHours});

  factory Class.fromJson(Map<String, dynamic> json) {
    List<dynamic> coresFromJson = json["cores"];
    List<String> coreList = new List<String>.from(coresFromJson);

    Map<String, dynamic> weeklyHoursFromJson = json["hoursOfDay"];
    Map<String, List<dynamic>> weeklyHoursFromJson2 = Map<String, List<dynamic>>.from(weeklyHoursFromJson);
    Map<String, List<Hours>> weeklyHoursData = new Map<String, List<Hours>>();
    for (var week in weeklyHoursFromJson2.keys) {
      List<dynamic> hoursList = weeklyHoursFromJson2[week];
      List<Hours> hours = new List<Hours>();
      for (var hour in hoursList) {
        hours.add(Hours.fromJson(hour));
      }
      weeklyHoursData[week] = hours;
    }

    return Class(
      courseCRN: json["courseCRN"],
      subject: json["subject"],
      title: json["title"],
      isLab: json["isLabCourse"],
      classDescription: json["courseDescription"],
      faculty: json["faculty"],
      room: json["room"],
      credit: json["credit"],
      cores: coreList,
      weeklyHours: weeklyHoursData,
      timeString: json["timeContent"],
      isCancelled: json["isCancelled"],
    );
  }
}