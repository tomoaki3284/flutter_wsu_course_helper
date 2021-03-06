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

  Map<String, dynamic> toJson() => {
    'courseCRN': courseCRN,
    'subject': subject,
    'title': title,
    'classDescription': classDescription,
    'faculty': faculty,
    'room': room,
    'timeString': timeString,
    'credit': credit,
    'isLab': isLab,
    'isCancelled': isCancelled,
    'cores': cores,
    'weeklyHours': weeklyHours,
  };

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

  /// return number [1,2,3,...] or 'L'
  /// return 'L' if class is lab && can bind with any class that has same subject
  String getSectionNumber() {
    List<String> crnArr = courseCRN.split(' ');
    if (isLab) {
      // sectionNumberChunk looks like "0LA12477", "01A12477", "02A12477"
      // I want "L", "1", "2", since these are the section number
      String sectionNumberChunk = crnArr[crnArr.length - 1];
      String sectionNumber = sectionNumberChunk.substring(1, 2);
      return sectionNumber;
    } else {
      // sectionNumberChunk looks like "0128-002"
      // I want last character "2", since this is the section number
      String sectionNumberChunk = crnArr[2];
      String sectionNumber = sectionNumberChunk.substring(
          sectionNumberChunk.length - 1, sectionNumberChunk.length);
      return sectionNumber;
    }
  }

  String getCoresString() {
    if (cores.length == 0) {
      return '';
    } else if (cores.length == 1) {
      return cores[0];
    }
    String res = '';
    for (String core in cores) {
      res += '$core, ';
    }
    res = res.trim();
    return res.substring(0, res.length-1);
  }

  List<String> getClassTimeOfEachDay() {
    List<String> res = [];
    for (var day in weeklyHours.keys) {
      for (var hour in weeklyHours[day]) {
        res.add('$day:  ${hour.getMilitaryTime()}');
      }
    }

    if (res.isEmpty) {
      res.add('no schedule available');
    }

    return res;
  }
}