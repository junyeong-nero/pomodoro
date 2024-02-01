import 'package:flutter/material.dart';

class CustomTheme {
  static int themeIndex = 0;
  static List<Color> currentTheme() {
    return CustomTheme.themeList[CustomTheme.themeIndex];
  }

  static List<List<Color>> themeList = [
    ColorTheme.origin,
    ColorTheme.greens,
  ];
  static List<String> themeName = [
    'origin',
    'greens',
  ];
}

class ColorTheme {
  static const List<Color> origin = [
    Color.fromARGB(255, 13, 27, 42), // 0
    Color.fromARGB(255, 27, 38, 59), // 1
    Color.fromARGB(255, 71, 89, 117), // 2
    Color.fromARGB(255, 124, 140, 167), // 3
    Color.fromARGB(255, 217, 217, 217), // 4
    Color.fromARGB(255, 197, 98, 98), // 5
  ];

  static const List<Color> greens = [
    Color.fromARGB(255, 5, 42, 30),
    Color.fromARGB(255, 18, 55, 42),
    Color.fromARGB(255, 67, 104, 80),
    Color.fromARGB(255, 173, 188, 159),
    Color.fromARGB(255, 251, 250, 218),
    Color.fromARGB(255, 224, 176, 41),
  ];
}
