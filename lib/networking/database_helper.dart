import 'dart:convert';

import 'package:eng_dict/model/vocabulary.dart';
import 'package:flutter/material.dart';
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
      onCreate: (db, version) {
        print("asdf");
        db.execute('''
          CREATE TABLE IF NOT EXISTS vocabulary(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          word_title TEXT,
          word_form text,
          phrase_title Text,
          word_definition TEXT,
          fluency_level int,
          url text
        )''');
      },
    );
  }

  Future<void> insertVocabulary(Vocabulary vocabulary) async {
    await database.insert(
        "vocabulary",
        {
          "word_title": vocabulary.wordTitle,
          "word_form": vocabulary.wordForm,
          "phrase_title": vocabulary.phraseTitle,
          "word_definition": vocabulary.definition,
          "fluency_level": 1,
          "url": vocabulary.URL
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

  Future<void> deleteVocabulary(int id) async {
    await database.delete("vocabulary", where: "id = ?", whereArgs: [id]);
  }
}
