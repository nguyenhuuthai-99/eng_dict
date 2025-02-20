import 'dart:ui';

import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/cupertino.dart';

enum VocabularyLevel { unfamiliar, familiar, mastered }

class Vocabulary {
  late final int _id;
  late final String _wordTitle;
  late final String _wordForm;
  late final String _phraseTitle;
  late final String _wordDefinition;
  late final int _fluencyLevel;
  late final String _URL;
  late final String? _soundUrl;
  late int _updatedFluencyLevel;

  Vocabulary();

  Vocabulary.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    wordTitle = map["word_title"];
    wordForm = map["word_form"];
    phraseTitle = map["phrase_title"];
    wordDefinition = map["word_definition"];
    fluencyLevel = map["fluency_level"];
    _updatedFluencyLevel = map["fluency_level"];
    URL = map['url'];
    soundUrl = map['sound_url'];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "word_title": wordTitle,
      "word_form": wordForm,
      "phrase_title": phraseTitle,
      "word_definition": wordDefinition,
      "fluency_level": fluencyLevel,
      "url": URL,
      "sound_url": soundUrl
    };
  }

  Color pickIndicatorColor() {
    if (8 >= fluencyLevel && fluencyLevel > 4) {
      return Constant.kYellowIndicatorColor;
    } else if (fluencyLevel > 8) {
      return Constant.kGreenIndicatorColor;
    } else {
      return Constant.kRedIndicatorColor;
    }
  }

  TextSpan pickUpdatedSymbol() {
    int updatedStatus = _updatedFluencyLevel - _fluencyLevel;
    if (updatedStatus == 0) {
      return Constant.kRemainSymbol;
    } else if (updatedStatus > 0) {
      return Constant.kUpSymbol;
    } else {
      return Constant.kDownSymbol;
    }
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get phraseTitle => _phraseTitle;

  set phraseTitle(String value) {
    _phraseTitle = value;
  }

  String get wordTitle => _wordTitle;

  set wordTitle(String value) {
    _wordTitle = value;
  }

  String get wordForm => _wordForm;

  String get URL => _URL;

  set URL(String value) {
    _URL = value;
  }

  String get definition => _wordDefinition;

  set definition(String value) {
    _wordDefinition = value;
  }

  set wordForm(String value) {
    _wordForm = value;
  }

  String get wordDefinition => _wordDefinition;

  set wordDefinition(String value) {
    _wordDefinition = value;
  }

  String? get soundUrl => _soundUrl;

  set soundUrl(String? value) {
    _soundUrl = value;
  }

  int get updatedFluencyLevel => _updatedFluencyLevel;

  void increaseFluencyLevel() {
    if (_updatedFluencyLevel < 12) {
      _updatedFluencyLevel++;
    }
  }

  void decreaseFluencyLevel() {
    if (_updatedFluencyLevel > 1) {
      _updatedFluencyLevel--;
    }
  }

  int get fluencyLevel => _fluencyLevel;

  set fluencyLevel(int value) {
    _updatedFluencyLevel = value;
    _fluencyLevel = value;
  }
}
