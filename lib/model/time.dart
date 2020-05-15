import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timr/store/db_provider.dart';

class TimeModel {
  int id;
  int seconds;
  int orderNum;
  static final _tableName = "times";

  TimeModel({this.id, @required this.seconds, @required this.orderNum});

  factory TimeModel.fromMap(Map<String, dynamic> json) => TimeModel(
      id: json['id'], seconds: json['seconds'], orderNum: json['order_num']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'seconds': seconds,
        'order_num': orderNum,
      };
}

class TimeStore {
  //時間が設定されているかチェック。無かった場合、追加する
  static Future<void> checkIsExistTimes() async {
    Completer<void> completer = Completer<void>();
    List<TimeModel> times = await TimeStore.getAllTimes();
    if (times.length == 0) {
      completer.complete();
    } else {
      completer.complete();
    }
    return completer.future;
  }

  static createTime(int seconds) async {
    final db = await DBProvider().database;

    var res = await db.rawInsert(
        "INSERT INTO ${TimeModel._tableName} "
            "(seconds, order_num) "
            "SELECT ?, "
            "CASE "
            "WHEN (SELECT MAX(order_num)) IS NULL THEN 0 "
            "ELSE (SELECT MAX(order_num) + 1) "
            "END "
            "FROM ${TimeModel._tableName}",
        [seconds]);
    return res;
  }

  static Future<List<TimeModel>> getAllTimes() async {
    final db = await DBProvider().database;
    var res = await db.query(TimeModel._tableName);
    List<TimeModel> list =
    res.isNotEmpty ? res.map((c) => TimeModel.fromMap(c)).toList() : [];
    return list;
  }

  static updateTime(TimeModel time) async {
    final db = await DBProvider().database;
    var res = await db.update(TimeModel._tableName, time.toMap(),
        where: "id = ?", whereArgs: [time.id]);
    return res;
  }

  static deleteTime(int id) async {
    final db = await DBProvider().database;
    var res = db.delete(TimeModel._tableName, where: "id = ?", whereArgs: [id]);
    return res;
  }



}