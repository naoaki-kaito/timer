import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:timr/components/app_button.dart';
import 'package:timr/components/app_dialog.dart';
import 'package:timr/model/timer.dart';
import 'package:timr/util/str_util.dart';

class TimerApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimerState();
  }
}

class _TimerState extends State<TimerApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Timr'),
        ),
        body: Center(
            child: Consumer<TimerModel>(builder: (context, timerModel, _) {
          // 終了ダイアログ
          if (timerModel.isFinished) {
            //ビルドが終わってから終了ダイアログを出す
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppDialog.showFinishDialog(context);
            });
          }

          return Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // 時間を表示
                    //Text(StrUtil.formatToMS(timerModel.seconds),
                    Text(StrUtil.formatToMS(timerModel.seconds),
                        style: TextStyle(
                          fontSize: 150.0,
                        )),
                    SizedBox(
                        height: 120,
                        child: //編集ボタン
                            Visibility(
                                visible: !timerModel.isCounting,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        AppButton.textButton('EDIT', () {
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
                    AppButton.textButton(
                        timerModel.isCounting ? 'STOP' : 'START',
                        timerModel.handleCounting),
                    // RESET ボタン
                    if (!timerModel.isCounting) ...[
                      SizedBox(
                        width: 20,
                      ),
                      AppButton.textButton('RESET', timerModel.initTimes)
                    ]
                  ],
                ),
              )
            ],
          );
        })));
  }
}
