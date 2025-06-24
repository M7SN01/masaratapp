import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      version: 3,
      onUpgrade: _onUpgrade,
    );
    // print("XXXXXXXXXXXXXXXXXXXXXXXXX-- OPEN DATABASE --XXXXXXXXXXXXXXXXX");
    return mydb;
  }

  //create database only first time the  app run
  _onCreate(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('''
    CREATE TABLE "USER"(      
      "U_ID" TEXT,
      "U_NAME" TEXT,
      "U_P" TEXT,
      "AUTO_LOGIN" INTEGER DEFAULT 0
    );
    ''');
    batch.execute('''
    CREATE TABLE IF NOT EXISTS "ACT_TYPE" (
      "ACT_ID" INTEGER PRIMARY KEY,
      "ACT_NAME" TEXT
    );
    ''');
    batch.execute('''
    CREATE TABLE IF NOT EXISTS "CUSTOMERS" (
      "CUS_ID" INTEGER PRIMARY KEY,
      "CUS_NAME" TEXT,
      "ADRS" TEXT,
      "MOBL" TEXT,
      "TAX_NO" TEXT,
      "STOPED" INTEGER DEFAULT 0,
      "SLS_MAN_ID" INTEGER,
      "LATITUDE" REAL,
      "LONGITUDE" REAL,
      "VISIT_CNT" INTEGER,
      "VAT_STATUS" INTEGER
    );
    ''');
    batch.execute('''
    CREATE TABLE IF NOT EXISTS "SLS_CENTER" (
      "SLS_CNTR_ID" INTEGER,
      "SLS_CNTR_NAME" TEXT
    );
    ''');
    batch.execute('''
    CREATE TABLE IF NOT EXISTS "COST_CENTERS" (
      "CST_ID" INTEGER,
      "CST_A_NAME" TEXT
    );
    ''');
    batch.execute('''
    CREATE TABLE IF NOT EXISTS "STWHOUSE" (
      "WH_ID" INTEGER,
      "WH_NAME" TEXT
    );
    ''');
    batch.execute('''
    CREATE TABLE IF NOT EXISTS "BRANCH" (
      "BR_ID" INTEGER,
      "BR_NAME" TEXT
    );
    ''');
    batch.execute('''
    CREATE TABLE IF NOT EXISTS "SH_BANKS_DTL" (
      "BANK_ID" TEXT,
      "ACC_NAME" TEXT,
      "ACC_ID" TEXT,
      "BANK_OR_CASH" INTEGER,
      "STOPED" INTEGER DEFAULT 0,
      "CUR_ID" TEXT
    );
    ''');
    batch.execute('''
    CREATE TABLE IF NOT EXISTS "ITEMS" (
      "ITEM_ID" TEXT PRIMARY KEY,
      "BARCODE" TEXT,
      "ITEM_NAME" TEXT,
      "MAIN_UNIT" TEXT,
      "PRICE1" REAL,
      "PRICE_AFTR_VAT" REAL,
      "CURNT_BAL" REAL
    );
    ''');
    batch.execute('''
    CREATE TABLE IF NOT EXISTS "CS_CLS" (
      "CS_CLS_ID" INTEGER PRIMARY KEY,
      "CS_CLS_NAME" TEXT,
      "ACC_ID" TEXT,
      "BR_ID" TEXT,
      "CUR_ID" TEXT
    );
''');

    batch.execute('''
    CREATE TABLE IF NOT EXISTS "COMP" (
      "REP_A_COMP_NAME" TEXT,
      "REP_E_COMP_NAME" TEXT,
      "REP_A_NTUR_WORK" TEXT,
      "REP_E_NTUR_WORK" TEXT,
      "REP_A_ADRS" TEXT,
      "REP_E_ADRS" TEXT,
      "REP_A_TEL" TEXT,
      "REP_A_FAX" TEXT,
      "TAX_NO" TEXT,
      "COMMERCIAL_REG" TEXT,      
      "HAS_OFFLINE_DATA" INTEGER DEFAULT 0,
      "LAST_OFFLINE_SYNC" TEXT
    );
''');

//ACC Tables
    batch.execute('''
    CREATE TABLE "ACC_HD" (
      "ACC_TYPE" INTEGER,
      "ACC_HD_ID" INTEGER,
      "DATE1" TEXT,
      "BR_ID" TEXT,
      "CUR_ID" TEXT,
      "TTL" REAL,
      "DSCR" TEXT,
      "TRHEL" INTEGER,
      "RDY" INTEGER,
      "SYS_TYPE" TEXT,
      "BRNCH_ACT" INTEGER,
      "EXCHNG_PR" REAL,
      "USR_INS" INTEGER,
      "USR_INS_DATE" TEXT,
      "SCRN_SRC" TEXT,
      "SYNC" INTEGER DEFAULT 0 CHECK("SYNC" IN (0, 1)),
      PRIMARY KEY ("ACC_TYPE", "ACC_HD_ID")
    );
    ''');

    batch.execute('''
    CREATE TABLE "ACC_DT" (
      "CUS_ID" INTEGER,
      "ACC_TYPE" INTEGER,
      "ACC_HD_ID" INTEGER,
      "ACC_ID" TEXT,
      "CUR_ID" TEXT,
      "STATE" INTEGER,
      "AMNT" REAL,
      "DSCR" TEXT,
      "CST_ID" INTEGER,
      "SRL" INTEGER,
      "BANK_ID" TEXT,
      "BR_ID" TEXT,
      FOREIGN KEY ("ACC_TYPE", "ACC_HD_ID") REFERENCES "ACC_HD"("ACC_TYPE", "ACC_HD_ID") ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''');

//SLS SHOW TABLES
    batch.execute('''
    CREATE TABLE "SLS_SHOW_HD" (
      "R_TP" INTEGER,
      "R_ID" INTEGER,
      "DATE1" TEXT,
      "CUS_ID" INTEGER,
      "PUR_TTL" REAL,
      "DSCR" TEXT,
      "CUS_NM" TEXT,
      "CUS_NM1" TEXT,
      "CUS_MOBILE" TEXT,
      "USR_INS" INTEGER,
      "USR_INS_DATE" TEXT,
      "VAT_STATUS" INTEGER,
      "VAT_PR" INTEGER,
      "VAT" REAL,
      "PRICE_TYPE" INTEGER,
      "TAX_NO" TEXT,
      "SAVE_NO" INTEGER,
      "SYNC" INTEGER DEFAULT 0 CHECK("SYNC" IN (0, 1)),
      PRIMARY KEY ("R_TP", "R_ID")
    );
    ''');

    batch.execute('''
    CREATE TABLE "SLS_SHOW_DT" (
      "R_TP" INTEGER,
      "R_ID" INTEGER,
      "BARCODE" TEXT,
      "ITEM_ID" TEXT,
      "UNIT" TEXT,
      "QTY" REAL,
      "PRICE" REAL,
      "DISCNT" REAL,
      "HWMNY" INTEGER,
      "SRL" INTEGER,
      "VAT_IN" INTEGER,
      "IT_VAT" REAL,
      "VAT_VAL" REAL,
      "PRICE_AFTR_VAT" REAL,
      FOREIGN KEY ("R_TP", "R_ID") REFERENCES "SLS_SHOW_HD"("R_TP", "R_ID") ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''');

    await batch.commit();

    debugPrint("OnCreate database and table     ========================");
  }

  _onUpgrade(Database db, int oldversion, int newversion) async {
    await db.execute('''
    CREATE TABLE "SLS_SHOW_DT" (
      "R_TP" TEXT,
      "R_ID" INTEGER,
      "BARCODE" TEXT,
      "ITEM_ID" TEXT,
      "UNIT" TEXT,
      "QTY" REAL,
      "PRICE" REAL,
      "DISCNT" REAL,
      "HWMNY" INTEGER,
      "SRL" INTEGER,
      "VAT_IN" INTEGER,
      "IT_VAT" REAL,
      "VAT_VAL" REAL,
      "PRICE_AFTR_VAT" REAL,
      FOREIGN KEY ("R_TP", "R_ID") REFERENCES "SLS_SHOW_HD"("R_TP", "R_ID") ON DELETE CASCADE ON UPDATE CASCADE
    );
    ''');

    debugPrint("OnUpdate database and table     ========================");
  }

  //SELECT
  readData(String sql, [List<Object?>? arguments]) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql, arguments);
    return response;
  }

  //INSERT
  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  //update
  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  //delete
  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);

    return response;
  }

  //delete
  deleteTable({required String tableName}) async {
    Database? mydb = await db;
    int response = await mydb!.delete(tableName);
    return response;
  }

  // //colse database
  // Future<void> closeDatabase() async {
  //   if (_db != null && _db!.isOpen) {
  //     await _db!.close();
  //     _db = null;
  //     debugPrint("Database closed and reset.");
  //   }
  // }

  //BACKUP
  Future<bool> backupDatabase() async {
    try {
      // Get the source database path
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String sourcePath = join(appDocDir.path, 'Data.db');

      // Get external storage directory (requires permissions on Android)
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        print("Couldn't access external storage");
        return false;
      }

      // Create backup directory if it doesn't exist
      Directory backupDir = Directory('${externalDir.path}/backups');
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // Create timestamped backup file
      String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      String backupPath = join(backupDir.path, 'Data_$timestamp.db');

      // Copy the database file
      await File(sourcePath).copy(backupPath);

      print('Backup created at: $backupPath');
      return true;
    } catch (e) {
      print('Backup failed: $e');
      return false;
    }
  }

  //RESTORE
  Future<bool> restoreDatabase() async {
    // Close the database if it's open
    try {
      if (_db!.isOpen) {
        await _db!.close();
        _db = null; // Important to clear the reference
      }
    } catch (e) {
      print('Error closing database: $e');
      return false;
    }

    //
    try {
      // Get external storage directory
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        print("Couldn't access external storage");
        return false;
      }

      // Find the most recent backup
      Directory backupDir = Directory('${externalDir.path}/backups');
      if (!await backupDir.exists()) {
        print("No backup directory found");
        return false;
      }

      // List all backup files and sort by modification date
      List<FileSystemEntity> files = backupDir.listSync().where((file) => file.path.endsWith('.db')).toList();

      if (files.isEmpty) {
        print("No backup files found");
        return false;
      }

      files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      File latestBackup = File(files.first.path);

      // Get the destination path
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String destinationPath = join(appDocDir.path, 'Data.db');

      // Close any existing database connection
      // (Important - otherwise the file copy might fail)
      // You'll need to track your database instance somewhere

      // Copy the backup file
      await latestBackup.copy(destinationPath);

      print('Database restored from: ${latestBackup.path}');
      return true;
    } catch (e) {
      print('Restore failed: $e');
      return false;
    }
  }

  //delete DataBase
  mydeleteDataBase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'Data.db');
    await deleteDatabase(path);
  }
}
