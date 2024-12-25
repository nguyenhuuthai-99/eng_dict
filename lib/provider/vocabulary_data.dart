import 'dart:convert';
import 'dart:developer';

import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/networking/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VocabularyData extends ChangeNotifier {
  // late BuildContext context;
  late List<Vocabulary> vocabularyList;
  late DatabaseHelper databaseHelper;
  late bool isLoading;

  VocabularyData(this.databaseHelper);
  Future<void> getVocabulary() async {
    isLoading = true;

    vocabularyList = await databaseHelper.getVocabulary();

    isLoading = false;
    notifyListeners();
  }

  Future<void> insertVocabulary(Vocabulary vocabulary) async {
    databaseHelper.insertVocabulary(vocabulary);
    getVocabulary();
  }

  Future<void> deleteVocabulary(int id) async {
    databaseHelper.deleteVocabulary(id);
    getVocabulary();
  }
}
