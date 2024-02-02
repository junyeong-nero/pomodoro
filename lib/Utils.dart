class Utils {
  static String convertSecond2Text(int second) {
    return "${"${(second / 60).floor()}".padLeft(2, "0")}:${"${second % 60}".padLeft(2, "0")}";
  }

  static String convertSecond2display(int second) {
    if (second >= 3600) {
      return "${(second / 3600).toStringAsFixed(1)}H";
    }
    return "${(second / 60).toStringAsFixed(1)}M";
  }
}