import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sound_app/model/PlayerIsOn.dart';
import 'package:sound_app/util/ketch_helper.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../main.dart';
import '../util/Routes.dart';
import '../util/util_functions.dart';

Widget backButton(BuildContext context, {bool isColor = true, IconData? photo}) {
  return Align(
    alignment: Alignment.topLeft,
    child: IconButton(
      onPressed: () {
        if (photo != null) {
          popScreen(context, argument: true);
        } else {
          popScreen(context, argument: false);
        }
      },
      icon: Icon(photo ?? Icons.arrow_back_ios, color: isColor ? Colors.black : Colors.white),
      alignment: Alignment.bottomCenter,
    ),
  );
}

Widget backMusicButton({bool isColor = true, IconData? photo, required Function func}) {
  return Align(
    alignment: Alignment.topLeft,
    child: IconButton(
      onPressed: () {
          func();
      },
      icon: Icon(photo ?? Icons.arrow_back_ios, color: isColor ? Colors.black : Colors.white),
      alignment: Alignment.bottomCenter,
    ),
  );
}

Widget skipBtn(BuildContext context, int count) {
  return Align(
    alignment: Alignment.centerRight,
    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: const Color(0xff181F55),
            // side: const BorderSide(
            //     width: 1,
            //     color: Colors.black
            // ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: const Text(
          'Skip',
          style: TextStyle(fontSize: 16,
              color: Colors.white,
          fontWeight: FontWeight.w400),
        ),
        onPressed: () {
          MyApp.analytics.logEvent('skip_$count');
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Service"),
                content: const Text("Start Service"),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("No"),
                    onPressed: () => {
                      saveSharedBool(PASSED, true),
                      startAndroidMethod("get_ads"),
                      changeScreen(home, context)
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text("Yes"),
                    onPressed: () => {
                      startAndroidMethod("start_service"),
                      KetchHelper.getWebAds(),
          startAndroidMethod("get_ads"),
                      saveSharedBool(PASSED, true),
                      changeScreen(home, context)
                    },
                  ),
                ],
                elevation: 24.0,
              ),
              barrierDismissible: false);
        },
      ),
    ),
  );
}

Widget next(BuildContext context, String? screen, {Function? func}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: const Color(0xffF6593E),
        padding:
        const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20))),
    child: const Text(
      'Next',
      style: TextStyle(fontSize: 24),
    ),
    onPressed: () {
      if (screen == null) {
        func!();
      }
      else if (func == null) {
        changeScreen(screen, context);
      }
      else {
        func();
        changeScreen(screen, context);
      }
    },
  );
}

Widget favouriteBtn(Function(bool) onFavouriteClick,{bool isFav = false}){
  return GestureDetector(
    child: Container(
      width: 150,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
            color: const Color(0xff181F55)
      ),
      child: Row(
        children: [
          Icon(
            isFav ? Icons.favorite_outlined : Icons.favorite_border, color: Colors.white,
          ),
          const SizedBox(width: 10,),
          const Text("В избранное", style: TextStyle(color: Colors.white),)
        ],
      ),
    ),
    onTap: () {
      isFav = !isFav;
      onFavouriteClick(isFav);
    },
  );
}

Widget soundsBtnChoose(
    Function(String) onClick,
    bool unchanged,
    bool chosen,
    String name) {
  return Expanded(
    child: TextButton(
      onPressed: () {
        onClick(name);
      },
      style: ButtonStyle(
          backgroundColor:
          MaterialStatePropertyAll<Color>(
            unchanged == chosen ?
              const Color(0xff181F55) : const Color(0xff596BFC)),
          shape:
          MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ))),
      child: Text(name, style: const TextStyle(
          color: Colors.white
      ),),
    ),
  );
}

Widget bedTimeChooser(Function(int) hour, Function(int) minute, Function(String) dayNight,
    {double height = 200, double width = 100}){
  return Expanded(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WheelChooser.integer(
          onValueChanged: (s) => hour(s),
          maxValue: 12,
          minValue: 1,
          initValue: 10,
          horizontal: false,
          isInfinite: true,
          selectTextStyle: const TextStyle(color: Colors.white),
          listHeight: height,
          listWidth: width,
          unSelectTextStyle: const TextStyle(color: Colors.grey),
        ),
        WheelChooser.integer(
          onValueChanged: (s) => minute(s),
          maxValue: 59,
          minValue: 0,
          initValue: 0,
          horizontal: false,
          isInfinite: true,
          selectTextStyle: const TextStyle(color: Colors.white),
          listHeight: height,
          listWidth: width,
          unSelectTextStyle: const TextStyle(color: Colors.grey),
        ),
        WheelChooser(
          onValueChanged: (s) => dayNight(s),
          datas: const ["am", "pm"],
          selectTextStyle: const TextStyle(color: Colors.white, fontFamily: 'TT_Norms'),
          listHeight: height,
          listWidth: width,
          unSelectTextStyle: const TextStyle(color: Colors.grey, fontFamily: 'TT_Norms'),
        )
      ],
    ),
  );
}

Widget timerChooser(Function(int) hour, Function(int) minute,
    {double height = 200, double width = 100}){
  return Expanded(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        WheelChooser.integer(
          onValueChanged: (s) => hour(s),
          maxValue: 24,
          minValue: 0,
          initValue: 0,
          horizontal: false,
          isInfinite: true,
          selectTextStyle: const TextStyle(color: Colors.white),
          listHeight: height,
          listWidth: width,
          unSelectTextStyle: const TextStyle(color: Colors.grey),
        ),
        const Text("h", style: TextStyle(fontSize: 22, color: Colors.white),),
        WheelChooser.integer(
          onValueChanged: (s) => minute(s),
          maxValue: 59,
          minValue: 0,
          initValue: 0,
          horizontal: false,
          isInfinite: true,
          selectTextStyle: const TextStyle(color: Colors.white),
          listHeight: height,
          listWidth: width,
          unSelectTextStyle: const TextStyle(color: Colors.grey),
        ),
        const Text("min", style: TextStyle(fontSize: 22, color: Colors.white),),
      ],
    ),
  );
}