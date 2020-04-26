import 'package:flutter/material.dart';

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