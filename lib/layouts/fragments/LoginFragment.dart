// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:pomodoro/controllers/UserDataController.dart';
// import 'package:pomodoro/designs/CustomWidget.dart';
//
// import '../../designs/CustomCharts.dart';
// import '../../designs/CustomTheme.dart';
//
//
// class LoginFragment {
//
//   var color = [];
//   final customWidget = CustomWidget(ColorTheme.basic);
//
//   Widget get(BuildContext context) {
//
//     return SizedBox(
//       height: size.height - 112,
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Gap(72),
//             customWidget.getTitle("Account"),
//             const Gap(8),
//
//             /** Login Card **/
//             SizedBox(
//                 width: 288,
//                 height: 64,
//                 child: Card(
//                   elevation: 8,
//                   color: color[4],
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Positioned(
//                         left: 16,
//                         width: 24,
//                         height: 24,
//                         child: Icon(Icons.person, color: color[0]),
//                       ),
//                       Positioned(
//                           left: 56,
//                           child: Text(
//                             "Log",
//                             style: TextStyle(fontSize: 18, color: color[0]),
//                           )),
//                       Positioned(
//                         right: 16,
//                         width: 64,
//                         height: 32,
//                         child: Container(
//                             decoration: BoxDecoration(
//                                 color: dataController.isConnected
//                                     ? color[3]
//                                     : color[2],
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(100))),
//                             child: TextButton(
//                               onPressed: logButtonClick,
//                               onLongPress: logout,
//                               child: Text(
//                                 dataController.isConnected ? "OUT" : "IN",
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: color[4]),
//                               ),
//                             )),
//                       )
//                     ],
//                   ),
//                 )),
//             const Gap(16),
//             customWidget.getTitle("Timer"),
//             const Gap(8),
//
//             /** Focus Time Card **/
//             SizedBox(
//                 width: 288,
//                 height: 64,
//                 child: Card(
//                   elevation: 8,
//                   color: color[4],
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Positioned(
//                         left: 16,
//                         width: 24,
//                         height: 24,
//                         child: Icon(Icons.timelapse, color: color[0]),
//                       ),
//                       Positioned(
//                           left: 56,
//                           child: Text(
//                             "Focus Time",
//                             style: TextStyle(fontSize: 18, color: color[0]),
//                           )),
//                       Positioned(
//                           right: 32,
//                           width: 48,
//                           height: 32,
//                           child: TextField(
//                               cursorColor: color[0],
//                               cursorHeight: 24,
//                               controller: focusTimeController,
//                               textAlign: TextAlign.center,
//                               keyboardType: TextInputType.number,
//                               decoration: const InputDecoration(
//                                 border: InputBorder.none,
//                               ),
//                               style: TextStyle(
//                                   color: color[0],
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold))),
//                       Positioned(
//                           right: 8,
//                           width: 32,
//                           height: 64,
//                           child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 SizedBox(
//                                   width: 32,
//                                   height: 16,
//                                   child: IconButton(
//                                     onPressed: () => {
//                                       dataController.addTargetTime(1),
//                                       focusTimeController.text =
//                                           dataController
//                                               .userData.settings.targetTime
//                                               .toString()
//                                     },
//                                     padding: EdgeInsets.zero,
//                                     icon: const Icon(
//                                         Icons.arrow_drop_up_outlined,
//                                         size: 16),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 32,
//                                   height: 16,
//                                   child: IconButton(
//                                     onPressed: () => {
//                                       dataController.addTargetTime(-1),
//                                       focusTimeController.text =
//                                           dataController
//                                               .userData.settings.targetTime
//                                               .toString()
//                                     },
//                                     padding: EdgeInsets.zero,
//                                     icon: const Icon(
//                                         Icons.arrow_drop_down_outlined,
//                                         size: 16),
//                                   ),
//                                 )
//                               ]))
//                     ],
//                   ),
//                 )),
//
//             /** Light **/
//             SizedBox(
//                 width: 288,
//                 height: 64,
//                 child: Card(
//                   elevation: 8,
//                   color: color[4],
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Positioned(
//                         left: 16,
//                         width: 24,
//                         height: 24,
//                         child: Icon(
//                             dataController.userData.settings.light
//                                 ? Icons.lightbulb_sharp
//                                 : Icons.lightbulb_sharp,
//                             color: color[0]),
//                       ),
//                       Positioned(
//                           left: 56,
//                           child: Text(
//                             "Light",
//                             style: TextStyle(fontSize: 18, color: color[0]),
//                           )),
//                       Positioned(
//                         right: 16,
//                         width: 64,
//                         height: 32,
//                         child: Container(
//                             decoration: BoxDecoration(
//                                 color: dataController.userData.settings.light
//                                     ? color[3]
//                                     : color[2],
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(100))),
//                             child: TextButton(
//                               onPressed: () => {
//                                 dataController.userData.settings.light =
//                                 !dataController.userData.settings.light,
//                                 setState(() {})
//                               },
//                               child: Text(
//                                 dataController.userData.settings.light
//                                     ? "ON"
//                                     : "OFF",
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: color[4]),
//                               ),
//                             )),
//                       )
//                     ],
//                   ),
//                 )),
//
//             /** Vibration **/
//             SizedBox(
//                 width: 288,
//                 height: 64,
//                 child: Card(
//                   elevation: 8,
//                   color: color[4],
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Positioned(
//                         left: 16,
//                         width: 24,
//                         height: 24,
//                         child: Icon(
//                             dataController.userData.settings.vibration
//                                 ? Icons.vibration
//                                 : Icons.vibration,
//                             color: color[0]),
//                       ),
//                       Positioned(
//                           left: 56,
//                           child: Text(
//                             "Vibration",
//                             style: TextStyle(fontSize: 18, color: color[0]),
//                           )),
//                       Positioned(
//                         right: 16,
//                         width: 64,
//                         height: 32,
//                         child: Container(
//                             decoration: BoxDecoration(
//                                 color:
//                                 dataController.userData.settings.vibration
//                                     ? color[3]
//                                     : color[2],
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(100))),
//                             child: TextButton(
//                               onPressed: () => {
//                                 dataController.userData.settings.vibration =
//                                 !dataController
//                                     .userData.settings.vibration,
//                                 setState(() {})
//                               },
//                               child: Text(
//                                 dataController.userData.settings.vibration
//                                     ? "ON"
//                                     : "OFF",
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: color[4]),
//                               ),
//                             )),
//                       )
//                     ],
//                   ),
//                 )),
//
//             /** Sound **/
//             SizedBox(
//                 width: 288,
//                 height: 64,
//                 child: Card(
//                   elevation: 8,
//                   color: color[4],
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Positioned(
//                         left: 16,
//                         width: 24,
//                         height: 24,
//                         child: Icon(
//                             dataController.userData.settings.sound
//                                 ? Icons.volume_up
//                                 : Icons.volume_off,
//                             color: color[0]),
//                       ),
//                       Positioned(
//                           left: 56,
//                           child: Text(
//                             "Vibration",
//                             style: TextStyle(fontSize: 18, color: color[0]),
//                           )),
//                       Positioned(
//                         right: 16,
//                         width: 64,
//                         height: 32,
//                         child: Container(
//                             decoration: BoxDecoration(
//                                 color: dataController.userData.settings.sound
//                                     ? color[3]
//                                     : color[2],
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(100))),
//                             child: TextButton(
//                               onPressed: () => {
//                                 dataController.userData.settings.sound =
//                                 !dataController.userData.settings.sound,
//                                 setState(() {})
//                               },
//                               child: Text(
//                                 dataController.userData.settings.sound
//                                     ? "ON"
//                                     : "OFF",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: color[4]),
//                               ),
//                             )),
//                       )
//                     ],
//                   ),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
//
//
// }