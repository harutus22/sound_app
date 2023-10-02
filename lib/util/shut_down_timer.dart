import 'dart:async';

class ShutDownTimer {
  late Timer _timer;
  var _minutes = 0;
  bool isRunning = false;

  void initTime(int minute){
    _minutes = minute;
  }

  int getMinutes(){
    return _minutes;
  }

  late StreamController<int> timerStream= StreamController<int>.broadcast();

  timeChanged(int minute) {
    timerStream.add(minute);
  }

  void startTimer(int minute) async {
    _minutes = minute;
    isRunning = true;
    if (timerStream.isClosed) {
      timerStream= StreamController<int>.broadcast();
    }
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) => {
      _minutes--,
      timeChanged(_minutes),
    });
  }

  void cancelTimer(){
    _minutes = 0;
    isRunning = false;
    _timer.cancel();
    timerStream.close();
  }
}



