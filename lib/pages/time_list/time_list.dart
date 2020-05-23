import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timr/components/app_button.dart';
import 'package:timr/model/time.dart';
import 'package:timr/pages/time_list/components/time_dialog.dart';
import 'package:timr/store/user_store.dart';
import 'package:timr/util/str_util.dart';

class TimeList extends StatefulWidget {
  TimeList({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TimeListState();
  }
}

class _TimeListState extends State<TimeList> {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      child: FlatButton.icon(
                        icon: Icon(Icons.add),
                        label: SizedBox(
                          width: 0,
                        ),
                        onPressed: () async {
                          await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  TimeDialog.add());
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      child: FlatButton.icon(
                        icon: Icon(
                          Icons.repeat,
                          color: UserStore().repeat
                              ? AppButton.backgroundColor
                              : Colors.white30,
                        ),
                        label: SizedBox(
                          width: 0,
                        ),
                        onPressed: () {
                          setState(() {
                            if (UserStore().repeat) {
                              UserStore.clearRepeat();
                            } else {
                              UserStore().repeat = true;
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: FutureBuilder(
                    future: TimeStore.getAllTimes(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TimeModel>> snapshot) {
                      if (snapshot.hasData) {
                        List<TimeModel> times = snapshot.data;

                        return ListView.builder(
                          itemCount: times.length,
                          itemBuilder: (BuildContext context, int index) {
                            TimeModel time =
                                TimeModel.fromMap(times[index].toMap());

                            return Dismissible(
                                key: Key(times[index].id.toString()),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                    color: Colors.deepOrange,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 30),
                                        child: Icon(
                                          Icons.cancel,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                                onDismissed: (direction) async {
                                  await TimeStore.deleteTime(time.id);
                                  setState(() {});
                                },
                                child: Column(
                                  children: <Widget>[
                                    Divider(),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                              StrUtil.formatToMS(time.seconds),
                                              style: TextStyle(fontSize: 60)),
                                        ),
                                        // 編集ボタン
                                        FlatButton.icon(
                                          icon: Icon(Icons.edit),
                                          label: SizedBox(),
                                          onPressed: () async {
                                            await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        TimeDialog.edit(time));
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ));
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
