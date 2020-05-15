import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:timr/pages/timer.dart';
import 'package:timr/pages/time_list/time_list.dart';

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
        home: TimerApp(),
        routes: {
          '/time_list': (context) => TimeList(),
        });
  }
}
