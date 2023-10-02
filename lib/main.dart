import 'package:amplitude_flutter/amplitude.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_pro/flutter_facebook_pro.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:sound_app/screens/creat_edit_screen.dart';
import 'package:sound_app/screens/main_screen.dart';
import 'package:sound_app/screens/mixer_choose_screen.dart';
import 'package:sound_app/screens/music_mix_player_screen.dart';
import 'package:sound_app/screens/music_player_screen.dart';
import 'package:sound_app/screens/profile_screen.dart';
import 'package:sound_app/screens/question_four_screen.dart';
import 'package:sound_app/screens/question_one_screen.dart';
import 'package:sound_app/screens/question_three_screen.dart';
import 'package:sound_app/screens/question_two_screen.dart';
import 'package:sound_app/screens/home_screen.dart';
import 'package:sound_app/util/Routes.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sound_app/util/const.dart';
import 'package:sound_app/util/util_functions.dart';

import 'NotificationService.dart';
const platform = MethodChannel('flutter.dev/sounds');
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Firebase.initializeApp();
  // FlutterBranchSdk.validateSDKIntegration();
  NotificationService().initNotification();
  await dbHelper.init();
  runApp(const MyApp());
}


void startAndroidMethod(String call) async {
  await platform.invokeMethod(call);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void facebookInit() async {
    final facebook =  FlutterFacebookPro();
    facebook.logActivateApp();
    oneSignalInit();
    attitudeInit();
  }

  static late Amplitude analytics;

  void attitudeInit() async {
    analytics = Amplitude.getInstance(instanceName: "sound_app");
    analytics.init("858817f2fe70e4874e1bdd2659d6942e");
    analytics.setEventUploadThreshold(1);
    analytics.logEvent('session_start');
  }

  void oneSignalInit(){
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setAppId("69afd40e-7022-4a28-a1b2-9c44dab1e64b");

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
  }

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    facebookInit();

    return FutureBuilder(
      future: getPassed(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final item = snapshot.data as bool;
          initialization();
          return MaterialApp(
            color: Colors.blue,
            initialRoute: item == true ? home : questionOneScreen,
            routes: {
              questionOneScreen: (context) => const QuestionOneScreen(),
              questionTwoScreen: (context) => const QuestionTwoScreen(),
              questionThreeScreen: (context) => const QuestionThreeScreen(),
              questionFourScreen: (context) => const QuestionFourScreen(),
              soundsScreen: (context) => const HomeScreen(),
              profileScreen: (context) => const ProfileScreen(),
              musicPlayerScreen: (context) => const MusicPlayerScreen(),
              musicMixPlayerScreen: (context) => const MusicMixPlayerScreen(),
              musicCreateEditScreen: (context) => const CreateEditScreen(),
              home: (context) => MainScreen(),
              mixerChooseScreen: (context) => const MixerChooseScreen(),
            },
          );
        } else {
          return CircularProgressIndicator();
        }

      }
    );
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }
}

