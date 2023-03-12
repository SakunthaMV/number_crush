import 'dart:ffi';

import 'package:number_crush/Models/Question.dart';
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

  Future setSettingStatus(String key, bool value) async {
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

  Future updateLevel(int star, int id, double time) async {
    Database db = await dbHelper.database;
    return await db.rawUpdate(
        ''' UPDATE level SET stars = ? , time = ? WHERE id = ? ''',
        [star, time, id]);
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

  //question table function
  Future storeQuestion(Question question) async {
    Database db = await dbHelper.database;
    return await db.rawInsert(''' 
      INSERT INTO question(levelId,operand_1,operand_2,operator,ans_1,ans_2,ans_3,correctAns,time) VALUES(?,?,?,?,?,?,?,?,?)
     ''', [
      question.levelId,
      question.operand_1,
      question.operand_2,
      question.operator,
      question.ans_1,
      question.ans_2,
      question.ans_3,
      question.correctAns,
      question.time
    ]);
  }

  Future<List<Question>> getQuestions(int levelId) async {
    List<Question> questionList = [];
    Database db = await dbHelper.database;
    List<Map<String, dynamic>> list = await db
        .rawQuery(''' SELECT * FROM question WHERE levelId = ? ''', [levelId]);

    for (int i = 0; i < list.length; i++) {
      questionList.add(Question.fromDatabase(list[i]));
    }
    return questionList;
  }
}
