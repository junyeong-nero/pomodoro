import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pomodoro/controllers/UserDataController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../designs/CustomTheme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  var controller = UserDataController();
  var idController = TextEditingController();
  var pwController = TextEditingController();
  var autoLogin = true;

  void signIn() async {
    Map userData = {'id': idController.text, 'password': pwController.text};
    var response = await UserDataController.login(userData);
    if (!mounted) return;
    if (response.body.toString() == 'null') {
      popupSnackBar('Login Failed');
    } else {
      Navigator.pop(context, response.body);
      final pref = await SharedPreferences.getInstance();
      if (autoLogin) {
        await pref.setString('id', userData['id']);
        await pref.setString('password', userData['password']);
        await pref.setBool('auto_login', true);
      } else {
        await pref.remove('auto_login');
      }
    }
  }

  void signUp() async {
    try {
      // Map userData = {'id': idController.text, 'password': pwController.text};
      var userData = await Navigator.pushNamed(context, '/login/register');
      if (userData == null || userData.toString() == 'null') {
        return;
      }

      userData = userData as Map<dynamic, dynamic>;
      var response =
          await UserDataController.register(userData);
      if (!mounted) return;
      if (response.body.toString() == 'null') {
        throw 'Register Failed with Connection Error';
      }

      idController.text = '';
      pwController.text = '';
      popupSnackBar('Register Success! retry login');
    } catch (err) {
      popupSnackBar(err.toString());
    }
  }

  void popupSnackBar(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  var hidePassword = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return CustomTheme.currentTheme()[3];
      }
      return CustomTheme.currentTheme()[4];
    }

    return Scaffold(
        backgroundColor: CustomTheme.currentTheme()[3],
        body: Stack(
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(4),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context, 'null');
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
                  SizedBox(
                      width: 288,
                      height: 72,
                      child: Card(
                        elevation: 8,
                        color: CustomTheme.currentTheme()[4],
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              margin: EdgeInsets.all(8),
                              child: Icon(Icons.person,
                                  color: CustomTheme.currentTheme()[1]),
                            ),
                            Container(
                              width: 288 - 80,
                              margin: EdgeInsets.fromLTRB(0, 8, 8, 8),
                              child: TextField(
                                controller: idController,
                                cursorColor: CustomTheme.currentTheme()[4],
                                style: TextStyle(
                                    color: CustomTheme.currentTheme()[1]),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "ID",
                                    hintStyle: TextStyle(
                                        color: CustomTheme.currentTheme()[3])),
                              ),
                            )
                          ],
                        ),
                      )),
                  SizedBox(
                      width: 288,
                      height: 72,
                      child: Card(
                        elevation: 8,
                        color: CustomTheme.currentTheme()[4],
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              margin: EdgeInsets.all(8),
                              child: Icon(Icons.password,
                                  color: CustomTheme.currentTheme()[1]),
                            ),
                            Container(
                              width: 288 - 80 - 44,
                              margin: EdgeInsets.fromLTRB(0, 8, 8, 8),
                              child: TextField(
                                obscureText: hidePassword,
                                controller: pwController,
                                cursorColor: CustomTheme.currentTheme()[4],
                                style: TextStyle(
                                    color: CustomTheme.currentTheme()[1]),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                        color: CustomTheme.currentTheme()[3])),
                              ),
                            ),
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hidePassword = !hidePassword;
                                    });
                                  },
                                  icon: Icon(
                                      hidePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      size: 18,
                                      color: CustomTheme.currentTheme()[1])),
                            ),
                          ],
                        ),
                      )),
                  const Gap(8),
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                    width: 288,
                    child: Row(
                      children: [
                        Checkbox(
                            value: autoLogin,
                            checkColor: CustomTheme.currentTheme()[1],
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            onChanged: (bool? v) {
                              setState(() {
                                autoLogin = v!;
                              });
                            }),
                        Text("Automatic Login")
                      ],
                    ),
                  ),
                  const Gap(16),
                  Container(
                      width: 96,
                      height: 48,
                      decoration: BoxDecoration(
                        color: CustomTheme.currentTheme()[1],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: TextButton(
                        onPressed: signIn,
                        child: Text(
                          "Login",
                          style:
                              TextStyle(color: CustomTheme.currentTheme()[4],
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  const Gap(4),
                  TextButton(
                    child: Text(
                      "Create Account",
                      style: TextStyle(color: CustomTheme.currentTheme()[1]),
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
