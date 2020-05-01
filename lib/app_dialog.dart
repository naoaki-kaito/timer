import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class AppDialog {
  static void showFinishDialog(BuildContext context) {
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
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }
}
