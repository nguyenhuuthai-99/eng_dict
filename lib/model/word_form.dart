import 'package:eng_dict/model/linked_word.dart';
import 'package:eng_dict/model/word.dart';

class WordForm {
  String? _formTitle;
  String? _ukIPA;
  String? _ukIPASoundURL;
  String? _usIPA;
  String? _usIPASoundURL;
  late List<Word>? _words;
  late List<LinkedWord>? _phrasalVerbs;
  late List<LinkedWord>? _idioms;

  WordForm();

  factory WordForm.fromJson(Map<String, dynamic> json) {
    return WordForm()
      .._formTitle = json['formTitle']
      .._ukIPA = json['ukIPA']
      .._ukIPASoundURL = json['ukIPASoundURL']
      .._usIPA = json['usIPA']
      .._usIPASoundURL = json['usIPASoundURL']
      .._words = (json['words'] as List<dynamic>?)
          ?.map((e) => Word.fromJson(e))
          .toList()
      .._phrasalVerbs = (json['phrasalVerbs'] as List<dynamic>?)
          ?.map(
            (e) => LinkedWord.fromJson(e),
          )
          .toList()
      .._idioms = (json['idioms'] as List<dynamic>?)
          ?.map(
            (e) => LinkedWord.fromJson(e),
          )
          .toList();
  }

  String? get formTitle => _formTitle;

  set formTitle(String? value) {
    _formTitle = value;
  }

  String? get ukIPA => _ukIPA;

  set ukIPA(String? value) {
    _ukIPA = value;
  }

  String? get usIPA => _usIPA;

  set usIPA(String? value) {
    _usIPA = value;
  }

  String? get usIPASoundURL => _usIPASoundURL;

  set usIPASoundURL(String? value) {
    _usIPASoundURL = value;
  }

  String? get ukIPASoundURL => _ukIPASoundURL;

  set ukIPASoundURL(String? value) {
    _ukIPASoundURL = value;
  }

  List<Word>? get words => _words;

  set words(List<Word>? value) {
    _words = value;
  }

  List<LinkedWord>? get idioms => _idioms;

  set idioms(List<LinkedWord>? value) {
    _idioms = value;
  }

  List<LinkedWord>? get phrasalVerbs => _phrasalVerbs;

  set phrasalVerbs(List<LinkedWord>? value) {
    _phrasalVerbs = value;
  }
}
