import 'package:firebase_database/firebase_database.dart';

const String favMusicUrl = "favourite_music_url";
const String favImageUrl = "favourite_image_url";
const String favName = "favourite_name";
const String favIs = "favourite_is";
const String favId = "favourite_id";

class MusicInfo{
  String musicUrl = "";
  String imageUrl = "";
  String name = "";
  bool isFav;

  MusicInfo(this.musicUrl, this.imageUrl, this.name, {this.isFav = false});

  factory MusicInfo.fromSnapshot(DataSnapshot dataSnapshot)
    => MusicInfo(
      (dataSnapshot.value as Map)[favMusicUrl],
      (dataSnapshot.value as Map)[favImageUrl]!,
      dataSnapshot.key!
    );

  Map<String, Object> toJson() => {
    favName: name,
    favMusicUrl: musicUrl,
    favImageUrl: imageUrl,
    favIs: isFav
  };

  factory MusicInfo.fromJson(dynamic json){
    return MusicInfo(json[favMusicUrl], json[favImageUrl], json[favName], isFav: json[favIs] == 0 ? true : false);
  }

}