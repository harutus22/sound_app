import 'package:shared_preferences/shared_preferences.dart';

import '../model/MusicList.dart';
import '../model/Pair.dart';

void saveShared(String title, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(title, value);
}

void saveSharedBool(String title, bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(title, value);
}

Future<bool> getPassed() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final item =  prefs.getBool(PASSED);
  return (item == null ? false : true);
}

const String PASSED = "have_passed";

String getTimeType(int hour, int minute, String type){
  return "${hour.toString().padLeft(2,"0")} : ${minute.toString().padLeft(2,"0")} $type";
}

Pair getTimeInt(String time){
  var hour = 0;
  var minute = 0;
  final _hour = time.substring(1, 2);
  if (time[8] == "p") {
    if (_hour == "12") {
      hour = 0;
    } else {
      hour = int.parse(_hour) + 12;
    }
  } else {
    hour = int.parse(_hour);
  }
  minute = int.parse(time.substring(5, 7));
  return Pair(hour, minute);
}
List<String> listName = ["All", "Favourite"];
List<MusicList> musicList = [];
