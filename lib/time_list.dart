import 'package:flutter/material.dart';
import 'package:timr/button.dart';
import 'package:timr/db_provider.dart';
import 'package:timr/model/time.dart';
import 'package:timr/time_dialog.dart';
import 'package:timr/util/str_util.dart';

class TimeList extends StatefulWidget {
  TimeList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TimeList();
  }
}

class _TimeList extends State<TimeList> {
  @override
  Widget build(BuildContext context) {
    var windowSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text('EDIT TIME LIST'),
        ),
        body: Container(
            width: windowSize.width,
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  child: Button.textButton('ADD TIME', () async {
                    print('ADD');
                    var dialogResult = await showDialog(
                        context: context,
                        builder: (BuildContext context) => TimeDialog.add());
                    print(dialogResult);
                  }),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: DBProvider().getAllTimes(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TimeModel>> snapshot) {
                      if (snapshot.hasData) {
                        List<TimeModel> times = snapshot.data;

                        return ListView.builder(
                          itemCount: times.length,
                          itemBuilder: (BuildContext context, int index) {
                            TimeModel time =
                                TimeModel.fromMap(times[index].toMap());

                            return Column(
                              children: <Widget>[
                                Divider(),
                                Row(
                                  children: <Widget>[
                                    Text(StrUtil.formatToMS(time.time),
                                        style: TextStyle(fontSize: 60)),
                                    // 編集ボタン
                                    FlatButton.icon(
                                      icon: Icon(Icons.edit),
                                      label: SizedBox(),
                                      onPressed: () async {
                                        final dialogResult = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                TimeDialog.edit(time));
                                        print(dialogResult);

                                        setState(() {});
                                      },
                                    ),
                                    //削除ボタン
                                    RaisedButton(
                                      color: Colors.black,
                                      textColor: Colors.white,
                                      shape: StadiumBorder(),
                                      highlightColor: Colors.grey,
                                      child: Text('DELETE'),
                                      onPressed: () {
                                        DBProvider().deleteTime(time.id);
                                        setState(() {});
                                      },
                                    )
                                  ],
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        return Text("データが存在しません");
                      }
                    },
                  ),
                )
              ],
            )));
  }
}
