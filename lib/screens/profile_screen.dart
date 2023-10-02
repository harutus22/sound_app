import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound_app/model/Pair.dart';
import 'package:sound_app/view/CustomWidgets.dart';
import 'package:sound_app/util/const.dart';
import 'package:sound_app/util/util_functions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../NotificationService.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late SharedPreferences prefs;
  String _text = "";
  bool _isSwitched = false;
  Pair pair = Pair("00", "00");
  late NotificationService not;
  int _hour = 0;
  int _minute = 0;
  String _dayNight = "pm";


  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff16123D),
      child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xff181F55),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Image.asset("assets/images/night.png"))),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 15,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Bed time",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'TT_Norms'),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${pair.left.toString().padLeft(2, "0")} : ${pair.right.toString().padLeft(2, "0")}",
                            style: const TextStyle(color: Color(0xffF7F8FF)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: CupertinoSwitch(
                          activeColor: Color(0xffF6593E),
                          value: _isSwitched,
                          onChanged: (value) {
                            final time = getTimeInt(_text);
                            if (value) {
                              not.showNotification(NOTIFICATION_ID, "Reminder",
                                  "Time for sleep!", time.left, time.right);
                              saveSharedBool(NOTIFICATION_SWITCHED, true);
                            } else {
                              not.cancelNotification(NOTIFICATION_ID);
                              saveSharedBool(NOTIFICATION_SWITCHED, false);
                            }
                            setState(() {
                              _isSwitched = !_isSwitched;
                            });
                          }),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          GestureDetector(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Change bed time",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'TT_Norms'),
                )),
            onTap: () {
              _changeSleepTime();
            },
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Divider(
              height: 15,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // GestureDetector(
                //   child: Text(
                //     "Contacts",
                //     style: TextStyle(
                //         color: Colors.white.withOpacity(0.6),
                //         fontSize: 16,
                //         fontFamily: 'TT_Norms'),
                //   ),
                //   onTap: () {
                //     _launchUrl(Uri(scheme: "https", path: "www.google.com"));
                //   },
                // ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  child: Text(
                    "Rate us",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 16,
                        fontFamily: 'TT_Norms'),
                  ),
                  onTap: () {
                    OpenStore.instance.open(
                        androidAppBundleId: packageInfo.packageName, // Android app bundle package name
                    );
                    // _launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.fungamesforfree.colorfy"));
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  child: Text(
                    "Share",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 16,
                        fontFamily: 'TT_Norms'),
                  ),
                  onTap: () {
                    Share.share("https://play.google.com/store/apps/details?id=${packageInfo.packageName}");
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  child: Text(
                    "Privacy policy",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 16,
                        fontFamily: 'TT_Norms'),
                  ),
                  onTap: () {
                    _launchUrl(Uri.parse("https://doc-hosting.flycricket.io/sounds-for-sleep-and-relaxing-privacy-policy/0968f0cf-471b-4da4-9c09-eecf17ed3e1e/privacy"));
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  child: Text(
                    "Terms & conditions",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 16,
                        fontFamily: 'TT_Norms'),
                  ),
                  onTap: () {
                    _launchUrl(Uri.parse("https://doc-hosting.flycricket.io/sounds-for-sleep-and-relaxing-terms-of-use/c75c12be-ad14-4741-b01f-ff06d0f7a837/terms"));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    _text = prefs.getString(NOTIFICATION_TIME) ?? "10 : 00 am";
    pair = getTimeInt(_text);
    _isSwitched = prefs.getBool(NOTIFICATION_SWITCHED) ?? false;
    setState(() {});
  }

  void _initPackage() async{
    packageInfo = await PackageInfo.fromPlatform();
    package = packageInfo.packageName;
  }

  late PackageInfo packageInfo;
  String package = "";

  @override
  void initState() {
    super.initState();
    _initPackage();
    not = NotificationService();
    not.initNotification();
    getSharedPreferences();
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void _changeSleepTime() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: const Color(0xff16123D),
              title: const Text(
                "Bed Time",
                style: TextStyle(color: Colors.white),
              ),
              content: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.white, width: 1)),
                child: bedTimeChooser((p0) => _hour = p0, (p0) => _minute = p0,
                    (p0) => _dayNight = p0,
                    height: 150, width: 60),
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Save", style: TextStyle(color: Colors.white),),
                  onPressed: () => {
                    _changeNotification(),
                    getSharedPreferences(),
                    Navigator.pop(context),
                    setState(() {})
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("Cancel", style: TextStyle(color: Colors.white),),
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                ),
              ],
              elevation: 24.0,
            ),
        barrierDismissible: true);
  }

  void _changeNotification() {
    final time = getTimeType(_hour, _minute, _dayNight);
    final date = getTimeInt(time);
    saveShared(NOTIFICATION_TIME, time);
    saveSharedBool(NOTIFICATION_SWITCHED, true);
    not.showNotification(
        NOTIFICATION_ID, "Reminder", "Time for sleep!", date.left, date.right);
  }
}
