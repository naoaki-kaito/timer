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
    return await db.execute("CREATE TABLE times ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "seconds INTEGER,"
        "order_num INTEGER"
        ")");
  }
}
