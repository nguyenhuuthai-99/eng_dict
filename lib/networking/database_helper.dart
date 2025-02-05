import 'package:eng_dict/model/searched_word.dart';
import 'package:eng_dict/model/vocabulary.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  late final Database database;

  Future<void> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "app.db");
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS vocabulary(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          word_title TEXT,
          word_form text,
          phrase_title Text,
          word_definition TEXT,
          fluency_level int,
          url text,
          sound_url text
        )''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS searched_word(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          word_title TEXT,
          url text,
          timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
        )''');
      },
    );
  }

  Future<void> insertSearchedWord(SearchedWord word) async {
    int rowCount = Sqflite.firstIntValue(
            await database.rawQuery('SELECT COUNT(*) FROM searched_word')) ??
        0;

    if (rowCount >= 10) {
      await database.rawQuery(
          'DELETE FROM searched_word WHERE id = (SELECT id FROM searched_word ORDER BY timestamp ASC LIMIT 1)');
    }

    await database.insert(
        "searched_word", {"word_title": word.wordTitle, "url": word.url});
  }

  Future<List<SearchedWord>> getSearchedWord() async {
    List<Map<String, dynamic>> result =
        await database.query("searched_word", orderBy: "timestamp desc");
    return result
        .map(
          (e) => SearchedWord.fromMap(e),
        )
        .toList();
  }

  Future<int> insertVocabulary(Vocabulary vocabulary) async {
    return await database.insert(
        "vocabulary",
        {
          "word_title": vocabulary.wordTitle,
          "word_form": vocabulary.wordForm,
          "phrase_title": vocabulary.phraseTitle,
          "word_definition": vocabulary.definition,
          "fluency_level": vocabulary.fluencyLevel,
          "url": vocabulary.URL,
          "sound_url": vocabulary.soundUrl
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Vocabulary>> getVocabulary() async {
    List<Map<String, dynamic>> result = await database.query("vocabulary");
    return result
        .map(
          (e) => Vocabulary.fromMap(e),
        )
        .toList();
  }

  Future<List<Vocabulary>> getVocabularyOnLevel(VocabularyLevel level) async {
    int start;
    int end;
    if (level == VocabularyLevel.unfamiliar) {
      start = 1;
      end = 4;
    } else if (level == VocabularyLevel.familiar) {
      start = 5;
      end = 8;
    } else {
      start = 9;
      end = 12;
    }
    List<Map<String, dynamic>> result = await database.query("vocabulary",
        where: "fluency_level between ? and ?", whereArgs: [start, end]);
    return result
        .map(
          (e) => Vocabulary.fromMap(e),
        )
        .toList();
  }

  Future<void> updateVocabularyFluency(int id, int level) async {
    await database.update("vocabulary", {"fluency_level": level},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteVocabulary(int id) async {
    await database.delete("vocabulary", where: "id = ?", whereArgs: [id]);
  }
}
