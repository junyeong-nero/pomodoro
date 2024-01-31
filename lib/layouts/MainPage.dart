import 'dart:convert';
import 'dart:math' show max;
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pomodoro/designs/CustomCharts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ClockTimer.dart';
import '../Utils.dart';
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
  final customCharts = CustomCharts(ColorTheme.basic);
  final dataController = UserDataController();

  late Size size;

  Future<void> timerHandler(int it) async => setState(() {
        if (it > 0) {
          dataController.addTodayFocusTime(1);
        } else if (it <= 0) {
          stop();
        }
      });

  var fragmentIndex = 0;
  var focusTimeController = TextEditingController();

  void checkAutoLogin() async {
    final storage = await SharedPreferences.getInstance();
    var autoLogin = (storage.getBool('auto_login') ?? false);
    if (!autoLogin) {
      return;
    }

    var id = storage.getString('id') ?? '';
    var password = storage.getString('password') ?? '';
    if (id.isEmpty || password.isEmpty) {
      return;
    }

    var res = await UserDataController.login({'id': id, 'password': password});
    if (res.body.toString() == 'null') {
      return;
    }

    setState(() {
      dataController.isConnected = true;
      dataController.init(json.decode(res.body.toString()));
    });
  }

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
                child: Text(Utils.convertSecond2Text(_timer.progress),
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
                                onLongPress: logout,
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
          return customCharts.getTodayChart(dataController);
        }
        if (index == 1) {
          return customCharts.getWeeklyChart(dataController);
        }
        if (index == 2) {
          return customCharts.getMonthlyChart(dataController, () {
            setState(() {});
          });
        }
        return Container(
          color: color[0],
        );
      },
      onIndexChanged: (index) => {chartIndex = index, setState(() => {})},
      itemCount: 3,
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
    setState(() {
      if (!dataController.isConnected) {
        _navigateLogin(context);
      } else {
        logout();
      }
    });
  }

  void logout() async {
    final storage = await SharedPreferences.getInstance();
    storage.remove('auto_login');
    storage.remove('id');
    storage.remove('password');

    setState(() {
      dataController.isConnected = false;
      dataController.logout();
      focusTimeController.text =
          dataController.userData.settings.targetTime.toString();
    });

    popupSnackBar('Logout');
  }

  Future<void> _navigateLogin(BuildContext context) async {
    final result = await Navigator.pushNamed(context, "/login");
    if (!mounted) return;

    var jsonString = result.toString();
    if (jsonString != 'null') {
      Map<String, dynamic> decode = json.decode(jsonString);
      setState(() {
        dataController.init(decode);
        dataController.isConnected = true;
        focusTimeController.text =
            dataController.userData.settings.targetTime.toString();
      });
      popupSnackBar('Successfully Login!');
    }
  }

  void popupSnackBar(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void initState() {
    super.initState();

    _timer.handler = timerHandler;
    checkAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
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
