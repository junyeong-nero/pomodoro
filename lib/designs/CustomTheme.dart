import 'package:flutter/material.dart';

class CustomTheme {
  static List<Color> currentTheme = ColorTheme.basic;
}

class ColorTheme {
  static const List<Color> basic = [
    Color.fromARGB(255, 13, 27, 42), // 0
    Color.fromARGB(255, 27, 38, 59), // 1
    Color.fromARGB(255, 71, 89, 117), // 2
    Color.fromARGB(255, 124, 140, 167), // 3
    Color.fromARGB(255, 217, 217, 217), // 4
    Color.fromARGB(255, 244, 172, 183), // 5
  ];
}