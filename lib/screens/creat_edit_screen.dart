import 'package:flutter/material.dart';
import 'package:sound_app/model/MusicList.dart';
import 'package:sound_app/util/const.dart';
import '../model/MusicInfo.dart';
import '../util/Routes.dart';
import '../view/CustomWidgets.dart';
import '../view/MusicPlayer.dart';

class CreateEditScreen extends StatefulWidget {
  const CreateEditScreen({Key? key}) : super(key: key);

  @override
  _CreateEditScreenState createState() => _CreateEditScreenState();
}

class _CreateEditScreenState extends State<CreateEditScreen> {
  List<MusicInfo> list = [];
  bool _isSaveMode = false;
  bool _isEdit = false;
  MusicList? musicList;
  List<Widget> widgetList = [];
  final listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    widgetList.add(getBtn());
    controller.text = "Mix $size";
  }

  @override
  Widget build(BuildContext context) {
    if (widgetList.length == 1) {
      final args = ModalRoute.of(context)!.settings.arguments;
      if (args is MusicInfo) {
        list.add(args);
        widgetList.add(MusicPlayer(
          musicInfo: args,
        ));
      } else if (args is MusicList) {
        _isEdit = true;
        musicList = args;
        controller.text = args.name;
        for (var element in args.music) {
          list.add(element);
          widgetList.add(MusicPlayer(
            musicInfo: element,
          ));
        }
      }
    }
    return Scaffold(
      backgroundColor: const Color(0xff0E133C),
      body: SafeArea(
        child: Column(children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                backMusicButton(
                    isColor: false,
                    photo: Icons.close,
                    func: () => {
                          if (_isSaveMode)
                            {_isSaveMode = false, setState(() {})}
                          else
                            popScreen(context)
                        }),
                Text(musicList != null ? musicList!.name :
                  "Mix $size",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'TT_Norms',
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: ()  {
                    if (!_isSaveMode) {
                      _isSaveMode = true;
                      setState(() {});
                    } else {
                      _isSaveMode = false;
                      if (_isEdit) {
                        musicList!.music.clear();
                        musicList!.name = controller.text;
                        musicList!.setMusic(list);
                        dbHelper.update(musicList!);
                        Navigator.popUntil(context, ModalRoute.withName(home));
                      } else {
                        final musicList = MusicList(controller.text);
                        musicList.setMusic(list);
                        dbHelper.insert(musicList);
                        popScreen(context);
                      }
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll<Color>(
                          Color(0xff181F55)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ))),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          !_isSaveMode
              ? Expanded(
                  child: ListView.builder(
                    key: listKey,
                    shrinkWrap: true,
                    itemCount: widgetList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: GestureDetector(
                            onLongPress: (){
                              _removeItem(index);
                              setState(() {});
                            },
                              child: widgetList[index]
                          ),
                          // child: Dismissible(
                          //   key: Key(widgetList[index].hashCode.toString()),
                          //     child: widgetList[index],
                          // onDismissed: (direction){
                          //   _removeItem(index);
                          // },
                          //   confirmDismiss: (direction) {
                          //     return _isDeletable(index);
                          //   },
                          // )
                      );
                    },
                  ),
                )
              : Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 80),
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        color: const Color(0xff181F55),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                            width: 1, color: const Color(0xff596BFC)),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: controller,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "",
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.60),
                              fontSize: 16,
                              fontFamily: 'TT_Norms'),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.60)),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ]),
      ),
    );
  }

  Future<bool> _isDeletable(int index) async {
    if(widgetList.length < 3) {
      return false;
    } else {
      if (index == 0) {
        return false;
      } else {
        return true;
      }
    }
  }

  TextEditingController controller = TextEditingController();

  Widget getBtn() {
    return Container(
      width: double.infinity,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: () async {
          final newValue =
              await changeScreen(mixerChooseScreen, context) as MusicInfo;
          list.add(newValue);
          widgetList.add(MusicPlayer(musicInfo: newValue));
          setState(() {});
        },
        style: ButtonStyle(
            backgroundColor:
                const MaterialStatePropertyAll<Color>(Color(0xff181F55)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(width: 1, color: Color(0xff596BFC)),
            ))),
        child: Image.asset("assets/images/add_btn.png"),
      ),
    );
  }

  void _removeItem(int index){
    widgetList.removeAt(index);
    list.removeAt(index - 1);
    setState(() {});
  }
}


