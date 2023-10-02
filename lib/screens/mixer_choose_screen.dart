import 'dart:collection';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sound_app/model/MusicInfo.dart';
import 'package:sound_app/model/MusicList.dart';
import 'package:sound_app/model/PlayerIsOn.dart';
import 'package:sound_app/util/util_functions.dart';
import 'package:sound_app/util/util_functions.dart';
import 'package:sound_app/view/music_grid_view.dart';
import 'package:sound_app/view/music_screen_player.dart';
import 'package:sound_app/view/timer_widget.dart';
import 'package:sound_app/view/top_menu.dart';
import '../util/Routes.dart';
import '../util/util_functions.dart';
import '../util/util_functions.dart';
import '../view/CustomWidgets.dart';

class MixerChooseScreen extends StatefulWidget {
  const MixerChooseScreen({Key? key}) : super(key: key);

  @override
  _MixerChooseScreenState createState() => _MixerChooseScreenState();
}

class _MixerChooseScreenState extends State<MixerChooseScreen> {
  Reference ref = FirebaseStorage.instance.ref();

  var a = "0";
  late TopMenu menu;

  @override
  void initState() {
    _menuItemClick("All");
    super.initState();
  }

  void _menuItemClick(String name) {
    final List<MusicInfo> listA = [];
    for (var musicListItem in musicList) {
      if (name == "All") {
        for (var musicItem in musicListItem.music) {
          listA.add(musicItem);
        }
      } else if (musicListItem.name == name) {
        listA.addAll(musicListItem.music);
      }
    }
    list.clear();
    list.addAll(listA);
  }

  final imageList = [
    "assets/images/circle_one.png",
    "assets/images/circle_two.png",
    "assets/images/circle_three.png",
    "assets/images/circle_four.png",
    "assets/images/circle_five.png",
    "assets/images/circle_six.png",
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            alignment: Alignment.topCenter,
            child: Flexible(
                flex: 3,
                child: Container(
                  color: const Color(0xff16123D),
                  child: Column(
                    children: [
                      backMusicButton(
                          isColor: false,
                          photo: Icons.close,
                          func: () => {popScreen(context)}),
                      TopMenu(
                        onItemClicked: (String text) => {
                          a = text,
                          _menuItemClick(text),
                          setState(() {}),
                        },
                        listName: listName,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Flexible(
                        flex: 3,
                        child: MusicGridView(
                            list: list,
                            clickedItem: (route, item) => {
                              popScreen(context, argument: item)
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }

  List<MusicInfo> list = [];

}
