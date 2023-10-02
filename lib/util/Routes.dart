import 'package:flutter/material.dart';

const String questionOneScreen = '/question_one';
const String questionTwoScreen = '/question_two';
const String questionThreeScreen = '/question_three';
const String questionFourScreen = '/question_four';
const String soundsScreen = '/sounds';
const String mixerScreen = '/mixer';
const String profileScreen = '/profile';
const String musicPlayerScreen = '/music_player';
const String musicMixPlayerScreen = '/music_mix_player';
const String musicCreateEditScreen = '/music_create/edit';
const String home = '/home';
const String mixerChooseScreen = '/mixer_choose_screen';

Future<T?> changeScreen<T extends Object?>(String route, BuildContext context, {Object? argument}) {
  return Navigator.pushNamed(context, route, arguments: argument);
}

void popScreen(BuildContext context, {Object? argument}){
  Navigator.pop(context, argument);
}

