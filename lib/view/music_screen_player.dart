import 'dart:async';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sound_app/model/MusicInfo.dart';
import 'package:sound_app/util/const.dart';
import 'package:sound_app/view/timer_widget.dart';
import '../model/PlayerIsOn.dart';
import '../util/Routes.dart';
import 'CustomWidgets.dart';

class MusicScreenPlayer extends StatefulWidget {
  MusicScreenPlayer({Key? key, required this.timer}) : super(key: key);
  MusicInfo? musicInfo;
  bool isGridScreen = false;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool _isFav = false;
  AudioPlayer audioPlayer = AudioPlayer();
  late TimerWidget timer;
  var firstClick = false;
  late AudioCache cached;
  bool isOld = false;
  late _MusicScreenPlayerState state;
  double positionVolume = 0.5;
  void setMusic(MusicInfo musicInfo) {
    this.musicInfo = musicInfo;
    _isFav = musicInfo.isFav;
  }

  void setNewSong() {
    isGridScreen = false;
    audioPlayer.release();
    position = Duration.zero;
    firstClick = false;
    isOld = false;
  }

  void setOldOne() {
    isGridScreen = false;
    isOld = true;
  }

  @override
  _MusicScreenPlayerState createState() => state = _MusicScreenPlayerState();
}

class _MusicScreenPlayerState extends State<MusicScreenPlayer> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isPlaying)
        {widget.isGridScreen = true;}
        else
        {widget.isGridScreen = false;}
        popScreen(context,
        argument: PlayerIsOn(
        isOn: widget.isPlaying, position: widget.position));
        return false;
      },
      child: widget.isGridScreen
          ? smallPlayer()
          : Container(
              decoration: const BoxDecoration(color: Color(0xff16123D)),
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  backMusicButton(
                      isColor: false,
                      photo: Icons.close,
                      func: () => {
                            if (widget.isPlaying)
                              {widget.isGridScreen = true}
                            else
                              {widget.isGridScreen = false},
                            popScreen(context,
                                argument: PlayerIsOn(
                                    isOn: widget.isPlaying, position: widget.position))
                          }),
                  widget.musicInfo!.imageUrl.contains("https") ?
                    Image.network(widget.musicInfo!.imageUrl) :
                    Image.asset(widget.musicInfo!.imageUrl)
                  ,
                  Text(
                    widget.musicInfo!.name,
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  favouriteBtn(
                      (fav) => {
                        if(!fav){
                          dbHelper.deleteFavourite(widget.musicInfo!.musicUrl)
                        } else {
                          dbHelper.insertFav(widget.musicInfo!)
                        },
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
                                  widget.audioPlayer.setVolume(newPlace);
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
            ),
    );
  }

  Widget smallPlayer() {

    return Container(
      alignment: Alignment.bottomCenter,
      color: const Color(0xff181F55),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          SizedBox(
            width: 0,
            height: 0,
            child: widget.timer,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              children: [
                Expanded(child: Text(widget.musicInfo!.name, style: const TextStyle(color: Colors.white),)),
                const Icon(Icons.skip_previous_sharp, color: Colors.white,),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () async {
                    play();
                  },
                  icon: widget.isPlaying
                      ? const Icon(Icons.pause)
                      : const Icon(Icons.play_arrow),
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(Icons.skip_next, color: Colors.white,),
              ],
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
                trackHeight: 1,
                thumbColor: Colors.transparent,
                overlayShape: SliderComponentShape.noOverlay,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0)),
            child: Slider(
              activeColor: const Color(0xff596BFC),
              inactiveColor: Colors.white.withOpacity(0.4),
              value: widget.position.inSeconds.toDouble(),
              onChanged: (newPlace) async {
                final position =
                Duration(seconds: newPlace.toInt());
                await widget.audioPlayer.seek(position);
                await widget.audioPlayer.resume();
              },
              min: 0,
              max: widget.duration.inSeconds.toDouble(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
      widget.timer.setCallBack((isTimerGoes) async => {
        if (isTimerGoes)
          {
            playCached(),
          } else {
            pause(),
        },
      });
      dbHelper.getFavourites().then((value) => {
        if(value?.singleWhere((element) => element.name == widget.musicInfo!.name) != null){
          widget._isFav = true
        } else {
          widget._isFav = false
      },
        setState((){}),
      });
  }

  void initPlayer() {
    setAudio();
    widget.audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        widget.isPlaying = state == PlayerState.PLAYING;
      });
    });
    widget.audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        widget.duration = event;
      });
    });
    widget.audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        widget.position = event;
      });
    });
    widget.cached = AudioCache(fixedPlayer: widget.audioPlayer);
    if (widget.isPlaying && !widget.isGridScreen) {
      play();
    }
  }

  playCached() async {
    final music = widget.musicInfo!.musicUrl;
    if(music.contains("https")){
      widget.audioPlayer.setReleaseMode(ReleaseMode.LOOP);
      await widget.audioPlayer.play(music);

    } else {
      await widget.cached.loop(music.substring(7, music.length));
    }
    widget.firstClick = true;
  }

  pause() async {
    await widget.audioPlayer.pause();
  }

  play() async {
    if (!widget.firstClick) {
      if(widget.musicInfo!.musicUrl.contains("https")){
        await widget.audioPlayer.play(widget.musicInfo!.musicUrl);
      } else {
        await widget.audioPlayer.playBytes(soundbytes);
      }
      widget.firstClick = true;
    }
    if (widget.isPlaying) {
      if (widget.isOld) {
        widget.isOld = !widget.isOld;
        await widget.audioPlayer.resume();
      } else {
        await widget.audioPlayer.pause();
      }
    } else {
      if (widget.isOld) {
        widget.isOld = !widget.isOld;
        await widget.audioPlayer.pause();
      }
      await widget.audioPlayer.resume();
    }
  }

  @override
  void dispose() {
    // widget.audioPlayer.release();
    super.dispose();
  }

  Future setAudio() async {
    String audioasset = widget.musicInfo!.musicUrl;
    ByteData bytes = await rootBundle.load(audioasset); //load sound from assets
    soundbytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }


  late Uint8List soundbytes;

  String formatTime(int value) {
    int m, s;

    m = ((value)) ~/ 60;

    s = value - (m * 60);

    String result =
        "${m.toString().padLeft(2, "0")}:${s.toString().padLeft(2, "0")}";

    return result;
  }

  void setMusic(MusicInfo musicInfo) {
    widget.musicInfo = musicInfo;
  }
}
