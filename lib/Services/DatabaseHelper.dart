import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _dbName = 'appDatabase.db';
  static const _dbVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _initiateDatabase();

  Future<Database> _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE setting
      (
        key STRING PRIMARY KEY ,
        value BOOLEAN
      )
      ''');
    await db.execute('''
      CREATE TABLE stage
      (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        toUnlock INTEGER,
        stars INTEGER,
        status STRING
      )
      ''');

    await db.execute('''
      CREATE TABLE level
      (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        stageId INTEGER,
        toUnlock INTEGER,
        status STRING,
        stars INTEGER,
        time FLOAT,
        FOREIGN KEY (stageID) REFERENCES stage (id)
      )
      ''');

    await db.execute('''
      CREATE TABLE question
      (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        levelId INTEGER,
        operand_1 INTEGER,
        operand_2 INTEGER,
        operator STRING,
        ans_1 INTEGER,
        ans_2 INTEGER,
        ans_3 INTEGER,
        correctAns INTEGER,
        time DOUBLE,
        FOREIGN KEY (levelId) REFERENCES level (id)
      )
      ''');

    await db.execute('''
      CREATE TRIGGER update_star
      AFTER UPDATE ON level
      FOR EACH ROW
      BEGIN
      UPDATE level SET toUnlock = toUnlock - NEW.stars + OLD.stars WHERE status = 'Locked';
      UPDATE stage SET toUnlock = toUnlock - NEW.stars + OLD.stars WHERE status = 'Locked';
      END
      ''');

    await db.execute('''
      CREATE TRIGGER update_status
      AFTER UPDATE ON level
      FOR EACH ROW
      BEGIN
      UPDATE level SET status = 'Unlocked', toUnlock = 0 WHERE toUnlock <= 0;
      UPDATE stage SET status = 'Unlocked', toUnlock = 0 WHERE toUnlock <= 0;
      END
      ''');

    await db.rawInsert(''' 
      INSERT INTO setting VALUES('vibration',true);
     ''');

    await db.rawInsert('''
      INSERT INTO setting VALUES('sound',false);
      ''');
  }

  Future<int> insert(Map<String, dynamic> raw, table) async {
    Database db = await instance.database;
    return await db.insert(table, raw);
  }

  Future<List<Map<String, dynamic>>> queryAll(table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(Map<String, dynamic> row, table) async {
    Database db = await instance.database;
    int id = row["id"];
    return db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id, table) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
