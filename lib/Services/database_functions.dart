import 'package:number_crush/Models/Question.dart';
import 'package:number_crush/controllers/algorithm.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/level.dart';
import '../Models/stage.dart';
import 'database_helper.dart';

class DatabaseFunctions {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

// Setting table function-----------------------------------------------------------------------------------------------

//get status of relevant setting
  Future<bool> getSettingStatus(String key) async {
    bool status;
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db
        .rawQuery(''' SELECT value FROM setting WHERE key = ? ''', [key]);
    result[0]['value'] == 1 ? status = true : status = false;
    return status;
  }

// set status of relevant setting
  void setSettingStatus(String key, bool value) async {
    final Database db = await _dbHelper.database;
    await db.rawUpdate(
        ''' UPDATE setting SET value = ? WHERE key = ?''', [value, key]);
  }

// Stage table function ------------------------------------------------------------------------------------------------

//get all stages as list of objects of stage
  Future<List<Stage>> getStages() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> result =
        await db.rawQuery(''' SELECT * FROM stage ''');
    List<Stage> stageList = [];
    for (int i = 0; i < result.length; i++) {
      Stage stage = Stage.fromMap(result[i]);
      stageList.add(stage);
    }
    return stageList;
  }

//store stage in the database

  Future getAll(String tableName) async {
    final Database db = await _dbHelper.database;
    return await db.rawQuery(''' SELECT * FROM $tableName ''');
  }

//get number of stars till that moment
  Future<int> getStars() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> stars =
        await db.rawQuery(''' SELECT SUM(stars) AS stars FROM stage ''');
    return stars[0]['stars'];
  }

// to get last unlock stage
  Future<int> lastUnlockStage() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
        ''' SELECT MAX(id) AS id FROM stage WHERE status = ? ''', ['Unlocked']);
    return result[0]['id'];
  }

//Level table functions-------------------------------------------------------------------------------------------------

// update level done details
  Future<void> updateLevel(
    int star,
    int id,
    double time,
    double doubleStar,
  ) async {
    final Database db = await _dbHelper.database;
    await db.rawUpdate(
        ''' UPDATE level SET stars = ? , time = ?, doubleStar = ? WHERE id = ? ''',
        [star, time, doubleStar, id]);

    await db.rawUpdate(
        ''' UPDATE level SET stars = ? , time = ?, doubleStar = ? WHERE id = ? ''',
        [star, time, doubleStar, id]);

    final List<Map<String, dynamic>> result = await db.rawQuery(
        ''' SELECT status,id FROM stage WHERE id = (SELECT MAX(id) FROM stage) ''');

    final Algorithm algorithm = Algorithm();
    final int stars = await getStars();
    final int lastStage = await lastUnlockStage();
    bool newStageAdd = false;
    if (result[0]['status'] == 'Unlocked') {
      newStageAdd = true;
      await db.rawInsert(
          ''' INSERT INTO stage(stars,status,forUnlock) VALUES(?,?,?) ''',
          [0, 'Locked', algorithm.startValue(result[0]['id'] + 1) - stars]);
    }

    for (int i = 1; i < 4; i++) {
      final int lastLevel = await lastUnlockLevel();
      if (algorithm.toUnlockStar(lastLevel + 1) <= stars &&
          lastLevel % 50 == 49 &&
          newStageAdd) {
        await db.rawInsert(
            '''INSERT INTO level(stageId,stars,time,fulltime,doubleStar) VALUES(?,?,?,?,?);''',
            [lastStage - 1, 0, 0, 0, 0]);
      } else if (algorithm.toUnlockStar(lastLevel + 1) <= stars) {
        await db.rawInsert(
            '''INSERT INTO level(stageId,stars,time,fulltime,doubleStar) VALUES(?,?,?,?,?);''',
            [lastStage, 0, 0, 0, 0]);
      }
    }
  }

//get all levels as a list of objects of levels
  Future<List<Level>> getLevels(int stageId) async {
    List<Level> levelList = [];
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db
        .rawQuery(''' SELECT * FROM level WHERE stageId = ? ''', [stageId]);
    for (int i = 0; i < result.length; i++) {
      Level level = Level.fromMap(result[i]);
      levelList.add(level);
    }
    return levelList;
  }

// update given time for this level
  Future<void> updateLevelFullTime(int level, double fullTime) async {
    final Database database = await _dbHelper.database;
    await database.rawUpdate(
        ''' UPDATE level SET fullTime = ? WHERE id = ? ''', [fullTime, level]);
  }

// get float number of stars and
  Future<double> getDoubleStar(int level) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db
        .rawQuery(''' SELECT doubleStar FROM level WHERE id = ? ''', [level]);
    return result[0]['doubleStar'];
  }

// check weather this level is unlocked or not
  Future<bool> isUnlock(int level) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
        ''' SELECT COUNT(id) AS id FROM level WHERE id = ? ''', [level]);
    return result[0]['id'] < 1 ? false : true;
  }

// to get last unlock level
  Future<int> lastUnlockLevel() async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> result =
        await db.rawQuery(''' SELECT MAX(id) AS id FROM level''');
    return result[0]['id'];
  }

//question table function-----------------------------------------------------------------------------------------------

//store questions in the database
  Future<void> storeQuestion(Question question) async {
    final Database db = await _dbHelper.database;
    await db.rawInsert(''' 
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

// get all question as a list of objects of questions
  Future<List<Question>> getQuestions(int levelId) async {
    List<Question> questionList = [];
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> list = await db
        .rawQuery(''' SELECT * FROM question WHERE levelId = ? ''', [levelId]);

    for (int i = 0; i < list.length; i++) {
      questionList.add(Question.fromDatabase(list[i]));
    }
    return questionList;
  }

// is this levelId existed in question

  Future<bool> ifExist(int level) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
        ''' SELECT COUNT(levelId) AS existing FROM question WHERE levelId = ?  ''',
        [level]);
    return result[0]['existing'] > 0 ? true : false;
  }

  Future<bool> isExistDataBase(int level) async {
    final Database db = await _dbHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
        ''' SELECT COUNT(id) AS existing FROM level WHERE id = ?  ''', [level]);
    return result[0]['existing'] > 0 ? true : false;
  }
}
