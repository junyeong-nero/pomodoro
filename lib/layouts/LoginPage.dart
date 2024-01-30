import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pomodoro/controllers/UserDataController.dart';

import '../designs/CustomTheme.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  var controller = UserDataController();
  final color = CustomTheme.currentTheme;

  void signIn() async {
    Map userData = {
      'id': idController.text,
      'password': pwController.text
    };

    var url = Uri.http('localhost:3000', 'userRouter/api/login');
    var response = await http.post(url, headers: <String, String>{
      'Content-Type': 'application/json',
    }, body: json.encode(userData));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // cannot login
    if (!mounted) return;
    if (response.body.toString() == 'null') {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login Failed'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: (){},
            ),
          )
      );
    } else {
      Navigator.pop(context, response.body);
    }
  }

  void signUp() async {
    Map userData = {
      'id': idController.text,
      'password': pwController.text
    };

    var url = Uri.http('localhost:3000', 'userRouter/api/register');
    var response = await http.post(url, headers: <String, String>{
      'Content-Type': 'application/json',
    }, body: json.encode(userData));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  var idController = TextEditingController();
  var pwController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color[3],
        body: Stack(
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(4),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context, 'failed');
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 216,
                    height: 56,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: color[2],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: TextField(
                      controller: idController,
                      cursorColor: color[2],
                      style: TextStyle(color: color[4]),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "ID",
                          hintStyle: TextStyle(color: color[3])),
                    ),
                  ),
                  const Gap(8),
                  Container(
                    width: 216,
                    height: 56,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: color[2],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: TextField(
                      controller: pwController,
                      cursorColor: color[2],
                      style: TextStyle(color: color[4]),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "PASSWORD",
                          hintStyle: TextStyle(color: color[3])),
                    ),
                  ),
                  const Gap(16),
                  Container(
                      width: 96,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color[1],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: TextButton(
                        onPressed: signIn,
                        child: Text(
                          "sign in",
                          style: TextStyle(color: color[4]),
                        ),
                      )),
                  const Gap(4),
                  TextButton(
                    child: Text(
                      "sign up",
                      style: TextStyle(color: color[1]),
                    ),
                    onPressed: () {
                      signUp();
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
