import 'dart:ffi';

import 'package:sqflite/sqflite.dart';
import '../Models/Level.dart';
import '../Models/stage.dart';
import 'DatabaseHelper.dart';

class DatabaseFunctions {
  DatabaseHelper dbHelper = DatabaseHelper.instance;

// Setting table function
  Future getSettingStatus(String key) async {
    Database db = await dbHelper.database;
    return await db
        .rawQuery(''' SELECT value FROM setting WHERE key = ? ''', [key]);
  }

  Future setSettingStatus(String key, String value) async {
    Database db = await dbHelper.database;
    return await db.rawUpdate(
        ''' UPDATE setting SET value = ? WHERE key = ?''', [value, key]);
  }

// Stage table function
  Future getNumberOfStages() async {
    Database db = await dbHelper.database;
    return await db.rawQuery(''' SELECT COUNT(id) AS stages FROM stage ''');
  }

  Future getToUnlockStageStars() async {
    Database db = await dbHelper.database;
    return await db.rawQuery(''' SELECT id,toUnlock FROM stage''');
  }

  Future getAchievedStarsOfStage() async {
    Database db = await dbHelper.database;
    return await db.rawQuery(''' SELECT id,stars FROM stage''');
  }

  Future addStage(Stage stage) async {
    Database db = await dbHelper.database;
    return await db.rawInsert(
        ''' INSERT INTO stage(toUnlock,stars,status) VALUES(?,?,?) ''',
        [stage.toUnlock, stage.stars, stage.status]);
  }

  Future getAll(String tableName) async {
    Database db = await dbHelper.database;
    return await db.rawQuery(''' SELECT * FROM ${tableName} ''');
  }

  Future getStageStars(int stageId) async {
    Database db = await dbHelper.database;
    return await db
        .rawQuery(''' SELECT stars FROM stage WHERE id = ? ''', [stageId]);
  }

  //Level table functions
  Future addLevel(Level level) async {
    Database db = await dbHelper.database;
    return await db.rawInsert(
        ''' INSERT INTO level(stageId,toUnlock,status,stars,time) VALUES(?,?,?,?,?)''',
        [
          level.stageId,
          level.toUnlock,
          level.status,
          level.stars,
          level.times
        ]);
  }

  Future numberOfUnlockLevels(int stageId) async {
    Database db = await dbHelper.database;
    return await db.rawQuery(
        ''' SELECT COUNT(id) AS unlocks FROM level WHERE stageId = ? AND status = ? ''',
        [stageId, 'Unlock']);
  }

  Future starsOfLevels(int stageId) async {
    Database db = await dbHelper.database;
    return await db.rawQuery(
        ''' SELECT id,stars FROM level WHERE stageId = ? AND status = ?  ''',
        [stageId, 'Unlock']);
  }

  Future toUnlockStars(int stageId) async {
    Database db = await dbHelper.database;
    return await db.rawQuery(
        ''' SELECT id,toUnlock FROM level WHERE stageId = ? AND status = ?  ''',
        [stageId, 'Locked']);
  }
}
