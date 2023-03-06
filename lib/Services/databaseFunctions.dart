import 'package:sqflite/sqflite.dart';
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

  Future addStage(Stage stage) async {
    Database db = await dbHelper.database;
    return await db.rawInsert(
        ''' INSERT INTO stage(toUnlock,stars,status) VALUES(?,?,?) ''',
        [stage.toUnlock, stage.stars, stage.status]);
  }

  Future getAll() async {
    Database db = await dbHelper.database;
    return await db.rawQuery(''' SELECT * FROM stage ''');
  }
}
