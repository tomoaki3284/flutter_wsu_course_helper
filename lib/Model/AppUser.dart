import 'package:flutter/cupertino.dart';
import 'package:wsu_course_helper/Model/SchedulePool.dart';

import '../Logger.dart';

class AppUser with ChangeNotifier {
  static final String defaultUsername = "student";

  String username;
  String email;
  String password;

  SchedulePool schedulePool = SchedulePool();

  AppUser(
      {String username,
      String email,
      String password,
      SchedulePool schedulePool}) {
    Logger.LogDetailed('AppUser', 'constructor', 'method called');

    this.username = username ?? defaultUsername;
    this.email = email ?? "";
    this.password = password ?? "";

    if (schedulePool != null && schedulePool.scheduleByName.length != 0) {
      this.schedulePool = schedulePool;
    }
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'schedulePool': schedulePool,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    Logger.LogDetailed('AppUser.dart', 'User.fromJson', 'method called');

    return AppUser(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      schedulePool: SchedulePool.fromJson(json['schedulePool']),
    );
  }

  factory AppUser.fromDatabase(Map<dynamic, dynamic> data) {
    Logger.LogDetailed('AppUser.dart', 'User.fromDatabase', 'method called');

    return AppUser(
      username: data['username'],
      password: data['password'],
      email: data['email'],
      schedulePool: SchedulePool.fromDatabase(data['schedulePool']),
    );
  }

  Map<dynamic, dynamic> getAppUserDataMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'schedulePool': schedulePool.getScheduleDataMap(),
    };
  }

  void changeReference(AppUser user) {
    this.email = user.email;
    this.password = user.password;
    this.username = user.username;
    this.schedulePool = user.schedulePool;
  }

  bool isValidUser() {
    return username != defaultUsername;
  }

  // provider methods
  void setName(String username) {
    this.username = username;
    notifyListeners();
  }

  void setSchedulePool(SchedulePool schedulePool) {
    this.schedulePool = schedulePool;
    notifyListeners();
  }
}
