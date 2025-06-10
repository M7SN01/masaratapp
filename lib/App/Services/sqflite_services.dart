import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB();
      return _db;
    } else {
      return _db;
    }
  }

  //initilize database path
  initialDB() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    // String appDocPath = appDocDir.path;
    String databasepath = appDocDir.path; //await getDatabasesPath();
    String path = join(databasepath, 'Data.db');
    Database mydb = await openDatabase(
      path,
      onCreate: _onCreate,
      version: 2,
      onUpgrade: _onUpgrade,
    );
    return mydb;
  }

  //create database only first time the  app run
  _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
    CREATE TABLE "USER"(      
      "U_ID" TEXT,
      "PASS" TEXT
    )
    ''');

    // batch.execute('''
    // insert into priv values('1','1')
    // ''');

    // batch.execute('''
    // CREATE TABLE "notes_Test"(
    //   "id" integer not null primary key autoincrement,
    //   "note"  TEXT not null ,
    //   "title" TEXT ,
    //   "color" TEXT

    // )
    // ''');
    await batch.commit();

    print("OnCreate database and table     ========================");
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    // await db.execute('ALTER TABLE priv ADD COLUMN isActivMyDecumentExpiry TEXT');

    print("OnUpdate database and table     ========================");
  }

  //SELECT
  readDate(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  //INSERT
  insertDate(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  //update
  updateDate(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  //delete
  deleteDate(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  //delete DataBase
  MydeleteDataBase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'Data.db');
    await deleteDatabase(path);
  }
}
