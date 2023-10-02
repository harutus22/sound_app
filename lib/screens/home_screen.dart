import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sound_app/model/MusicInfo.dart';
import 'package:sound_app/model/MusicList.dart';
import 'package:sound_app/model/PlayerIsOn.dart';
import 'package:sound_app/util/const.dart';
import 'package:sound_app/util/util_functions.dart';
import 'package:sound_app/view/music_grid_view.dart';
import 'package:sound_app/view/music_screen_player.dart';
import 'package:sound_app/view/timer_widget.dart';
import 'package:sound_app/view/top_menu.dart';
import '../util/Routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Reference ref = FirebaseStorage.instance.ref();

  var a = "0";
  static late MusicScreenPlayer musicPlayer;
  bool isPlaying = false;
  late MusicInfo music;
  Duration duration = Duration.zero;
  late Future<ListResult> result;
  late TopMenu menu;
  List<MusicInfo> favList = [];

  @override
  void initState() {
    super.initState();
    musicPlayer = MusicScreenPlayer(
      timer: TimerWidget(),
    );
    result = ref.child("audio_files").listAll();
    result.then((value) => {
      _dataLoad(value).then((value) => _setMenu())
    });

  }

  void _setMenu() {
    menu.setList(listName);
  }

  void _menuItemClick(String name) async {
    final List<MusicInfo> listA = [];
    for (var musicListItem in musicList) {
      if (name == "All") {
        for (var musicItem in musicListItem.music) {
          listA.add(musicItem);
        }
      } else if(name == "Favourite"){
        await dbHelper.getFavourites().then((value) => listA.addAll(value!.toList()));
        break;
      } else if (musicListItem.name == name) {
        listA.addAll(musicListItem.music);
      }
    }
    list.clear();
    list.addAll(listA);
    setState(() {});
  }

  Future<void> _getEach(Reference value) async {
    final name = value.fullPath;
    final as = _getName(name);
    listName.add(as);
    final music = MusicList(as);

    final audios = ref.child(name).listAll();
    await audios
        .then((value) async => {
          musicList.add(await _getMusic(value, music)),
        });
  }



  String _getImage(String name) {
    final item = name.toLowerCase().replaceAll(" ", "_").substring(0, name.length - 4);
    return "assets/images/sound_images/$item.png";
  }

  final imageList = [
    "assets/images/circle_one.png",
    "assets/images/circle_two.png",
    "assets/images/circle_three.png",
    "assets/images/circle_four.png",
    "assets/images/circle_five.png",
    "assets/images/circle_six.png",
    "assets/images/sound_images/birds.png",
  ];

  Future<MusicList> _getMusic(ListResult value, MusicList list) async {
    for (var item in value.items) {
      var musicInfo =
          MusicInfo(await item.getDownloadURL(), _getImage(item.name), _getProperName(item.name));
      list.addMusic(musicInfo);
    }
    return list;
  }
  
  String _getProperName(String name){
    var pos = name.lastIndexOf('.');
    String result = name.substring(0, pos);
    return result;
  }
  

  String _getName(String name) {
    var pos = name.lastIndexOf('/');
    String result = name.substring(pos + 1, name.length);
    return result;
  }

  bool isLoading = true;

  Future<void> _dataLoad(ListResult value) async {
    for (var items in value.prefixes) {
      await _getEach(items);
    }
    isLoading = false;
    _menuItemClick("All");
  }

  @override
  void dispose() {
    musicPlayer.audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            menu = TopMenu(
              onItemClicked: (String text) => {
                a = text,
                _menuItemClick(text),
              },
              listName: listName,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                flex: 3,
                child: isLoading
                    ? const SpinKitSpinningLines(
                        color: Colors.white,
                        size: 100.0,
                      )
                    : MusicGridView(
                        list: list,
                        clickedItem: (route, item) => {
                              if (musicPlayer.musicInfo != null)
                                {
                                  if (musicPlayer.musicInfo == item)
                                    {
                                      musicPlayer.setOldOne(),
                                    }
                                  else
                                    {musicPlayer.setNewSong()},
                                },
                              changeScreenThis(route, context, item)
                            })),
            getPlayer(musicPlayer.isGridScreen, musicPlayer.isPlaying)
          ],
        ));
  }

  Widget getPlayer(bool isForShow, bool isPlaying) {
    if (isPlaying) {
      return musicPlayer;
    } else {
      return const SizedBox();
    }
  }

  void changeScreenThis(
      String route, BuildContext context, MusicInfo item) async {
    final map = {'music': item, 'music_player': musicPlayer};
    final player =
        await changeScreen(route, context, argument: map) as PlayerIsOn;
    isPlaying = player.isOn;
    if (isPlaying) {
      music = item;
      duration = player.position;
    }
    setState(() {});
  }
  List<MusicInfo> list = [];

}
