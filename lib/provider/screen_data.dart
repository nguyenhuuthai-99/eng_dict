import 'package:eng_dict/view/screens/dictionary_screen.dart';
import 'package:eng_dict/view/screens/home_screen.dart';
import 'package:eng_dict/view/screens/vocabulary_screen.dart';
import 'package:flutter/material.dart';

class ScreenData extends ChangeNotifier {
  int _index = 0;
  final List<Widget> screens = [
    HomeScreen(),
    DictionaryScreen(),
    VocabularyScreen(),
  ];

  int get index => _index;

  void changeIndex(index) {
    _index = index;
    notifyListeners();
  }
}
