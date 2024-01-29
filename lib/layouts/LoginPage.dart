import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pomodoro/controllers/UserDataController.dart';
import 'package:realm/realm.dart';

import '../designs/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  var controller = UserDataController();
  final color = CustomTheme.currentTheme;

  void signIn() {

  }

  void signUp() {
    // Navigator.pop(context, 'yes');
  }

  @override
  Widget build(BuildContext context) {
    var idController = TextEditingController();
    var pwController = TextEditingController();

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
