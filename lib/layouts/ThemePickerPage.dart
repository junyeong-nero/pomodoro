import 'package:flutter/material.dart';

import '../designs/CustomTheme.dart';

class ThemePickerPage extends StatefulWidget {
  const ThemePickerPage({super.key, required this.title});

  final String title;

  @override
  State<ThemePickerPage> createState() => _ThemePickerState();
}

class _ThemePickerState extends State<ThemePickerPage> {

  List<Widget> getThemeList() {
    List<Widget> res = [];
    for (var i = 0; i < CustomTheme.themeList.length; i++) {
      var curColor = CustomTheme.themeList[i];
      res.add(Container(
        height: 48,
        color: curColor[4],
        child: Row(
          children: [
            Text(CustomTheme.themeName[i],
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: curColor[1]))
          ],
        ),
      ));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Text("Hello World!"),
        TextButton(
          child: Text("Return to origin page"),
          onPressed: () => {Navigator.pop(context)},
        )
      ],
    ));
  }
}
