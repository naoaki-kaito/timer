import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:timr/model/time.dart';
import 'package:timr/store/user_store.dart';

class TimerModel with ChangeNotifier {
  List<TimeModel> times = [];
  int _nowIndex = 0;
  int _setSeconds = 0;
  int _seconds = 0;
  bool _isCounting = false;
  bool _isFinished = false;
  Timer _timer;

  TimerModel() {
    this.initTimes();
  }

  int get nowIndex => _nowIndex;
  int get seconds => _seconds;
  bool get isCounting => _isCounting;
  bool get isFinished => _isFinished;

  //タイマーの初期化処理
  initTimes() async {
    // sharedPreferenceのインスタンスを保存しておく
    UserStore().prefs = await SharedPreferences.getInstance();
    if (!(UserStore().repeat ?? false)) {
      UserStore().repeat = false;
    }

    this.times = await TimeStore.getAllTimes();
    if (this.times.length == 0) {
      await TimeStore.createTime(60);
    }
    _isFinished = false;
    _nowIndex = 0;
    _setTimeOfIndex();
    _resetTime();
  }

  //リセット処理
  void _resetTime() {
    _seconds = _setSeconds;
    notifyListeners();
  }

  //カウントダウンを実行
  void _countDown(Timer timer) {
    if (_seconds > 0) {
      _seconds--;
    } else if (this.times.asMap().containsKey((_nowIndex + 1))) {
      // 次の設定時間があった場合の処理
      this.handleCounting();
      _nowIndex++;
      _setTimeOfIndex();
      this.handleCounting();
      FlutterRingtonePlayer.playAlarm(looping: true, volume: 0.5);
    } else if (UserStore().repeat) {
      // リピート設定をしていた場合の処理
      this.handleCounting();
      _nowIndex = 0;
      _setTimeOfIndex();
      this.handleCounting();
      FlutterRingtonePlayer.playAlarm(looping: true, volume: 0.5);
    } else {
      // タイマーが最後まで行って、終了した時の処理
      _timer.cancel();
      //AppDialog.showFinishDialog(context);
      _isCounting = false;
      _nowIndex = 0;
      _setTimeOfIndex();
      _isFinished = true;
    }
    notifyListeners();
  }

  //START, STOP ボタンをタップした際の処理
  void handleCounting() {
    _isCounting = !_isCounting;

    if (_isCounting) {
      _timer = Timer.periodic(
        Duration(seconds: 1),
        _countDown,
      );
    } else {
      _timer.cancel();
    }
    notifyListeners();
  }

  //指定したインデックスの時間をセットする
  void _setTimeOfIndex() {
    _setSeconds = this.times[_nowIndex].seconds;
    _resetTime();
  }

  void stop() {
    _timer.cancel();
  }
}
