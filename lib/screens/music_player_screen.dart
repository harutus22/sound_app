import 'package:flutter/material.dart';
import 'package:sound_app/model/MusicInfo.dart';
import 'package:sound_app/view/music_screen_player.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({Key? key}) : super(key: key);

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  late MusicInfo musicInfo;

  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context)?.settings.arguments as Map;
    musicInfo = map['music'];
    final musicPlayer = map['music_player'] as MusicScreenPlayer;
    musicPlayer.setMusic(musicInfo);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: musicPlayer,
      ),
    );
  }
}
