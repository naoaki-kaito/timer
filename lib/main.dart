import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:timr/button.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Anton'),
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Timer _timer;
  int _settedTime = 60;
  int _nowTime;
  bool _isCounting = false;
  String _buttonStr = '';

  @override
  void initState() {
    _reset();
    changeButtonStr();
    super.initState();
  }

  //カウントダウンを実行
  void _countDown(Timer timer) {
    if (_nowTime > 0) {
      setState(() {
        _nowTime--;
      });
    } else {
      _timer.cancel();
      showFinishDialog();
    }
  }

  //START, STOP ボタンをタップした際の処理
  void _handleCounting() {
    _isCounting = !_isCounting;

    if (_isCounting) {
      _timer = Timer.periodic(
        Duration(seconds: 1),
        _countDown,
      );
    } else {
      _timer.cancel();
    }
    changeButtonStr();
  }

  //リセットボタンをタップした際の処理
  void _reset() {
    setState(() {
      _nowTime = _settedTime;
    });
  }

  //START,STOPの文言入れ替え
  void changeButtonStr() {
    setState(() {
      _buttonStr = _isCounting ? 'STOP' : 'START';
    });
  }

  //終了ダイアログ
  void showFinishDialog() {
    FlutterRingtonePlayer.playAlarm(looping: true, volume: 0.5);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('通知'),
            content: Text('タイマーは終了しました。'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    FlutterRingtonePlayer.stop();
                    _isCounting = false;
                    changeButtonStr();
                    _reset();
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
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
                  Text(_formatToMS(_nowTime),
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
                                  Button.textButton('EDIT', showEditDialog),
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
                  Button.textButton(_buttonStr, _handleCounting),
                  // RESET ボタン
                  if (!_isCounting) ...[
                    SizedBox(
                      width: 20,
                    ),
                    Button.textButton('RESET', _reset)
                  ]
                ],
              ),
            )
          ],
        )));
  }

  //時間編集ダイアログ
  void showEditDialog() {
    final TextEditingController _textEditingController =
        new TextEditingController();

    //ダイアログ内で選択した時間
    int newTime = _settedTime;

    Dialog dialog = Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
            height: 400.0,
            width: 300.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //時間設定
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: CupertinoTimerPicker(
                      initialTimerDuration: new Duration(seconds: _settedTime),
                      mode: CupertinoTimerPickerMode.ms,
                      onTimerDurationChanged: (newDuration) {
                        setState(() {
                          newTime = newDuration.inSeconds;
                        });
                      },
                    ),
                  ),
                  //ボタン群
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        //キャンセルボタン
                        Button.textButton('Cancel', () {
                          Navigator.of(context).pop();
                        }),
                        //間隔スペース
                        SizedBox(
                          width: 20,
                        ),
                        //セーブボタン
                        Button.textButton('Save', () {
                          _settedTime = newTime;
                          _reset();
                          Navigator.of(context).pop();
                        }),
                      ],
                    ),
                  ),
                ])));
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  //時間のフォーマット
  String _formatToMS(int seconds) {
    Duration duration = Duration(seconds: seconds);
    return duration
        .toString()
        .replaceAll(RegExp("^0:"), "")
        .replaceAll(RegExp("\\..*"), "");
  }
}
