import 'package:flutter/material.dart';
import 'package:sound_app/model/MusicInfo.dart';
import 'package:sound_app/model/MusicList.dart';
import 'package:sound_app/view/music_mix_player.dart';
import 'package:sound_app/view/music_screen_player.dart';

class MusicMixPlayerScreen extends StatefulWidget {
  const MusicMixPlayerScreen({Key? key}) : super(key: key);

  @override
  _MusicMixPlayerScreenState createState() => _MusicMixPlayerScreenState();
}

class _MusicMixPlayerScreenState extends State<MusicMixPlayerScreen> {
  late MusicInfo musicInfo;

  @override
  Widget build(BuildContext context) {
    final list = ModalRoute.of(context)?.settings.arguments as MusicList;
    final musicPlayer = MusicMixPlayer(musicList: list);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: musicPlayer,
      ),
    );
  }
}
