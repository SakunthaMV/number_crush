import 'package:number_crush/Models/Question.dart';
import 'package:number_crush/controllers/algorithm.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/Level.dart';
import '../Models/stage.dart';
import 'DatabaseHelper.dart';

class DatabaseFunctions {
  final Algorithm _algorithm = Algorithm();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

// Setting table function-----------------------------------------------------------------------------------------------

//get status of relevant setting
  Future<bool> getSettingStatus(String key) async {
    bool status;
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db
        .rawQuery(''' SELECT value FROM setting WHERE key = ? ''', [key]);
    result[0]['value'] == 1 ? status = true : status = false;
    return status;
  }

// set status of relevent setting
  void setSettingStatus(String key, bool value) async {
    Database db = await _dbHelper.database;
    await db.rawUpdate(
        ''' UPDATE setting SET value = ? WHERE key = ?''', [value, key]);
  }

// Stage table function ------------------------------------------------------------------------------------------------

//get all stages as list of objects of stage
  Future<List<Stage>> getStages() async {
    Database db = await _dbHelper.database;
    List<Stage> stageList = [];
    List<Map<String, dynamic>> result =
        await db.rawQuery(''' SELECT * FROM stage ''');
    for (int i = 0; i < result.length; i++) {
      Stage stage = Stage.fromMap(result[i]);
      stageList.add(stage);
    }
    return stageList;
  }

//store stage in the database
  void _addStage(Stage stage) async {
    Database db = await _dbHelper.database;
    await db.rawInsert(
        ''' INSERT INTO stage(forUnlock,stars,status) VALUES(?,?,?) ''',
        [stage.forUnlock, stage.stars, stage.status]);
  }

  Future getAll(String tableName) async {
    Database db = await _dbHelper.database;
    return await db.rawQuery(''' SELECT * FROM ${tableName} ''');
  }

//get number of stars till that moment
  Future<int> getStars() async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> stars =
        await db.rawQuery(''' SELECT SUM(stars) AS stars FROM stage ''');
    return stars[0]['stars'];
  }

//Level table functions-------------------------------------------------------------------------------------------------

// store levels in the database
  void _addLevel(Level level) async {
    Database db = await _dbHelper.database;
    await db.rawInsert(
        ''' INSERT INTO level(stageId,status,stars,time,forUnlock,fullTime) VALUES(?,?,?,?,?,?)''',
        [
          level.stageId,
          level.status,
          level.stars,
          level.times,
          level.forUnlock,
          level.fullTIme
        ]);
  }

// update level done details
  Future<void> updateLevel(int star, int id, double time) async {
    Database db = await _dbHelper.database;
    await db.rawUpdate(
        ''' UPDATE level SET stars = ? , time = ? WHERE id = ? ''',
        [star, time, id]);

    await db.rawUpdate(
        ''' UPDATE level SET stars = ? , time = ? WHERE id = ? ''',
        [star, time, id]);

    List<Map<String, dynamic>> result = await db.rawQuery(
        ''' SELECT status,id FROM stage WHERE id = (SELECT MAX(id) FROM stage) ''');

    if (result[0]['status'] == 'Unlocked') {
      insert(result[0]['id']);
    }
  }

//insert when stage or level is unlocked
  Future<void> insert(int stageId) async {
    Stage stage = await _algorithm.stageGenerator(stageId + 1);
    _addStage(stage);
    List<Level> levelList = await _algorithm.levelGenerator(stageId);
    for (int i = 0; i < 50; i++) {
      _addLevel(levelList[i]);
    }
  }

//get all levels as a list of objects of levels
  Future<List<Level>> getLevels(int stageId) async {
    List<Level> levelList = [];
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        ''' SELECT COUNT(id) AS unlocks FROM level WHERE stageId = ? AND status = ? ''',
        [stageId, 'Unlock']);
    for (int i = 0; i < result.length; i++) {
      Level level = Level.fromMap(result[i]);
      levelList.add(level);
    }
    return levelList;
  }

// update given time for this level
  Future<void> updateLevelfullTime(int level, double fullTime) async {
    Database database = await _dbHelper.database;
    await database.rawUpdate(
        ''' UPDATE level SET fullTime = ? WHERE id = ? ''', [fullTime, level]);
  }

//question table function-----------------------------------------------------------------------------------------------

//store questions in the database
  void storeQuestion(Question question) async {
    Database db = await _dbHelper.database;
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
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> list = await db
        .rawQuery(''' SELECT * FROM question WHERE levelId = ? ''', [levelId]);

    for (int i = 0; i < list.length; i++) {
      questionList.add(Question.fromDatabase(list[i]));
    }
    return questionList;
  }

// is this levelid existed in question

  Future<bool> ifExist(int level) async {
    Database db = await _dbHelper.database;
    List<Map<String, dynamic>> result = await db.rawQuery(
        ''' SELECT COUNT(levelId) AS existing FROM question WHERE levelId = ?  ''',
        [level]);
    return result[0]['existing'] > 0 ? true : false;
  }
}
