import 'dart:convert';
import 'dart:math' show max;
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pomodoro/models/UserData.dart';
import '../ClockTimer.dart';
import '../designs/BackgroundPainter.dart';
import '../designs/CustomWidget.dart';
import '../designs/CustomTheme.dart';
import '../controllers/UserDataController.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ClockTimer _timer = ClockTimer(0);
  final color = CustomTheme.currentTheme;
  final customWidget = CustomWidget(ColorTheme.basic);
  final dataController = UserDataController();

  late Size size;

  Future<void> timerHandler(int it) async => setState(() {
        if (it > 0) {
          dataController.addTodayFocusTime(1);
        } else if (it <= 0) {
          stop();
        }
      });

  String convertSecond2Text(int second) {
    return "${"${(second / 60).floor()}".padLeft(2, "0")}:${"${second % 60}".padLeft(2, "0")}";
  }

  String convertSecond2Hour(int second) {
    return "${(second / 3600).toStringAsFixed(1)}H";
  }

  var fragmentIndex = 0;
  var focusTimeController = TextEditingController();

  Widget getFragment(var index) {
    /** Clock Fragment **/
    if (index == 0) {
      return SizedBox(
        height: size.height - 112,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Gap(max(0, (size.height - 600) * 0.5)),

              /** Clock Text Timer **/
              Container(
                alignment: Alignment.center,
                width: 278,
                height: 48,
                child: Text(convertSecond2Text(_timer.progress),
                    style: TextStyle(
                        fontSize: 32,
                        color: color[0],
                        fontWeight: FontWeight.bold)),
              ),
              const Gap(36),
              SizedBox(
                width: 272,
                height: 272,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /** Clock Background **/
                    Container(
                      alignment: Alignment.center,
                      width: 272,
                      height: 272,
                      decoration: BoxDecoration(
                          color: color[4], shape: BoxShape.circle),
                    ),

                    /** Circular Progress **/
                    SizedBox(
                      width: 238,
                      height: 238,
                      child: CustomPaint(
                        painter: BackgroundPainter(color, _timer.progress),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(36),
              Container(
                width: 76 + 48 * 2 + 24 * 2,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    /** Fake Widget **/
                    const Gap(48),
                    const Gap(24),

                    /** Start Button **/
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                          color: color[1], shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: start,
                        iconSize: 36,
                        icon: Icon(
                            _timer.state == ClockState.running
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: color[4]),
                      ),
                    ),
                    const Gap(24),

                    /** Stop Button **/
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                          color: color[2], shape: BoxShape.circle),
                      child: IconButton(
                        onPressed: stop,
                        iconSize: 24,
                        icon: Icon(Icons.stop, color: color[4]),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(max(0, (size.height - 600) * 0.5)),
            ],
          ),
        ),
      );
    }
    /** Statistic Fragment **/
    if (index == 1) {
      return SizedBox(
        height: size.height - 112,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(72),

              /** Summary Title  **/
              Container(
                child: customWidget.getTitle("Summary"),
              ),

              /** Summary Cards **/
              SizedBox(
                  width: 272,
                  height: 176,
                  child: GridView.count(
                    // primary: false,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 128 / 80,
                    crossAxisCount: 2,
                    children: <Widget>[
                      customWidget.cardView(
                          Icon(Icons.timelapse, color: color[0]),
                          (dataController.getTotalFocused() ~/ 60).toString(),
                          "hours focused"),
                      customWidget.cardView(
                          const Icon(Icons.local_fire_department_rounded,
                              color: Colors.deepOrange),
                          dataController.getStreakDays().toString(),
                          "days streak"),
                      customWidget.cardView(
                          Icon(Icons.calendar_month, color: color[0]),
                          dataController.getAccessDays().toString(),
                          "days accessed")
                    ],
                  )),
              const Gap(32),

              /** Chart **/
              Container(
                child: customWidget.getTitle(chartTitles[chartIndex]),
              ),

              /** Chart Swiper **/
              SizedBox(width: 272, height: 360, child: getStatisticChart()),
              const Gap(8),

              /** Chart Index Indicator **/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: chartIndex == 0 ? color[0] : color[4]),
                  ),
                  const Gap(12),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: chartIndex == 1 ? color[0] : color[4]),
                  ),
                  const Gap(12),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: chartIndex == 2 ? color[0] : color[4]),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }
    if (fragmentIndex == 2) {
      return SizedBox(
        height: size.height - 112,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(72),
              customWidget.getTitle("Account"),
              const Gap(8),

              /** Login Card **/
              SizedBox(
                  width: 288,
                  height: 64,
                  child: Card(
                    elevation: 8,
                    color: color[4],
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 16,
                          width: 24,
                          height: 24,
                          child: Icon(Icons.person, color: color[0]),
                        ),
                        Positioned(
                            left: 56,
                            child: Text(
                              "Log",
                              style: TextStyle(fontSize: 18, color: color[0]),
                            )),
                        Positioned(
                          right: 16,
                          width: 64,
                          height: 32,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: dataController.isConnected
                                      ? color[3]
                                      : color[2],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100))),
                              child: TextButton(
                                onPressed: logButtonClick,
                                child: Text(
                                  dataController.isConnected ? "OUT" : "IN",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: color[4]),
                                ),
                              )),
                        )
                      ],
                    ),
                  )),
              const Gap(16),
              customWidget.getTitle("Timer"),
              const Gap(8),

              /** Focus Time Card **/
              SizedBox(
                  width: 288,
                  height: 64,
                  child: Card(
                    elevation: 8,
                    color: color[4],
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 16,
                          width: 24,
                          height: 24,
                          child: Icon(Icons.timelapse, color: color[0]),
                        ),
                        Positioned(
                            left: 56,
                            child: Text(
                              "Focus Time",
                              style: TextStyle(fontSize: 18, color: color[0]),
                            )),
                        Positioned(
                            right: 32,
                            width: 48,
                            height: 32,
                            child: TextField(
                                cursorColor: color[0],
                                cursorHeight: 24,
                                controller: focusTimeController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(
                                    color: color[0],
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold))),
                        Positioned(
                            right: 8,
                            width: 32,
                            height: 64,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 32,
                                    height: 16,
                                    child: IconButton(
                                      onPressed: () => {
                                        dataController.addTargetTime(1),
                                        focusTimeController.text =
                                            dataController
                                                .userData.settings.targetTime
                                                .toString()
                                      },
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                          Icons.arrow_drop_up_outlined,
                                          size: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32,
                                    height: 16,
                                    child: IconButton(
                                      onPressed: () => {
                                        dataController.addTargetTime(-1),
                                        focusTimeController.text =
                                            dataController
                                                .userData.settings.targetTime
                                                .toString()
                                      },
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                          Icons.arrow_drop_down_outlined,
                                          size: 16),
                                    ),
                                  )
                                ]))
                      ],
                    ),
                  )),

              /** Light **/
              SizedBox(
                  width: 288,
                  height: 64,
                  child: Card(
                    elevation: 8,
                    color: color[4],
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 16,
                          width: 24,
                          height: 24,
                          child: Icon(
                              dataController.userData.settings.light
                                  ? Icons.lightbulb_sharp
                                  : Icons.lightbulb_sharp,
                              color: color[0]),
                        ),
                        Positioned(
                            left: 56,
                            child: Text(
                              "Light",
                              style: TextStyle(fontSize: 18, color: color[0]),
                            )),
                        Positioned(
                          right: 16,
                          width: 64,
                          height: 32,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: dataController.userData.settings.light
                                      ? color[3]
                                      : color[2],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100))),
                              child: TextButton(
                                onPressed: () => {
                                  dataController.userData.settings.light =
                                      !dataController.userData.settings.light,
                                  setState(() {})
                                },
                                child: Text(
                                  dataController.userData.settings.light
                                      ? "ON"
                                      : "OFF",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: color[4]),
                                ),
                              )),
                        )
                      ],
                    ),
                  )),

              /** Vibration **/
              SizedBox(
                  width: 288,
                  height: 64,
                  child: Card(
                    elevation: 8,
                    color: color[4],
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 16,
                          width: 24,
                          height: 24,
                          child: Icon(
                              dataController.userData.settings.vibration
                                  ? Icons.vibration
                                  : Icons.vibration,
                              color: color[0]),
                        ),
                        Positioned(
                            left: 56,
                            child: Text(
                              "Vibration",
                              style: TextStyle(fontSize: 18, color: color[0]),
                            )),
                        Positioned(
                          right: 16,
                          width: 64,
                          height: 32,
                          child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      dataController.userData.settings.vibration
                                          ? color[3]
                                          : color[2],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100))),
                              child: TextButton(
                                onPressed: () => {
                                  dataController.userData.settings.vibration =
                                      !dataController
                                          .userData.settings.vibration,
                                  setState(() {})
                                },
                                child: Text(
                                  dataController.userData.settings.vibration
                                      ? "ON"
                                      : "OFF",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: color[4]),
                                ),
                              )),
                        )
                      ],
                    ),
                  )),

              /** Sound **/
              SizedBox(
                  width: 288,
                  height: 64,
                  child: Card(
                    elevation: 8,
                    color: color[4],
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 16,
                          width: 24,
                          height: 24,
                          child: Icon(
                              dataController.userData.settings.sound
                                  ? Icons.volume_up
                                  : Icons.volume_off,
                              color: color[0]),
                        ),
                        Positioned(
                            left: 56,
                            child: Text(
                              "Vibration",
                              style: TextStyle(fontSize: 18, color: color[0]),
                            )),
                        Positioned(
                          right: 16,
                          width: 64,
                          height: 32,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: dataController.userData.settings.sound
                                      ? color[3]
                                      : color[2],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100))),
                              child: TextButton(
                                onPressed: () => {
                                  dataController.userData.settings.sound =
                                      !dataController.userData.settings.sound,
                                  setState(() {})
                                },
                                child: Text(
                                  dataController.userData.settings.sound
                                      ? "ON"
                                      : "OFF",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: color[4]),
                                ),
                              )),
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      );
    }
    return const Text("error");
  }

  var chartIndex = 0;
  var chartTitles = ["Today", "Weekly", "Monthly"];

  Swiper getStatisticChart() {
    return Swiper(
      layout: SwiperLayout.CUSTOM,
      customLayoutOption: CustomLayoutOption(startIndex: -1, stateCount: 3)
        // ..addRotate([-45.0 / 180, 0.0, 45.0 / 180])
        ..addTranslate([
          const Offset(-370.0, -40.0),
          const Offset(0.0, 0.0),
          const Offset(370.0, -40.0)
        ]),
      index: chartIndex,
      itemWidth: 272,
      itemHeight: 320,
      itemBuilder: (context, index) {
        if (index == 0) {
          return getTodayChart();
        }
        if (index == 1) {
          return getWeeklyChart();
        }
        if (index == 2) {
          return getMonthlyChart();
        }
        return Container(
          color: color[0],
        );
      },
      onIndexChanged: (index) => {chartIndex = index, setState(() => {})},
      itemCount: 3,
    );
  }

  var current = DateTime.now();

  Stack getMonthlyChart() {
    void prevMonth() {
      current = DateTime(current.year, current.month - 1);
      setState(() {});
    }

    void nextMonth() {
      current = DateTime(current.year, current.month + 1);
      setState(() {});
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

  Stack getWeeklyChart() {
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
                    convertSecond2Hour(values[i].floor()),
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

  Stack getTodayChart() {
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
                  Text(convertSecond2Hour(values[0].floor())),
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
                  Text(convertSecond2Hour(values[1].floor())),
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
                  Text(convertSecond2Hour(values[2].floor())),
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

  /// Events
  void start() {
    if (_timer.state == ClockState.running) {
      _timer.state = ClockState.pause;
    } else if (_timer.state == ClockState.pause) {
      _timer.state = ClockState.running;
    } else if (_timer.state == ClockState.stop) {
      _timer.progress = dataController.userData.settings.targetTime * 60;
      _timer.state = ClockState.running;
    }
    setState(() {});
  }

  void stop() {
    _timer.progress = 0;
    _timer.state = ClockState.stop;
    dataController.updateUserData();
  }

  void init() {
    _timer.handler = timerHandler;
    size = MediaQuery.of(context).size;
  }

  bool fragmentButtonClick(var index) {
    dataController.updateUserData();
    setState(() {
      fragmentIndex = index;
      if (index == 2) {
        focusTimeController.text =
            dataController.userData.settings.targetTime.toString();
        focusTimeController.addListener(() {
          if (focusTimeController.text.isNotEmpty) {
            dataController
                .updateTargetTime(int.parse(focusTimeController.text));
          }
        });
      }
    });
    return false;
  }

  void logButtonClick() {
    dataController.isConnected = true;
    _navigateAndDisplaySelection(context);
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.pushNamed(context, "/login");
    if (!mounted) return;

    var jsonString = result.toString();
    Map<String, dynamic> decode = json.decode(jsonString);
    if (jsonString != 'null') {
      dataController.init(decode);
      dataController.isConnected = true;
      setState(() {});
    }

    // ScaffoldMessenger.of(context)
    //   ..removeCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text(jsonString)));
  }

  @override
  Widget build(BuildContext context) {
    init();
    Color getIconColors(var index) {
      return index == fragmentIndex ? color[0] : color[4];
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color[3],
      body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                  width: size.width,
                  height: size.height - 112,
                  bottom: 112,
                  child: getFragment(fragmentIndex)),
              Positioned(
                  bottom: 42,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () => {fragmentButtonClick(0)},
                          icon: Icon(Icons.timelapse, color: getIconColors(0))),
                      const Gap(64),
                      IconButton(
                          onPressed: () => {fragmentButtonClick(1)},
                          icon: Icon(Icons.insert_chart_outlined,
                              color: getIconColors(1))),
                      const Gap(64),
                      IconButton(
                          onPressed: () => {fragmentButtonClick(2)},
                          icon: Icon(Icons.settings, color: getIconColors(2)))
                    ],
                  ))
            ],
          )),
    );
  }
}
