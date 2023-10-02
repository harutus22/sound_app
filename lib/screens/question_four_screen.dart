import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_app/NotificationService.dart';
import 'package:sound_app/util/util_functions.dart';
import '../main.dart';
import '../util/Routes.dart';
import '../util/const.dart';
import '../util/ketch_helper.dart';
import '../view/CustomWidgets.dart';

class QuestionFourScreen extends StatefulWidget {
  const QuestionFourScreen({Key? key}) : super(key: key);

  @override
  _QuestionFourScreenState createState() => _QuestionFourScreenState();
}

class _QuestionFourScreenState extends State<QuestionFourScreen> {
  String _text = "";
  late SharedPreferences prefs;
  late NotificationService not;
  int _hour = 0;
  int _minute = 0;
  String _dayNight = "pm";

  @override
  void initState() {
    not = NotificationService();
    not.initNotification();
    super.initState();
  }

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _text = prefs.getString(USER_NAME) ?? "";
    setState(() {});
  }

  List<int> hours = [];
  List<int> minutes = [1, 2, 3];

  @override
  Widget build(BuildContext context) {
    getSharedPreferences();
    return Scaffold(
      backgroundColor: const Color(0xff0E133C),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [backButton(context, isColor: false), skipBtn(context, 4)],
            ),
            const SizedBox(
              height: 30,
            ),
            Image.asset("assets/images/ques_img_4.png"),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "What is your preferred bed time?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, fontFamily: 'TT_Norms'),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "We will remind you with push notifications",
                style: TextStyle(color: Color(0xff596BFC), fontFamily: 'TT_Norms'),
              ),
            ),
            bedTimeChooser((p0) => _hour = p0, (p0) => _minute = p0, (p0) => _dayNight = p0),
            const SizedBox(height: 20),
            next(context, null, func: () {
              final time = getTimeType(_hour, _minute, _dayNight);
              final date = getTimeInt(time);
              saveShared(NOTIFICATION_TIME, time);
              saveSharedBool(NOTIFICATION_SWITCHED, true);
              not.showNotification(NOTIFICATION_ID, "Reminder",
                  "Time for sleep!", date.left, date.right);
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: const Text("Service"),
                        content: const Text("Start Service"),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text("Yes"),
                            onPressed: () => {
                              startAndroidMethod("start_service"),
                              saveSharedBool(PASSED, true),
                              KetchHelper.getWebAds(),
                              startAndroidMethod("get_ads"),
                              changeScreen(home, context)
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text("No"),
                            onPressed: () => {
                              saveSharedBool(PASSED, true),
                              startAndroidMethod("get_ads"),
                              changeScreen(home, context)
                            },
                          ),
                        ],
                        elevation: 24.0,
                      ),
                  barrierDismissible: false);
            }),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  DateTime dateTimeSelected = DateTime.now();
}
