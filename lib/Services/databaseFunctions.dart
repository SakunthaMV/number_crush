import 'package:sqflite/sqflite.dart';

import 'DatabaseHelper.dart';

class DatabaseFunctions {
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future queryy(table) async {
    Database db = await dbHelper.database;
    return await db
        .rawInsert(''' INSERT INTO stage(toUnlock,stars) VALUES(100,20) ''');
  }
}
