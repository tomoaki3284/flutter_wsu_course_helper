import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Logger.dart';
import 'Model/AppUser.dart';

class InternalStorage {

  static final String _localFilePathUser = "user.txt";
  static SharedPreferences _prefs;

  static Future<SharedPreferences> init() async {
    Logger.LogDetailed('InternalStorage.dart', 'init', 'async method called');
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  static save(String key, value) async {
    Logger.LogDetailed('InternalStorage.dart', 'save', 'async method called');
    await _prefs.setString(key, json.encode(value));
  }

  static read(String key) async {
    Logger.LogDetailed('InternalStorage.dart', 'read', 'async method called');
    var user = await json.decode(_prefs.getString(key));
    return user;
  }

  static remove(String key) async {
    Logger.LogDetailed('InternalStorage.dart', 'remove', 'async method called');
    await _prefs.remove(key);
  }
}
