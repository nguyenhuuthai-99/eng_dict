import 'package:eng_dict/networking/request_handler.dart';
import 'package:flutter/material.dart';

import '../model/word_field.dart';

class WordFieldData extends ChangeNotifier {
  RequestHandler requestHandler = RequestHandler();
  List<WordField> wordFields = [];
  late bool _isLoading = true;

  WordFieldData() {
    updateWordFieldList("hello");
  }

  Future<void>? updateWordFieldList(String word) async {
    _isLoading = true;
    notifyListeners();

    wordFields = await requestHandler.getWordData(word);
    _isLoading = false;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
}
