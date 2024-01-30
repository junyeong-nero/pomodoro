// import 'package:realm/realm.dart';
//
// part 'car.g.dart';

import 'dart:convert';


class UserData {
  String? id;
  String? password;
  String? name;
  Settings settings = Settings();
  Map<String, dynamic> history = {};

  UserData({this.id, this.password, this.name});

  Map<dynamic, dynamic> toJson() {
    return {
      "name": name,
      "id": id,
      "password": password,
      "settings": settings.toJson(),
      "history": history
    };
  }

  factory UserData.init() {
    return UserData(
        id: "test_id", password: "test_password", name: "test_name");
  }

  factory UserData.fromJson(Map<dynamic, dynamic> json) {
    var user = UserData(
        id: json['id'], password: json['password'], name: json['name']);
    user.settings = Settings.fromJson(json['settings']);
    user.history = json['history'];
    return user;
  }
}

class Settings {
  var sound = false;
  var vibration = false;
  var light = false;
  var targetTime = 40;
  var themeIndex = 0;

  Settings();

  Map<dynamic, dynamic> toJson() {
    return {
      "sound": sound,
      "vibration": vibration,
      "light": light,
      "target_time": targetTime,
      "theme_index": themeIndex
    };
  }

  factory Settings.fromJson(Map<dynamic, dynamic> json) {
    var temp = Settings();
    temp.sound = json['sound'];
    temp.vibration = json['vibration'];
    temp.light = json['light'];
    temp.targetTime = json['target_time'];
    temp.themeIndex = json['theme_index'];
    return temp;
  }
}
