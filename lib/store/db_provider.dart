import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:timr/model/time.dart';

class DBProvider {
  // インスタンスのキャッシュ
  static final DBProvider _dbProvider = DBProvider._internal();

  factory DBProvider() => _dbProvider;

  // 内部から呼び出してインスタンスを作るための、プライベートなコンストラクタ。
  DBProvider._internal();

  static Database _database;
  static final _tableName = "times";

  Future<Database> get database async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(documentsDirectory);

    if (_database != null) return _database;

    // DBがなかったら作る
    _database = await initDB();
    return _database;
  }

  //DBの設定と作成
  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // 'package:path/path.dart' を使って取得
    String path = join(documentsDirectory.path, "TimerDB.db");
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    return await db.execute("CREATE TABLE $_tableName ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "time INTEGER,"
        "order_num INTEGER"
        ")");
  }

  //時間が設定されているかチェック。無かった場合、追加する
  Future<void> checkIsExistTimes() async {
    Completer<void> completer = Completer<void>();
    List<TimeModel> times = await DBProvider().getAllTimes();
    if (times.length == 0) {
      completer.complete();
    } else {
      completer.complete();
    }
    return completer.future;
  }

  createTime(int time) async {
    final db = await database;

    var res = await db.rawInsert(
        "INSERT INTO $_tableName "
        "(time, order_num) "
        "SELECT ?, "
        "CASE "
        "WHEN (SELECT MAX(order_num)) IS NULL THEN 0 "
        "ELSE (SELECT MAX(order_num) + 1) "
        "END "
        "FROM $_tableName",
        [60]);

    //var res = await db.insert(_tableName, time.toMap());
    return res;
  }

  Future<List<TimeModel>> getAllTimes() async {
    final db = await database;
    var res = await db.query(_tableName);
    List<TimeModel> list =
        res.isNotEmpty ? res.map((c) => TimeModel.fromMap(c)).toList() : [];
    return list;
  }

  updateTime(TimeModel time) async {
    final db = await database;
    var res = await db.update(_tableName, time.toMap(),
        where: "id = ?", whereArgs: [time.id]);

    print(res);

    return res;
  }

  deleteTime(int id) async {
    final db = await database;
    var res = db.delete(_tableName, where: "id = ?", whereArgs: [id]);
    return res;
  }
}
