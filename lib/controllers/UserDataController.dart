import 'dart:convert';
import 'dart:math' show Random;
import 'package:pomodoro/models/UserData.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../Constants.dart';

class UserDataController {
  var userData = UserData.init();
  var isConnected = false;
  var autoLogin = false;

  UserDataController() {
    /** TEST Dataset **/
    for (var i = 1; i <= 10; i++) {
      if (Random().nextInt(10) <= 7) {
        updateFocusTime(DateTime.now().subtract(Duration(days: i)),
            Random().nextInt(60 * 3) * 60);
      }
    }
  }

  /// initialize UserData which is connected to DataController with json
  void init(Map<dynamic, dynamic> json) {
    userData = UserData.fromJson(json);
  }

  /// login with userData
  /// @param(userData) must contain field 'id' and 'password'
  static Future<http.Response> login(Map userData) async {
    try {
      var url = Uri.http('localhost:3000', 'userRouter/api/login');
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: json.encode(userData));
      return response;
    } catch(err) {
      return http.Response('null', 500);
    }
  }

  /// register with userData
  ///
  /// registered data initialized by UserData.init();
  /// @param(userData) must contain field 'id' and 'password'
  static Future<http.Response> register(Map userData) async {
    try {
      var url = Uri.http('localhost:3000', 'userRouter/api/register');
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: json.encode(userData));

      return response;
    } catch(err) {
      return http.Response('null', 500);
    }
  }

  /// update registered userData
  ///
  /// @param(userData) must contain field 'id' and 'password'
  static Future<http.Response> update(UserData userData) async {
    var url = Uri.http(serverURL, 'userRouter/api/update');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(userData.toJson()));
    return response;
  }

  /// update registered userData which is connected to UserDataController
  /// it works equally to UserDataController.update(userDataController.userData);
  Future<bool> updateUserData() async {
    if (!isConnected) return false;
    var res = await UserDataController.update(userData);
    return res.body.isEmpty;
  }

  /// disconnect automatic api calling to update
  void logout() {
    isConnected = false;
    userData = UserData.init();
  }

  /// return continuous streak days
  int getStreakDays() {
    DateTime d = DateTime.now();
    var days = 0;
    while (true) {
      if (getFocusedTime(d) == 0) {
        break;
      }
      d = d.subtract(const Duration(days: 1));
      days += 1;
    }
    return days;
  }

  /// return total accessed days
  int getAccessDays() {
    if (userData.history.isEmpty) {
      return 0;
    }
    return userData.history.length;
  }

  /// return total focused time with second
  int getTotalFocused() {
    if (userData.history.isEmpty) {
      return 0;
    }
    return userData.history.values.reduce((value, element) => value + element);
  }

  /// return summation of focused time between [now - days, now]
  int getTotalFocusedByDays(int days) {
    DateTime d = DateTime.now();
    var res = 0;
    for (var i = 0; i <= days; i++) {
      res += getFocusedTime(d);
      d = d.subtract(const Duration(days: 1));
    }
    return res;
  }

  /// return average focused time overall
  double getAverage() {
    return getTotalFocused() / getAccessDays();
  }

  /// return average focused time between [now - days, now]
  double getAverageByDays(int days) {
    double sum = 0;
    DateTime d = DateTime.now();
    for (var i = 0; i < days; i++) {
      d = d.subtract(const Duration(days: 1));
      sum += getFocusedTime(d);
    }
    return sum / days;
  }

  /// return focused time at date
  int getFocusedTime(DateTime date) {
    String key = date2str(date);
    if (userData.history.containsKey(key)) {
      return userData.history[key]!;
    }
    return 0;
  }

  /// return dates with format of yyyy/MM/dd
  /// this conversion is used to save focused time to UserData.history
  String date2str(DateTime d) {
    return DateFormat('yyyy/MM/dd').format(d);
  }

  /// update focused time at date to time
  void updateFocusTime(DateTime date, int time) {
    String now = date2str(date);
    if (!userData.history.containsKey(now)) {
      userData.history[now] = 0;
    }
    userData.history[now] = time;
  }

  /// increment `time` focused time at date
  void addFocusTime(DateTime d, int time) {
    String now = date2str(d);
    if (!userData.history.containsKey(now)) {
      userData.history[now] = 0;
    }
    userData.history[now] = userData.history[now]! + time;
  }

  /// increment `time` focused time at now
  void addTodayFocusTime(int time) {
    addFocusTime(DateTime.now(), time);
  }

  /// update target time to UserData.settings.targetTime
  void updateTargetTime(int target) {
    if (target < 0) {
      target = 0;
    }
    if (target > 60) {
      target = 60;
    }
    userData.settings.targetTime = target;
  }

  /// increment target time to UserData.settings.targetTime
  void addTargetTime(int time) {
    updateTargetTime(userData.settings.targetTime + time);
  }
}
