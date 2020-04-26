import 'dart:io';
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
  static final _tableName = "Times";

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // DBがなかったら作る
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // 'package:path/path.dart' を使って取得
    String path = join(documentsDirectory.path, "TimerDB.db");
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    return await db.execute(
        "CREATE TABLE Times ("
            "id TEXT PRIMARY KEY,"
            "time INTEGER,"
            "order_num INTEGER"
            ")"
    );
  }

  createTime(TimeModel time) async {
    final db = await database;
    var res = await db.insert(_tableName, time.toMap());
    return res;
  }

  Future<dynamic> getAllTimess() async {
    final db = await database;
    var res = await db.query(_tableName);
    List<TimeModel> list =
    res.isNotEmpty ? res.map((c) => TimeModel.fromMap(c)).toList() : [];
    return list;
  }

  updateTodo(TimeModel time) async {
    final db = await database;
    var res  = await db.update(
        _tableName,
        time.toMap(),
        where: "id = ?",
        whereArgs: [time.id]
    );
    return res;
  }

  deleteTodo(String id) async {
    final db = await database;
    var res = db.delete(
        _tableName,
        where: "id = ?",
        whereArgs: [id]
    );
    return res;
  }
}