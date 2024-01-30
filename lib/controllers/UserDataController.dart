import 'dart:convert';
import 'dart:math' show Random;
import 'package:pomodoro/models/UserData.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../Constants.dart';

class UserDataController {
  var userData = UserData.init();
  var isConnected = false;

  UserDataController() {
    /** TEST Dataset **/
    for (var i = 1; i <= 10; i++) {
      if (Random().nextInt(10) <= 7) {
        updateFocusTime(DateTime.now().subtract(Duration(days: i)),
            Random().nextInt(60 * 3) * 60);
      }
    }
  }

  void init(Map<dynamic, dynamic> json) {
    userData = UserData.fromJson(json);
  }

  static Future<http.Response> login(Map userData) async {
    var url = Uri.http('localhost:3000', 'userRouter/api/login');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(userData));
    return response;
  }

  static Future<http.Response> register(Map userData) async {
    var url = Uri.http('localhost:3000', 'userRouter/api/register');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(userData));

    return response;
  }

  static Future<http.Response> update(UserData userData) async {
    var url = Uri.http(serverURL, 'userRouter/api/update');
    var response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(userData.toJson()));

    return response;
  }

  Future<bool> updateUserData() async {
    if (!isConnected) return false;
    var res = await UserDataController.update(userData);
    return res.body.isEmpty;
  }

  void logout() {
    isConnected = false;
    userData = UserData.init();
  }

  /// 연속으로 집중한 일수를 반환합니다.
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

  int getAccessDays() {
    if (userData.history.isEmpty) {
      return 0;
    }
    return userData.history.length;
  }

  /// 전체 집중 시간을 반환합니다.
  int getTotalFocused() {
    if (userData.history.isEmpty) {
      return 0;
    }
    return userData.history.values.reduce((value, element) => value + element);
  }

  /// 현재 날짜를 기준으로 부터 days 이후까지 집중시간의 합을 반환합니다.
  int getTotalFocusedByDays(int days) {
    DateTime d = DateTime.now();
    var res = 0;
    for (var i = 0; i <= days; i++) {
      res += getFocusedTime(d);
      d = d.subtract(const Duration(days: 1));
    }
    return res;
  }

  /// 전체 평균 집중시간을 반환합니다.
  double getAverage() {
    return getTotalFocused() / getAccessDays();
  }

  /// 현재 날짜를 기준으로부터 days 이후까지 평균 집중시간을 반환합니다.
  double getAverageByDays(int days) {
    double sum = 0;
    DateTime d = DateTime.now();
    for (var i = 0; i < days; i++) {
      d = d.subtract(const Duration(days: 1));
      sum += getFocusedTime(d);
    }
    return sum / days;
  }

  int getFocusedTime(DateTime dateTime) {
    String key = date2str(dateTime);
    if (userData.history.containsKey(key)) {
      return userData.history[key]!;
    }
    return 0;
  }

  /**
   * 날짜를 yyyy/MM/dd 형식으로 변환합니다.
   * history에 저장되는 날짜 형식입니다.
   */
  String date2str(DateTime d) {
    return DateFormat('yyyy/MM/dd').format(d);
  }

  void updateFocusTime(DateTime d, int time) {
    String now = date2str(d);
    if (!userData.history.containsKey(now)) {
      userData.history[now] = 0;
    }
    userData.history[now] = time;
  }

  void addFocusTime(DateTime d, int time) {
    String now = date2str(d);
    if (!userData.history.containsKey(now)) {
      userData.history[now] = 0;
    }
    userData.history[now] = userData.history[now]! + time;
  }

  void addTodayFocusTime(int time) {
    addFocusTime(DateTime.now(), time);
  }

  void updateTargetTime(int target) {
    if (target < 0) {
      target = 0;
    }
    if (target > 60) {
      target = 60;
    }
    userData.settings.targetTime = target;
  }

  void addTargetTime(int time) {
    updateTargetTime(userData.settings.targetTime + time);
  }
}
