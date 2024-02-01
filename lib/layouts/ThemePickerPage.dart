import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pomodoro/designs/CustomWidget.dart';

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
    res.add(const Gap(36));
    res.add(CustomWidget().getTitle('Theme'));

    for (var i = 0; i < CustomTheme.themeList.length; i++) {
      var currentColor = CustomTheme.themeList[i];
      var widget = SizedBox(
          width: 320,
          height: 64,
          child: Card(
            elevation: 8,
            color: currentColor[4],
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                    left: 16,
                    child: Text(
                      CustomTheme.themeName[i],
                      style: TextStyle(
                          fontSize: 18, color: currentColor[0]),
                    )),
                Positioned(
                  right: 16,
                  width: 64,
                  height: 32,
                  child: Container(
                      decoration: BoxDecoration(
                          color: currentColor[1],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(100))),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            CustomTheme.themeIndex = i;
                          });
                        },
                        child: Text(
                          'select',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: currentColor[4]),
                        ),
                      )),
                ),
                Positioned(
                  right: 88,
                  width: 32,
                  height: 32,
                  child: Container(
                    decoration: BoxDecoration(
                        color: currentColor[2],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100))),
                  ),
                ),

                Positioned(
                  right: 128,
                  width: 32,
                  height: 32,
                  child: Container(
                    decoration: BoxDecoration(
                        color: currentColor[3],
                        borderRadius:
                        const BorderRadius.all(Radius.circular(100))),
                  ),
                ),

                Positioned(
                  right: 168,
                  width: 32,
                  height: 32,
                  child: Container(
                    decoration: BoxDecoration(
                        color: currentColor[5],
                        borderRadius:
                        const BorderRadius.all(Radius.circular(100))),
                  ),
                )
              ],
            ),
          ));
      res.add(widget);
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomTheme.currentTheme()[3],
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
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
              Positioned.fill(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: getThemeList(),
                ),
              )
            ],
          ),
        ));
  }
}
