import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_app/model/MusicInfo.dart';
import 'package:sound_app/model/MusicList.dart';
import 'package:sound_app/view/timer_widget.dart';
import '../model/PlayerIsOn.dart';
import '../util/Routes.dart';
import 'CustomWidgets.dart';

class MusicMixPlayer extends StatefulWidget {
  MusicMixPlayer({Key? key, required this.musicList}) : super(key: key);
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool _isFav = false;
  late TimerWidget timer = TimerWidget();
  var firstClick = false;
  late AudioCache cached;
  late MusicList musicList;
  double positionVolume = 0.5;
  void setMusic(MusicInfo musicInfo) {

  }

  void setNewSong() {
    position = Duration.zero;
  }

  @override
  _MusicMixPlayerState createState() => _MusicMixPlayerState();
}

class _MusicMixPlayerState extends State<MusicMixPlayer> {

  List<AudioPlayer> listAudioPlayer = [];
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return
         Container(
            decoration: const BoxDecoration(color: Color(0xff16123D)),
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    backMusicButton(
                        isColor: false,
                        photo: Icons.close,
                        func: () => {
                          popScreen(context,
                              argument: PlayerIsOn(
                                  isOn: widget.isPlaying, position: widget.position))
                        }),
                    backMusicButton(
                        isColor: false,
                        photo: Icons.edit_note,
                        func: () => {
                          changeScreen(musicCreateEditScreen, context, argument: widget.musicList)
                        }),
                  ],
                ),
                  Image.asset(_image),
                Text(
                  widget.musicList.name,
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
                favouriteBtn(
                    (fav) => {
                          setState(() {
                            widget._isFav = fav;
                          })
                        },
                    isFav: widget._isFav),
                Text(
                  "Таймер отключения",
                  style: TextStyle(
                      fontSize: 15,
                      color: const Color(0xffF7F8FF).withOpacity(0.6)),
                ),
                widget.timer,
                Column(
                  children: [
                    // Padding(
                    //     padding: const EdgeInsets.only(right: 20, left: 15),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text(
                    //           formatTime(widget.position.inSeconds),
                    //           style: const TextStyle(color: Colors.white),
                    //         ),
                    //         Text(
                    //           formatTime(
                    //               widget.duration.inSeconds - widget.position.inSeconds),
                    //           style: const TextStyle(color: Colors.white),
                    //         ),
                    //       ],
                    //     )),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.volume_up_outlined,
                                color: Colors.white,
                              )),
                          Expanded(
                            flex: 5,
                            child: Slider(
                              activeColor: Colors.white,
                              inactiveColor: Colors.white.withOpacity(0.4),
                              // value: widget.position.inSeconds.toDouble(),
                              value: widget.positionVolume,
                              onChanged: (newPlace) async {
                                for (var element in listAudioPlayer) {
                                  element.setVolume(newPlace);
                                }
                                widget.positionVolume = newPlace;
                                setState(() {});
                                // final position =
                                //     Duration(seconds: newPlace.toInt());
                                // await widget.audioPlayer.seek(position);
                                // await widget.audioPlayer.resume();
                              },
                              min: 0.0,
                              // max: widget.duration.inSeconds.toDouble(),
                              max: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/previous.png"),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () async {
                          play();
                        },
                        icon: widget.isPlaying
                            ? Image.asset("assets/images/pause.png")
                            : Image.asset("assets/images/play.png"),
                        iconSize: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset("assets/images/next.png"),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  @override
  void initState() {
    super.initState();
    _image = _getImage();
    initPlayer();
      widget.timer.setCallBack((isTimerGoes) async => {
        if (isTimerGoes)
          {
            play(),
          } else {
          pause(),
        },
      });
  }



  void initPlayer() async {
    _index = await setAudio();
    listAudioPlayer[_index].onPlayerStateChanged.listen((state) {
      setState(() {
        widget.isPlaying = state == PlayerState.PLAYING;
      });
    });
    listAudioPlayer[_index].onDurationChanged.listen((event) {
      setState(() {
        widget.duration = event;
      });
    });
    listAudioPlayer[_index].onAudioPositionChanged.listen((event) {
      setState(() {
        widget.position = event;
      });
    });
  }

  pause() async {
    for (var value in listAudioPlayer) {
      await value.pause();
    }
  }

  play() async {
    if (!widget.isPlaying) {
      listAudioPlayer.asMap().forEach((index, value) async {
        value.setReleaseMode(ReleaseMode.LOOP);
        await value.play(widget.musicList.music[index].musicUrl);
      });
    } else {
      pause();
    }

  }

  @override
  void dispose() {
    for (var value in listAudioPlayer) {
      value.dispose();
    }
    super.dispose();
  }

  String formatTime(int value) {
    int m, s;

    m = ((value)) ~/ 60;

    s = value - (m * 60);

    String result =
        "${m.toString().padLeft(2, "0")}:${s.toString().padLeft(2, "0")}";

    return result;
  }

  final imageList = [
    "assets/images/circle_one.png",
    "assets/images/circle_two.png",
    "assets/images/circle_three.png",
    "assets/images/circle_four.png",
    "assets/images/circle_five.png",
    "assets/images/circle_six.png",
  ];
  String _image = "";
  String _getImage() {
    return imageList[Random().nextInt(imageList.length)];
  }

  Future<int> setAudio() async {
    final list = widget.musicList.music;
    int longest = 0;
    await Future.forEach(list, (element) async {
      final index = list.indexOf(element as MusicInfo);
      final audioPlayer = AudioPlayer();
      listAudioPlayer.add(audioPlayer);
      int a = 0;
      audioPlayer.setUrl(element.musicUrl);
      a = await audioPlayer.getDuration();
      if(a > longest) {
        longest = index;
      }
    });
     return longest;
  }
}


