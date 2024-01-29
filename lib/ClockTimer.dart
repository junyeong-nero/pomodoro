import 'dart:async';

enum ClockState { pause, running, stop }

class ClockTimer {
  late Timer _timer;
  ClockState state = ClockState.stop;
  Function handler = () => {};
  int progress = 0;

  ClockTimer(int value) {
    progress = value;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state == ClockState.running) {
        progress -= 1;
      }
      handler(progress);
    });
  }

  void pause() {
    _timer.cancel();
  }
}
