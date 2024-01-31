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
      final storage = await SharedPreferences.getInstance();
      if (autoLogin) {
        await storage.setString('id', userData['id']);
        await storage.setString('password', userData['password']);
        await storage.setBool('auto_login', true);
      } else {
        await storage.remove('auto_login');
      }
    }
  }

  void signUp() async {
    Map userData = {'id': idController.text, 'password': pwController.text};
    var response = await UserDataController.register(userData);
    if (!mounted) return;
    if (response.body.toString() == 'null') {
      popupSnackBar('Register Failed');
      return;
    }

    idController.text = '';
    pwController.text = '';
    popupSnackBar('Register Success! retry login');

  }

  void popupSnackBar(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
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
                  Container(
                    width: 216,
                    height: 56,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: CustomTheme.currentTheme()[2],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: TextField(
                      controller: idController,
                      cursorColor: CustomTheme.currentTheme()[4],
                      style: TextStyle(color: CustomTheme.currentTheme()[4]),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "ID",
                          hintStyle: TextStyle(color: CustomTheme.currentTheme()[3])),
                    ),
                  ),
                  const Gap(8),
                  Container(
                    width: 216,
                    height: 56,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: CustomTheme.currentTheme()[2],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    child: TextField(
                      controller: pwController,
                      cursorColor: CustomTheme.currentTheme()[4],
                      style: TextStyle(color: CustomTheme.currentTheme()[4]),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle: TextStyle(color: CustomTheme.currentTheme()[3])),
                    ),
                  ),
                  const Gap(8),
                  SizedBox(
                    width: 216,
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
                          "sign in",
                          style: TextStyle(color: CustomTheme.currentTheme()[4]),
                        ),
                      )),
                  const Gap(4),
                  TextButton(
                    child: Text(
                      "sign up",
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
