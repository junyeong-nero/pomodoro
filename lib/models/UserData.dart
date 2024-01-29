// import 'package:realm/realm.dart';
//
// part 'car.g.dart';

class UserData {

  String name;
  String? id;
  Settings settings;
  Map<String, int> history;

  UserData({
    required this.name,
    required this.settings,
    this.id,
    required this.history});


  Map<dynamic, dynamic> toJson() {
    return {
      "name": name,
      "settings": settings.toJson(),
      "history": history
    };
  }

  factory UserData.init() {
    return UserData(name: "user", settings: Settings(), history: <String, int>{});
  }

  factory UserData.fromJson(Map<dynamic, dynamic> json) {
    return UserData(
        id: json['_id'],
        name: json['name'],
        settings: Settings.fromJson(json['settings']),
        history: json['history']
    );
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
