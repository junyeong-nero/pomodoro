import 'package:vibration/vibration.dart';

class VibrateController {
  static vibrate(times) async {
    var hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator?? false) {
      for (var i = 0; i < times; i++) {
        Vibration.vibrate();
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
  }
}
