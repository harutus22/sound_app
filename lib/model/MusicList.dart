import 'dart:convert';
import 'dart:ffi';

import 'package:sound_app/model/MusicInfo.dart';


const String columnId = '_id';
const String columnTitle = 'title';
const String columnList = 'sound_list';

class MusicList{
  List<MusicInfo> music = [];
  String name = "";
  late int id;

  MusicList(this.name);

  void setMusic(List<MusicInfo> musicList) {
    music = musicList;
  }

  void addMusic(MusicInfo audio) {
    music.add(audio);
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnTitle: name,
      columnList: jsonEncode(music)
    };
    return map;
  }

  MusicList.fromMap(Map<dynamic, dynamic> map) {
    id = map[columnId] as int;
    name = map[columnTitle] as String;
    final a = map[columnList];
    List<dynamic> b = jsonDecode(a);
    List<MusicInfo> aaa = [];
    for (var element in b) {
      aaa.add(MusicInfo.fromJson(element));
    }
    music = aaa;
  }
}