import 'package:flutter/material.dart';

class TimeModel {
  int id;
  int seconds;
  int orderNum;

  TimeModel({this.id, @required this.seconds, @required this.orderNum});

  factory TimeModel.fromMap(Map<String, dynamic> json) => TimeModel(
      id: json['id'], seconds: json['seconds'], orderNum: json['order_num']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'seconds': seconds,
        'order_num': orderNum,
      };
}
