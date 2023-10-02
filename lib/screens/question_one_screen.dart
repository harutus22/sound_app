import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sound_app/view/MenuGridView.dart';
import 'package:sound_app/view/CustomWidgets.dart';
import 'package:sound_app/util/Routes.dart';

import '../main.dart';

class QuestionOneScreen extends StatefulWidget {
  const QuestionOneScreen({Key? key}) : super(key: key);

  @override
  _QuestionOneScreenState createState() => _QuestionOneScreenState();
}

class _QuestionOneScreenState extends State<QuestionOneScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E133C),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            skipBtn(context, 1),
            Image.asset("assets/images/questions_img.png"),
            const Text(
              "What you would like to achieve?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'TT_Norms'),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("Choose the right one for you", style: TextStyle(color: Color(0xff596BFC), fontFamily: 'TT_Norms'), ),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: MenuGridView()),

            next(context, questionTwoScreen, func: (){
              MyApp.analytics.logEvent('onboarding_1');
            }),

            const SizedBox(height: 10,)
          ],
        ),
      ),
    );
    ;
  }
}
