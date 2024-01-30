import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pomodoro/controllers/UserDataController.dart';

import '../Utils.dart';

class CustomCharts {

  var current = DateTime.now();
  var color = [];

  CustomCharts(this.color);

  Stack getTodayChart(UserDataController dataController) {
    var values = [
      dataController.getFocusedTime(DateTime.now()),
      dataController
          .getFocusedTime(DateTime.now().subtract(const Duration(days: 1))),
      dataController.getAverageByDays(7)
    ];

    var maxValue = max(1, values.reduce(max));
    List<double> ratios = [];
    for (var i = 0; i < 3; i++) {
      ratios.add(values[i] / maxValue);
    }

    var textStyle =
        TextStyle(fontWeight: FontWeight.bold, color: color[0], fontSize: 16);

    // var height = size.height * 0.3;
    var height = 260;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
            right: 16,
            width: 56,
            height: (height * ratios[0]) + 60,
            child: Container(
              margin: const EdgeInsets.all(4),
              child: Column(
                children: [
                  Text(Utils.convertSecond2Hour(values[0].floor())),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: color[5],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Text("Today", style: textStyle),
                  )
                ],
              ),
            )),
        Positioned(
            width: 56,
            height: (height * ratios[1]) + 60,
            child: Container(
              margin: const EdgeInsets.all(4),
              child: Column(
                children: [
                  Text(Utils.convertSecond2Hour(values[1].floor())),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: color[1],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Text("D+1", style: textStyle),
                  )
                ],
              ),
            )),
        Positioned(
            left: 16,
            width: 56,
            height: (height * ratios[2]) + 60,
            child: Container(
              margin: const EdgeInsets.all(4),
              child: Column(
                children: [
                  Text(Utils.convertSecond2Hour(values[2].floor())),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: color[2],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            topRight: Radius.circular(4.0)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: Text("Avg.", style: textStyle),
                  )
                ],
              ),
            )),
      ],
    );
  }
  Stack getWeeklyChart(UserDataController dataController) {
    List<int> values = [];
    for (var i = 6; i >= 0; i--) {
      values.add(dataController
          .getFocusedTime(DateTime.now().subtract(Duration(days: i))));
    }

    var maxValue = max(1, values.reduce(max));
    var avg = dataController.getAverageByDays(7);
    var textStyle =
        TextStyle(fontWeight: FontWeight.bold, color: color[0], fontSize: 16);

    List<double> ratios = [];
    for (var i = 0; i < values.length; i++) {
      ratios.add(values[i] / maxValue);
    }

    var height = 260;
    var width = (272 - 4 * 8) / 7;

    List<Widget> stackChild = [];
    for (var i = 0; i < values.length; i++) {
      stackChild.add(Positioned(
          left: 16 + width * i,
          bottom: 32,
          width: width,
          height: (height * ratios[i]) + 24,
          child: Container(
            margin: const EdgeInsets.all(4),
            child: Column(
              children: [
                Container(
                  width: 24,
                  alignment: Alignment.center,
                  child: Text(
                    Utils.convertSecond2Hour(values[i].floor()),
                    style: const TextStyle(fontSize: 9),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: i == 6
                          ? color[5]
                          : (values[i] > avg ? color[1] : color[2]),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0)),
                    ),
                  ),
                ),
              ],
            ),
          )));

      stackChild
          .add(Positioned(left: 16, child: Text("D+6", style: textStyle)));

      stackChild
          .add(Positioned(right: 16, child: Text("Today", style: textStyle)));
    }

    return Stack(alignment: Alignment.bottomCenter, children: stackChild);
  }
  Stack getMonthlyChart(UserDataController dataController, Function callBack) {
    void prevMonth() {
      current = DateTime(current.year, current.month - 1);
      callBack();
    }

    void nextMonth() {
      current = DateTime(current.year, current.month + 1);
      callBack();
    }

    List<Widget> getGrassPlants() {
      List<Widget> res = [];
      var firstDate = DateTime(current.year, current.month, 1);
      var lastDate = DateTime(current.year, current.month + 1, 0);
      for (var i = 0; i < firstDate.weekday; i++) {
        res.add(Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              color: color[3],
              borderRadius: const BorderRadius.all(Radius.circular(4.0))),
        ));
      }

      var avg = dataController.getAverage();

      Color getGrassColor(DateTime d) {
        var now = DateTime.now();
        var value = dataController.getFocusedTime(d);
        if (d == DateTime(now.year, now.month, now.day)) {
          return color[5];
        } else if (d.isAfter(now)) {
          return color[4];
        } else if (value == 0) {
          return color[3];
        }
        return value > avg ? color[1] : color[2];
      }

      for (var i = 1; i <= lastDate.day; i++) {
        var that = DateTime(current.year, current.month, i);
        res.add(Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: getGrassColor(that),
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          ),
        ));
      }

      return res;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
            top: 0,
            child: Row(
              children: <Widget>[
                IconButton(
                    onPressed: prevMonth, icon: const Icon(Icons.arrow_left)),
                const Gap(14),
                Text(
                  "${current.year}.${current.month}",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color[0]),
                ),
                const Gap(14),
                IconButton(
                    onPressed: nextMonth, icon: const Icon(Icons.arrow_right)),
              ],
            )),
        Positioned(
            top: 60,
            width: 272,
            height: 300,
            child: GridView.count(
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
                crossAxisCount: 7,
                children: getGrassPlants()))
      ],
    );
  }
}
