import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Model/User.dart';

class InternalStorage {

  static final String _localFilePathUser = "user.txt";
  static SharedPreferences _prefs;

  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  static save(String key, value) async {
    await _prefs.setString(key, json.encode(value));
  }

  static read(String key) async {
    var user = await json.decode(_prefs.getString(key));
    return user;
  }

  static remove(String key) async {
    await _prefs.remove(key);
  }
}
