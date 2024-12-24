import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "app.db");

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
    CREATE TABLE IF NOT EXISTS vocabulary(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      word_title TEXT,
      phrase_title Text,
      word_definition TEXT,
    )''');
      },
    );
  }

  static
}
