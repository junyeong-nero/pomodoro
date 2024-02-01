import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pomodoro/controllers/UserDataController.dart';

import '../designs/CustomTheme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.title});

  final String title;

  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  var nameController = TextEditingController();
  var idController = TextEditingController();
  var pwController = TextEditingController();
  var pwCheckController = TextEditingController();
  var condID = false;
  var hidePassword = true;

  Future<bool> checkSatisfiedID() async {
    var res = await UserDataController.exist(idController.text);
    return res.body.toString() == 'false' && idController.text.isNotEmpty;
  }

  void register() {
    if (!condID || pwCheckController.text != pwController.text) {
      return;
    }
    Navigator.pop(context, {
      'name': nameController.text,
      'id': idController.text,
      'password': pwController.text,
    });
  }

  @override
  void initState() {
    idController.addListener(() async {
      condID = await checkSatisfiedID();
      setState(() {});
    });

    pwController.addListener(() {
      setState(() { });
    });

    pwCheckController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

                  /** Name Card **/
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
                              child: Icon(Icons.tag,
                                  color: CustomTheme.currentTheme()[1]),
                            ),
                            Container(
                              width: 288 - 80 - 44,
                              margin: EdgeInsets.fromLTRB(0, 8, 8, 8),
                              child: TextField(
                                controller: nameController,
                                cursorColor: CustomTheme.currentTheme()[4],
                                style: TextStyle(
                                    color: CustomTheme.currentTheme()[1]),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Name",
                                    hintStyle: TextStyle(
                                        color: CustomTheme.currentTheme()[3])),
                              ),
                            ),
                          ],
                        ),
                      )),

                  /** ID Card **/
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
                              width: 288 - 80 - 44,
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
                            ),
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: Icon(
                                  condID
                                      ? Icons.check
                                      : Icons.close,
                                  size: 18,
                                  color: CustomTheme.currentTheme()[1]),
                            ),
                          ],
                        ),
                      )),

                  /** Password Card**/
                  SizedBox(
                      width: 288,
                      height: 72,
                      child: Card(
                        elevation: 8,
                        color: CustomTheme.currentTheme()[4],
                        child: Row(
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

                  /** Password Check Card **/
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
                                controller: pwCheckController,
                                cursorColor: CustomTheme.currentTheme()[4],
                                style: TextStyle(
                                    color: CustomTheme.currentTheme()[1]),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password Check",
                                    hintStyle: TextStyle(
                                        color: CustomTheme.currentTheme()[3])),
                              ),
                            ),
                            SizedBox(
                              width: 36,
                              height: 36,
                              child: Icon(
                                  pwController.text == pwCheckController.text
                                      ? Icons.check
                                      : Icons.close,
                                  size: 18,
                                  color: CustomTheme.currentTheme()[1]),
                            ),
                          ],
                        ),
                      )),

                  const Gap(24),

                  /** Create Button **/
                  Container(
                      width: 96,
                      height: 48,
                      decoration: BoxDecoration(
                        color: CustomTheme.currentTheme()[1],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: TextButton(
                        onPressed: register,
                        child: Text(
                          "Create",
                          style: TextStyle(
                              color: CustomTheme.currentTheme()[4],
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ],
              ),
            )
          ],
        ));
  }
}
