import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:timr/components/app_button.dart';
import 'package:timr/model/time.dart';

class TimeDialog extends StatelessWidget {
  final TimeModel timeObj;
  final int settedTime;

  TimeDialog.add() : this._init(settedTime: 0);
  TimeDialog.edit(TimeModel time)
      : this._init(timeObj: time, settedTime: time.seconds);
  TimeDialog._init({Key key, this.timeObj, this.settedTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TimeModel _timeObj = timeObj;
    int _settedTime = settedTime;

    return Dialog(
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
                        _settedTime = newDuration.inSeconds;
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
                        AppButton.textButton('Cancel', () {
                          Navigator.pop(context, 'canceled');
                        }),
                        //間隔スペース
                        SizedBox(
                          width: 20,
                        ),
                        //セーブボタン
                        AppButton.textButton('Save', () async {
                          if (_settedTime <= 0) {
                            return;
                          }

                          if (_timeObj != null) {
                            _timeObj.seconds = _settedTime;
                            await TimeStore.updateTime(_timeObj);
                          } else {
                            await TimeStore.createTime(_settedTime);
                          }

                          Navigator.pop(
                              context, (_timeObj != null) ? 'edited' : 'added');
                        }),
                      ],
                    ),
                  ),
                ])));
  }
}
