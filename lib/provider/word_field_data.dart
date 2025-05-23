import 'dart:async';

import 'package:eng_dict/main.dart';
import 'package:eng_dict/networking/request_handler.dart';
import 'package:eng_dict/view/dialog/error-dialog.dart';
import 'package:flutter/material.dart';

import '../model/word_field.dart';

class WordFieldData extends ChangeNotifier {
  RequestHandler requestHandler = RequestHandler();
  List<WordField> wordFields = [];
  BuildContext? context = MyApp.navigatorKey.currentState?.context;
  late String title;
  bool _isLoading = false;
  bool _hasError = false;
  bool _isFirstSearched = false;
  final int _timeout = 60;

  WordFieldData();

  Future<void>? loadWordFromURL(String title, String url) async {
    this.title = title;
    _isFirstSearched = true;
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      wordFields = await requestHandler
          .getWordDataFromURL(url)
          .timeout(Duration(seconds: _timeout));
      _isLoading = false;
      notifyListeners();
    } on TimeoutException {
      if (context != null) {
        showDialog(
          context: context!,
          builder: (context) => const TimeOutDialog(),
        );
        _hasError = true;
        notifyListeners();
      }
    } on FormatException {
      if (context != null) {
        showDialog(
          context: context!,
          builder: (context) => const NoInternetDialog(),
        );
        _hasError = true;
        notifyListeners();
      }
    }
  }

  Future<void>? updateWordFieldList(String word) async {
    title = word;
    _isFirstSearched = true;
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      wordFields = await requestHandler
          .getWordData(word)
          .timeout(Duration(seconds: _timeout));
      _isLoading = false;
      notifyListeners();
    } on TimeoutException {
      if (context != null) {
        showDialog(
          context: context!,
          builder: (context) => const TimeOutDialog(),
        );
        _hasError = true;
        notifyListeners();
      }
    } on FormatException {
      if (context != null) {
        showDialog(
          context: context!,
          builder: (context) => const NoInternetDialog(),
        );
        _hasError = true;
        notifyListeners();
      }
    }
  }

  Future<void> reload() async {
    await updateWordFieldList(title);
  }

  bool get hasError => _hasError;

  bool get isLoading => _isLoading!;

  bool get isFirstSearched => _isFirstSearched;
}
