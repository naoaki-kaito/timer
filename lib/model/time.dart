import 'package:flutter/material.dart';

class TimeModel {
  int id;
  int time;
  int orderNum;

  TimeModel({this.id, @required this.time, @required this.orderNum});

  factory TimeModel.fromMap(Map<String, dynamic> json) => TimeModel(
      id: json['id'], time: json['time'], orderNum: json['order_num']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'time': time,
        'order_num': orderNum,
      };
}
