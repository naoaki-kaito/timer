import 'package:flutter/material.dart';

class TimeModel {
  String id;
  int time;
  int order_num;

  TimeModel({this.id, @required this.time, @required this.order_num});

  factory TimeModel.fromMap(Map<String, dynamic> json) => TimeModel(
      id: json['id'],
      time: json['title'],
      order_num: json['order_num']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'time': time,
    'order_num': order_num,
  };
}