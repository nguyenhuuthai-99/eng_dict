import 'package:eng_dict/networking/request_handler.dart';
import 'package:flutter/material.dart';

import '../model/word_field.dart';

class WordFieldData extends ChangeNotifier {
  RequestHandler requestHandler = RequestHandler();
  List<WordField> wordFields = [];
  String word = "hello";
  late bool _isLoading = true;

  WordFieldData();

  Future<void>? updateWordFieldList(String word) async {
    this.word = word;
    _isLoading = true;
    notifyListeners();

    wordFields = await requestHandler.getWordData(word);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> reload() async {
    await updateWordFieldList(word);
  }

  bool get isLoading => _isLoading;
}
