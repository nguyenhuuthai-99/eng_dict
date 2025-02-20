import 'package:eng_dict/model/vocabulary.dart';
import 'package:eng_dict/networking/database_helper.dart';
import 'package:flutter/material.dart';

class VocabularyData extends ChangeNotifier {
  late List<Vocabulary> vocabularyList;
  Set<int> newVocabularyList = {};
  late DatabaseHelper databaseHelper;
  late bool isLoading;
  bool isSorted = false;

  VocabularyData(this.databaseHelper);
  Future<void> getVocabulary() async {
    isLoading = true;

    await getVocabulariesFromDatabase();

    sortVocabularyByID();

    isLoading = false;
    notifyListeners();
  }

  Future<void> getVocabulariesFromDatabase() async {
    vocabularyList = await databaseHelper.getVocabulary();
  }

  Future<void> updateVocabulary(int id, int level) async {
    await databaseHelper.updateVocabularyFluency(id, level);
    getVocabulariesFromDatabase();
    notifyListeners();
  }

  Future<void> insertVocabulary(Vocabulary vocabulary) async {
    int id = await databaseHelper.insertVocabulary(vocabulary);
    addNewWord(id);
    getVocabulary();
  }

  Future<void> deleteVocabulary(int id) async {
    databaseHelper.deleteVocabulary(id);
    getVocabulary();
  }

  void sortToggle() {
    isSorted = !isSorted;

    if (isSorted) {
      sortVocabularyByName();
    } else {
      sortVocabularyByID();
    }
    notifyListeners();
  }

  void sortVocabularyByID() {
    vocabularyList.sort(
      (a, b) => b.id.compareTo(a.id),
    );
  }

  void sortVocabularyByName() {
    vocabularyList.sort(
      (a, b) => a.wordTitle.codeUnitAt(0).compareTo(b.wordTitle.codeUnitAt(0)),
    );
  }

  void resetNewVocabularyList() {
    newVocabularyList.clear();
    notifyListeners();
  }

  void addNewWord(int id) {
    newVocabularyList.add(id);
  }
}
