import 'package:flutter/material.dart';
import 'package:timr/db_provider.dart';


class TimeList extends StatefulWidget {
  TimeList({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {

    DBProvider().getAllTimess().then((time) {
      print('--------------');
      print(time);
    });


    return _TimeList();
  }
}

class _TimeList extends State<TimeList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EDIT TIME LIST'),
      ),
      body: Center(
        child: Text('AAAAAAA'),
      )
    );
  }
}