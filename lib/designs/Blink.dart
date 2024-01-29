import 'package:flutter/material.dart';
import 'package:pomodoro/ClockTimer.dart';

class Blink {

  int _blinkTick = 0;
  int _blinkTime = 5;
  bool _isBlink = false;
  var widget;
  Color colorOn = Colors.orangeAccent;
  Color colorOff = Colors.orange;

  Color _getBlinkColor() {
    if (_blinkTick % 2 == 0) {
      return colorOff;
    }
    return colorOn;
  }

  Blink(this._blinkTime, this.colorOff, this.colorOn) {
    widget = Container(
      decoration: BoxDecoration(
        color: _getBlinkColor(),
        shape: BoxShape.circle,
      ),
    );
  }

  Container getWidget() {
    return widget;
  }

  void blink() {
    if (_isBlink) {
      print('widget is blinking');
      return;
    }
    _isBlink = true;
    ClockTimer timer = ClockTimer(_blinkTime);
    timer.handler = (tick) => {
      _blinkTick = tick,
      if (_blinkTick <= 0) {_blinkTick = 0, _isBlink = false, timer.pause()}
    };
    timer.state = ClockState.running;
  }
}