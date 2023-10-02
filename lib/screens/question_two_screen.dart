import 'package:flutter/material.dart';
import 'package:sound_app/view/ListView.dart';

import '../main.dart';
import '../util/Routes.dart';
import '../view/CustomWidgets.dart';

class QuestionTwoScreen extends StatelessWidget {
  const QuestionTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0E133C),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                backButton(context, isColor: false),
                skipBtn(context, 2)
              ],
            ),
            Image.asset("assets/images/ques_img_2.png"),
            const Text(
              "What better suits you?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'TT_Norms'),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text("You can choose multiple categories)", style: TextStyle(color: Color(0xff596BFC), fontFamily: 'TT_Norms'),),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 30),child: ListMenuView(),),

            next(context, questionThreeScreen, func: (){
              MyApp.analytics.logEvent('onboarding_2');
            }),
            const SizedBox(height: 10,)
          ],
        ) ,
      ),
    );
  }
}
