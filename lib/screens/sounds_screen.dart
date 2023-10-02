import 'package:flutter/material.dart';
import 'package:sound_app/model/MusicInfo.dart';
import 'package:sound_app/util/Routes.dart';
import 'package:sound_app/util/const.dart';
import 'package:sound_app/util/util_functions.dart';
import 'package:sound_app/view/CustomWidgets.dart';

import '../model/MusicList.dart';
import '../view/music_grid_view.dart';
import '../view/top_menu.dart';

class SoundsScreen extends StatefulWidget {
  SoundsScreen({Key? key}) : super(key: key);
  final GlobalKey<_SoundsScreenState> key = GlobalKey();

  @override
  _SoundsScreenState createState() => _SoundsScreenState();
}

class _SoundsScreenState extends State<SoundsScreen> {
  List<Widget> widgetList = [];
  bool _isSaved = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper.getMySounds().then((value) =>
    {
      if (value != null){
        size = value.length + 1,
        mixList = value}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.3,
              // ignore this, cos I am giving height to the container
              width: MediaQuery.of(context).size.width,
              // ignore this, cos I am giving width to the container
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image:
                          AssetImage("assets/images/sounds_background.png"))),
              alignment: Alignment.bottomCenter,
              // This aligns the child of the container
              child: Container(
                height: MediaQuery.of(context).size.height * 0.045,
                margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                decoration: const BoxDecoration(
                    color: Color(0xff181F55),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    soundsBtnChoose((p0) => {
                      _isSaved = false,
                      setState(() {})
                    }, true, _isSaved, "Create"),
                    soundsBtnChoose((p0) => {
                      _isSaved = true,
                    dbHelper.getMySounds().then((value) => {
                    if (value  != null){
                      size = value.length + 1,
                      mixList = value}}),
                      setState(() {})
                    }, false, _isSaved, "Saved"),
                  ],
                ),
              )),
          Flexible(
            flex: 2,
            child: Container(
              color: const Color(0xff16123D),
              child: Column(
                children: [
                  if(!_isSaved) TopMenu(
                    onItemClicked: (String text) => {
                      a = text,
                      _menuItemClick(text),
                    },
                    listName: listName,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    flex: 3,
                    child: _isSaved == false ?
                    MusicGridView(
                        list: listSounds,
                        clickedItem: (route, item) => {
                          changeScreen(musicCreateEditScreen, context, argument: item)
                        }) :
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: mixList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap:() async {
                            changeScreenThis(musicMixPlayerScreen,
                                context, mixList[index]!);

                          },
                          child: Dismissible(
                            key: Key(mixList[index].hashCode.toString()),
                            onDismissed: (direction){
                              dbHelper.delete(mixList[index]!.id);
                              mixList.removeAt(index);
                            },
                            child: Container(
                                height: MediaQuery.of(context).size.height * 0.1,
                                margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff181F55),
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    border: Border.all(width: 1, color:const Color(0xff596BFC)),
                                  ),
                                  child: Text(mixList[index]!.name,
                                    textAlign: TextAlign.center, style:
                                  const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'TT_Norms',
                                    fontSize: 18
                                  ),),
                                )),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

      ),
    );
  }

  var a = "0";

  void _menuItemClick(String name) async {
    final List<MusicInfo> listA = [];
    for (var musicListItem in musicList) {
      if (name == "All") {
        for (var musicItem in musicListItem.music) {
          listA.add(musicItem);
        }
      }else if(name == "Favourite"){
        await dbHelper.getFavourites().then((value) => listA.addAll(value!.toList()));
        break;
      } else if (musicListItem.name == name) {
        listA.addAll(musicListItem.music);
      }
    }
    listSounds.clear();
    listSounds.addAll(listA);
    setState(() {});
  }


  void setList() {
    _menuItemClick("All");
  }

  void changeScreenThis(String route, BuildContext context, MusicList item) async {
    await changeScreen(route, context, argument: item);
  }

// List<String> getMyMixes() async {}
  List<MusicInfo> listSounds = [];
  List<MusicList?> mixList = [];
}
