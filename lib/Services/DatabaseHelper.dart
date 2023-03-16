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
        stars INTEGER,
        status STRING,
        forUnlock INTEGER
      )
      ''');

    await db.execute('''
      CREATE TABLE level
      (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        stageId INTEGER,
        status STRING,
        stars INTEGER,
        time DOUBLE,
        forUnlock INTEGER,
        fullTime DOUBLE,
        doubleStar DOUBLE,
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
      UPDATE level SET forUnlock = forUnlock - NEW.stars + OLD.stars WHERE status = 'Locked';
      UPDATE stage SET forUnlock = forUnlock - NEW.stars + OLD.stars WHERE status = 'Locked';
      UPDATE stage SET stars = stars + NEW.stars - OLD.stars WHERE id = NEW.stageId ;
      END
      ''');

    await db.execute('''
      CREATE TRIGGER update_status_stage
      AFTER UPDATE ON level
      FOR EACH ROW
      BEGIN
      UPDATE stage SET status = 'Unlocked', forUnlock = 0 WHERE forUnlock <= 0;
      UPDATE level SET status = 'Unlocked', forUnlock = 0 WHERE forUnlock <= 0;
      END
      ''');

    await db.execute('''
      CREATE TRIGGER update_status_level
      AFTER UPDATE ON level
      FOR EACH ROW
      BEGIN
      UPDATE level SET status = 'Unlocked', forUnlock = 0 WHERE forUnlock <= 0;
      END
      ''');

    await db.execute(''' CREATE INDEX status_Index ON level(status) ''');

    await db.execute(''' CREATE INDEX forUnlock_Index ON level(forUnlock) ''');

    await db.rawInsert('''
      INSERT INTO stage(stars,status,forUnlock) VALUES(0,'Unlocked',0);
      ''');

    await db.rawInsert(''' 
      INSERT INTO setting VALUES('vibration',true);
     ''');

    await db.rawInsert('''
      INSERT INTO setting VALUES('sound',true);
      ''');
  }
}
