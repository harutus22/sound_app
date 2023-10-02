import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sound_app/model/MusicInfo.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key, required this.musicInfo}) : super(key: key);
  final MusicInfo musicInfo;
  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  var _isActive= false;
  bool _isPlaying = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  double _volume = 0.5;

  @override
  void initState() {
    super.initState();
    // setAudio();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.PLAYING;
      });
    });
    _audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        _duration = event;
      });
    });
    _audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        _position = event;
      });
    });
  }

  Future setAudio() async {
    var url = widget.musicInfo.musicUrl;
    _audioPlayer.setUrl(url);
  }


  @override
  Widget build(BuildContext context) {
    if(!_isActive) {
      _isActive = true;
      setAudio();
      play();
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff181F55),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(width: 1, color:const Color(0xff596BFC)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14,right: 14, top: 10),
            child: Text(widget.musicInfo.name, style: const TextStyle(
              color: Colors.white, fontFamily: 'TT_Norms', fontSize: 16
            ), textAlign: TextAlign.start,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){},
                icon: const Icon(Icons.volume_up, size: 25, color: Colors.white,),),
              Expanded(
                child: SizedBox(
                  child: SfSliderTheme(
                    data: SfSliderThemeData(
                      thumbRadius: 10,
                      activeDividerStrokeWidth: 3,
                      inactiveDividerStrokeWidth: 3,
                    ),
                    child: SfSlider(
                      value: _volume,
                      min: 0.0,
                      max: 1.0,
                      interval: 0.1,

                      onChanged: (dynamic volume) async {
                        setState(() {
                          _volume = volume;
                          _audioPlayer.setVolume(volume);
                        });
                      },
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  play() async {
    if (!_isPlaying) {
      int result = await _audioPlayer.resume();
      if (result == 1) {}
    } else {
      await _audioPlayer.pause();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
