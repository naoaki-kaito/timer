import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timr/button.dart';
import 'package:timr/app_dialog.dart';
import 'package:timr/store/db_provider.dart';
import 'package:timr/pages/time_list/time_list.dart';
import 'package:timr/store/user_store.dart';
import 'package:timr/util/str_util.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'Anton',
          appBarTheme: AppBarTheme(
            color: Colors.black,
          ),
        ),
        home: MyPage(),
        routes: {
          '/time_list': (context) => TimeList(),
        });
  }
}

class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Timer _timer;
  int _settedTime = 0;
  int _nowTime;
  bool _isCounting = false;
  List _times = [];
  int _nowIndex = 0;

  @override
  void initState() {
    _resetTime();
    initTimes();
    super.initState();
  }

  initTimes() async {
    // sharedPreferenceのインスタンスを保存しておく
    UserStore().prefs = await SharedPreferences.getInstance();
    if (!(UserStore().repeat ?? false)) {
      UserStore().repeat = false;
    }

    await DBProvider().checkIsExistTimes();
    _times = await DBProvider().getAllTimes();
    _nowIndex = 0;
    _settedTime = _times[_nowIndex].time;
    _resetTime();
  }

  //カウントダウンを実行
  void _countDown(Timer timer) {
    if (_nowTime > 0) {
      setState(() {
        _nowTime--;
      });
    } else if (_times.asMap().containsKey((_nowIndex + 1))) {
      // 次の設定時間があった場合の処理
      _handleCounting();
      _nowIndex++;
      _settedTime = _times[_nowIndex].time;
      _resetTime();
      _handleCounting();
      FlutterRingtonePlayer.playAlarm(looping: true, volume: 0.5);
    } else if (UserStore().repeat) {
      // リピート設定をしていた場合の処理
      _handleCounting();
      _nowIndex = 0;
      _settedTime = _times[0].time;
      _resetTime();
      _handleCounting();
      FlutterRingtonePlayer.playAlarm(looping: true, volume: 0.5);
    } else {
      // タイマーをストップ
      _timer.cancel();
      AppDialog.showFinishDialog(context);
      setState(() {
        _isCounting = false;
      });
      _settedTime = _times[0].time;
      _resetTime();
    }
  }

  //START, STOP ボタンをタップした際の処理
  void _handleCounting() {
    setState(() {
      _isCounting = !_isCounting;
    });

    if (_isCounting) {
      _timer = Timer.periodic(
        Duration(seconds: 1),
        _countDown,
      );
    } else {
      _timer.cancel();
    }
  }

  //リセットボタンをタップした際の処理
  void _resetTime() {
    setState(() {
      _nowTime = _settedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Timr'),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(StrUtil.formatToMS(_nowTime),
                      style: TextStyle(
                        fontSize: 150.0,
                      )),
                  SizedBox(
                      height: 120,
                      child: //編集ボタン
                          Visibility(
                              visible: !_isCounting,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Button.textButton('EDIT', () {
                                        Navigator.pushNamed(
                                            context, '/time_list');
                                      }),
                                    ],
                                  )
                                ],
                              ))),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // START, STOP ボタン
                  Button.textButton(
                      _isCounting ? 'STOP' : 'START', _handleCounting),
                  // RESET ボタン
                  if (!_isCounting) ...[
                    SizedBox(
                      width: 20,
                    ),
                    Button.textButton('RESET', initTimes)
                  ]
                ],
              ),
            )
          ],
        )));
  }
}
