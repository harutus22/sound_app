import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sound_app/util/shut_down_timer.dart';
import 'package:sound_app/view/CustomWidgets.dart';

class TimerWidget extends StatefulWidget {
  late Function(bool isStarted) callback;

  void setCallBack(Function(bool isStarted) callback) {
    this.callback = callback;
  }

  final hourController = TextEditingController();
  final minuteController = TextEditingController();
  bool _isPlaying = false;
  ShutDownTimer shutDownTimer = ShutDownTimer();
  bool _enableTextField = true;
  late _TimerWidgetState state;
  late String btnText = "Start";

  @override
  _TimerWidgetState createState() => state = _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late TextField hourField;
  late TextField minuteField;
  late Text time;

  @override
  Widget build(BuildContext context) {
    if (widget.shutDownTimer.isRunning) {
      widget.btnText = "Stop";
      return _runningTimer();
    } else {
      widget.btnText = "Start";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff181F55)),
        child: GestureDetector(
          onTap: (){
            if(widget._enableTextField){
              _chooseTimerTime();
            }
          },
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: hourField = TextField(
                    enabled: false,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: const Color(0xff16123D),
                      hintText: '0 h',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    controller: widget.hourController,
                    onChanged: (text) {
                      if (int.parse(text) > 10) {
                        widget.hourController.value =
                            widget.hourController.value.copyWith(
                          text: "10 h",
                        );
                      } else {
                        widget.hourController.value =
                            widget.hourController.value.copyWith(text: "$text h");
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: minuteField = TextField(
                    enabled: false,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      fillColor: const Color(0xff16123D),
                      hintText: '00 m',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onChanged: (text) {
                      if (int.parse(text) > 59) {
                        widget.minuteController.value =
                            widget.minuteController.value.copyWith(
                          text: "59 m",
                        );
                      } else {
                        widget.minuteController.value = widget
                            .minuteController.value
                            .copyWith(text: "$text m");
                      }
                    },
                    controller: widget.minuteController,
                  ),
                ),
              ),
              const SizedBox(width: 30),
              SizedBox(
                height: 40,
                width: 80,
                child: ElevatedButton(
                  onPressed: () {
                    widget._isPlaying = !widget._isPlaying;
                    if (widget._isPlaying) {
                      var hour = widget.hourController.value.text
                          .replaceAll("h", '')
                          .trim();
                      var min = widget.minuteController.value.text
                          .replaceAll("m", '')
                          .trim();
                      if (hour == "") {
                        hour = '0';
                      }
                      if (min == "") {
                        min = '0';
                      }
                      widget.minuteController.value =
                          widget.minuteController.value.copyWith(
                            text: min,
                          );
                      widget.hourController.value =
                          widget.hourController.value.copyWith(
                            text: hour,
                          );
                      var minutes = int.parse(hour) * 60 + int.parse(min);
                      if (minutes > 0) {
                        runTimer(minutes);
                        widget._isPlaying = true;
                        widget._enableTextField = false;
                        widget.callback(true);
                      } else {
                        widget._isPlaying = false;
                        widget._enableTextField = true;
                      }
                    } else {
                      widget._isPlaying = false;
                      widget._enableTextField = true;
                      widget.shutDownTimer.cancelTimer();
                      widget.callback(false);
                    }
                    setState(() {});
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )), backgroundColor: MaterialStateProperty.all(
                      const Color(0xff596BFC)
                  )),
                  child: Text(widget.btnText),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }}

  void _chooseTimerTime() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xff16123D),
          title: const Text(
            "Turn of timer",
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            decoration:
            BoxDecoration(border: Border.all(color: Colors.white, width: 1)),
            child: timerChooser((p0) => {
            widget.hourController.value =
            widget.hourController.value.copyWith(text: "$p0 h")
            }, (p0) => widget.minuteController.value = widget.minuteController.value.copyWith(text: "$p0 m"),
                height: 150, width: 60),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text("Save", style: TextStyle(color: Colors.white),),
              onPressed: () => {
                Navigator.pop(context),
                setState(() {})
              },
            ),
            CupertinoDialogAction(
              child: const Text("Cancel", style: TextStyle(color: Colors.white),),
              onPressed: () => {
                Navigator.pop(context),
              },
            ),
          ],
          elevation: 24.0,
        ),
        barrierDismissible: true);
  }

  void runTimer(int minute) {
    widget.shutDownTimer.startTimer(minute);
    initCallback(minute);
  }

  StreamSubscription? subs;

  void initCallback(int minute) {
    subs = widget.shutDownTimer.timerStream.stream.listen((time) {
      retTime(time);
    });
  }

  void retTime(int time) {
    widget.hourController.value =
        widget.hourController.value.copyWith(text: "${time ~/ 60}");
    widget.minuteController.value =
        widget.minuteController.value.copyWith(text: "${time % 60}");
    if (time <= 0) {
      widget.hourController.value =
          widget.hourController.value.copyWith(text: "");
      widget.minuteController.value =
          widget.minuteController.value.copyWith(text: "");
      widget._enableTextField = true;
      widget._isPlaying = false;
      widget.callback(false);
      subs!.cancel();
      widget.shutDownTimer.cancelTimer();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.shutDownTimer.isRunning) {
      final time = widget.shutDownTimer.getMinutes();
      initCallback(time);
    }
  }

  @override
  void dispose() {
    if (subs != null) {
      subs!.cancel();
    }
    super.dispose();
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  int _getMinutes(){
    var hour = widget.hourController.value.text
        .replaceAll("h", '')
        .trim();
    var min = widget.minuteController.value.text
        .replaceAll("m", '')
        .trim();
    if (hour == "") {
      hour = '0';
    }
    if (min == "") {
      min = '0';
    }
    return int.parse(hour) * 60 + int.parse(min);
  }

  Widget _runningTimer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xff181F55)),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
                child: time = Text(
                  durationToString(_getMinutes()),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              height: 40,
              width: 80,
              child: OutlinedButton(
                onPressed: () {
                  widget._isPlaying = !widget._isPlaying;
                    widget.minuteController.value =
                        widget.minuteController.value.copyWith(
                          text: "${widget.minuteController.value.text} m",
                        );
                    widget.hourController.value =
                        widget.hourController.value.copyWith(
                          text: "${widget.hourController.value.text} h",
                        );
                    widget._isPlaying = false;
                    widget._enableTextField = true;
                    widget.shutDownTimer.cancelTimer();
                    widget.callback(false);
                  setState(() {});
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  side: const BorderSide(width: 2, color: Color(0xff596BFC)),
                ),

                child: const Text("Pause", style: TextStyle(
                  color: Color(0xff596BFC)
                ),),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              height: 40,
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  widget._isPlaying = !widget._isPlaying;
                  widget.minuteController.value =
                      widget.minuteController.value.copyWith(
                        text: "",
                      );
                  widget.hourController.value =
                      widget.hourController.value.copyWith(
                        text: "",
                      );
                  widget._isPlaying = false;
                  widget._enableTextField = true;
                  widget.shutDownTimer.cancelTimer();
                  widget.callback(false);
                  setState(() {});
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )), backgroundColor: MaterialStateProperty.all(
                    const Color(0xff596BFC)
                )),
                child: Text(widget.btnText),
              ),
            )
          ],
        ),
      ),
    );
  }
}
