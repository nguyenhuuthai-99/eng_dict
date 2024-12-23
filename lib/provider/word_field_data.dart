import 'dart:async';

import 'package:eng_dict/networking/request_handler.dart';
import 'package:flutter/material.dart';

import '../model/word_field.dart';

class WordFieldData extends ChangeNotifier {
  RequestHandler requestHandler = RequestHandler();
  List<WordField> wordFields = [];
  late String word;
  late bool _isLoading;
  bool _hasError = false;
  late bool _timedOut;

  WordFieldData();

  Future<void>? updateWordFieldList(String word) async {
    this.word = word;
    _isLoading = true;
    notifyListeners();

    try {
      wordFields = await requestHandler
          .getWordData(word)
          .timeout(const Duration(seconds: 6));
      _isLoading = false;
      notifyListeners();
    } on TimeoutException {
      _hasError = true;
      notifyListeners();
    } on FormatException {
      _hasError = true;
      notifyListeners();
    }
  }

  Future<void> reload() async {
    await updateWordFieldList(word);
  }

  bool get hasError => _hasError;

  bool get isLoading => _isLoading;
}
