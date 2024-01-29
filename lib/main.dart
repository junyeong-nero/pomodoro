import 'package:flutter/material.dart';
import 'package:pomodoro/layouts/EmptyPage.dart';
import 'layouts/LoginPage.dart';
import 'layouts/MainPage.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pomodoro',
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(title: "Main Page"),
        '/empty': (context) => const EmptyPage(title: "Empty Page"),
        '/login': (context) => const LoginPage(title: "Login Page")
      },
    );
  }
}