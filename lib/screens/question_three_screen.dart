import 'package:flutter/material.dart';
import '../main.dart';
import '../util/Routes.dart';
import '../view/CustomWidgets.dart';

class QuestionThreeScreen extends StatefulWidget {
  const QuestionThreeScreen({Key? key}) : super(key: key);

  @override
  _QuestionThreeScreenState createState() => _QuestionThreeScreenState();
}

class _QuestionThreeScreenState extends State<QuestionThreeScreen> {
  TextEditingController controller = TextEditingController();

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
              children: [backButton(context, isColor: false), skipBtn(context, 3)],
            ),
            const SizedBox(height: 30,),
            Image.asset("assets/images/ques_img_3.png"),
            const SizedBox(height: 30,),
            const Text(
              "What is your name?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, fontFamily: 'TT_Norms'),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "You can use a nickname",
                style: TextStyle(color: Color(0xff596BFC), fontFamily: 'TT_Norms'),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Name ",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.60), fontSize: 16, fontFamily: 'TT_Norms'),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.60)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            next(context, questionFourScreen, func: (){
              MyApp.analytics.logEvent('onboarding_3');
            }),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
